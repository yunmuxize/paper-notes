# IGSD: Environment-Verified Hindsight Self-Distillation for Search Agents 笔记

> **原文**: Jiang et al. (USTC / 清华 / 美团), arXiv:2609.32694, 2026-09-26
> **链接**: https://arxiv.org/abs/2609.32694 ｜ 代码：https://github.com/PhilipGAQ/igsd_code ｜ 双栏翻译：`babeldoc-output-IGSD_2609.32694/`
> **个人定位**: 本文的**环境验证自蒸馏（Environment-Verified Hindsight Self-Distillation）**与**信息增益门控（Information-Gain-Gated）**是后续设计"贡献归因型检索（Execution-Grounded Search Credit）"时**必须精读和超越的核心 baseline**。

---

## 1. 摘要

On-policy 自蒸馏无需外部教师即可致密化 agent 训练：让以**特权事后信息（privileged hindsight）**为条件的策略（teacher），为自己无特权的 rollout（student）提供步级指导。但对搜索 agent 而言，**hindsight 会让教师偏好一个"从 student 当前状态出发并不能改善检索"的查询**。现有方法（SD-Search 直接蒸馏；SDAR 用模型内部分数过滤）都**没有验证查询被执行后的真实检索后果**。

IGSD 的做法：把每个查询 token 当作**微动作（micro-action）**，在蒸馏之前用**环境反馈**验证 on-policy 的 token 提案——teacher 提案 token 与 student 采样 token 被同一个冻结策略补全成两个查询，从**同一个失败状态、用同一个检索器**执行。共享的反事实对照（counterfactual control）扣除"查询措辞本身对答案似然的影响"，两者之差即**执行配对信息增益（executed paired information gain, ΔIG）**，作为检索证据效用的相对对比。IGSD 把 ΔIG 作为 **positive-only 软权重**用于候选对蒸馏，GRPO 目标不变，验证只在训练期进行、推理零开销。

7 个单跳/多跳 QA 基准：3B 策略 macro-EM **42.8%**，7B 策略 **47.0%**（均为所测方法最高），且推理时无需任何验证。

---

## 2. 故事逻辑

### 2.1 递进式 problem chain（论文叙事非常工整，四步）

```
Search-R1 等轨迹级 RL
   └─ 问题：奖励只看最终答案 → 有用的查询和冗余/误导的查询拿到同样的轨迹级 credit
        → 中间搜索决策没有细粒度监督
Hindsight Self-Distillation（SD-Search, Search-E1, SDAR）
   └─ 修复：用成功 sibling 的 hindsight 提示让教师回看失败轨迹，给步级指导
        └─ 新问题：hindsight 偏好 ≠ 执行有效性！
           一个查询在"成功的兄弟轨迹"里有用，在 student 的失败状态里可能：
             ① 冗余（证据已在轨迹里）② 缺桥接实体根本查不到东西
SDAR 的模型内部过滤（teacher-student 似然差）
   └─ 仍是"模型偏好"，不是"执行后果" → teacher-supervision reliability gap
IGSD
   └─ 搜索 agent 的独特优势：每个搜索动作天然产生环境反馈
      → "指导是否真有用"这个问题可以靠【执行】回答，而不是靠【内省】
```

### 2.2 两个失败案例直觉（论文 Table 4，先建立直觉）

- **Case A（教师对，要保留）**：问题问某女演员出名的是哪部 CBS 情景剧。student 证据里已识别出 Berlinda Tolbert 但没展开，student 查询用模糊的 "the actress" → 查回 Ricki Lake，答错。hindsight 教师把**已识别的实体**编码进查询 "which CBS sitcom was **Berlinda Tolbert** better known for..." → 查回 The Jeffersons，答对。ΔIG = **+3.58** → 保留蒸馏。
- **Case B（教师错，要拒绝）**：问题问"精神分析之父的父亲"。证据已含 Sigmund Freud。student 直接查 "father of Sigmund Freud" → 查回 Jacob Freud，答对。hindsight 教师反而把**已解决的关系**再嵌套复述一遍 → 检索返回原文，答错。ΔIG = **−0.198** → **负增益，拒绝蒸馏这个教师提案**。

> 这就是标题里 "environment-verified" 的含义：**教师说了不算，检索器执行结果说了算。**

### 2.3 贡献声明
1. **环境验证的事后蒸馏**：把教师建议转成局部候选动作，蒸馏前从 student 状态实际执行验证检索后果；
2. **配对效用门控**：定义执行配对信息增益（共享反事实对照），作为 positive-only 软权重加在候选对蒸馏损失上，GRPO 目标完全不动；
3. **实证 + 机理分析**：7 基准 × 3B/7B，并证明 ΔIG 与最终答案正确性的对齐度**强于所有被测的模型内部信号**。

