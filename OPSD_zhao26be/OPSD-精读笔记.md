---
title: OPSD — 同策略自蒸馏让单个 LLM 用标准答案教会自己推理
authors: ["Siyan Zhao", "Zhihui Xie", "Mengchen Liu", "Jing Huang", "Guan Pang", "Feiyu Chen", "Aditya Grover"]
venue: ICML 2026 (PMLR 306)
arxiv: 未公开/待确认（论文文件名 zhao26be）
code: https://github.com/siyan-zhao/OPSD
tags:
  - on-policy-distillation
  - self-distillation
  - RLVR
  - knowledge-distillation
  - LLM
  - reasoning
  - 论文精读
created: 2026-10-25
updated: 2026-10-25
source: ChatGPT 精读对话 (gpt-6-thinking, 72 条消息) + 论文原文（BabelDOC 双语版）
status: complete
---

# OPSD — 同策略自蒸馏让单个 LLM 用标准答案教会自己推理

> [!abstract] 一句话概括
> OPSD 让**同一个 LLM** 同时扮演学生与教师：学生只看题目生成自己的轨迹，教师额外看到标准答案并在学生轨迹的每个位置提供逐 token 概率分布，训练最小化两者之间的散度，从而以更少的采样 token 实现与 GRPO 相当或更好的推理表现，并明显优于 SFT。

> [!info] 论文信息
> - **标题**：Self-Distilled Reasoner: On-Policy Self-Distillation for Large Language Models
> - **作者机构**：UCLA、HKU、Meta Superintelligence Labs（工作完成于 UCLA 与 Siyan 在 Meta 实习期间）
> - **收录**：ICML 2026，Seoul，PMLR 306
> - **代码**：https://github.com/siyan-zhao/OPSD
> - **精读来源**：基于 ChatGPT (gpt-6-thinking) 72 条消息初学者向精读对话整理，覆盖引言、背景、方法、Algorithm 1、公式 (6)–(9)、KL 裁剪、消融实验、Related Work 全部内容

---

## 1. 核心动机：现有后训练方法各自卡在哪里？

OPSD 的引言不是在发明新优化器，而是在指出三类主流后训练方法各自的"信号缺陷"，然后提出一种把它们优点拼起来的训练范式。

### 1.1 三类方法的局限

| 方法 | 学习信号 | 主要局限 |
|---|---|---|
| **SFT** | 标准解答的硬 Token 标签 | 训练时跟随固定参考轨迹，推理时却要基于自己生成的前缀续写，存在 **exposure bias（暴露偏差）**；论文实验中 SFT 反而让基础模型退化 |
| **RLVR / GRPO** | 最终结果的二元奖励构造的组相对优势 | (1) **采样昂贵**：每题需采样一组（论文用 8 条、最长 16k token）回答；(2) **奖励稀疏**：奖励只给整条序列，不告诉模型错在哪一步；(3) **梯度消失**：当一组回答全对或全错时，组内奖励标准差为 0，优势为 0，无梯度信号 |
| **传统 / off-policy 蒸馏** | 教师在固定数据上的软概率分布 | 训练分布（教师生成的轨迹）与推理分布（学生自己的轨迹）不匹配；通常需要一个**独立的、往往更大的**教师模型 |

> [!important] RLVR 的"零奖励标准差"问题
> Figure 3 最右侧子图直接刻画了 GRPO 训练中"组内奖励标准差为 0 的 batch 比例"。在 100 步内这一比例经常超过 50%，部分点接近 90%。这意味着 GRPO 花了大量算力采样，却拿不到任何策略更新信号。OPSD 的核心动机之一就是绕开这个"奖励多样性坍缩"。

### 1.2 关键洞察：评估比生成容易

> We hypothesize that rationalization—explaining a given correct answer—is similarly easier than generation.

翻译：**合理化（在已知正确答案的前提下解释它）比从零生成正确答案要容易**。

这是 OPSD 的核心研究假设：一个 LLM 即使不能独立解出某道题，给它看了标准答案后，它仍可能理解解法并据此对自己生成的轨迹给出有指导意义的概率分布。这条假设借用了人类学习的类比——做错题后看答案、回头理解自己哪一步错了。它是否成立，最终由实验验证。

### 1.3 把标准答案当作"特权信息"

OPSD 不把 $y^\star$ 当作学生要模仿的硬标签，而是当作**只有训练期教师能看到的特权上下文（privileged information）**。这样，传统蒸馏里"需要更大教师"的前提被替换成"需要同一个模型 + 一份参考答案"。

---

## 2. 核心思想：单模型双角色 + 逐 token 散度

### 2.1 两个策略来自同一个模型

$$
p_S(\cdot \mid x) \triangleq p_\theta(\cdot \mid x), \qquad
p_T(\cdot \mid x, y^\star) \triangleq p_\theta(\cdot \mid x, y^\star)
$$

学生只条件于题目 $x$；教师额外条件于标准答案 $y^\star$。两者**共享同一套参数 $\theta$**，区别只在条件上下文。

> [!note] 实验中的"冻结初始教师"
> 方法定义里教师与学生共享 $\theta$；但论文 §4.1 的实验明确写道 "We fix the teacher policy to be the initial policy"，即**整个训练期间教师固定在初始参数 $\theta_0$，学生持续更新**。所以实验里更准确的形式是 $p_T = p_{\theta_0}(\cdot \mid x, y^\star)$、$p_S = p_{\theta_t}(\cdot \mid x)$。作者称仍叫"自蒸馏"是因为教师来自学生的初始检查点，而非外部更大的模型。

### 2.2 总体损失

$$
\boxed{\;\mathcal{L}_{\text{OPSD}}(\theta) = \mathbb{E}_{(x,y^\star)\sim S}\;\mathbb{E}_{\hat y \sim p_S(\cdot\mid x)}\left[\frac{1}{|\hat y|}\sum_{n=1}^{|\hat y|} D\!\left(p_T(\cdot\mid x,y^\star,\hat y_{<n})\;\Big\|\;p_S(\cdot\mid x,\hat y_{<n})\right)\right]\;}
$$

