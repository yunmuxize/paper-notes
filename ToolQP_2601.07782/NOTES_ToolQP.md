# ToolQP: Beyond Single-Shot — Multi-step Tool Retrieval via Query Planning 笔记

> **原文**: Fang & Glass (MIT), arXiv:2601.07782, 2026-01-12
> **链接**: https://arxiv.org/abs/2601.07782 ｜ 双栏翻译：`babeldoc-output-ToolQP_2601.07782/`
> **个人定位**: 本文提出的 **多步查询规划（Multi-step Query Planning）** 是后续设计"功能缺口感知检索（Function-Gap Aware Querying）"的重要方法基础。

---

## 1. 摘要

在超大、动态的工具库上运行的 LLM Agent 依赖有效的工具检索，但标准的**单步（single-shot）稠密检索**在复杂请求上表现很差。失败主要源于两点：

1. **抽象用户目标 ↔ 技术文档之间的语义断层**（semantic misalignment）；
2. **固定尺寸 embedding 难以建模工具组合的排列多样性**（compositional bottleneck）。

TOOLQP 把检索建模为**迭代式查询规划**：不再一次性匹配，而是把指令分解为子任务，动态生成查询与检索器交互。训练分两步——先用教师模型合成查询轨迹做 SFT，再用**可验证奖励的强化学习（RLVR / GRPO）**优化。在 ToolRet（35 个数据集、44k 工具）上取得 SOTA，零样本迁移、跨检索器鲁棒性和下游 agent 执行成功率都显著提升。核心卖点：**轻量（1.7B）、模块化、即插即用于任意稠密检索器**。

---

## 2. 故事逻辑（为什么会有这篇论文）

### 2.1 大背景
- Agent 工具库从几十个手工函数膨胀到 **数万级 API**（如 RapidAPI 52k+），无法把全部工具文档塞进上下文 → **工具检索成为刚需前置步骤**。
- 现有做法：把 IR 技术搬到工具检索上（稠密 embedding + 单步召回），但在真实 tool-use 任务上表现糟糕（Shi et al., 2025 的 ToolRet 基准揭示的 gap）。

### 2.2 三个根本挑战（论文的 problem statement，非常清晰）
| # | 挑战 | 例子 |
|---|------|------|
| 1 | **语义错位** | 用户说"让录音音质变高"，相关工具却是 `scipy.signal.lfilter(b,a,x)`——文档全是数学参数；"high quality" 与 "IIR/FIR filter" 在 embedding 空间距离很远 |
| 2 | **组合瓶颈** | "分析降雨对零售的影响"需要同时召回 WeatherAPI + StockMarketDB；单个固定维向量编码不了多工具的组合意图 |
| 3 | **缺乏交互式工具集感知** | 单步检索把仓库当静态数据库，无法发现 `forecasting_tool` 依赖 `lookup_utility` 提供的 `region_id` 这类**工具间依赖**，也无法适应工具集变动 |

### 2.3 核心洞察
> 把检索从"静态相似度匹配"重构成"**序贯决策过程（planning）**"：检索器 E 不是索引，而是一个**可交互、可探索的环境**。

三个挑战分别被三个机制化解：
- 语义错位 → **任务分解**：先产出自然语言计划 P，拆成子任务 {s_n}，再针对每个子任务生成"功能级"查询；
- 组合瓶颈 → **逐步检索**：每个子任务单独生成概念相近的查询，而不是把所有意图压进一个向量；
- 工具间依赖 → **反馈回路**：每步观察检索反馈 O_t = E(q_t; D)，发现缺前置工具就追加查询（trial-and-error 自纠正）。

### 2.4 贡献声明
1. 范式转变：工具检索 = 动态规划过程（可解决组合查询、发现隐式依赖）；
2. 模块化轻量层：不改底层索引、不微调下游 LLM，即插即用；规划轨迹还能作为下游 agent 的 grounding 上下文；
3. 大规模实验：检索精度 + 下游执行成功率双提升，尤其在**高组合复杂度 + 抽象意图**场景。

---

## 3. 算法逻辑（含数学实例）

### 3.1 推理框架：三阶段

![TOOLQP 框架总览](figures/fig_p03_image_0.png)
*Figure 1：Planner 把复杂用户查询（如旅行规划）分解为顺序子任务，对每个子任务交互式生成查询 → 处理稠密检索器反馈 → 必要时自我纠正 → 最后聚合相关工具集。*

