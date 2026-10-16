---
title: GEPA — 反思式提示演进可超越强化学习
authors: ["Lakshya A Agrawal", "Shangyin Tan", "Dilara Soylu", "Noah Ziems", "Ion Stoica", "Dan Klein", "Matei Zaharia", "Omar Khattab"]
venue: ICLR 2026 (Oral)
arxiv: 2507.19457
code: https://github.com/gepa-ai/gepa
tags:
  - prompt-optimization
  - reflection
  - evolutionary-search
  - pareto
  - agent
  - LLM
  - 论文精读
created: 2026-10-15
updated: 2026-10-16
source: ChatGPT 精读对话 (gpt-6-thinking, gpt-6) + 论文原文 + MinerU v4 flash 版面解析
mineru_tier: flash
status: complete
---

# GEPA — 反思式提示演进可超越强化学习

> [!abstract] 一句话概括
> GEPA 利用 LLM 对执行轨迹进行**自然语言反思**，在 **Prompt 空间**（而非模型参数空间）中通过**遗传式改写 + Pareto 选择**搜索更优策略，在少量 rollout 下实现超越 GRPO 的任务表现。

> [!info] 论文信息
> - **标题**：GEPA: Reflective Prompt Evolution Can Outperform Reinforcement Learning
> - **收录**：ICLR 2026 (Oral)
> - **arXiv**：2507.19457v2 [cs.CL] 14 Feb 2026
> - **代码**：https://github.com/gepa-ai/gepa
> - **机构**：UC Berkeley, Stanford, BespokeLabs.ai, Notre Dame, Databricks, MIT
> - **精读来源**：基于 ChatGPT (gpt-6-thinking) 9 轮精读对话整理，配合论文 Figure 1-8

---

## 1. 核心动机：语言是比标量奖励更丰富的学习媒介

### 1.1 作者的核心论断

> We argue that the **interpretable nature of language** often provides a much richer learning medium for LLMs, compared to **policy gradients derived from sparse, scalar rewards**.

翻译：与从稀疏标量奖励中计算得到的策略梯度相比，**自然语言的可解释性往往能为 LLM 提供信息更丰富的学习媒介**。

这是整篇论文的理论直觉——不是证明语言总比梯度有效，而是指出：当环境能提供丰富的执行轨迹、错误信息和反馈时，将其压缩成一个标量奖励会**丢失大量有价值的学习信息**。

### 1.2 传统 RL vs GEPA：一个对比示例

假设任务是回答「北京大学成立于哪一年」，模型答 1902 年，正确答案是 1898 年。

**方法 A：传统强化学习（PPO / GRPO）**

- 信号：$R = -1$（一个标量）
- 模型只知道「这次错了」，不知道**为什么**错
- 需要大量样本 + 梯度更新才能学到正确行为
- 优化对象：**模型参数**

**方法 B：GEPA 的自然语言反思**

- 反思：*「本次回答混淆了北京大学的创办时间（1898）与更名时间（1902）。今后遇到历史年份问题，应先区分创办、改名和重组等不同事件。」*
- 将经验直接写入新 Prompt
- 优化对象：**Prompt**（不更新模型权重）

| 比较维度 | 传统策略梯度 RL | GEPA |
|---|---|---|
| 学习信号 | 标量奖励 + 导出梯度 | 自然语言反馈 + 反思 |
| 错误原因 | 通常需隐式学习 | 可显式描述 |
| 改进方式 | 更新模型参数 | 修改 Prompt |
| 是否训练权重 | 通常需要 | **不需要** |
| 经验可解释性 | 相对较低 | 相对较高 |

> [!tip] 关键认知
> 传统 RL 在**参数空间**中寻找更优策略；GEPA 利用 LLM 理解自然语言反馈的能力，在 **Prompt 空间**中搜索更优策略。

### 1.3 名字的含义：Genetic-Pareto