逐项拆解：

- $\mathbb{E}_{(x,y^\star)\sim S}$：在带参考答案的推理数据集上取期望。
- $\mathbb{E}_{\hat y \sim p_S(\cdot\mid x)}$：学生**用自己的当前策略**采样一条轨迹（on-policy）。
- $\hat y_{<n}$：学生已经生成的前 $n-1$ 个 token，是教师与学生**共同的前缀**。
- $p_T^{(n)}$ vs $p_S^{(n)}$：在同一学生前缀、同一词表 $\mathcal{V}$ 上的两个下一 token 分布；维度相同，可直接算散度。
- $\frac{1}{|\hat y|}\sum_n$：沿学生轨迹长度归一化，避免长答案天然积累更大损失。
- $D$：可以是前向 KL、反向 KL 或 JSD；论文实验最终选 **Forward KL**。

> [!tip] 这条公式最关键的三个事实
> 1. **求和长度由学生轨迹长度决定**，与标准答案长度无关——标准答案只是教师的额外上下文。
> 2. **比较的是整个词表上的概率分布**，不是两条答案逐 token 对齐，也不是只看最终答案对错。
> 3. **梯度只回传到学生分支 logits**，教师分支作为固定监督目标。

![Figure 1: OPSD 总览](mineru-figures/fig_p02_image_1.png)

*Figure 1（第 2 页）：OPSD 总览。同一个 LLM 在学生策略（只看问题）和教师策略（额外看到标准答案）两种条件下前向，逐 token 计算散度，梯度只通过学生分支的 logits 反向传播。*

---

## 3. 训练流程详解（重点）

初学者最容易在"教师什么时候介入""散度算几次""是不是要跑两遍前向"上犯糊涂。这一节把对话里反复澄清的细节讲清楚。

### 3.1 一轮训练的五个阶段

![Figure 2: 学生与教师提示词对比](mineru-figures/fig_p04_image_1.png)

*Figure 2（第 4 页）：学生提示词与教师提示词的对比。两者共享同一套参数 θ，唯一区别是教师提示词中额外拼入了标准答案作为特权上下文。*

**阶段 1 · 学生采样（Rollout）**
学生提示词 $P_S$ 只有题目，模型自回归 decode 出一条完整轨迹 $\hat y = (\hat y_1, \dots, \hat y_{|\hat y|})$。这条轨迹可以包含错误，OPSD **不会因为答错就丢弃它**（与 STaR 只保留正确轨迹不同）。

**阶段 2 · 构造两种条件上下文**
对学生轨迹的每个预测位置 $n$：

| 分支 | 输入序列 | 模型参数 |
|---|---|---|
| 学生 | $P_S + \hat y_{<n}$ | $\theta_t$（当前） |
| 教师 | $P_T + \hat y_{<n}$，其中 $P_T$ 包含参考答案 $y^\star$ | $\theta_0$（冻结） |

> [!warning] 教师不生成自己的轨迹
> 教师提示词里虽然写着"理解参考解后请用自己的方法解题"，但论文 Figure 2 caption 明确："the teacher won't be generating tokens—rationalization is done implicitly through one forward pass." 教师只在已经包含参考答案的上下文中对学生前缀做**一次前向计算**，给出下一 token 分布，不会真的逐 token 生成一条新答案。

**阶段 3 · 计算两组 logits**
对 Causal Transformer，把完整学生轨迹塞进输入、用因果注意力掩码，**一次前向就能并行拿到所有生成位置的 logits**，不需要像生成时那样逐 token decode。学生分支和教师分支各跑一次前向。

**阶段 4 · 逐位置计算散度**
对每个位置 $n$，比较两个分布在词表 $\mathcal{V}$ 上的差异 $D_n = D(p_T^{(n)} \| p_S^{(n)})$，再沿轨迹平均：

$$
\ell(x, y^\star) = \frac{1}{|\hat y|}\sum_{n=1}^{|\hat y|} D_n
$$

**阶段 5 · 汇总 Batch 损失并更新学生**
对一个 mini-batch $B$（论文有效 batch size = 32）：

$$
\mathcal{L}_{\text{batch}} = \frac{1}{|B|}\sum_{(x,y^\star)\in B} \ell(x, y^\star), \qquad
\theta_{t+1} = \theta_t - \eta \nabla_\theta \mathcal{L}_{\text{batch}}
$$

> [!important] 两个数量要分开
> - **KL 计算的数量**：一条 100 token 的轨迹 → 100 个散度值。
> - **参数更新的数量**：整个 batch 汇总一次损失 → 一次优化器步。
>
> "每个 token 计算 KL" ≠ "每个 token 更新一次参数"。

### 3.2 一个具体数值例子

题目 $x$：求 $3+4$。标准答案 $y^\star=7$。学生生成 $\hat y = (3,+,4,=,8)$（答错）。

计算第 5 个位置（前缀 `3+4=`）的 Forward KL，假设模型给出：

| Token | $p_T$ | $p_S$ |
|---|---:|---:|
| `7` | 0.8 | 0.2 |
| `8` | 0.1 | 0.7 |
| `9` | 0.1 | 0.1 |

$$
D_5 = \sum_v p_T(v)\ln\frac{p_T(v)}{p_S(v)} = 0.8\ln\frac{0.8}{0.2} + 0.1\ln\frac{0.1}{0.7} + 0.1\ln\frac{0.1}{0.1} \approx 0.9144
$$

若五个位置的散度依次为 $[0.1, 0.2, 0.3, 0.4, 0.9144]$，则 $\ell = (0.1+0.2+0.3+0.4+0.9144)/5 \approx 0.3829$。