1. **Planning by Task Decomposition**：生成自然语言计划 P，把 q 分解为子任务序列 {s_n}。与依赖昂贵 prompt 大模型的方法不同，这个分解能力是**学出来的**（小模型 1.7B）。
2. **Interactive Query Generation**：在计划引导下，针对每个子任务交互式生成查询序列 {q_t}；每步观察 O_t = E(q_t; D) 再生成 q_{t+1}。例：先召回的相关工具需要 `region_id` 输入 → 下一步就生成针对 lookup 工具的查询。持续到模型判断子任务已覆盖，得到轨迹 {(q_t, O_t)}。
3. **Retrieval Aggregation（peak-rank）**：对每个出现过的一次工具 d ∈ ∪O_t，取它**在任意一次检索中达到的最高名次**作为最终排名。

#### 数学实例 ①：为什么 peak-rank 优于 RRF？
设子任务 A（1 次查询）命中工具 X 的名次为 [1]，子任务 B（3 次查询）反复命中工具 Y，名次 [3,3,3]。

- **RRF**（k=60）：score(X) = 1/61 = 0.01639；score(Y) = 3/63 = 0.04762 → **Y 排在 X 前面**。Y 只是"被频繁尝试的子任务"反复命中，X 却是某次查询的**第一名**——RRF 的频率偏置把结果带偏。
- **Peak-rank**：rank(X)=1 < rank(Y)=3 → **X 排第一**，与直觉一致。

实验佐证（Table 4）：peak-rank 53.9 N@10 vs RRF 50.9（in-domain），与更复杂的多视图融合（54.1）持平。

#### 数学实例 ②：nDCG@10 与 Completeness@10
Ground truth 工具 T* = {a, b, c}，某方法 top-10 返回 `a, x, b, ...`（a 第 1 位，b 第 3 位，c 未进前 10，二进制相关度）：
- DCG@10 = Σ rel_i / log2(i+1) = 1/log2(2) + 1/log2(4) = 1 + 0.5 = 1.5
- IDCG@10（理想排序 a,b,c 在前三）= 1 + 1/log2(3) + 1/log2(4) = 1 + 0.6309 + 0.5 = 2.1309
- **nDCG@10 = 1.5 / 2.1309 ≈ 0.704**
- **Completeness@10 = 𝟙[R@10 = 1] = 0**（c 没找全 → 0；这是"工具必须集齐才能执行任务"这一 agent 场景特性的指标）

### 3.2 数据合成 + SFT（Algorithm 1）

标准数据集只有 (用户查询 q, 真值工具集 T*)，没有查询轨迹 → 用教师模型（gpt-4.1-mini）合成，三个阶段：

1. **Plan Alignment**：教师把高层计划 P 解析成离散子任务，并把 T* 的子集分配给每个子任务 → 得到 (s_n, T*_n) 映射。
2. **Query Generation**：教师**只看子任务描述**（不喂目标工具名！）为每个子任务生成 N 个候选查询 → 逼教师描述"想要的功能"而非背工具名。课程学习兜底：若候选全部失败，迭代地把更多目标信息加进 context 重新生成。
3. **Query Verification**：N 个候选全部送检索器，选**平均名次最优且优于阈值 r_τ** 的候选作为有效查询（r_τ = 5，即目标工具平均要进 top-5）。以 0.4 的概率**保留失败尝试**（低名次查询 + 后续成功查询的序列），显式教模型"试错—纠正"。

#### 数学实例 ③：候选选择
子任务 s = "查询某地区天气"，T*_n = {getWeatherByCity}。教师生成 3 个候选：
| 候选 | 检索后 T*_n 中工具的名次 | 平均名次 AvgRank |
|---|---|---|
| q1 "weather API for city" | [2] | 2 ✅ ≤ r_τ=5 |
| q2 "get current temperature" | [11] | 11 ❌ |
| q3 "meteorological data service" | [7] | 7 ❌ |

选 q1 进入轨迹。若三个全部 > 5，则 ADDMOREINFO（加入"按城市名查天气"等目标线索）重新生成一轮。

SFT：标准最大似然 + teacher forcing，反馈取 top-5 检索结果；3 epochs、lr 2e-5、batch 32、max seq 16384；训练数据为 ToolRet 训练集（源自 ToolBench/ToolACE/APIGen，Web 类）抽样 10k 条。

### 3.3 RLVR（GRPO）

SFT 只是蒸馏教师；RLVR 让模型自己探索更优查询策略。总奖励：

$$R = \beta_1 R_{\text{retrieval}} + \beta_2 R_{\text{format}} + \beta_3 R_{\text{plan}}$$

- **R_retrieval = β_{1,n}·ΔN + β_{1,r}·ΔR**：**序列级**奖励。ΔN = 最终聚合列表的 nDCG@5 与基线（直接用 Concat(q, P) 检索）的 nDCG@5 之差；ΔR 同理用 recall 差。**对比基线的相对奖励**鼓励模型优化全局覆盖而非单步。
- **R_format = β_{2,f}·R_f + β_{2,s}·R_s**：格式合规比例 + 序列是否以 `<stop_retrieval>` 结束。
- **R_plan = Sim(P̂, P)**：生成计划与参考计划的 embedding 余弦相似度（用 gte-Qwen），防止 RL 探索时偏离用户意图。
- 权重：β_{1,n}=5.0，β_{1,r}=2.5，β_{2,f}=1.5，β_{2,s}=0.6，β_3=1.0。