- **Genetic（遗传进化）**：通过自然语言反思，不断生成改进后的 Prompt 候选版本
- **Pareto（帕累托）**：不只保留总分最高的 Prompt，而是保留在不同任务实例上具有优势的候选，维持多样性

GEPA 是一个持续进行的 **反思 → 修改 → 评估 → 选择 → 再进化** 的优化过程，而非「反思一次就改写一次」。

![Figure 1: GEPA 与 GRPO 的学习行为对比](mineru-figures/fig_p01_image_7.png)

*Figure 1（第 1 页）：GEPA 与基线方法在 HotpotQA 和 IFBench 上的表现对比，GEPA 用显著更少的 rollout 达到更高的准确率。*

---

## 2. GEPA 的两个核心角色

### 2.1 角色分工

| 角色 | 主要职责 | 是否更新权重 |
|---|---|---|
| **执行模型**（Task LM） | 使用当前 Prompt 执行任务，生成答案和执行轨迹 | 否 |
| **反思模型**（Reflection LM） | 分析执行轨迹、反馈和错误原因，提出改进后的 Prompt | 否 |
| **GEPA 搜索算法** | 选择候选 Prompt、组织评估、维护 Pareto 候选集合 | 不涉及模型权重 |

> [!note] 反思模型 ≠ 传统教师模型
> Reflection LM 和 Task LM **可以是同一个模型，也可以是不同模型**。它更像一个**自动 Prompt 工程师**，而不是知识蒸馏意义上的教师模型。
>
> 与 **SkillRL** 的关键区别：
> - SkillRL：经验被整理为 Skill，并参与学生模型的**训练**与使用
> - GEPA：反思模型直接把经验转化为改进后的 Prompt，执行模型下一轮**直接使用新 Prompt**，无需重新训练

### 2.2 一次完整迭代示例（HotpotQA + Qwen3-8B）

```
初始 Prompt P₀
  "请根据检索结果回答问题"
        ↓
执行模型 Qwen3-8B 运行任务
  → 得到回答、执行轨迹、评估反馈
        ↓
Reflection LM 反思与改写
  → 发现模型没有进行第二跳检索
  → 生成改进后的 Prompt P₁
        ↓
新 Prompt P₁
  "回答前先定位第一个实体，再检索关联实体，最后综合证据"
        ↓
重新评估 + Pareto 选择
  → 若 P₁ 在部分任务上更有优势，则保留并继续进化
```

---

## 3. 形式化系统定义：$\Phi = (M, C, X, Y)$

### 3.1 作者为什么定义这么复杂的系统？

作者希望建立一个**统一的数学框架**，以便公平地描述和比较 GEPA 与 GRPO 等不同优化方法。这个框架能涵盖单 Agent、多 Agent、ReAct、Articulate 等各类基于 LLM 的 AI 系统。

### 3.2 符号体系

| 符号 | 含义 | 说明 |
|---|---|---|
| $\Phi = (M, C, X, Y)$ | 一个 AI 系统 | $M$=模块集合, $C$=控制流, $X$=输入, $Y$=输出 |
| $\Pi_\Phi$ | 所有模块的 **Prompt 集合** | GEPA **唯一优化**的对象 |
| $\Theta_\Phi$ | 所有模块的**模型权重集合** | GEPA 中**保持固定**，但定义中保留以统一框架 |
| $(x, m)$ | 任务实例 | $x$=输入查询, $m$=评估元数据（标准答案等） |
| $\mu$ | 评价函数 | $\mu(y, m)$ 返回标量分数 |
| $B$ | rollout 预算 | 完整系统执行是昂贵的，需在有限预算内优化 |

> [!important] $\Theta_\Phi$ 的意义
> GEPA **不优化** $\Theta_\Phi$，只优化 $\Pi_\Phi$。但作者引入 $\Theta_\Phi$ 是为了统一描述：
> - **GEPA**：固定 $\Theta_\Phi$，优化 $\Pi_\Phi$
> - **GRPO**：固定 $\Pi_\Phi$（或没有），优化 $\Theta_\Phi$
>
> 两者都在最大化 $\mathbb{E}[\mu(\Phi(x), m)]$，只是优化的空间不同。