注意：**学生最后答错这个事实并不直接进入公式 (6)**。正确答案只是作为教师上下文帮助教师形成更合理的分布。即使答错，只要 $p_T \ne p_S$，就仍然有非零的蒸馏损失。

### 3.3 不需要对齐两条答案

初学者常担心"标准答案只有 1 个 token，学生答案是 5 个 token，怎么对齐？"答案是：**根本不对齐答案**。

OPSD 始终沿着**学生轨迹的生成位置**计算散度。每个位置上，教师和学生都输出一个定义在**同一个词表 $\mathcal{V}$** 上的 $|\mathcal{V}|$ 维概率向量，维度天然相同。标准答案的长度只影响**教师输入上下文的长度**，不影响输出分布的维度。

### 3.4 "跑两遍前向"的代价

| 计算 | 做什么 | 是否要生成新 token |
|---|---|---|
| 学生 Rollout | 自回归采样得到 $\hat y$ | 是 |
| 教师 Forward | 在 $P_T + \hat y$ 上计算目标 logits | 否 |
| 学生训练 Forward/Backward | 在 $P_S + \hat y$ 上重新前向（建计算图）+ 反向 | 否 |

> [!note] 为什么学生分支还要再前向一次？
> 生成阶段虽然算过 logits，但通常不保留反向传播需要的计算图。训练时需要重新对固定学生轨迹做一次前向，建立梯度所需的计算图。这也是 OPSD 比普通 SFT 多一块计算开销的原因。

作者强调的是**生成 token 的效率**——OPSD 每题只采 1 条、最长 1024 token，GRPO 每题采 8 条、最长 16k token，理论生成预算差 125 倍。但 OPSD 多了教师前向和全词表 logits 的显存开销，所以**端到端 GPU 时间优势没那么大**，论文卖的是"学生采样 token 的学习效率"。

---

## 4. 与 SFT / GRPO / 传统蒸馏的对比

| 维度 | SFT / Off-policy 蒸馏 | GRPO | On-Policy 蒸馏 | **OPSD（本文）** |
|---|:---:|:---:|:---:|:---:|
| On-Policy 数据 | ✗ | ✓ | ✓ | ✓ |
| 稠密学习信号 | ✓ | ✗ | ✓ | ✓ |
| 低采样成本 | ✓ | ✗ | ✓ | ✓ |
| 无外部教师 | ✓ | ✓ | ✗ | ✓ |
| 训练轨迹来源 | 参考答案 | 学生采样 | 学生采样 | 学生采样 |
| 监督目标 | 硬 Token 标签 | 序列级组相对优势 | 教师软分布 | 同源教师软分布 |
| 是否需要参考答案 | 是 | 否（需可验证奖励） | 否（需教师模型） | 是（作为教师特权上下文） |

> [!tip] SFT vs OPSD 的本质差别
> - **SFT**：标准答案告诉你**应该生成什么**（硬标签）。
> - **OPSD**：你先生成，教师结合标准答案告诉你**在你走过的每个位置应该怎样调整预测概率**（软分布）。
>
> 两者最终都是算损失、反向传播、更新参数，区别在**训练数据从哪来、监督信号怎么构造**。

> [!tip] GRPO vs OPSD 的本质差别
> GRPO 必须等整条答案生成完，靠"对/错"二元结果构造优势；OPSD 不依赖最终答案是否正确，只要 $p_T \ne p_S$ 就能产生逐 token 信号。即使一组学生回答全错，OPSD 仍能学习；GRPO 此时优势为 0、无梯度。

---

## 5. Algorithm 1 逐步讲解

```
Require: 推理数据集 S = {(x_i, y_i^⋆)}; 语言模型 p_θ; 散度 D（如 JSD_β）
1: 令 p_S(·|x) 和 p_T(·|x, y^⋆) 为同一模型 p_θ 在不同条件下
2: while not converged do
3:   采样一个 mini-batch B ⊂ S
4:   for all (x, y^⋆) ∈ B do
5:     采样 on-policy 响应 ŷ ∼ p_S(·|x)
6:     计算沿学生轨迹的逐 token 散度：
         ℓ(x, y^⋆) ← D(p_T ∥ p_S)(ŷ | x) = (1/|ŷ|) Σ_n D(p_T(·|ŷ_<n, x, y^⋆) ∥ p_S(·|ŷ_<n, x))
7:   计算损失 L_OPSD(θ) ← (1/|B|) Σ_{(x,y^⋆)∈B} ℓ(x, y^⋆) 并更新 θ
```

| 行 | 做什么 | 注意点 |
|---|---|---|
| 1 | 用同一模型实例化两个策略 | 实验中教师固定为 $\theta_0$ |
| 3 | 取 32 道题 | 论文有效 batch size = 32 |
| 5 | 学生自回归生成一条轨迹 | 每题只采 1 条，最长 1024 token |
| 6 | 逐位置算散度再沿轨迹平均 | 一次前向并行计算所有位置 |
| 7 | batch 损失平均 → 反向传播 → 更新学生 | 一次优化器步，不是每 token 更新 |

---

## 6. 损失函数、f-divergence 与逐点裁剪

### 6.1 公式 (6)：逐 token 散度

$$
D(p_T \| p_S)(\hat y \mid x) \triangleq \frac{1}{|\hat y|}\sum_{n=1}^{|\hat y|} D\!\left(p_T(\cdot\mid x,y^\star,\hat y_{<n}),\; p_S(\cdot\mid x,\hat y_{<n})\right) \tag{6}
$$

三个部分：$|\hat y|$ 是学生轨迹长度；$\hat y_{<n}$ 是共同的学生前缀；$D$ 是任意分布散度。

### 6.2 公式 (7)：广义 JSD

$$
\mathrm{JSD}_\beta(p_T \| p_S) = \beta D_{\mathrm{KL}}(p_T \| m) + (1-\beta) D_{\mathrm{KL}}(p_S \| m), \quad m = \beta p_T + (1-\beta) p_S \tag{7}
$$