#### 数学实例 ④：奖励计算
某 rollout 最终聚合列表 nDCG@5 = 0.82、Recall@5 = 0.67；基线 Concat(q,P) 检索 nDCG@5 = 0.70、Recall@5 = 0.33；格式全对（R_f=1, R_s=1）；计划相似度 0.9：
- R_retrieval = 5.0×(0.82−0.70) + 2.5×(0.67−0.33) = 0.60 + 0.85 = 1.45
- R_format = 1.5×1 + 0.6×1 = 2.1
- R_plan = 1.0×0.9 = 0.9
- **R = 1.45 + 2.1 + 0.9 = 4.45**（负的 ΔN/ΔR 会被惩罚，例如检索反而变差时 R_retrieval < 0）

GRPO 配置：verifiers 库实现多步 rollout；500 步、lr 1e-6、有效 batch 256、KL 正则 0.02、group size 4、每轮 top-5 反馈、最多 10 轮查询、dev set 早停。

---

## 4. 实验部分（设计动机 + 结果解读）

### 4.1 检索主实验（ToolRet）
**为什么这么设计**：ToolRet 覆盖 35 个数据集、Web/Code/Custom 三域、44k 工具。训练源（ToolBench/ToolACE/APIGen）全属 Web 类 → Web 测试集 = **in-domain**，Code/Custom = **真零样本**。这个划分刻意检验"学到的是规划能力还是数据记忆"。基线三梯队刻意对齐三种干预层级：prompting（Qwen3-30B 的 Q2E/Q2D/HyDE/D2Q/Re-Invoke）→ re-ranking（bge-m3 / bge-gemma cross-encoder）→ fine-tuning（Q2P-SFT、ContrastiveFT）。

| 方法（Avg） | N@10 | C@10 |
|---|---|---|
| Base 检索器 gte-Qwen | 29.8 | 27.0 |
| 最强 prompting (Q2E/ZS) | 32.0 | 29.8 |
| 最强 re-rank (bge-gemma) | 34.0 | 29.7 |
| Q2P/SFT | 33.2 | 31.1 |
| **TOOLQP** | **36.9** | **35.8** |
| TOOLQP-FORMAT（in-domain 最强 63.1/66.1） | 26.1 | 25.9 |

**结果说明**：
- 零样本上 TOOLQP 超 cross-encoder re-ranker ~3%（N@10）/ ~6%（C@10）→ **交互式查询规划比昂贵的后置交叉注意力重打分更能"找全"相关工具**；
- in-domain 上 TOOLQP-FORMAT（SFT 时把工具 schema 格式也作为生成目标）超 ContrastiveFT ~6% → 显式建模工具 schema 对特定领域收益大，但它是**特化**（zero-shot 掉到 26.1），通用性要靠标准版 TOOLQP；
- 1.7B 模型胜过 30B 多轮 prompting → 收益来自**框架与训练**，不是模型规模。

### 4.2 跨检索器迁移
**为什么这么设计**：TOOLQP 的 SFT 数据和 RLVR 环境都只用 gte-Qwen 一个检索器。若测试时换检索器（bge-large、e5-base、e5-mistral-7b、两个 ToolRet 微调版共 5 个）仍能涨点，说明规划策略学到的是**通用语义性质**而非对特定 embedding 空间过拟合。

**结果**（Table 2，相对各基线检索器的平均增益）：zero-shot 场景 TOOLQP ΔN@10 = **+5.4**、ΔC@10 = **+7.1**，全面超过 Q2E(+2.2/+2.8)、D2Q(+2.8/+2.8)、Re-Invoke(+5.2/+5.4)。in-domain 上 TOOLQP-FORMAT 涨最多（+9.4/+9.6）但零样本增益缩水（+1.6），再次印证"特化 vs 通用"的权衡。

### 4.3 端到端工具调用
**为什么这么设计**：检索指标好 ≠ agent 任务好。API-Bank（73 工具，Level-1 被改造为强制走 ToolSearcher）测小工具库；StableToolBench（I2-Cat 13k 工具 / I3-Inst 1.6k 工具，ReAct 流水线 + MirrorAPI 仿真）测大工具库多步组合。若 TOOLQP 在 73 工具的小库上也有效，说明收益不只来自"大库才需要规划"。