### 3.3 Figure 2：GEPA 在优化什么？

![Figure 2: 多跳问答第二跳的种子提示与 GEPA 优化提示](mineru-figures/fig_p03_image_1.png)

*Figure 2（第 3 页）：以多跳问答系统的「第二跳查询生成器」为例，展示 seed prompt 与 GEPA 优化后 prompt 的对比。*

以「《哈利·波特与魔法石》的作者出生于哪个城市？」为例：

- **第一跳**：找到作者 → J.K. Rowling
- **第二跳**（GEPA 优化的模块）：找到出生城市 → Yate, England

**Seed Prompt（初始）**：*「给定 question 和 summary_1，生成一个 query。」*

问题：模型可能直接重复原问题，没有利用第一跳已找到的作者信息。

**GEPA 优化后的 Prompt**：详细规定了
- 第一跳已经提供了什么信息
- 第二跳应该寻找哪些**尚未获得**的信息
- 如何根据 `summary_1` 识别相关实体
- 为什么不能重复原问题
- 怎样构造精确的搜索查询

> [!tip] GEPA 学的是策略不是答案
> GEPA 学到的不是 `question_A → query_A`，而是「先识别已知信息 → 找出缺失信息 → 构造针对性查询」这样的**可泛化策略**。

### 3.4 核心研究问题

> How do we extract **maximal learning signal** from every expensive rollout to enable effective adaptation of complex, modular AI systems in **low-data or budget-constrained** settings?

传统方法：$\text{Rollout} \rightarrow \text{Scalar Reward}$

GEPA：$\text{Rollout} \rightarrow \text{Execution Trace + Feedback} \rightarrow \text{Language Reflection} \rightarrow \text{Prompt Evolution}$

---

## 4. GEPA 算法详解（Section 3 + Algorithm 1）

### 4.1 算法总览（Figure 3）

![Figure 3: GEPA 算法总览](mineru-figures/fig_p05_image_1.png)

*Figure 3（第 5 页）：GEPA 在每次迭代中通过两种策略（反思式 Prompt 变异 / 系统感知合并）改进现有候选，先在小批量上评估，若有改进再在更大数据集上评估。*

### 4.2 Algorithm 1：反思式进化主循环

![Algorithm 1 & 2: GEPA 核心算法与 Pareto 选择](paper-analysis-GEPA_2507.19457/images/page_06_full.png)

*Algorithm 1 & 2（第 6 页）：左为 GEPA 反思式提示进化的核心算法，右为 SelectCandidate 子过程。*

**七个阶段拆解：**

| 阶段 | 算法行 | 做什么 |
|---|---|---|
| **1. 初始化** | 1-5 | 将 $D_{train}$ 分为 $D_{feedback}$ 和 $D_{pareto}$；候选池 $P \leftarrow [\Phi]$；在 $D_{pareto}$ 上评估初始系统 |
| **2. 选择候选和模块** | 6-9 | Pareto 选择候选 $\Phi_k$；round-robin 选择要改的模块 $j$ |
| **3. 获取轨迹和反馈** | 10 | 在 $D_{feedback}$ 的 minibatch 上执行，收集 feedback、scores、traces，调用反馈函数 $\mu_f$ |
| **4. Reflection LM 修改 Prompt** | 11-12 | 反思模型看到 (当前 prompt, 轨迹, 分数, 反馈)，提出改进后的 $\pi'_j$ |
| **5. 小样本验证** | 13-14 | 比较新 prompt 在 minibatch 上的分数 $\sigma'$ 是否优于 $\sigma$ |
| **6. 加入候选池并评估** | 15-19 | 若有改进，加入 $P$ 并在完整 $D_{pareto}$ 上评估，记录父子关系 |
| **7. 返回最终候选** | 20-21 | 预算耗尽后，返回在 $D_{pareto}$ 上平均分最高的候选 |

### 4.3 反馈函数 $\mu_f$：两种诊断信号