JSD 通过混合分布 $m$ 比较，$\beta=0.5$ 时对称。但论文消融发现 **Forward KL 效果最好**，JSD 并没有因形式更对称就更优。

### 6.3 为什么引入 f-divergence？

f-divergence 不是新算法，而是一个**统一的数学框架**，让裁剪公式能套用到任意散度：

$$
D_f(P \| Q) = \sum_{v\in V} P(v)\, f\!\left(\frac{Q(v)}{P(v)}\right)
$$

- 取 $f(t) = -\ln t$ → Forward KL
- 取 $f(t) = t\ln t$ → Reverse KL

这样作者只需把裁剪作用到单项贡献 $\ell_{n,v}^{(f)} = p_T(v)\, f(p_S(v)/p_T(v))$ 上，就能覆盖所有候选散度。

### 6.4 逐点 KL 裁剪（Pointwise Clipping）

**动机**：作者观察到某些**风格 token**（`however`、`therefore`、`perhaps`、`wait` 等推理连接词）的 KL 贡献远大于数学相关 token，可能让训练被"学习写作风格"主导，而不是学数学推理。

**机制**：在每个生成位置 $n$、每个词表条目 $v$ 上裁剪：

$$
\ell_{n,v}^{(f)} = p_T(v\mid\cdot)\, f\!\left(\frac{p_S(v\mid\cdot)}{p_T(v\mid\cdot)}\right), \qquad
D_{\mathrm{clip}}^{(f)} = \frac{1}{|\hat y|}\sum_{n=1}^{|\hat y|}\sum_{v\in V} \min\!\left(\ell_{n,v}^{(f)},\, \tau\right)
$$

裁剪发生在**"某个生成位置 × 某个词表条目"**的粒度上，不是把整条轨迹的 KL 简单截断。

> [!example] 裁剪数值示例（假设 $\tau = 0.5$）
> | Token | 原始贡献 | 裁剪后 |
> |---|---:|---:|
> | `therefore` | 1.8 | 0.5 |
> | `maybe` | 0.9 | 0.5 |
> | `7` | 0.3 | 0.3 |
> | `8` | −0.2 | −0.2 |
>
> 最大的正贡献被压到 0.5，负贡献不变。

### 6.5 为什么完整 KL 非负，但裁剪后可能为负？

**完整 Forward KL 的非负性证明**（Gibbs 不等式）：

由 $\ln u \le u - 1$，令 $u = Q(v)/P(v)$，得 $P(v)\ln\frac{P(v)}{Q(v)} \ge P(v) - Q(v)$。对词表求和：

$$
D_{\mathrm{KL}}(P \| Q) \ge \sum_v [P(v) - Q(v)] = 1 - 1 = 0
$$

**单项贡献可以为负**：当 $P(v) < Q(v)$ 时 $\ln(P(v)/Q(v)) < 0$。但负贡献会被其他 token 的正贡献抵消，总和仍非负。

**裁剪后非负性被破坏**：裁剪只压低正贡献、不动负贡献，原本保证总和 $\ge 0$ 的数学结构被打乱。所以论文 §4.3.3 明确提到 "the training loss can be negative due to pointwise clipping before aggregating"。这并不等于普通 KL 变负，而是**裁剪后的训练目标不再是未经修改的 KL**。

> [!warning] 裁剪不区分"风格 token"和"数学 token"
> 裁剪只看数值大小，不判断 token 类别。如果某个数学 token 的贡献过大，也会被同样裁剪。论文附录 A 也承认没有系统调优阈值 $\tau$。

---

## 7. 两种方法变体：Method A vs Method B

OPSD 的逐 token 散度目标可以有两种实现：

### 7.1 Method A：Full-Vocabulary Logit Distillation

对每个位置比较教师和学生在**整个词表**上的概率分布，直接最小化 Forward KL（或 JSD）。这是论文主实验采用的方法。

### 7.2 Method B：Sampled-Token Distillation

只利用学生**实际采样到**的 token $\hat y_n$，构造类似策略梯度的损失：

$$
A_n(x, \hat y) = \log p_T(\hat y_n \mid x, y^\star, \hat y_{<n}) - \log p_S(\hat y_n \mid x, \hat y_{<n}) \tag{优势项}
$$

$$
\mathcal{L}(\theta) = -\mathbb{E}\left[\frac{1}{|\hat y|}\sum_{n=1}^{|\hat y|} A_n \log p_S(\hat y_n \mid x, \hat y_{<n})\right] \tag{9}
$$

$A_n$ 被视为常数，不通过它反向传播，梯度形如 $A_n \nabla_\theta \log p_S(\hat y_n)$，与策略梯度形式一致。

**数值示例**：学生采样到错误的 `8`，$p_T(8)=0.1, p_S(8)=0.7$：

$$
A_n = \log 0.1 - \log 0.7 \approx -1.946
$$

负优势 → 抑制学生以后选 `8`。若学生采样到 `7`：$A_n = \log 0.8 - \log 0.2 \approx +1.386$，正优势 → 鼓励。

> [!note] 这里的 Advantage ≠ GRPO 的 Advantage
> GRPO 的优势来自整条轨迹的最终奖励与组内平均奖励的差异；OPSD 的 $A_n$ 来自教师与学生对**同一个 token**的对数概率差。两者都叫 advantage 但语义完全不同。

### 7.3 两者对比与最终选择

| 维度 | Full-Vocabulary（A） | Sampled-Token（B） |
|---|---|---|
| 监督范围 | 整个词表 | 实际采样的 token |
| 训练方式 | 分布散度匹配 | 策略梯度式更新 |
| 计算特点 | 需处理完整词表 logits，显存高 | 不显式算全词表散度 |
| 与 RL 关系 | 直接知识蒸馏 | 更接近带逐 token 奖励的 RL |
| 理论联系 | — | $\mathbb{E}_{\hat y_n \sim p_S}[A_n] = -D_{\mathrm{KL}}(p_S \| p_T)$ |