---

## 3. 算法逻辑（含数学实例）

![IGSD 总览](figures/fig_p03_image_0.png)
*Figure 1：左：特权 hindsight 对失败 student rollout 产生教师提案；中：教师 token 与 student 采样 token 由同一冻结策略补全成匹配查询、用同一检索器执行；右：环境效用对比 ΔIG_i 作为 positive 软门控候选对蒸馏，与不变的 GRPO 目标并行。*

### 3.1 形式化设置

- 问题 x，策略 πθ 生成多轮轨迹 τ（思考 ↔ search 动作 ↔ 观测 → 答案）；答案评估器给标量 r(τ)。
- 对**失败轨迹**（组内存在成功 sibling）构造辅助监督：取**最后一个有效搜索动作**。设其前缀为 h_S，序列化工具调用 z = (z₁,…,z_M)，查询字段内的 tokenizer 位置 I_Q = {k₁,…,k_N}，student 在 k_i 采样到的 token s_i = z_{k_i}。
- **Hindsight 教师提示** H⁺ = (Q⁺, r⁺)：来自奖励最高的成功 sibling，**只含其搜索查询和得分**，不含答案/推理/检索文档。
- 教师 = **同一个冻结策略 checkpoint**，但条件上加 hindsight：h_T = P_T(x, h_S, H⁺)。
- 同一决策状态、有无提示两个分布（式 2）：
  p^T_i(v) = π_{θ_old}(v | h_T, z_{<k_i})，p^S_i(v) = π_{θ_old}(v | h_S, z_{<k_i})
- **候选微动作**：t_i = argmax_v p^T_i(v)。t_i = s_i → 教师认可；t_i ≠ s_i → 形成候选对 S_i = {t_i, s_i}，进入执行验证。

### 3.2 配对环境验证（核心机制）

**匹配补全（式 3）**：把候选 token 固定在 k_i，用**冻结 student 策略、无 hindsight 提示、贪心解码**补全剩余查询：
Q^T_i = Complete(h_S, z_{<k_i} ⊕ t_i)，Q^S_i = Complete(h_S, z_{<k_i} ⊕ s_i)

> 两条分支共享：状态、前缀、补全策略、解码过程、检索器——**只差 k_i 处那一个 token**。这是干净的"单 token 干预"因果对照。

**文档效用 + 反事实对照（式 4）**：文档集 D 的得分 = 冻结策略对参考答案 alias 的平均 token log-likelihood（取 alias 最大值）：
L^b_i(D; A_i) = max_{a∈A_i} log π_{θ_old}(a | h_S, Q^b_i, D)，b ∈ {T, S}

**为什么要反事实对照**：查询措辞本身就会改变答案似然（即使检索文档一模一样）。所以每个候选对从语料随机抽 C 个**与真实检索集同尺寸同格式**的反事实文档集 D̃_ij，给两条分支**共享**。

**执行配对信息增益（式 5）**：
$$\Delta IG_i = \frac{1}{C}\sum_{j=1}^{C}\Big[L^T_i(D^T_i;A_i) - L^T_i(\tilde{D}_{ij};A_i)\Big] - \Big[L^S_i(D^S_i;A_i) - L^S_i(\tilde{D}_{ij};A_i)\Big]$$

即（教师真实文档增益）−（student 真实文档增益），各自都先减去"随机文档下的基线似然提升"，把**纯检索证据的贡献**剥离出来。反事实集从当前训练 batch 检索到的 passage 池中均匀无放回采样（排除本分支已检索的），C = 3。

#### 数学实例 ①：ΔIG 计算（仿 Case A 构造数字）
问题答案 alias A = {"The Jeffersons"}，C = 1（简化）：

| 分支 | 真实检索文档下 log π(a) | 随机反事实文档下 log π(a) | 证据增益 |
|---|---|---|---|
| 教师（Berlinda Tolbert 查询） | −2.10 | −3.50 | +1.40 |
| student（the actress 查询） | −3.00 | −3.40 | +0.40 |

ΔIG = 1.40 − 0.40 = **+1.00** > 0 → 教师查询的证据带来了更多答案支持，保留。

（Case B 的情形：教师嵌套查询检索回的原文让答案似然反而更低 → ΔIG = −0.198 < 0 → 拒绝。）