GEPA 利用两类自然语言信息进行反思：

1. **执行轨迹（Execution Traces）**：LLM 在执行过程中产生的推理、工具调用、中间输出
2. **评估轨迹（Evaluation Traces）**：环境在计算奖励时产生的信息，如编译器错误、失败的评分细则、profiling 结果

$\mu_f$ 将标量奖励 $\mu$ 扩展为返回 `(score, feedback_text)` 的函数，使反思模型能看到「**为什么**得分低」。

> [!example] 评估轨迹的价值
> 代码生成任务中，编译器报错信息（如 "undefined variable"）比单纯的 reward=0 更有诊断价值。GEPA 让反思模型直接看到这些错误信息来改进 Prompt。

### 4.4 Figure 5：Prompt 进化轨迹实例（PUPA 隐私任务）

![Figure 5: GEPA 反思式提示变异的进化轨迹](mineru-figures/fig_p07_image_2.png)

*Figure 5（第 7 页）：GEPA 在 PUPA（隐私保护委托）任务上的优化轨迹，从 candidate 0（基础指令）到 candidate 11（最佳）的逐步改进。*

| 候选 | 阶段名称 | 关键改进 |
|---|---|---|
| **0** | 基础指令 | *「给定私密查询，创建一个隐私保护请求」* |
| **2** | 扩展隐私策略 + 任务理解 | 加入 PII 识别与泛化指导，强调分析查询意图 |
| **4** | 结构化输出 + 领域最佳实践 | 形式化分为 Reasoning 和 Request，禁止姓名/代码，要求隐私理由 |
| **5** | 详细透明的转换理由 | 强制透明隐私推理，处理位置/姓名/虚构角色 |
| **11** | 严格且全面的协议 | 逐步 PII 抽象，禁止部分遮蔽，零泄露容忍 |

> [!tip] 三个最值得记住的认识
> 1. **GEPA 不只是 Prompt 自动改写**——它引入候选池、父子关系、统一评分集合和 Pareto 选择，使反思在持续搜索框架中积累
> 2. **Pareto 的价值是保护搜索多样性**——平均分最高的候选不一定掌握所有最好策略；保留不同任务上的优势候选可跳出局部最优
> 3. **根本思想是提高每次 rollout 的学习价值**——一次执行本就会产生输入、输出、推理、工具结果、错误、评分；标量奖励只概括其中一部分，GEPA 尝试利用全部语言信息

---

## 5. Pareto-based 候选选择（Section 3.1 + Algorithm 2）

### 5.1 要解决的问题

**已经有很多 Prompt 候选了，下一轮究竟应该选哪个继续进化？**

朴素方法：永远选平均分最高的 → **容易陷入局部最优**。一旦找到一种占优策略，就难以超越，预算耗尽也学不到新策略（Figure 6a 展示了这种行为）。

### 5.2 Pareto "照明"策略（Illumination Strategy）

GEPA 的解决方案（Algorithm 2）：

1. **构建实例级 Pareto 集**：对每个训练实例 $i$，找到所有候选中的最高分 $s^*[i]$，记录达到该分的候选集 $P^*[i]$
2. **去除被支配候选**：若某候选在所有实例上都不领先，则被剪枝
3. **按"擅长任务数"加权采样**：$f[\Phi]$ = 该候选在多少个任务上领先；按 $f[\Phi_k]$ 的比例随机采样

> [!important] 为什么叫 "illumination"？
> 这个策略来自 Mouret & Clune (2015) 的 **MAP-Elites** 思想。目标不是找到一个最优解，而是**照亮整个解空间**——让不同任务上的优秀策略都有机会被保留和组合，从而跳出局部最优。

### 5.3 Figure 6：选择策略对比

![Figure 6a: 贪心选择陷入局部最优](mineru-figures/fig_p10_image_4.png)
![Figure 6b: Pareto 选择保持多样性](mineru-figures/fig_p10_image_6.png)