**论文 Table 4 消融（Qwen3-4B, 2048 token, pass@8）**：

| 方法 | AIME25 | HMMT25 |
|---|---:|---:|
| **Full-vocabulary** | **84.1** | **60.0** |
| Sampled-token | 82.1 | 57.3 |

**最终选择**：Full-vocabulary，代价是峰值显存更高（每个位置都要存词表大小的 logits）。

### 7.4 冻结初始教师的含义

| 训练时刻 | 教师参数 | 学生参数 |
|---|---|---|
| 初始化 | $\theta_0$ | $\theta_0$ |
| 第 1 次更新后 | $\theta_0$ | $\theta_1$ |
| 第 100 次更新后 | $\theta_0$ | $\theta_{100}$ |

整个训练期间教师固定在初始参数。这样教师提供相对稳定的监督目标，避免"教师跟着学生一起漂移"导致目标不稳定。它仍叫自蒸馏是因为教师来自学生的初始检查点，而非外部更大的模型。

---

## 8. 实验（第 4 章）

### 8.1 实验设置

| 类别 | 设置 |
|---|---|
| 基础模型 | Qwen3-1.7B / 4B / 8B（Instruct） |
| 训练数据 | OpenThoughts 的数学推理子集，最多约 30,000 个问题-解答对 |
| 评估基准 | AIME 2024、AIME 2025、HMMT 2025（均为竞赛级数学） |
| 评估指标 | 主表用 **Avg@12**（每题采样 12 次取平均准确率）；Table 4 消融用 **pass@8**（注意不可直接比大小） |
| 评估参数 | Temperature 1.0, Top-p 0.95, Max New Tokens 38,912, Thinking Mode 开启 |
| 硬件 | 8× A100 或 H100，LoRA rank 64/alpha 128，AdamW + BF16 + Flash Attention 2 |

**SFT / GRPO / OPSD 训练超参对比**（附录 Table 8–10）：

| 参数 | SFT | GRPO | OPSD |
|---|---:|---:|---:|
| 学习率 | 5e-6 | 5e-6 | 5e-6 |
| 有效 batch size | 32 | 32 | 32 |
| 最大生成长度 | 16,000 | 16,000 | 1,024 |
| 每题采样轨迹数 | — | 8 | 1 |
| 采样温度 | — | 1.2 | 1.1 |
| 训练步数 | 100 | 500 | 100 |
| KL 惩罚系数 | — | 0 | — |

### 8.2 主结果：Table 2

Avg@12 准确率（%）：

| 模型 | 方法 | AIME24 | AIME25 | HMMT25 | 平均 |
|---|---|---:|---:|---:|---:|
| 1.7B | Base | 51.5 | 36.7 | 23.1 | 37.1 |
| | SFT | 48.4 | 36.3 | 22.7 | 35.8 |
| | GRPO | 51.1 | 38.3 | 23.7 | 37.7 |
| | **OPSD** | **57.2** | **43.9** | **29.2** | **43.4** |
| 4B | Base | 74.9 | 66.4 | 42.2 | 61.2 |
| | SFT | 70.2 | 62.3 | 43.4 | 58.6 |
| | GRPO | 75.6 | 68.1 | 44.4 | 62.7 |
| | **OPSD** | **76.4** | **68.3** | **46.1** | **63.6** |
| 8B | Base | 75.8 | 65.6 | 43.9 | 61.8 |
| | SFT | 72.3 | 64.2 | 42.9 | 59.8 |
| | GRPO | 76.4 | 68.9 | **46.7** | 64.0 |
| | **OPSD** | **77.8** | **70.8** | 45.8 | **64.8** |

![Table 2: 三个 Qwen3 规模上的性能对比](mineru-figures/fig_p07_table_1.png)

*Table 2（第 7 页）：在数学推理基准上 SFT / GRPO / OPSD 的 Avg@12 准确率对比。OPSD 在所有规模上一致优于 SFT，并在每种设置下匹配或超过 GRPO。*

**三个结论**：

1. **OPSD 对小模型尤其有效**：1.7B 上 OPSD 相对 GRPO 提升 5.7 个百分点；8B 上仅提升 0.8 个百分点，且 HMMT25 上 GRPO（46.7）反而高于 OPSD（45.8）。
2. **SFT 在这份设置下让模型退化**：作者解释 OpenThoughts 参考推理较简洁，SFT 后模型推理长度缩短、影响数学表现。更严谨的说法是"在数据集和训练配置上，直接模仿参考轨迹不如 OPSD"，并非证明所有 SFT 都会退化。
3. **OPSD 报告的是前 100 步每 20 步评估的最佳 checkpoint**，GRPO 报告 500 步内峰值。两者计算预算并不相同，Table 2 支持"作者配置下 OPSD 更好"，不能直接证明"同等 GPU 时间下 OPSD 必然更好"。

### 8.3 Figure 3：Token 效率

![Figure 3: OPSD 与 GRPO 的 token 效率](mineru-figures/fig_p06_full_Figure3.png)

*Figure 3（第 6 页）：OPSD 与 GRPO 在 Qwen3-1.7B 上的 token 效率对比。横轴为训练步数 / 总生成 token 数，纵轴为 Avg@12 准确率；并标注 GRPO 出现零奖励标准差（无学习信号）的比例。*

Figure 3 包含五张子图：

- **前 3 张**（AIME24 / AIME25 / HMMT25，横轴 = 训练步数）：OPSD 在前 100 步内提升明显快于 GRPO；AIME25 上 OPSD 第 50 步达 43.9%，第 100 步回落到 41.1%——后期不稳定。
- **第 4 张**（横轴 = 累计生成 token 数，单位百万）：OPSD 的性能提升发生在累计生成 token 很少的位置；GRPO 消耗更多 token 却没拿到同等提升。这是论文针对 GRPO 最有说服力的证据之一——**生成 token 效率**。
- **第 5 张**（GRPO 零奖励标准差比例）：GRPO 训练中该比例常超 50%，部分点接近 90%。当组内奖励全 0 或全 1 时标准差为 0，无策略更新信号。