**结果**：API-Bank Level-1/2 = 33.0/60.7（基线 30.2/57.8，约 +3%）；STB I2-Cat **60.2 vs 51.9**、I3-Inst **48.3 vs 40.3**（+8~9%）。且 TOOLQP 是唯一在所有子集都不掉点的方法（Re-Invoke 在 I3-Inst 崩到 28.6）→ 规划轨迹给下游 LLM 提供了**稳定可靠的 grounding 上下文**。注意 STB 的工具 embedding 格式与训练时不同仍有效 → 再次验证鲁棒性。

### 4.4 消融（每项都对应一个设计决策）
| 变体 | In-Domain N@10 | 0-Shot N@10 | 结论 |
|---|---|---|---|
| PROMPTING（Qwen3-30B 零样本跑同管线） | 45.6 | 34.0 | 框架本身就有效（已超所有 prompting 基线） |
| SFT | 52.4 | 35.4 | **in-domain 增益主要来自 SFT** |
| RLVR | 53.9 | 36.9 | **RLVR 主要精调 out-of-domain 策略** |
| RRF 聚合 | 50.9 | 35.4 | peak-rank 缓解频率偏置 |
| Multi-view 融合 | 54.1 | 37.0 | 复杂融合不必要，peak-rank 够用 |
| 去掉用户原始查询 | 52.3 | 34.8 | 原始查询是分解出错的"锚点"，必须保留 |

### 4.5 定性分析
![TOOLQP 发现隐式依赖](figures/fig_p08_image_22.png)
*Figure 2："modify password" 任务隐式依赖 GetUserToken 提供的 token。dense/Q2E/Q2D/Q2P/Re-Invoke 全部只召回密码修改类工具；TOOLQP 的子目标查询显式包含 "user authentication"，把 GetUserToken 也拉进 top-5。*

---

## 5. 最终结论

- 把工具检索从**静态单步匹配**重构为**迭代规划过程**，用合成轨迹 SFT + RLVR（GRPO）训练一个 1.7B 轻量规划器，即可在任意稠密检索器之上显著提升检索与下游执行。
- 关键经验：① in-domain 增益靠 SFT、零样本增益靠 RLVR；② 简单 peak-rank 聚合优于 RRF；③ 原始用户查询要作为锚点保留；④ 交互反馈是发现**工具间隐式依赖**的关键（_trial-and-error 而非知识图谱_）。
- **局限（作者自述）**：合成数据只用单一基线检索器（可探索多检索器合成）；隐式 trial-and-error 不如显式 Tool Knowledge Graph 高效；小工具库上迭代规划是杀鸡用牛刀（延迟换精度不划算），需要自适应的"简单查询直接答"机制。

---

## 6. 相关文献地图

| 文献 | 关系 |
|---|---|
| Shi et al. 2025 (ToolRet) | 基准来源 + 训练数据编译 + "检索模型不懂工具"的问题提出者 |
| Chen et al. 2024b (Re-Invoke) | 最强 expansion 基线：意图抽取 + D2Q；TOOLQP 在依赖发现上胜出 |
| Wang et al. 2023b (Query2doc/Q2D)、Gao et al. 2023 (HyDE)、Nogueira 2019 (doc expansion) | 传统查询/文档扩展路线，单步、无交互 |
| Qu et al. 2024 (Completeness-oriented tool retrieval) | 指出多工具组合是工具检索独有难点 |
| Shao et al. 2024 (DeepSeekMath/GRPO)、Lambert 2024 (Tulu 3/RLVR) | RL 训练方法基础 |
| Qin et al. 2024b (ToolLLM)、Li et al. 2023b (API-Bank)、Guo et al. 2025b (StableToolBench) | 下游评测环境 |
| Fang et al. 2025 (PLAY2PROMPT) | 同组前作：零样本工具指令优化 |
| Xu et al. 2024 | 检索器微调内嵌扩展；与 TOOLQP 的"外挂规划层"路线相对 |

## 7. 对"功能缺口感知检索（Function-Gap Aware Querying）"的启示

- **可直接继承**：把"用户意图词汇 ↔ 工具功能词汇"的 gap 显式建模为**生成式子目标查询**，而非 embedding 对齐；查询轨迹 + peak-rank 聚合是现成可复用的工程骨架。
- **可超越之处**：① TOOLQP 的分解是"计划驱动"，**没有显式建模"当前已召回的工具集 vs 任务所需能力"之间的缺口（gap）**——它的反馈利用是隐式 trial-and-error；Function-Gap Aware 可以把"缺口"显式定义为状态函数（已覆盖功能 ⊖ 所需功能），让每一步查询针对性填补缺口；② 作者自己在 Limitations 里点名：trial-and-error 探索可被 Tool Knowledge Graph / 显式依赖建模替代——这正是切入空间；③ 单一基线检索器的偏差是公认弱点。