### 3.3 增益门控的候选对蒸馏

**Positive-only 软门（式 6）**：
$$w_i = \text{sg}\Big(\max\big(0,\ \tanh(\tfrac{\beta}{2}\Delta IG_i)\big)\Big)$$
sg = stop-gradient（门是权重，不传梯度）；ΔIG ≤ 0 → w_i = 0，该候选对**完全不蒸馏**；ΔIG 越大权重越接近 1（tanh 饱和）。

#### 数学实例 ②：门控值（取 β = 2）
- Case A：w = max(0, tanh(1 × 1.00)) = tanh(1) ≈ **0.76**
- ΔIG = +3.58（真实 Case A）：w = tanh(3.58) ≈ **0.998**
- Case B：ΔIG = −0.198 → w = **0**，直接跳过。

**候选对目标（式 7-8）**：把教师目标分布与当前 student 分布在**两个 token 的支撑集** S_i 上重归一化，然后算 Jensen–Shannon 散度：
$$\mathcal{L}_{pair}(i) = \tfrac{1}{2}KL(\bar{p}^T_i \| \mu_i) + \tfrac{1}{2}KL(\bar{q}_{\theta,i} \| \mu_i),\quad \mu_i = \tfrac{\bar{p}^T_i + \bar{q}_{\theta,i}}{2}$$

#### 数学实例 ③：JSD 损失计算
设某位置教师分布重归一化后 p̄ᵀ = (0.9, 0.1)（教师强烈倾向 t_i），student 当前 q̄θ = (0.6, 0.4)：
- μ = (0.75, 0.25)
- KL(p̄ᵀ‖μ) = 0.9·ln(0.9/0.75) + 0.1·ln(0.1/0.25) = 0.9(0.1823) + 0.1(−0.9163) = 0.0725
- KL(q̄θ‖μ) = 0.6·ln(0.6/0.75) + 0.4·ln(0.4/0.25) = 0.6(−0.2231) + 0.4(0.4700) = 0.0541
- **L_pair = ½(0.0725 + 0.0541) = 0.0633**
- 若 w = 0.76，则该位置的加权贡献 = 0.76 × 0.0633 ≈ **0.048**（再除以查询 token 总数 |I_Q| 归一化）

**联合目标（式 9）**：
$$\mathcal{L}_{IGSD}(\mathcal{Q}) = \frac{1}{|I_Q|}\sum_{i\in V_Q} w_i \mathcal{L}_{pair}(i),\qquad \mathcal{L}_{actor} = \mathcal{L}_{GRPO} + \lambda\,\mathbb{E}_\mathcal{Q}[\mathcal{L}_{IGSD}(\mathcal{Q})]$$
V_Q = {i : ΔIG_i > 0}。**除以全部查询 token 数** → 被拒绝的位置贡献 0，辅助项不会因为"拒绝得多"而膨胀。验证只在训练期；推理时就是普通搜索 agent（无教师、无验证分支、无额外检索调用）。

### 3.4 训练覆盖漏斗（Appendix A.3，理解机制规模）
| 阶段 | 比例 |
|---|---|
| 查询 token 中教师–student 不一致（形成候选） | 9.22% |
| 提交配对验证 / 验证有效 | 99.68% / 99.90% |
| 有效对中 ΔIG > 0（教师提案真有用） | **53.45%**（≈一半教师的 hindsight 提案被执行证伪！） |
| 最终获得非零蒸馏权重的 token | 4.91% |

> 这个漏斗是本文最有说服力的证据之一：**如果不验证，约一半的蒸馏信号是有害或无效的。**

---

## 4. 实验部分（设计动机 + 结果解读）

### 4.1 实验配置
**为什么这么设计**：完全对齐 Search-R1 / SD-Search 的协议——NQ+HotpotQA 训练，7 个评测集（单跳 NQ/TriviaQA/PopQA + 多跳 HotpotQA/2Wiki/MuSiQue/Bamboogle）报 EM；检索器 E5-base-v2 + 2018-12 Wikipedia，每次取 top-3，最多 6 轮；Qwen2.5-3B/7B-Instruct；8×A100，batch 256 prompts × 5 rollouts，lr 1e-6，400 步。这样所有 baseline 数字（Search-R1、ReSearch、AutoRefine、IGPO、GiGPO、CRAFT、SD-Search、LOTAPO）可直接对比，且基线覆盖三个监督层级：推理 only / 轨迹级 RL / 过程级监督。