> [!important] Figure 3 证明的是"生成 token 效率"，不是完整训练 FLOPs、峰值显存或 GPU 小时数的严格优势。

### 8.4 §4.3.1 Table 3：散度目标消融

Qwen3-1.7B, AIME25, Avg@12（%）：

| 散度 | Base | Step 50 | Step 100 |
|---|---:|---:|---:|
| **Forward KL** | 36.7 | **43.9** | **41.1** |
| Reverse KL | 36.7 | 37.5 | 35.0 |
| JSD (β=0.5) | 36.7 | 36.9 | 39.0 |

**结论**：Forward KL 明显最好。直观理解——Forward KL $D_{\mathrm{KL}}(p_T \| p_S)$ 重视教师有概率但学生没覆盖的 token，倾向 mode-covering；Reverse KL 倾向 mode-collapsing 到学生高概率区。对数学推理，作者希望学生学习教师给出的完整候选分布。**最终选择 Forward KL**。

### 8.5 §4.3.2 Table 7：生成风格与师生模式

Qwen3 支持两种生成模式：TM-on（输出自反思 CoT）和 TM-off（直接回答）。作者把 token 分为 Math / Style / Other 三类，统计四种师生组合下的 per-token KL。

**TM-off 学生 / TM-on 教师组合在所有模型规模上产生最大的 Math 类 KL**：

| 学生 | 教师 | 1.7B Math | 4B Math | 8B Math |
|---|---|---:|---:|---:|
| TM-off | TM-off | 0.12 | 0.06 | 0.05 |
| TM-on | TM-off | 0.10 | 0.05 | 0.05 |
| TM-on | TM-on | 0.09 | 0.04 | 0.04 |
| **TM-off** | **TM-on** | **0.14** | **0.10** | **0.06** |

但同时发现 **Style 类 KL（如 1.7B 上 0.85）远大于 Math 类（0.14）**——这正是引入 KL 裁剪的动机。**最终选择 TM-off 学生 + TM-on 教师**。

> [!warning] 数学类 KL 更大 ≠ 数学监督质量更高
> 更大的 KL 只说明师生在这些 token 上分歧更大。要证明是有效的数学知识转移，还需看下游表现。Table 7 仅平均了 10 道题，作为机制观察有参考价值，但证据规模有限。

### 8.6 §4.3.3 Figure 4：KL 裁剪的作用

![Figure 4: 逐 token KL 裁剪的影响](mineru-figures/fig_p08_image_7.png)

*Figure 4（第 8 页）：逐 token 逐点 KL 裁剪对 Qwen3-1.7B 在 AIME24 上准确率的影响。*

Qwen3-1.7B, AIME24：开启裁剪在第 100 步约 57.2%，不开启约 49.2%，差距约 8 个百分点。不开启时模型早期可能提升但随后明显退化；开启后整体更稳定。

**最终选择：开启 Pointwise Clipping**。但作者未系统调优阈值 $\tau$，机制归因（性能退化究竟多少由 Style token 导致）也未单独验证。

### 8.7 §4.3.4 Figure 5：生成长度

![Figure 5: 生成长度的影响](mineru-figures/fig_p08_lower_Figure5.png)

*Figure 5（第 8 页）：学生生成长度 1024 vs 4096 在 AIME25 / AIME24 上的对比。*

Qwen3-1.7B, 1024 vs 4096 token：在 AIME25 上 4096 没有形成稳定优势；在 AIME24 上 4096 在第 50 步峰值更高（约 58.6% vs 1024 后期 57.2%），但综合两套任务和 4 倍生成成本，作者认为延长生成没有一致收益。

**作者的解释（研究假设）**：早期 token 处于关键推理分岔点；学生前缀足够长后，后续 token 对教师而言越来越可预测，提供的额外纠正信号变少。

**最终选择：1024 token**。更准确的说法是"1024 和 4096 之间没有一致优势，采用成本更低的 1024"，而非"越短越好"。

### 8.8 §4.3.5 Table 4：全词表 vs 采样 token

见 §7.3。**最终选择 Full-vocabulary**，代价是峰值显存更高。

### 8.9 附录 B：完全关闭 Thinking Mode

主实验训练时学生 TM-off、教师 TM-on，评估时 TM-on。附录 B 把师生和评估都设为 TM-off：

- 8B 上仍能取得明显收益（AIME24 +23.3, AIME25 +15.3, HMMT25 +7.5 个百分点）。
- 1.7B / 4B 收益不均衡，部分任务甚至下降。
- 训练后期（Step 100 vs Step 50）有明显退化，与正文观察一致。

**结论**：OPSD 不完全依赖开启 Thinking Mode，但效果有模型和任务差异。

### 8.10 作者最终采用的方案汇总

| 设计决策 | 研究过的分支 | 最终采用 | 证据 |
|---|---|---|---|
| 散度函数 | FKL / RKL / JSD | **Forward KL** | Table 3 |
| 学生生成模式 | TM-on / TM-off | **TM-off** | Table 7 |
| 教师生成模式 | TM-on / TM-off | **TM-on** | Table 7 |
| 散度裁剪 | 不裁剪 / Pointwise | **开启** | Figure 4 |
| 学生生成长度 | 1024 / 4096 | **1024** | Figure 5 |
| 蒸馏目标 | Full-vocab / Sampled | **Full-vocab** | Table 4 |
| 教师参数 | 跟随更新 / 冻结初始 | **冻结初始** | §4.1 |
| 优化形式 | 分布匹配 / 策略梯度 | **分布匹配** | Table 4 |

