# RPL 论文笔记 — Learning to Program Retrievals

> 整理自 ChatGPT 讲解记录(2026-11-06,`chatgpt-archive-markdown-20261107-1140.zip`),论文见本目录 `RPL_2610.24854.pdf`,中文翻译见 `babeldoc-output-RPL_2610.24854/`,插图见 `figures/`。

![Figure 1 — RPL 总览:Monolithic Search vs Retrieval Program Learning,以及 Held-out EM 与 Context Consumption 对比](figures/fig1-overview.png)
*Figure 1:全文总览。左上 Monolithic Search(固定检索流程)vs 左下 RPL(模型生成检索程序);右上 Held-out EM(RPL+Mutation 最高);右下 Context Consumption(RPL 仅 150–320 tokens)。*

## 元信息

- **标题**:Learning to Program Retrievals: Composing Search Primitives via Reinforcement Learning
- **arXiv**:2610.24854 (cs.CL / cs.IR),2026-10-17 v1,提交者 Kyuyoung Kim
- **方法简称**:RPL (Retrieval Program Learning,检索程序学习)
- **一句话总结**:把 Agent 的检索动作从"输出一条 Query"升级为"生成一段可执行的检索程序",用 RL(GRPO)+ 程序变异(Program Mutation)+ 执行验证 SFT 训练;检索广度与上下文消耗解耦——可以检索大量文档,只把少量精选证据交给 LLM。

---

## 一、核心问题与动机

传统 Search Agent(如 Search-R1)的瓶颈:

1. **检索流程固定**:Agent 只能决定"搜什么"(Query),不能决定检索系统内部用 BM25 还是 Dense、如何融合、是否去重重排、返回几篇——这些都由开发者预先配置(Monolithic Search)。
2. **检索广度 = 上下文消耗**:要检索 100 篇就得把结果塞进上下文让 LLM 自己筛。
3. **RL 探索困难**:程序空间大(操作组合 × 参数),而 RL 只有最终答案对错的稀疏反馈,失败时无法定位是 Query 不好、检索方式不对、候选太少还是缺融合/重排。

RPL 的解法分两层:

| 层次 | 解决什么 | 手段 |
|---|---|---|
| 可编程检索接口 | 模型控制检索内部流程 | LLM 生成检索程序,调用 SDK 原语,沙箱执行 |
| Program Mutation | 程序空间太大,RL 探索不到好结构 | 受约束变异 + 执行验证 + SFT 内化 |

## 二、方法

### 2.1 检索程序(可编程接口)

模型生成类似下面的程序,由沙箱执行:

```python
def query_pipeline():
    s_ret = sparse(q_s, k=5)      # BM25,擅长专有名词/数字
    d_ret = dense(q_d, k=5)       # E5,擅长语义匹配
    ret = fuse(s_ret, d_ret)      # RRF 融合
    ret = rerank(q_r, ret, k=3)   # Qwen3-Reranker-4B
    return ret[0]
```

可用原语:Dense / Sparse / Fuse / Dedupe / Rerank / Select。**关键性质:中间结果留在程序状态里,不必进入 LLM 上下文**——检索广度与上下文消耗解耦。

![Figure 2 — 论文中的真实检索程序示例](figures/fig2-example-program.png)
*Figure 2:论文正文的真实示例程序(比示意图多了 dedupe,注意 `print(D_r[:3])` —— 只有显式打印的内容才进入模型上下文,其余留在程序中间状态):*

```python
D_s = sparse_retrieval(q_s, top_k=10)
D_d = dense_retrieval(q_d, top_k=10)
D_f = fuse(dedup(D_s, D_d))
D_r = rerank(q_r, D_f, top_k=5)
print(D_r[:3])
```

### 2.2 Program Mutation(核心创新)

流程:RL 探索 → 收集次优轨迹 → 局部程序变异 → 执行验证 → 拼接轨迹 → SFT → 继续 RL。

四个关键设计细节:

1. **Typed Grammar 约束**:变异在带类型约束的语法内生成合法局部变体(替换检索器、增大 top-k、加 rerank 等),不是让另一个 LLM 随便写代码,也不是随机改 Python。
2. **保留原始 Query,只改检索结构**:分离"程序结构"与"查询表达"两个因素的贡献。
3. **只变异最后一次检索**:改前面的轮次会使后续动作全部失效、需重放整条轨迹;只改最后一轮可复用前序轨迹,控制成本。
4. **检索与答案分离监督(Loss Mask)**:变异程序执行后重新采样后续回答;**只要检索证据验证通过(V_ret(p')=1),即使新答案仍错误,程序部分也参与 SFT,只 mask 掉错误答案**。即"检索成功、回答失败"时不浪费有效检索信号:

   - D_mut = {(x, p', y') | p' ∈ U(p), V_ret(p') = 1}
   - L_SFT ≈ L_program + m_answer · L_answer,m_answer 按答案对错取 0/1(简化表达,非原文公式)

定位:**Mutation 不是替代 RL,而是周期性插入的额外监督来源**(N 为变异间隔;Open-domain QA 实验通常一次变异就够,设在 Step 200,第二次往往找不到足够多新的有效样本)。

![Figure 6 — Program Mutation 图示:变异候选 × 双重验证](figures/fig6-mutation-illustration.png)
*Figure 6:对次优程序生成三个受约束变体,分别过 Retrieval Verification 和 Answer Verification。注意 Mutated Code #3:检索验证 ✓、答案验证 ✗ —— 程序仍保留用于 SFT,只 mask 答案部分(对应 2.2 节设计细节 4)。*

### 2.3 Algorithm 1 流程

1. 采样一批问题,LLM 生成完整轨迹(程序→检索→阅读→回答);
2. GRPO 用可验证奖励(答案对错,组内相对优势)更新;
3. 每 N 步触发一次:收集次优轨迹 → 变异最后一次检索程序 → 同题同语料库执行并验证证据 → 通过者拼接进原轨迹、重新生成回答 → 进入 D_mut;
4. 对 D_mut 做短暂 SFT,继续 RL。

谁在学什么:**自始至终只有一个 LLM**——RL 学完整任务,外部规则+执行环境负责搜索更好的程序结构,SFT 把它蒸馏回同一个模型,再继续 RL。

## 三、实验要点

![Figure 3 — Program Mutation 对 RL 训练的影响(Held-out EM)](figures/fig3-mutation-em.png)
*Figure 3:实线 = RPL + Mutation,虚线 = RL only。4B(左)与 8B(右);蓝 = NQ,橙 = HotpotQA。Mutation 在 Step 200 执行一次,此后实线持续高于虚线,且后续 RL 继续利用这部分改进。*

- **训练效果(Held-out EM,Qwen3-4B)**:Mutation 带来持续增益——NQ 0.516→0.536,HotpotQA 0.517→0.539;且后续 RL 能继续利用这部分改进。绿色(RPL RL only)本身已超蓝色(Search-R1):程序化接口有价值;橙色(+Mutation)又超绿色:变异帮助探索。
![Figure 4 — GlobalQA 上的检索与训练效率(以 RPL 为基准归一化)](figures/fig4-efficiency.png)
*Figure 4:三栏分别为上下文消耗、检索轮数、训练时间,RPL 全部最低。*

- **效率(GlobalQA,以 RPL 为基准)**:
  - 上下文消耗:Search-R1 7,170–7,310 tokens(≈31×)、MARAG-R1 1,040–2,840(≈8×)、RPL 仅 150–320;
  - 检索轮数:RPL 1.00–1.27,Search-R1 2.18–2.24,MARAG-R1 2.00–4.61(一个程序组合多个操作,减少交互开销);
  - 训练时间相对:Search-R1 ≈5.6–5.9×,MARAG-R1 ≈1.2–2.3×;
  - 证据覆盖 dF1:RPL 最高(4B:30.17,8B:32.97)——省上下文不是靠少检索,证据覆盖反而更高。
![Figure 5 — 原语采用率随 RL 训练的演化](figures/fig5-primitive-adoption.png)
*Figure 5:模型 rollout 中使用 Sparse Retrieval 与 Reranking 的比例随训练稳步上升(左:模型规模;中:训练数据;右:提示词中示例数量)。说明 RL 确实在学着组合检索原语,而不是固化为单次检索。*

- **规模优势**:4B + RPL 超过所有 8B baseline;multi-hop 任务增益最大。

## 四、与相关工作对比

| 工作 | 学什么 | 检索如何执行 |
|---|---|---|
| Search-R1 | 何时搜、搜什么 | 调用固定检索接口 |
| MARAG-R1 | 如何选检索工具 | 逐个调用原子工具 |
| MAPS | 如何组织协调搜索 | 多角色/策略协作 |
| **RPL** | **如何编写、组合检索程序** | 一次执行含多个操作的程序 |

注意:RPL 不是训练多个 LLM 分管 Dense/Sparse/Rerank;是同一个策略模型生成程序,SDK 提供检索能力,沙箱执行;RL 用 GRPO,Mutation 阶段加短暂 SFT。

## 五、读这篇论文最值得注意的两个细节

1. **别把两类贡献混为一谈**:Held-out EM 曲线说明的是 *Mutation 的训练收益*;上下文消耗实验(GlobalQA)**没有用 Mutation**,说明的是 *程序化接口的效率收益*。
2. **并非全面碾压**:Qwen3-4B 在 GlobalQA 的 Count 子任务上,RPL 答案 F1 低于 Search-R1 和 MARAG-R1。

## 六、向赵哥汇报版(一段话)

> Search-R1 等早期工作用 RL 学"什么时候搜、生成什么 Query",但底层检索是固定外部工具。RPL 把检索过程本身变成模型可学习编写的程序——自主组合 Sparse/Dense/Fuse/Dedupe/Rerank/Select。程序化带来更大探索空间,普通 RL 难以直接找到好结构,因此提出 Program Mutation:对失败轨迹中的检索程序做受约束变异、执行验证、SFT 内化。最终同时提高问答效果,并把检索广度与上下文消耗分离(检索大量文档,只读少量精选证据)。

**最值得记住的一句话:RPL 改变了 Agent 学习检索的对象——从学习 Search Query,推进到学习完整的 Retrieval Program。**

---

## 七、延伸:迁移方案《Learning to Program Skill Search》笔记

记录后半段讨论的是基于 RPL 撰写的研究方案文档(把可编程检索迁移到 **Skill Retrieval**),目前为方案阶段、**尚无真实实验结果**。

### 7.1 问题设定

- 大规模技能库(数千~数万技能)下,给定任务 Q₀,检索 Top-K 最适用技能。
- 与文档检索的三大差异:表述抽象级差(任务描述 vs 功能规范)、**多能力组合需求**(一个任务需要一组互补技能)、功能粒度敏感(单条查询 vs 跨记录聚合,表面相似但能力不同)。
- 单次检索的典型失败:高频领域词(航班号、机场代码)占满所有返回槽位,正交子能力(分位数计算、趋势绘图)被遗漏。

### 7.2 方法

- **四个模块**:LLM Search Policy(生成 think + 搜索程序)、固定 Retriever/Reranker(冻结黑盒)、Program Executor(沙箱执行、强制预算、只反馈精简摘要)、Skill Bundle(跨查询跨轮次的共享候选集合)。
- **五个原语**:`SEARCH(query,k)`、`MERGE`(聚合分 σ̂ = max σ + η·Σ 1/(60+rank))、`DEDUP`、`REFINE`(定向补查缺失能力)、`STOP(bundle,K)`。
- **训练**:沿用 RPL 三段式——GRPO(奖励 = α·Recall@K + (1-α)·nDCG@K − λ·Penalty(超预算/语法错))+ 程序变异(查询拆解改写/召回宽度调整/冗余剪枝)+ 执行验证 SFT(验证标准改为黄金技能的 Recall/nDCG 改善)。

### 7.3 与 RPL 的关键差异(迁移中真正改变的东西)

| 维度 | RPL | Skill Search 方案 |
|---|---|---|
| 检索对象 | 证据文档 | 功能互补的技能集合 |
| 变异范围 | 只改结构、保留 Query | **还允许拆解/改写 Query**(联合优化,需消融分离贡献) |
| Mutation 验证 | 检索证据是否充分 | 黄金技能 Recall/nDCG 是否提升 |
| 评价 | 答案 EM 等 | Recall / nDCG / MRR / Full Set Coverage / 调用次数 |

### 7.4 实验设计(规划)

- 数据集:SkillRet(主)、SRA-Bench(跨域)、R3-Skill(多技能组合);训练/测试技能池互不相交。
- 对照(递进):Single-Shot → One-Shot Multi-Query → Multi-Turn Text Search → Programmatic(不训练)→ 完整 GRPO+Mutation。核心要证明的是**程序化组织超出普通多查询的额外收益**。
- 指标中特别注意 **Full Set Coverage@K**:任务所需技能是否一次找齐(只差一个技能,整个工作流可能仍跑不通)。

### 7.5 六个待解决问题(审查意见)

1. **Mutation 与 RPL 原版不一致**:允许改 Query 后,提升究竟来自结构还是查询?需"只结构变异 vs 结构+Query 变异"消融。
2. **黄金技能标注完整性**:功能等价替代技能(Pandas 版 vs NumPy 版 P95)算不算对?否则模型可能只是学会匹配基准的技能 ID。
3. **MERGE 融合公式未验证**:BM25/Embedding/Reranker 得分尺度不可比;需对比 max 融合 / RRF / 混合公式;多次被召回 ≠ 覆盖多个能力。
4. **DEDUP 的三档区分**:同 ID 精确去重 / 不同 ID 功能重复的语义去重 / **功能相似但粒度不同必须保留**(去重过激会删掉正确技能)。
5. **"显著提升"标准不具体**:应在同等检索预算下比较综合质量,防止靠多调用换 Recall。
6. **程序化 vs 普通多查询的增量收益**是生死问题:动态补查、Bundle 减重复、REFINE 精准性、主动停止、预算分配,这些才需实验分离。

### 7.6 当前定位与建议

- 研究问题明确、方法有完整雏形、实验有初步框架,**但实际有效性尚未验证**。
- 范围:只做 Skill Retrieval,不做 Skill Execution / Agent 自演化——第一阶段科学问题收窄是对的。
- 建议路径:先别把 GRPO/Mutation 做复杂,第一步只验证最基础的假设——**底层检索器不变、预算相同下,带候选集合管理和定向补查的程序化搜索是否优于普通 Multi-Query**;成立后再加训练范式。
- 对个人研究的启发(可迁移的核心思想):**把失败轨迹拆开,单独验证某个局部行为是否成功,只监督验证有效的部分**;对应的关键研究问题是"任务失败时,如何区分检索决策错误 vs 检索正确但后续执行错误"。但 Skill Selection 缺少文档检索那样简单的证据验证器(正确性依赖前置条件/状态变化/最终效用),不能直接照搬。

---

## 附:相关文件

| 文件 | 说明 |
|---|---|
| `RPL_2610.24854.pdf` | 论文原文 |
| `babeldoc-output-RPL_2610.24854/RPL_2610.24854.zh-CN.dual.pdf` | 中英双语翻译版 |
| `babeldoc-output-RPL_2610.24854/RPL_2610.24854.zh-CN.mono.pdf` | 纯中文翻译版 |
| `figures/fig1–fig6` | 论文 Figure 1–6 裁剪图(本笔记内嵌) |
| `chatgpt-archive-markdown-20261107-1140.zip` | 本次笔记的素材来源(讲解记录) |