### 4.2 主结果（RQ1）
| 方法（3B macro-EM） | Avg. | | 方法（7B macro-EM） | Avg. |
|---|---|---|---|---|
| Search-R1 | 0.394 | | Search-R1 | 0.445 |
| AutoRefine（最强轨迹级 RL） | 0.400 | | SD-Search | 0.456 |
| IGPO / GiGPO / CRAFT / LOTAPO | 0.385–0.398 | | IGSD w/o Gate | 0.453 |
| SD-Search（最强过程级） | 0.415 | | **IGSD** | **0.470** |
| IGSD w/o Gate | 0.417 | | | |
| **IGSD** | **0.428** | | | |

**结果说明**：
- vs 轨迹级 RL：+2.8 点（0.428 vs 0.400）→ **步级监督有超出轨迹级奖励的净价值**；
- vs 无门控对照（唯一差别是去掉执行验证门）：0.428 vs 0.417 → 剩余 +1.1 点**全部归因于执行增益加权**——门控是过程信号的**必要组件**而非锦上添花；
- 三种子重复实验排名不变；7B 上优势保持（多跳 4 项全部领先）→ 规模可迁移。
- **训练稳定性**（Figure 2）：Search-R1 约 200 步后平台期；IGSD w/o Gate 全程震荡（未验证的 hindsight 时好时坏）；IGSD 全程平滑上升 → 执行过滤"保留有用提案、压制有害提案"。

![IGSD 训练曲线](figures/fig_p06_image_3.png)
*Figure 2：固定验证集上的 macro-average 训练曲线——Search-R1 早升后平台、IGSD w/o Gate 震荡、IGSD 平滑持续提升。*

### 4.3 机理证据（RQ2：ΔIG 真的对齐下游效用吗？）
**设计**：对 307 个候选对，把两个分支各自走完轨迹到终止答案，测真实 EM；再比较"用 ΔIG 预测哪条分支最终赢"的能力（ROC-AUC，72 个终止分歧对，question-cluster bootstrap）。

![IGSD 机理证据](figures/fig_p07_image_2.png)
*Figure 3：(a) 按增益符号分组的分支准确率；(b) 各 ΔIG 区间的终止准确率差；(c) 四种信号的 winner 预测 AUC。*

**结果**：
- 全体：教师分支 EM 0.326 vs student 0.215；
- ΔIG > 0 时：0.378 vs 0.199（教师大幅占优）；ΔIG ≤ 0 时两者互有胜负 → **门控确实筛掉了教师不占优的对**；
- 分区间看配对准确率差（Figure 3b）：低增益区小且波动，ΔIG∈[0.5,1] → +20.0pp，**ΔIG≥1 → +44.8pp** → ΔIG 是**有梯度的效用对比**，不只是符号；
- 信号对比（Figure 3c）：执行增益 AUC **0.708** [0.568, 0.836] ≫ 最强模型内部信号（teacher-student 似然差）0.552，教师 top-1 置信度仅 0.401（比随机还差！）→ **模型"自信"与"真有用"基本脱钩**；
- 零阈值符号预测：72 对中赢 47 对（65.3%，CI [54.2%, 76.1%]）；ΔIG>0 组内 85% 是教师唯一正确。

### 4.4 消融（RQ3：决策链每一环都不可少）
**设计逻辑**：消融沿"决策链局部化"三要素逐一拆除——① 对比对象是不是 student 实际采样的 token；② 对比是否发生在执行之后；③ 权重是否只作用于对应的候选对。

| 变体（3B macro-EM） | Avg. | 拆掉了什么 |
|---|---|---|
| **IGSD（完整）** | **0.428** | — |
| All-turn verification（验证所有轮而非最后轮） | 0.421 | 最后轮上下文最全、分歧最具体；多验无益 |
| w/o sampled-token branch（只看教师分支） | 0.397 | 没有配对参照，ΔIG 无从谈起（掉 3.1 点，最痛） |
| w/o counterfactual control | 0.405 | 查询措辞的似然污染回来了（掉 2.3 点） |
| Student argmax（用 student 贪心 token 替代采样 token） | 0.413 | 采样 token 才是"策略真实行为"的对照 |
| w/o Gate（单位权重） | 0.417 | 不验证，好坏提案一起蒸 |
| Log-probability gate（用似然差当权重） | 0.409 | **模型内部信号替代执行验证 → 更差** |
| Query-level gate（查询内平均 ΔIG） | 0.419 | 平均会抹平局部 token 差异 |
| Top-50 JSD / reverse-KL（扩大蒸馏支撑） | 0.419 / 0.420 | 蒸馏质量应聚焦在"被环境裁决过的 2 个 token"上 |