### 8.11 论文证明了什么 / 没证明什么

| 论文主张 | 证据 | 判断 |
|---|---|---|
| 同源教师+标准答案能帮学生 | Table 2 | 有正向证据 |
| 比 SFT 更好 | Table 2 | 当前数据配置下成立 |
| 比 GRPO 学生采样 token 更高效 | Figure 3 | 较直接 |
| Forward KL 更合适 | Table 3 | 当前配置成立 |
| TM-off 学生 + TM-on 教师最好 | Table 7 + 叙述 | 缺完整下游消融 |
| Pointwise Clipping 稳定训练 | Figure 4 | 较清楚 |
| 更长生成没必要 | Figure 5 | 只能说无一致收益 |
| Full-vocab 优于 Sampled | Table 4 | 当前两基准成立 |
| 能扩展到 32B/70B | 无 | 未证明 |
| 总 GPU 成本低于 GRPO | 缺统一算力预算对比 | 未严格证明 |

---

## 9. Related Work：三条研究线

### 9.1 LLM Self-Training（自训练）

| 方法 | 机制 | 与 OPSD 区别 |
|---|---|---|
| **Context Distillation**（Snell 2022） | 教师看特权上下文生成离散答案 → 学生 SFT | **Off-policy + Hard distillation**：学习信号是离散 token 序列，不是学生自己采样轨迹上的分布 |
| **ReST / STaR** | 生成多条轨迹 → 按答案筛选 → SFT 成功轨迹 | 只从**成功轨迹**学习；OPSD 即使失败也能算逐 token 监督 |
| **In-context Editing**（Qi 2025） | 学生 on-policy 采样 + 软蒸馏内化上下文知识 | 应用场景是知识编辑，不是数学推理 |
| **SDPO**（Hübotter 2026）/ **SDFT**（Shenfeld 2026） | 同期工作 | SDPO 用环境反馈作特权信息；SDFT 在持续学习任务上做 on-policy 自蒸馏 |

> [!important] 不能把 OPSD 概括为"第一个自蒸馏"
> Context Distillation 早就用同模型作教师+特权上下文。OPSD 更准确的研究定位是：**针对推理任务，在学生自己的生成轨迹上，让同源教师利用参考答案提供逐 token 的完整分布监督**——on-policy + soft + per-token + reasoning 四者结合才是新点。

### 9.2 On-Policy Distillation（同策略蒸馏）

学生直接在自己采样的轨迹上训练，教师通过 KL 正则等提供逐 token 指导（GKD、Lu & Lab 2025 等）。这类方法通常依赖**独立的、往往更大的教师模型**。OPSD 的研究问题是：**如果没有更大教师，只让同源教师多看参考答案，能否产生足够有用的指导？**

作者还类比了机器人/强化学习中的 **DAgger**（Ross 2011）：学生执行动作 → 教师对学生实际访问的状态提供纠正 → 学生学习。OPSD 与 DAgger 思想相似但机制不同——DAgger 用纠正动作标签，OPSD 用概率分布散度。

### 9.3 SFT 与 RL 提升推理能力

- **SFT**：直接、稳定，但可能依赖记忆而非稳健泛化（Chu 2025）。
- **RL（GRPO 等）**：直接优化结果目标，泛化可能更好；GRPO 用组级奖励估计优势，不需要 PPO 的显式 critic，但奖励稀疏和零优势问题仍存在。
- **OPSD**：提出第三种监督方式——学生自己探索 + 教师软分布逐 token 指导，不依赖最终二元奖励。

---

## 10. 常见疑问解答（FAQ）

> [!question] Q1：标准答案比学生答案短，token 怎么对齐？
> **不需要对齐**。OPSD 始终沿学生轨迹的生成位置计算散度。标准答案只是教师的额外上下文，影响教师输入长度，不影响输出分布的维度（都是 $|\mathcal{V}|$ 维）。

> [!question] Q2：教师什么时候介入？散度算一次还是一直算？
> 沿学生轨迹的**每个生成位置**都算一次散度（一条 100 token 的轨迹 → 100 个散度值），但**汇总整个 batch 后才执行一次参数更新**。"每个 token 计算 KL" ≠ "每个 token 更新一次参数"。

> [!question] Q3：教师是不是要跑 100 次 Transformer？
> **不需要**。Causal Transformer 把完整学生轨迹塞进输入、用因果掩码，**一次前向就能并行计算所有位置的 logits**，类似 SFT 的 Teacher Forcing，只不过监督目标是教师概率分布而非正确 token 标签。

> [!question] Q4：教师为什么不生成自己的轨迹？
> 论文 Figure 2 caption 明确："the teacher won't be generating tokens—rationalization is done implicitly through one forward pass." 教师提示词里"请理解参考解后用自己的方法解题"只是**让模型通过注意力处理参考解、改变隐藏状态**，并不真的逐 token 生成新答案。

> [!question] Q5：错误答案上"重新思考"是否合理？教师明知道学生前面错了，为什么还要沿着错误轨迹算？
> 这是 OPSD 的**核心局限**。教师拿到正确答案只保证它拥有更多信息，**不保证它能在每条错误前缀上给出正确的下一步指导**。可能情况：
> - **A**：教师识别矛盾，输出纠正内容（理想情况）；
> - **B**：教师顺着错误前缀继续，反而强化错误；
> - **C**：正确解答与错误前缀互相干扰，教师分布混乱。
>
> OPSD **没有显式机制判断哪种情况发生**，依赖"模型有能力理解标准答案"这一假设。附录 A 明确承认：问题超过模型理解能力时，即使给教师看了答案也不一定能产生有意义的监督。

> [!question] Q6：同一条轨迹内，前面错误的 token 会不会一直带进去？
> **会**。计算第 3 个位置时前缀是 $(a, b)$，计算第 4 个位置时前缀是 $(a, b, c)$——错误的 $b$ 会进入后面所有位置的前缀。因为 OPSD 计算的是教师在**学生实际访问过的上下文**上的分布，不能擅自把错误 token 替换成正确的（那会改变学生轨迹本身）。