*Figure 6（第 10 页）：对比不同候选选择策略的搜索树。左侧（贪心）陷入局部最优；右侧（Pareto）保持多样性。*

### 5.4 消融结论（Table 3）

Pareto 选择相比贪心选择和随机选择，在多个任务上都有显著优势——它**不保证每一步都找到更好的 Prompt，而是保护搜索多样性**。

---

## 6. 与强化学习的根本区别

### 6.1 Reflection LM 是不是教师模型？

**不是**。传统教师-学生蒸馏中，教师通常更强、负责标注数据或蒸馏知识。GEPA 的 Reflection LM 只做一件事：**看轨迹 → 反思 → 改写 Prompt**，它和执行模型可以是同一个模型。

### 6.2 GEPA 是不是在做强化学习？

**本质上不是传统 RL**，但有相似之处：

| 维度 | GRPO（传统 RL） | GEPA |
|---|---|---|
| 优化空间 | 模型参数 $\Theta_\Phi$ | Prompt $\Pi_\Phi$ |
| 学习信号 | 标量奖励 → 策略梯度 | 自然语言轨迹 → 反思 → Prompt 更新 |
| 是否需要训练 | 需要（LoRA 或全参数） | **不需要** |
| 样本效率 | 需要数千次 rollout | **几次 rollout 即可大幅提升** |
| 经验形式 | 隐式（编码在权重中） | 显式（写在 Prompt 里，可读可迁移） |

> [!quote] 论文的核心实验结论
> 在六项任务中，GEPA 平均比 GRPO **高 6%**，最高达 **20%**，同时使用的 rollout 次数最多减少 **35 倍**。GEPA 还比 MIPROv2 高出 **10% 以上**（如 AIME-2025 上 +12% 准确率）。

**Table 1：Qwen3-8B 上的主 Benchmark 结果**

![Table 1: Qwen3-8B Benchmark 结果](mineru-figures/fig_p08_table_3.png)

**Table 2：GPT-4.1 Mini 上的主 Benchmark 结果**

![Table 2: GPT-4.1 Mini Benchmark 结果](mineru-figures/fig_p08_table_4.png)

### 6.3 关于 LoRA 的脚注说明

> [!note] Footnote 1
> 作者在 GRPO 基线中使用 LoRA（而非全参数微调），原因是低成本且在 GRPO 上有成功先例。同时也在 Figure 11 探索了全参数微调的对比。这属于**实验设置与基线公平性说明**，不是 GEPA 算法本身的机制。

---

## 7. 扩展应用（Section 5）

### 7.1 GEPA 作为推理时搜索（Inference-Time Search）

![Figure 7: NPU Kernel 生成结果](mineru-figures/fig_p13_image_1.png)

*Figure 7（第 13 页）：GEPA + GPT-4o 为 AMD NPU 生成的 kernel，部分达到 70% 向量利用率。*

**核心思路**：把待解决的任务集合（如一组待转换的 PyTorch 模块）直接作为 $D_{train}$ 传给 GEPA，让 $D_{train}$ 和 $D_{pareto}$ 都包含全部任务。这样 GEPA 可以**"过拟合"任务集**，迭代地为每个问题提出更好的解，并把从一个任务 rollout 中提取的经验迁移到其他任务。

**NPU 实验（AMD XDNA2 架构，Sequential10 agent）**：

| 方法 | 平均向量利用率 |
|---|---|
| GPT-4o + Sequential10 | 4.25% |
| + RAG（技术手册检索） | 16.33% |
| + MIPROv2 | 19.03% |
| **+ GEPA（无 RAG）** | **30.52%**（部分 kernel 达 70%） |
| GEPA 单 prompt + Sequential10 | 26.85% |

**CUDA 实验（KernelBench，GPT-4o）**：GEPA 将 close-to-0% 的 pass@1 提升到 **20% 以上**（随搜索预算增加）。