**结论**：完整决策链（配对 + 反事实 + 采样参照 + 逐对门控 + 窄支撑 JSD）每个组件都有正贡献，且"执行信号优于内部信号"这条主线被门控消融与 AUC 双重确认。

### 4.5 定性案例
见 §2.2 的 Case A/B。值得一提的反直觉点：**hindsight 教师并非总对**——Case B 中教师把已解决的关系冗余复述，执行结果更差；IGSD 的贡献正是建立了"敢拒绝教师"的机制。

---

## 5. 最终结论

- 对搜索 agent，hindsight 教师偏好必须经过**环境执行验证**才能作为监督：IGSD 用同状态、同补全策略、同检索器的配对执行 + 共享反事实对照，得到 ΔIG 这一行动粒度的环境效用对比；
- ΔIG 以 positive-only 软权重进入候选对 JSD 蒸馏，**GRPO 目标与推理流程零改动**；
- 7 基准 × 3B/7B 全面领先（42.8% / 47.0% macro-EM），且 ΔIG 与终止效用的对齐度强于所有被测模型内部信号；
- **局限（作者自述）**：依赖参考答案来估计文档效用 → 只适用于有明确答案/可靠评估器的任务，不能直接用于开放式任务；训练期增加分支补全、执行、评分开销（但局部化验证 + 受限反事实预算可控）。

---

## 6. 相关文献地图

| 文献 | 关系 |
|---|---|
| Jin et al. 2025 (Search-R1) | 轨迹级 RL 基础设定 + 训练/评测协议来源 |
| Ma et al. 2026 (SD-Search) | 最直接的 predecessor：on-policy hindsight 自蒸馏，**无逐候选执行验证**（IGSD 的 w/o Gate 近似它 + 候选构造） |
| Lu et al. 2026 (SDAR) | 用 teacher-student 似然差做 token 级门控——"模型内部信号"路线的代表，被 IGSD 实验证明 inferior |
| Liang et al. 2026a (IG-Search) / Wang et al. 2025 (IGPO) | 信息增益作为 RL 信号（不改变梯度目标的辅助信号 vs IGSD 只做蒸馏权重） |
| Wang et al. 2026 (Skill-SD) | 技能条件化的特权自蒸馏（多轮 agent） |
| Meng & Chen 2026 (CRAFT) / Zhu et al. 2026 (LOTAPO) | 从 sibling rollout 估计 token/过程级 credit |
| Feng et al. 2025 (GiGPO) | 组中组优势估计，步级 RL 信号 |
| Shao et al. 2024 (GRPO/DeepSeekMath)、Sheng et al. 2025 (veRL) | 训练框架基础（SearchAgent-Zero 封装） |
| Yao et al. 2023 (ReAct) | 交错的推理-检索-行动范式 |

## 7. 对"贡献归因型检索（Execution-Grounded Search Credit）"的启示

**必须吸收的核心思想**：
1. **"执行验证 > 模型内省"** 是本文最大的一级原理：任何检索贡献的归因都应落到真实执行（检索 → 文档 → 下游答案似然/任务结果）上，而不是模型打分；
2. **配对反事实对照**（同一状态、同一补全、同一检索器，只差一个动作；随机文档集扣除措辞效应）是干净的因果归因模板，可直接移植为 Search Credit 的度量协议；
3. 训练漏斗（9.22% 分歧 → 53.45% 有效 → 4.91% 通过门控）说明**归因信号天然稀疏**，门控/加权的稀疏化设计值得保留。

**可超越之处**（写 related work / motivation 时的攻击点）：
- ① **归因粒度仍是 token 级微动作 + 事后 hindsight**：ΔIG 度量的是"教师提案 vs student 采样"的相对差，不是对整个轨迹最终成功的**绝对贡献分解**；Execution-Grounded Search Credit 可以做轨迹级的 credit 分配（如对每步检索做 leave-one-out 或 Shapley 式执行归因）；
- ② **效用代理 = 参考答案似然**：依赖 gold answer，无法处理开放式/工具型任务（作者自己承认）；用任务级结果奖励或无参考的效用估计可扩大适用域；
- ③ **验证只用于训练期蒸馏门控**，不改变探索策略本身；把执行增益直接接入 advantage/奖励（作者刻意不做，为了不动 GRPO）是一个显式可对比的变体；
- ④ 反事实对照只有 C=3 随机文档集，**对"措辞效应"的剥离是近似**；更强的对照（如同查询改写、检索消融）可以更干净。