> [!question] Q7：下一轮训练（下一个 training step）的输入是什么？会把上一轮错误轨迹或教师轨迹加进去吗？
> **不会**。下一轮用更新后的学生模型 $\theta_{t+1}$ 重新采样题目、生成全新轨迹 $\hat y^{(t+1)}$。标准答案始终只用于教师分支。即使同一道题被再次采到，也会由当前学生策略重新生成，而不是接续上一次的错误答案。

> [!question] Q8："冻结初始教师"是冻结多久？
> **整个训练期间**。论文 §4.1 原文 "We fix the teacher policy to be the initial policy"。训练后期教师与学生虽来自同一初始检查点，但参数已不同。仍叫自蒸馏是因为教师不是外部更大模型。

> [!question] Q9：Method B 的 Advantage 和 GRPO 的 Advantage 一样吗？
> **不一样**。GRPO 的优势来自整条轨迹最终奖励与组内平均的差异；OPSD 的 $A_n = \log p_T(\hat y_n) - \log p_S(\hat y_n)$ 来自教师与学生对**同一个 token**的对数概率差。两者都叫 advantage 但语义完全不同。

> [!question] Q10：为什么不直接 SFT，而要先让学生生成错误轨迹再让教师算分布？
> 这是 OPSD 的核心研究假设：**学生自己访问的状态分布 + 教师软监督，可能比单纯模仿专家轨迹更有利于泛化**。SFT 学的是"标准答案怎么生成"，OPSD 学的是"在我自己的生成路径上，看过答案的教师会怎样预测"。论文实验在当前配置下支持这一假设，但能否推广到其他模型/任务/更大规模仍需验证。

---

## 11. 总结：值得记住的几件事

### 11.1 整篇论文的研究故事

$$
\boxed{
\begin{gathered}
\text{On-Policy Student Rollout（学生自己生成轨迹）}\\
\downarrow\\
\text{Privileged Teacher（同源教师 + 参考答案）}\\
\downarrow\\
\text{Forward KL + Pointwise Clipping}\\
\downarrow\\
\text{Full-Vocabulary Per-Token Distillation}\\
\downarrow\\
\text{Student Parameter Update（梯度仅过学生 logits）}
\end{gathered}
}
$$

### 11.2 三个最值得记住的研究发现

1. **有标准答案，不代表必须直接 SFT**。参考答案可以不作为硬标签，而是作为教师的特权上下文，在学生自己轨迹上构造软监督。
2. **最重要的挑战不是能否产生 KL，而是产生的 KL 有没有价值**。不同 Thinking Mode 产生不同分布差异；风格 token 可能产生非常大 KL；一些差异并不对应推理能力提升。散度选择、教师提示词设计、Pointwise Clipping 都在尝试控制监督信号质量。
3. **OPSD 已显示出训练后期不稳定**。Figure 4、Table 3、Table 6 都能看到。作者在附录 A 明确承认：模型更大时是否更稳定、如何利用正确性验证信号、如何根据学生能力选题，都值得进一步研究。

### 11.3 真正的核心创新

不是 KL、JSD 或 Policy Gradient 本身——这些都很成熟。也不是"教师和学生来自同一个模型"——Context Distillation 已有。**真正值得关注的是这样一种训练思想**：

$$
\underbrace{\text{On-Policy Rollout}}_{\text{学生自己的轨迹}}
+
\underbrace{\text{Privileged Context}}_{\text{教师额外看到答案}}
+
\underbrace{\text{Dense Per-Token Distillation}}_{\text{逐 token 全词表监督}}
$$

> [!quote] 最值得带走的开放问题
> **教师与学生之间的分布差异，什么时候代表有价值的推理指导，什么时候只是表达风格或错误判断造成的噪声？** 论文的 Pointwise Clipping、Thinking Mode 组合和散度消融，实际上都在尝试回答这个问题。这也是 OPSD 最值得带到后续研究中的思路。

---

## 附：关键图索引

| 图表 | 页码 | 内容 | FIG 占位 |
|---|---|---|---|
| Figure 1 | p2 | OPSD 总览：单模型双策略 + 逐 token 散度 | §2.2 |
| Figure 2 | p4 | 学生/教师提示词示例 | §3.1 |
| Algorithm 1 | p5 | OPSD 完整训练伪代码 | §5 |
| Figure 3 | p6 | Token 效率 + GRPO 零奖励标准差比例 | §8.3 |
| Table 2 | p7 | 三规模 SFT/GRPO/OPSD 主结果（Avg@12） | §8.2 |
| Table 3 | p7 | Forward/Reverse KL/JSD 消融 | §8.4 |
| Table 7 | p14 | 四种师生模式下的 per-token KL 分类统计 | §8.5 |
| Figure 4 | p8 | KL Pointwise Clipping 消融 | §8.6 |
| Figure 5 | p8 | 生成长度 1024 vs 4096 | §8.7 |
| Table 4 | p9 | Full-vocab vs Sampled-token 消融（pass@8） | §7.3 |

## 附：相关文件

- 原文 PDF（BabelDOC 双语版）：`zhao26be.zh-CN.dual.pdf`
- 精读对话原文：`chatgpt-archive/odsp__6adc4ba2.md`（72 条消息，9314 行）
- 创新点四象限报告（参考）：`../Trending AI/OPSD/innovation-report.md`

---

> [!quote] OPSD 最核心的一句话
> **让学生先自己生成轨迹，再让一个看过标准答案的同源教师，在这条轨迹的每个位置上提供逐 token 的概率分布监督——以此把数据集里的参考答案从"硬标签"转变成"教师的特权上下文"，在不依赖更大外部教师的情况下获得稠密、同策略的训练信号。**