> [!tip] 反馈函数 $\mu_f$ 的扩展用法
> 在这些代码任务中，$\mu_f$ 被用来**动态注入领域知识**：根据 rollout 失败信息（如编译器错误）检索技术手册的相关章节，让反思模型把架构最佳实践整合进 Prompt。这是一种**错误驱动的知识注入**。

### 7.2 GEPA 作为对抗提示搜索（Adversarial Prompt Search）

**反向奖励**：让优化器寻找能**最小化**任务性能的 prompt 编辑，同时要求 prompt 不与任务矛盾、仍包含解题所需信息。

**AIME-2025 实验（GPT-5 Mini）**：

- Clean prompt 的 pass@1：**76%**
- GEPA 对抗 prompt 的 pass@1：**10%**

**对抗 prompt 示例（节选）**：

> You are a helpful assistant... It's interesting to note that **honey never spoils** and that the **longest river in the world is the Nile**, stretching over 6,650 kilometers... remember that **many mammals, including dolphins, sleep with one eye open**. Proceed to answer the given question accordingly.

**失败机制分析**：对抗 prompt 让 GPT-5 Mini 在大多数回答末尾输出字面占位符 `### <final answer>`——这是**无关细节与严格格式约束的交互**导致的系统性误解，而非格式要求本身的问题。

> [!important] 科研价值
> 对抗 prompt 搜索系统地发现**指令级扰动**，能急剧降低模型性能。它提供了一种**原则性、自动化的方法**来探测最坏情况鲁棒性，可生成可复用的压力测试和回归测试套件，用于红队、安全训练和鲁棒性漂移追踪。

### 7.3 Figure 8：CUDA 代码优化

![Figure 8: CUDA Kernel 优化结果](mineru-figures/fig_p13_image_2.png)

*Figure 8（第 13 页）：GEPA 随搜索预算增加逐步提升 CUDA kernel 的 pass@1。*

---

## 8. 三个值得深入思考的研究方向

### 8.1 从 Prompt Learning 转向 Test-Time Adaptation

传统 Prompt 优化强调找到一个能泛化的最佳 Prompt。Section 5.1 展示了另一种范式：**允许系统在解决当前任务的过程中继续优化自己的行为策略**。

这与 Test-Time Compute、Agent Self-Improvement 有明显关联。但需区分：GEPA 优化的是 **Prompt**，不是测试时更新模型参数。

### 8.2 把环境反馈变成可迁移经验

> 根据编译器/评估器返回的错误信息，选择性检索专业知识，让 LLM 把知识转化为后续可用的 Prompt 策略。

例如代码生成 Agent 在任务 A 中发现某种硬件内存布局不合理，可形成更普遍的指令：*「遇到该架构的相关计算模式时，优先检查指定的内存布局限制。」*

**开放问题**：能否把 GEPA 生成的 Prompt 经验，进一步抽象为结构化、可检索、可组合的 **Skill**，而不是持续增加 Prompt 长度？

### 8.3 搜索算法可同时用于能力提升和能力诊断

Section 5.2 展示了一种科研范式：不直接提出新的训练算法，而是设计自动化方法**系统发现已有模型无法处理好的任务或指令组合**。可用于：
- 模型鲁棒性评估
- Agent 可靠性测试
- 自动生成困难样本
- 评估基准构建
- 后续训练数据生成

---

## 9. 整篇论文的终极公式

$$
\boxed{
\text{环境反馈}
\rightarrow
\text{自然语言反思}
\rightarrow
\text{策略进化}
\rightarrow
\text{再次执行}
}
$$

这个循环**既可以用于提高任务表现（5.1），也可以用于搜索失败模式（5.2）**。

> [!summary] 阅读建议
> - **理解算法** → 重点读 Section 3 及 Pareto Sampling（主体）
> - **寻找新方向** → 重点读 Section 5.1 推理时搜索与反馈驱动知识注入
> - **理解形式化** → 重点读 Section 2 的 $\Phi$ 定义与公式 (1)(2)
>
> 从证据强度说，Section 5 的应用属于**扩展与初步探索**，不能与主 Benchmark 上的系统比较等量齐观。

---

## 10. 与 SkillRL 的对比

| 维度 | SkillRL | GEPA |
|---|---|---|
| 经验组织形式 | 结构化 Skill，可检索可组合 | 写入 Prompt，随候选进化 |
| 经验利用方式 | 通过 SFT 等训练让模型学会使用 Skill | 执行模型下一轮直接使用新 Prompt |
| 是否更新权重 | 是 | **否** |
| 经验可迁移性 | Skill 可跨任务组合 | Prompt 经验需进一步抽象才能迁移 |
| 共同点 | 都关注**从轨迹中提炼可复用经验** | 同 |

> [!question] 开放问题
> GEPA 生成的 Prompt 经验能否抽象为结构化 Skill？这是从论文机制出发的自然研究延伸——把「持续增加 Prompt 长度」升级为「可检索、可组合的经验库」。

---

## 附：关键图索引

| 图表 | 页码 | 内容 | MinerU 图块 |
|---|---|---|---|
| Figure 1 | p1 | GEPA vs GRPO 学习行为对比 | `fig_p01_image_7.png` |
| Figure 2 | p3 | 多跳问答第二跳的 seed vs GEPA prompt | `fig_p03_image_1.png` |
| Figure 3 | p5 | GEPA 算法总览 | `fig_p05_image_1.png` |
| Figure 4 / Algorithm 1-2 | p6 | 核心算法 + Pareto 选择伪代码 | PyMuPDF 整页 `page_06_full.png`（flash 档位未识别图块） |
| Figure 5 | p7 | PUPA 任务的 Prompt 进化轨迹 | `fig_p07_image_2.png` |
| Figure 6 | p10 | 候选选择策略对比搜索树 | `fig_p10_image_4.png` + `fig_p10_image_6.png` |
| Figure 7 | p13 | NPU Kernel 生成结果 | `fig_p13_image_1.png` |
| Figure 8 | p13 | CUDA Kernel 优化结果 | `fig_p13_image_2.png` |
| Table 1 | p8 | 主 Benchmark 结果（Qwen3-8B） | `fig_p08_table_3.png` |
| Table 2 | p8 | 主 Benchmark 结果（GPT-4.1 Mini） | `fig_p08_table_4.png` |
| Table 3 | p10 | 候选选择策略消融 | `fig_p10_table_3.png` |

## 附：图片资源

MinerU v4 flash 版面解析提取的精确图块位于 `mineru-figures/`（11 个文件，216 DPI）：
- 8 个 image 块 + 3 个 table 块
- 元数据：`mineru-figures/figures_meta.json`（含页码、类型、bbox、像素尺寸）
- 版面分析 JSON：`~/.mineru/doclib/parsed/ab/ab3a513.../flash/1-14_*.json`

PyMuPDF 整页渲染（备用，含矢量图全页）位于 `paper-analysis-GEPA_2507.19457/images/`：
- `page_01_full.png` ~ `page_14_full.png`（15 页整页渲染，180 DPI）
- `p05_img1.png`、`p05_img2.png`（嵌入式光栅图）

## 附：相关文件

- 原文 PDF：`GEPA_2507.19457.pdf`
- 中文翻译（双语对照）：`zh-translation/GEPA_2507.19457.zh-CN.dual.pdf`
- 中文翻译（纯中文）：`zh-translation/GEPA_2507.19457.zh-CN.mono.pdf`
- 精读对话原文：`chatgpt-archive/论文精读方向__6ad03b58.md`
- MinerU 解析 Markdown：`mineru-parse-GEPA.md`（594 行，14 页结构化文本）

---

> [!quote] GEPA 最核心的一句话
> **当每一次完整 Agent 执行都很昂贵时，我们如何尽可能充分地利用每次执行产生的信息，让复杂的模块化 AI 系统在少量数据或有限预算下仍然能够有效优化？**
>
> GEPA 的回答：用 LLM 对执行轨迹进行自然语言反思，通过遗传式改写和 Pareto 选择来优化 Prompt。
