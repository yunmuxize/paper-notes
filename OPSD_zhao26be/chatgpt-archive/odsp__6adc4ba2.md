# odsp

Created: 2026-10-24
Updated: 2026-10-24
Messages: 72
Model: gpt-6-thinking

---
## User
*2026-10-24 06:09*
请你给我拆解讲解一下整个引言部分

---

## Tool
*2026-10-24 06:09*
> ❔ tether_browsing_display

---

## Tool
*2026-10-24 06:09*
[L1] <PARSED TEXT FOR PAGE: 1 / 16>
Use ref_id "turn0file0" to reference this file. For broad questions or unknown locations, retrieve relevant chunks with `files.search` scoped to this file. Use `files.find` only for exact text, and use `files.read` for a known range or to expand relevant results. Full file size: 16 pages, 1337 file lines.

[L2]                                                                                                                                       本文档由 funstory.ai 的开源 PDF 翻译库 BabelDOC v0.6.2 (https://github.com/funstory‑ai/BabelDOC) 翻译，本仓库正在积极的建设当中，欢迎 star 和关注。




[L7]                                       Self-Distilled Reasoner:                                                                                                          自蒸馏推理器：面向大语言模型的同策略自蒸馏
[L8]                        On-Policy Self-Distillation for Large Language Models


[L11]       Siyan Zhao† 1 Zhihui Xie 2 Mengchen Liu 3 Jing Huang 3 Guan Pang 3 Feiyu Chen∗,‡ 3 Aditya Grover∗ 1                                       Siyan Zhao† 1 Zhihui Xie 2 Mengchen Liu 3 Jing Huang 3 Guan Pang 3 Feiyu Chen∗,‡ 3 Aditya Grover∗ 1



[L15]                           Abstract                                  struction following. Achieving these capabilities during                                         摘要                                        令遵循能力。在后训练中实现这些能力通常依赖于强
[L16]        Knowledge distillation improves large language
[L17]                                                                     post-training typically relies on reinforcement learning
[L18]                                                                                                                                                       知识蒸馏通过压缩教师大语言模型的知识                                       化学习方法，例如带可验证奖励的强化学习（RLVR）
[L19]                                                                     methods such as Reinforcement Learning with Verifiable
[L20]        model (LLM) reasoning by compressing the                                                                                                     来训练更小的大语言模型，从而提升大语言模                                       （例如 GRPO（Shao 等，2024；Guo 等，2025；
[L21]                                                                     Rewards (RLVR) (e.g., GRPO (Shao et al., 2024; Guo et al.,
[L22]        knowledge of a teacher LLM to train smaller
[L23]                                                                     2025; Team et al., 2025; Rastogi et al., 2025; Yu et al.,                       型（LLM）的推理能力。同策略蒸馏推进了这                                      Team 等，2025；Rastogi 等，2025；Yu 等，
[L24]        LLMs. On-policy distillation advances this ap-
[L25]                                                                     2025)), supervised fine-tuning (SFT) on high-quality rea-                       一方法：让学生模型采样自身轨迹，同时由教                                       2025））、在高质量推理数据集上进行监督微调（
[L26]        proach by having the student sample its own tra-
[L27]        jectories while a teacher LLM provides dense
[L28]                                                                     soning datasets (Guha et al., 2025; Team et al., 2025; Xi-                      师大语言模型提供稠密的词元级监督，从而解                                       SFT）（Guha 等，2025；Team 等，2025；小米，
[L29]                                                                     aomi, 2026), or knowledge distillation, where recent work
[L30]        token-level supervision, addressing the distribu-                                                                                            决离策略蒸馏方法中训练与推理之间的分布不                                       2026），或知识蒸馏；近期工作表明，从先进教师模
[L31]                                                                     has shown that distillation from advanced teacher models
[L32]        tion mismatch between training and inference
[L33]                                                                     can outperform RL in both performance and training effi-                        匹配问题。然而，同策略蒸馏通常需要一个独                                       型进行蒸馏在性能和训练效率上均可优于强化学习
[L34]        in off-policy distillation methods. However, on-
[L35]                                                                     ciency (Yang et al., 2025; Xiaomi, 2026; Lu & Lab, 2025).                       立的、往往更大的教师大语言模型，并且没有                                       （Yang 等，2025；小米，2026；Lu & Lab，2025）。
[L36]        policy distillation typically requires a separate,
[L37]                                                                                                                                                     显式利用推理数据集中可用的真值解。受以下
[L38]        often larger, teacher LLM and does not explicitly            Despite their respective successes, each approach has in-                                                                                  尽管各自取得了成功，每种方法都有其固有限制。
[L39]                                                                                                                                                     直觉启发：能力足够强的大语言模型能够将外
[L40]        leverage ground-truth solutions available in rea-            herent limitations. RLVR suffers from inefficiencies in-                                                                                   RLVR 存在低效问题，包括：（1）针对每个提示采样
[L41]        soning datasets. Inspired by the intuition that a            cluding: (1) sampling a group of responses per prompt is                        部特权推理轨迹合理化，并教导较弱的自身，
[L42]                                                                                                                                                                                                                一组回复计算成本高昂，并且在估计真实价值函数时
[L43]        sufficiently capable LLM can rationalize external            computationally expensive and can introduce high variance                       我们提出同策略自蒸馏（OPSD），一种学习
[L44]                                                                                                                                                                                                                可能引入高方差；此外，当所有样本要么正确要么错
[L45]        privileged reasoning traces and teach its weaker             in estimating the true value function; moreover, when all                       算法，其中单个大语言模型以不同上下文同时
[L46]        self, we introduce On-Policy Self-Distillation               samples are either correct or incorrect, the gradient sig-                                                                                 误时，梯度信号会消失（Yu 等，2025；Zhao 等，
[L47]                                                                                                                                                     充当教师与学生。教师策略以特权信息为条件，
[L48]        (OPSD), a learning algorithm where a single                  nal vanishes (Yu et al., 2025; Zhao et al., 2025); and (2)                                                                                 2025）；并且（2）奖励信号稀疏，并统一施加到生
[L49]                                                                     the reward signal is sparse and uniformly applied across                        而学生策略只看到问题；训练最小化这些分布
[L50]        LLM acts as both teacher and student with dif-
[L51]                                                                                                                                                     在学生自身轨迹上的逐词元散度。我们在多个                                       成输出中的所有词元上，忽视了细粒度词元级反馈。
[L52]        ferent contexts. The teacher policy conditions on            all tokens in the generated output, neglecting fine-grained
[L53]        privileged information while the student policy              token-level feedback. Supervised fine-tuning suffers from                       数学推理基准上证明了该方法的有效性，相比                                       监督微调存在暴露偏差和泛化能力较弱的问题（
[L54]        sees only the question; training minimizes the               exposure bias and weaker generalization (Agarwal et al.,                        强化学习方法实现了更优的词元效率，并相较                                       Agarwal 等，2024；Chu 等，2025）。传统知识蒸馏
[L55]        per-token divergence between these distributions             2024; Chu et al., 2025). Traditional knowledge distillation                     离策略蒸馏方法取得了更好的性能。代码仓库：                                      由教师模型提供稠密词元级监督，但依赖离策略数据
[L56]        over the student’s own rollouts. We demonstrate              provides dense token-level supervision from a teacher model
[L57]                                                                                                                                                     h                                                          （Hinton 等，2015）。同策略蒸馏的最新进展——其
[L58]        the efficacy of our method on multiple mathe-                but relies on off-policy data (Hinton et al., 2015). Recent
[L59]                                                                                                                                                                                                                中学生模型采样自己的轨迹，而教师策略提供稠密词
[L60]                                                                                                                                                     ttps://github.com/siyan-zhao/OPSD。
[L61]        matical reasoning benchmarks, achieving supe-                advances in on-policy distillation—where a student model
[L62]        rior token efficiency compared to reinforcement              samples its own trajectories while a teacher policy provides                                                                               元级监督——通过将同策略训练的分布真实性与稠密
[L63]        learning methods and better performance over off-            dense token-level supervision—have demonstrated superior                                                                                   反馈相结合，已表现出更优的样本效率（Agarwal 等，
[L64]        policy distillation methods. Code repo: https:               sample efficiency by combining the distributional realism
[L65]                                                                                                                                                                                                                2024；Lu & Lab，2025）。
[L66]        //github.com/siyan-zhao/OPSD.                                of on-policy training with dense feedback (Agarwal et al.,
[L67]                                                                     2024; Lu & Lab, 2025).
[L68]                                                                     While on-policy distillation has shown strong performance,                                                                                 尽管同策略蒸馏已展现出强劲性能，但它依赖一个独
[L69] 1. Introduction                                                     it relies on a distinct teacher model to supervise the student.         1. 引言                                                              立的教师模型来监督学生模型。鉴于现代大语言模型
[L70]                                                                     Given that modern LLMs already exhibit strong reasoning                 大语言模型（LLMs）的最新进展已展现出令人印象深刻
[L71] Recent advances in large language models (LLMs) have                                                                                                                                                           已经具备强大的推理能力，我们提出这一研究问题：
[L72]                                                                     capabilities, we ask this research question: can a model
[L73] demonstrated impressive capabilities in reasoning and in-                                                                                   的推理和指‑                                                             模型能否通过自蒸馏有效地充当自己的教师？我们的
[L74]                                                                     effectively serve as its own teacher through self-distillation?
[L75]                                                                                                                                               共同指导，† 工作完成于加州大学洛杉矶分校以及 Siyan 在 Meta 兼职                          方法受人类学习启发：在错误地解决一个问题后，学
[L76]   *                †                                                                                                                            *
[L77]    Equal advising, Work done at UCLA and during Siyan’s part-       Our approach is inspired by human learning: after solving a
[L78] time internship at Meta.,‡ Work done at Meta. 1 UCLA 2 HKU                                                                                  实习期间。‡ 工作完成于 Meta。 1加州大学洛杉矶分校 2香港大学 3Meta超
3
[L80]   Meta Superintelligence Labs. Correspondence to: Siyan Zhao
[L81]                                                                     problem incorrectly, a student can examine the correct solu-
[L82]                                                                                                                                             级智能实验室。通讯作者：Siyan Zhao<siyanz@g.ucla.edu>。
[L83]                                                                                                                                                                                                                生可以查看正确的解法，对其步骤进行合理化，并找
[L84]                                                                     tion, rationalize its steps, and identify where their reasoning
[L85] <siyanz@g.ucla.edu>.                                                                                                                                                                                           出其推理失败之处。先前工作表明，对于大语言模型
[L86]                                                                     failed. Prior work has shown that for LLMs, evaluation is
[L87] Proceedings of the 43 rd International Conference on Machine        often easier than generation (Sun et al., 2024; Naor, 1996).            会议论文集： 43 rd 国际机器学习大会，韩国首尔。                                        而言，评估往往比生成更容易（Sun 等,2024;
[L88] Learning, Seoul, South Korea. PMLR 306, 2026. Copyright 2026        We hypothesize that rationalization—explaining a given cor-             PMLR 306，2026。2026 年版权归作者所有。                                       Naor,1996）。我们假设合理化—解释给定的正‑
[L89] by the author(s).

[L91]                                                                 1                                                                                                                                          1


[L93] <PARSED TEXT FOR PAGE: 2 / 16>

[L94]                                            On-Policy Self-Distillation for Large Language Models                                                                                           面向大语言模型的同策略自蒸馏

[L96]                                       Construct two
[L97]                                      prompts for the
[L98]                                                         On-Policy Self-Distillation                                                                                                  构建两个
[L99]                                                                                                                                                                                      用于⋯⋯的提示词        同策略自蒸馏
[L100]                                         same LLM                                                                                                                                       同一 大语言模
                                                                                                                                                                                       型
[L102]                                                        Student Prompt              Teacher Prompt                       Learning Objective                                                          学生提示词                     教师提示词                            学习目标
[L103]      Dataset               Sample                                                                                                                       数据集                样本
[L104]                                                               only                      and                                                                                                             only                     and
[L105]                                                                                                                         Per-Token Divergence                                                                                                                   逐词元散度
[L106]                                                        Student Policy               Teacher Policy                                                                                                  学生策略                       教师策略
[L107]                : Problem                                                                                                                                       ：问题
[L108]                : CoT + Answer                                                                                                                                  ：思维链 + 答案
[L109]                                                                On-Policy                              Evaluate with                                                                                        同策略                                    使用⋯⋯评估
[L110]                                                                  Sample                                 privileged    Gradient only flow through                                                             样本                                    特权       梯度仅流经
[L111]           Large Language Model                                                                         information
[L112]                                                                                                                          the student's logits              大语言模型                                                                                  信息
[L113]                                                                                                                                                                                                                                                               学生 logits




[L118] Figure 1. Overview of On-Policy Self-Distillation (OPSD): Given a reasoning dataset S = {(xi , yi⋆ )}N      i=1 , we instantiate two policies       图 1. 同策略自蒸馏（OPSD）概述： 给定一个推理数据集 S = {（xi， yi⋆）}N
[L119]                                                                                                                                                                                                   i=1，我们从同一大语言模型实例化两个策略：一个 学生策略
[L120] from the same LLM: a student policy pS (· | x) and a teacher policy pT (· | x, y ⋆ ). The student generates an on-policy response                   pS （ · | x ）和一个 教师策略 pT （ · | x， y ⋆ ）。学生模型生成一个同策略响应 ŷ ∼ pS （ · | x ）。随后，两个策略评估该轨迹，以在每
[L121] ŷ ∼ pS (· | x). Both policies then evaluate this trajectory to produce next-token distributions pS (· | x, ŷ<n ) and pT (· | x, y ⋆ , ŷ<n ) at   一步 n 产生下一词元分布 pS（· | x， ŷ<n）和 pT （· | x， y ⋆， ŷ<n）。学习目标为最小化沿学生模型 rollout 的逐词元散度 D（pT ∥pS）。
[L122] each step n. The learning objective minimizes the per-token divergence D(pT ∥pS ) along the student’s rollout. The divergence here can
[L123]                                                                                                                                                     这里的散度可以是前向 KL、反向 KL 或 JSD。关键在于，梯度仅通过学生模型的 logits 反向传播，从而使模型能够自蒸馏。
[L124] be forward KL, reverse KL or JSD. Crucially, gradients backpropagate only through the student’s logits, allowing the model to self-distil.


[L127] rect answer—is similarly easier than generation. Motivated                        we find stylistic tokens can dominate the training signal         确答案——同样比生成更容易。受此启发，我们由单                                                  我们发现风格词元可能主导数学词元的训练信号。
[L128] by this, we instantiate both the teacher and student policies                     of math tokens.                                                   个大语言模型实例化教师策略与学生策略。教师策略
[L129] from a single LLM. The teacher policy is provided with                          • We evaluate OPSD on three competition-level mathemat-                                                                                     • 我们在三个竞赛级数学推理任务上评估 OPSD，证明
[L130]                                                                                                                                                     被提供特权信息 y ⋆，例如真实答案或参考思维链，而
[L131] privileged information y ⋆ , such as the ground-truth answer                      ical reasoning tasks, demonstrating that it matches the                                                                                   它在显著提高词元效率的同时达到与 GRPO 相当的性
[L132] or a reference chain-of-thought, while the student policy                         performance of GRPO with significantly improved token             学生策略仅以问题 x 为条件。具体而言，教师策略
[L133]                                                                                                                                                                                                                             能，并优于监督微调。
[L134] conditions only on the problem x. Concretely, the teacher                         efficiency and outperform supervised fine-tuning.                 pT (· | x, y ⋆) 同时以问题和特权答案为条件，而学生
[L135] policy pT (· | x, y ⋆ ) conditions on both the problem and                      • We analyze the impact of different divergence objec-              策略 pS(· | x) 仅观察问题。我们通过仅从学生策略采                                          • 我们分析不同散度目标的影响、学生生成长度的影
[L136] the privileged answer, whereas the student policy pS (· | x)                      tives, the effect of student generation length, and stu-                                                                                  响，以及学生与教师生成风格的影响。
[L137]                                                                                                                                                     样轨迹 ˆy 来保持同策略训练范式，随后该学生策略
[L138] observes only the problem. We preserve the on-policy train-                       dent–teacher generation styles.
[L139] ing paradigm by sampling trajectories ŷ exclusively from                                                                                           从特权教师策略获得密集的词元级监督。
[L140] the student policy, which then receives dense, token-level
[L141] supervision from the privileged teacher policy.                                 2. Background                                                                                                                               2. 背景
[L142] We therefore propose On-Policy Self-Distillation (OPSD),                        2.1. Knowledge Distillation for Autoregressive Large                因此，我们提出同策略自蒸馏（OPSD），这是一个                                                2.1. 自回归大语言模型的知识蒸馏
[L143] a framework in which a single model plays both teacher                               Language Models                                                让单一模型同时扮演教师与学生角色的框架。学生采
[L144] and student roles. The student samples its own trajectories
[L145]                                                                                 Knowledge distillation transfers knowledge from a larger            样自身轨迹 ˆy ∼ pS(· | x)；随后我们计算学生与教师
[L146]                                                                                                                                                                                   知识蒸馏通过训练学生模型模仿教师的行为，将知识
[L147] ŷ ∼ pS (· | x); we then compute the per-token divergence
[L148] between the student and teacher distributions and minimize                      teacher model to a smaller student model by training the            分布之间的逐词元散度，并在学生自身轨迹上最小化       从较大的教师模型迁移到较小的学生模型（Hinton
[L149] it over the student’s own rollouts. This formulation (i) uses                   student to mimic the teacher’s behavior (Hinton et al.,             该散度。该形式（i）使用同策略监督（学生自身轨迹），等，2015；Kim &Rush，2016；Sanh 等，2019）。
[L150]                                                                                 2015; Kim & Rush, 2016; Sanh et al., 2019). The core
[L151] on-policy supervision (the student’s own trajectories), (ii)
[L152]                                                                                 insight is that the teacher’s soft probability distribution         （ii）提供稠密逐词元反馈，（iii）利用真实解 y ⋆， 核心洞见在于，教师对各类别的软概率分布所包含的
[L153] provides dense per-token feedback, (iii) exploits ground-
[L154]                                                                                 over classes contains richer information than hard labels           并且（iv）无需单独的教师模型。学习过程由以下损      信息比单独的硬标签更丰富，因为它揭示了教师学习
[L155] truth solutions y ⋆ , and (iv) requires no separate teacher
[L156] model. The learning process is captured by the loss                             alone, as it reveals the teacher’s learned similarities be-         失刻画                           到的类别间相似性。对于自回归语言模型，给定一个
[L157]                                                                                 tween classes. For auto-regressive language models, given
[L158]                                                                                                                                                                                                                             数据集 S = {（x， y ⋆）} 其中 x 表示输入，且 y ⋆ 是
[L159]                                                |ŷ|                             a dataset S = {(x, y ⋆ )} where x denotes an input and y ⋆ is                                                |ŷ|
[L160]                                                                                                                                                                                                                             对应的参考输出，教师 pT 和学生 pS 都定义词汇表上
[L161]                                                X                                                                                                                                             X
[L162]    LOPSD (θ) = E(x,y⋆ )∼S Eŷ∼pS (·|x)                                          the corresponding reference output, both teacher pT and stu-          LOPSD (θ) = E(x,y⋆ )∼S Eŷ∼pS (·|x)
[L163]                                                n=1                              dent pS define token-level distributions over vocabulary V.                                                  n=1                            的词元级分布 V。传统的监督蒸馏最小化一个散度D ，
[L164]                                                                                                                                                                                                                             该散度是在固定数据集上对教师与学生分布取平均得
[L165]                                                                                                                                                                                                          
[L166]                D pT (· | x, y ⋆ , ŷ<n )     pS (· | x, ŷ<n ) .      (1)       Traditional supervised distillation minimizes a divergence                     D pT (· | x, y ⋆ , ŷ<n )   pS (· | x, ŷ<n ) .    (1)
[L167]                                                                                 D between teacher and student distributions averaged over
                                                                                                                                                                                                                            到的：
[L169]                                                                                 a fixed dataset:
[L170] In summary, our contributions are as follows:                                                                                                       总之，我们的贡献如下：
[L171]                                                                                   LSupervised Distillation (θ) = E(x,y)∼S [D(pT ∥pS )(y|x)], (2)                                                                             LSupervised Distillation (θ) = E(x,y)∼S [D(pT ∥pS )(y|x)], (2)
[L172] • We introduce On-Policy Self-Distillation (OPSD), a novel                                                                                          • 我们提出同策略自蒸馏（OPSD），一种新颖框架，
[L173]   framework that enables a single model to act as both                          where               D(pT ∥pS )(y|x)                     =
[L174]                                                                                                                                                     使单一模型同时充当教师与学生，利用真实答案为学                                                 哪里 1 P|y|         D(pT ∥pS )(y|x)                           =
[L175]                                                                                                                                                                                                                                       n=1 D(pT (·|y<n, x)∥pS(·|y<n, x)) 衡量逐词元
                                                                                 1
                                                                                   P|y|
[L178]   teacher and student, leveraging ground-truth answers to                                  D(p   (·|y   , x)∥p  (·|y   , x))     measures
[L179]                                                                                                                                                     生的轨迹提供稠密词元级监督。
[L180]                                                                                 |y|   n=1      T     <n       S     <n                                                                                                         |y|
[L181]   provide dense token-level supervision on student rollouts.                    per-token discrepancy. However, this off-policy approach                                                                                    差异。然而，这种离策略方法存在分布不匹配问题：
[L182] • We introduce a per-token pointwise KL clipping mecha-                         suffers from distribution mismatch: the student encounters          • 我们引入了一种逐词元逐点 KL 裁剪机制，该机制可稳定                                           学生模型在自回归时会遇到不同的部分序列 y<n
[L183]   nism that stabilizes training and improves performance as                     different partial sequences y<n during auto-regressive              训练并提升性能，因为

[L185]                                                                             2                                                                                                                                           2


[L187] <PARSED TEXT FOR PAGE: 3 / 16>

[L188]                                        On-Policy Self-Distillation for Large Language Models                                                                                            面向大语言模型的同策略自蒸馏

[L190]                                              SFT/Off-Policy        GRPO           On-Policy             On-Policy                                                                            监督微调/异策略             GRPO       同策略              同策略
[L191]                                                Distillation                       Distillation    Self-Distillation (Ours)                                                                     蒸馏                            蒸馏            自蒸馏（本文方法）
[L192]                On-Policy Data                        ✗                  ✓              ✓                       ✓                                                同策略数据                                ✗               ✓         ✓                            ✓
[L193]                Dense Learning Signal                 ✓                  ✗              ✓                       ✓                                                密集学习信号                               ✓               ✗         ✓                            ✓
[L194]                Low Sampling Cost                     ✓                  ✗              ✓                       ✓                                                低采样成本                                ✓               ✗         ✓                            ✓
[L195]                No External Teacher                   ✓                  ✓              ✗                       ✓                                                无外部教师                                ✓               ✓          ✗                           ✓
[L196] Table 1. Comparison of training methods for reasoning tasks. On-Policy Self-Distillation (OPSD) combines the advantages of on-policy             表 1. 推理任务训练方法比较。同策略自蒸馏（OPSD）结合了同策略训练与稠密反馈的优势，且无需外部教师模型。
[L197] training with dense feedback without requiring an external teacher model.



[L201] generation at inference than those seen during training on                  at the sequence level. The GRPO objective incorporates               推理时的生成与在固定数据集上训练时所见的不同，                                                 序列级别上。GRPO 目标包含裁剪替代损失以调节策
[L202] the fixed dataset, leading to compounding errors. On-policy                 a clipped surrogate loss to moderate policy updates, along           导致误差累积。同策略蒸馏（Agarwal 等，2024；                                            略更新，以及反向KL惩罚以防止过度偏离参考策略：
[L203] distillation (Agarwal et al., 2024; Lu & Lab, 2025; Xu                      with a reverse KL penalty to prevent excessive deviation
[L204]                                                                                                                                                  Lu & Lab，2025；Xuet al.，2024a）通过在其自身生
[L205] et al., 2024a) addresses this by training the student on its                from a reference policy:
[L206] own generated sequences ŷ ∼ pS (·|x), obtaining dense                                                                                           成的序列上训练学生模型来解决这一问题 ˆy ∼ pS(·|x)，
[L207]                                                                                                                                                  从教师那里获取这些同策略样本上的密集词元级反馈：
[L208]                                                                                                                                    |oi |                                                                                                                                             |oi |
[L209]                                                                                                                      "    G
[L210]                                                                                                                                                                                                                                                                      "      G
[L211] token-level feedback from the teacher on these on-policy                                                               1 X 1 X                                                                                                                                           1 X 1 X
[L212] samples:                                                                          LGRPO (θ) = E           x∼S                                                                                                                 LGRPO (θ) = E            x∼S
[L213]                                                                                                  o1 ,...,oG ∼πθ (·|x) G
                                                                                                                         i=1
[L215]                                                                                                                              |oi | n=1                                                                                                        o1 ,...,oG ∼πθ (·|x)       G i=1 |oi | n=1
[L216] LOn-Policy Distillation (θ) = Ex∼S [Eŷ∼pS (·|x) [D(pT ∥pS )(ŷ|x)]].                       min (ρni Ai , clip (ρni , 1 − ε, 1 + ε) Ai )   (5)   LOn-Policy Distillation (θ) = Ex∼S [Eŷ∼pS (·|x) [D(pT ∥pS )(ŷ|x)]].               min (ρni Ai , clip (ρni , 1 − ε, 1 + ε) Ai )            (5)
[L217]                                                                 (3)                                                                                                                                              (3)
[L218]                                                                                                                                      #                                                                                                                                        #
[L219] This approach connects distillation to imitation learn-                                                 −βDKL [πθ (·|x)∥πref (·|x)]              该方法将蒸馏与模仿学习联系起来（Ross 等，2011），                                                                     −βDKL [πθ (·|x)∥πref (·|x)]
[L220] ing (Ross et al., 2011), where the student iteratively im-                                                                                       其中学生模型通过从教师对其自身输出的指导中学习
[L221] proves by learning from the teacher’s guidance on its own                                π (on |x,o<n )
[L222]                                                                             where ρni = π θ (oi n |x,oi <n ) is the importance ratio, πθold is   来迭代改进，将强化学习的同策略相关性与监督学习                                                 其中 ρni = θ(oni |x,o<n
                                                                                                                                                                                                                                    π
[L224]                                                                                                                                                                                                                                             i  ) πθold(on     <n
[L225]                                                                                                                                                                                                                                                         i |x,oi  ) 是重要性比率，
[L226] outputs, combining the on-policy relevance of reinforcement
[L227]                                                                                                                                                  的密集奖励信号相结合，从而在保持计算效率的同时                                                 πθold 是更新前的策略， ε 控制裁剪范围。
[L228]                                                                                          θold   i       i
[L229] learning with the dense reward signal of supervised learn-                  the policy before the update, and ε controls the clipping
[L230] ing, thereby mitigating exposure bias while maintaining                     range.                                                               缓解暴露偏差。
[L231] computational efficiency.
[L232]                                                                             While RLVR methods have demonstrated strong empirical                                                                                        尽管 RLVR 方法已展现出强大的实证性能，但它们面
[L233] 2.2. Reinforcement Learning with Verifiable Rewards
[L234]                                                                             performance, they face two key limitations: (1) the reward
[L235]                                                                                                                                                  2.2. 带可验证奖励的强化学习                                                        临两个关键局限：(1) 奖励信号稀疏，仅提供序列级反
[L236]                                                                             signal is sparse, providing only sequence-level feedback
[L237]                                                                                                                                                                                                                          馈，而不能就错误发生的位置提供词元级指导；(2) 当
[L238] Reinforcement learning with verifiable rewards (RLVR)                       rather than token-level guidance on where errors occur, and          带可验证奖励的强化学习（RLVR）已成为后训练大
[L239]                                                                             (2) when all sampled responses receive identical rewards                                                                                     所有采样响应获得相同奖励（全部正确或全部错误）
[L240] has emerged as a popular approach for post-training large                                                                                        语言模型的一种流行方法，尤其适用于数学和编程等
[L241] language models, particularly on tasks with easily verifi-                  (all correct or all incorrect), the advantages become zero,                                                                                  时，优势变为零，从而尽管采样需要计算成本，也无
[L242]                                                                                                                                                  结果易于验证的任务，并使用近端策略优化（PPO）
[L243] able outcomes such as mathematics and coding, using al-                     preventing any policy update despite the computational cost                                                                                  法进行任何策略更新。
[L244] gorithms like Proximal Policy Optimization (PPO) (Schul-                    of sampling.                                                         （Schulman 等，2017）以及组相对策略优化（
[L245] man et al., 2017) and Group Relative Policy Optimization                                                                                         GRPO）（Shao 等，2024）。
[L246] (GRPO) (Shao et al., 2024).                                                 3. Methods                                                                                                                                   3. 方法
[L247]                                                                                                                                                  GRPO 通过采样一组 G 响应{o1 , o2 , . . . , oG } 来进行训
[L248] GRPO trains by sampling a group of G responses                              3.1. Learning from Verifiable Reasoning Dataset                                                                                              3.1. 从可验证推理数据集中学习
[L249] {o1 , o2 , . . . , oG } from the current policy πθ for each prob-                                                                                练：这些响应来自当前策略 πθ ，并针对每个问题 x。每
[L250] lem x. Each response oi receives a binary reward ri ∈                       We consider a dataset of problem-solution pairs S =                  个响应 oi 都会获得一个二元奖励 ri ∈{0, 1} ，以指示
[L251]                                                                                                                                                                                                                          我们考虑一个由问题‑解决方案对组成的数据集 S ={
[L252]                                                                             {(xi , yi⋆ )}N                                                                                                                               (xi, yi⋆ )}N
[L253]                                                                                                                                                                                                                                     i=1, 其中每个 xi 表示一个问题， yi 是对应
                                                                                                                                          ⋆
[L255] {0, 1} indicating correctness. The method then assigns ad-                               i=1 , where each xi denotes a problem and yi                                                                                                                     ⋆
[L256]                                                                                                                                                  其正确性。该方法随后使用组归一化奖励，为所有词元
[L257] vantages to all tokens k = 1, . . . , |oi | within response oi              is the corresponding reference solution, which may include
[L258]                                                                                                                                                  k = 1，……， |oi | （位于响应 oi 内）分配优势：                                        的参考解，可能包含思维链推理。为简洁起见，我们
[L259] using a group-normalized reward:                                            chain-of-thought reasoning. For brevity, we omit the sample
[L260]                                                                             index i and use (x, y ⋆ ) to denote a generic sample from the                                                                                省略样本索引 i ，并使用 (x, y ⋆) 表示来自该数据集的
[L261]                          ri − mean({rj }G j=1 )                             dataset. We can exploit learning signals from this dataset                                   ri − mean({rj }G j=1 )                          一个通用样本。我们可以通过不同方式利用该数据集
[L262]                  Ai =                           .               (4)                                                                                               Ai =                          .              (4)
                                      G
[L264]                              std({rj }j=1 )                                 from different ways: Standard supervised fine-tuning (SFT)                                                G
[L265]                                                                                                                                                                              std({rj }j=1 )                              中的学习信号：对 S 进行标准监督微调（SFT）可视
[L266]                                                                             on S can be viewed as off-policy distillation/imitation learn-
[L267]                                                                                                                                                                                                                          为使用专家轨迹的离策略蒸馏/模仿学习，但它存在训
[L268] This formulation can be understood through the value func-                  ing using expert trajectories, but it suffers from distribution      该公式可以通过价值函数视角来理解：均值({rj }Gj=1)
[L269]                                                                                                                                                                                                                          练与推理之间的分布不匹配问题。基于可验证奖励的
[L270] tion lens: mean({rj }G  j=1 ) serves as a G-sample Monte                    mismatch between training and inference. Reinforcement               作为价值函数 V (x) 的 G个样本的蒙特卡洛估计，而
[L271] Carlo estimate of the value function V (x), while the sparse                learning from verifiable rewards (RLVR), such as GRPO,                                                                                       强化学习（RLVR），例如 GRPO，通过优化同策略
[L272]                                                         

[L280] <PARSED TEXT FOR PAGE: 4 / 16>

[L281]                                         On-Policy Self-Distillation for Large Language Models                                                                             面向大语言模型的同策略自蒸馏

[L283]         Student Prompt                                                                                                                               学生提示词
[L284]         Problem:       Find the derivative of f (x) = 3x2 + 2x − 5 at x = 2                                                                          问题：求 f(x) = 3x2 + 2x − 5 在 x = 2 处的导数 答案：
[L285]         Answer:



[L289]         Teacher Prompt                                                                                                                               教师提示词
[L290]         Problem:       Find the derivative of f (x) = 3x2 + 2x − 5 at x = 2                                                                          问题：       求 f(x) = 3x2 + 2x − 5 在 x = 2 处的导数
[L291]         Here is a reference solution:                                                                                                                以下是参考解：
[L292]         First find f ′ (x) = 6x + 2, then evaluate at x = 2:                       f ′ (2) = 6(2) + 2 = 14                                           首先求 f ′(x) = 6x + 2，然后在 x = 2 处求值：                     f ′(2) = 6(2) + 2 = 14
[L293]         After understanding the reference solution, please try to solve this problem                                                                 在理解参考解后，请尝试解决这个问题
[L294]         using your own approach below:                                                                                                               在下方用你自己的方法：
[L295]         Answer:                                                                                                                                      答案：

[L297] Figure 2. Prompt example for student and teacher policies. Both policies share the same parameters θ but differ in conditioning                 图 2. 学生模型和教师策略的提示示例。 两种策略共享相同的参数 θ ，但在条件上下文上有所不同。教师在生成之前接收真
[L298] context. The teacher receives the ground-truth solution y ⋆ as privileged information before generation. To ensure a natural transition         实解 y ⋆ 作为特权信息。为确保在评估学生模型的轨迹之前实现自然过渡，教师被提示进行合理化并生成自己的解。注意，
[L299] before evaluating the student’s rollout, the teacher is prompted to rationalize and generate its own solution. Note that the teacher won’t be
[L300] generating tokens—rationalization is done implictly through one forward pass.                                                                   教师不会生成词元——合理化是通过一次前向传播隐式完成的。


[L303] reward signal is sparse, providing same feedback across all              varying the conditioning context. The teacher policy con-              奖励信号是稀疏的，无论错误出现在何处，都会为所有                            改变条件上下文。教师策略 以特权信息为条件——即
[L304] tokens regardless of where errors occur. Alternatively, one              ditions on privileged information—both the problem x and               词元提供相同的反馈。或者，可以训练过程奖励模型                             问题 x 和参考解 y ⋆：
[L305] can train a process reward model (PRM) to provide dense,                 the reference solution y ⋆ :                                           （PRM），以便在强化学习期间提供稠密的词元级反馈。
[L306] token-level feedback during RL. However, acquiring labels
[L307]                                                                                           pT (· | x, y ⋆ ) ≜ pθ (· | x, y ⋆ ).                  然而，获取用于PRM训练的标签成本高得令人望而却步，                                        pT (· | x, y ⋆ ) ≜ pθ (· | x, y ⋆ ).
[L308] for PRM training is prohibitively expensive and difficult to
[L309] scale (Lightman et al., 2023; Zhang et al., 2025). On-policy                                                                                    且难以扩展（Lightmanet al.，2023；Zhang et al.，2025）。
[L310] distillation works (Agarwal et al., 2024; Xu et al., 2024a; Lu           The student policy observes only the problem statement,                同策略蒸馏有效（Agarwal 等，2024；Xu et al.，2024a；             学生策略 仅观察问题陈述，与推理时条件一致：
[L311] & Lab, 2025) address distribution shift by training on the               matching the inference-time condition:                                 Lu& Lab，2025）通过训练学生模型自身的样本来应对分
[L312] student’s own samples, but require a separate, often larger,
[L313]                                                                                               pS (· | x) ≜ pθ (· | x).                          布偏移，但需要一个独立的、通常更大的教师模型来提                                               pS (· | x) ≜ pθ (· | x).
[L314] teacher model to provide supervision. We instead seek a
[L315]                                                                                                                                                 供监督。我们转而寻求一种训练信号，它稠密，同策略，
[L316] training signal that is dense, on-policy, and does not require                                                                                                                                      两个策略共享相同参数 θ 但仅在条件上下文上不同。
[L317] external teachers or reward models. This motivates our
[L318]                                                                          Both policies share the same parameters θ but differ only              并且不需要外部教师或奖励模型。这促使我们提出同策
[L319] On-Policy Self-Distillation approach. We summarize the
[L320]                                                                          in their conditioning context. To encourage the teacher to
[L321]                                                                                                                                                 略自蒸馏方法。这些方法的差异总结于表1。                                为鼓励教师自然地评估学生模型的生成，我们在教师
[L322]                                                                          naturally evaluate the student’s generation, we add a prompt
[L323] differences of these methods in Table 1.                                                                                                                                                            看到参考解后添加一个提示，要求其生成新的解，如
[L324]                                                                          asking the teacher to generate a new solution after seeing
[L325]                                                                          the reference solution as shown in Figure 2. However, the                                                                  图 2。然而，教师并不生成词元，它只是通过预填充
[L326] 3.2. On-Policy Self-Distillation                                         teacher doesn’t generate tokens, it only does rationalization          3.2. 同策略自蒸馏                                         隐式地进行合理化。
[L327] Motivation: Learning by understanding solutions. We                      implicitly through prefilling.                                         动机：通过理解解答来学习。 我们提出一种不同的视
[L328] propose a different perspective inspired by how students                 On-policy sampling from the student. Given a problem                   角，其灵感来自学生如何学习：当学生遇到难题时，                             从学生模型进行同策略采样。 给定问题x，学生模型生
[L329] learn: when struggling with a problem, rather than extended              x, the student generates an on-policy response                         与其进行漫长的试错，不如查看解答、理解推理过程，                            成同策略响应
[L330] trial-and-error, a student can examine the solution, under-
[L331] stand the reasoning, and internalize the approach. Similarly,                                                                                   并将方法内化。类似地，如果一个模型能够获得正确
[L332]                                                                                          ŷ = (ŷ1 , . . . , ŷ|ŷ| ) ∼ pS (· | x).                                                                               ŷ = (ŷ1 , . . . , ŷ|ŷ| ) ∼ pS (· | x).
[L333] if a model has access to the correct answer or reasoning y ⋆                                                                                    答案或推理 y ⋆，并且具备足够的能力，它就可以合理
[L334] and is sufficiently capable, it can rationalize the reasoning            Both policies then evaluate this student-generated trajectory.         化推理步骤并自我教学——这类似于学生回顾解答并                             两个策略随后评估这条学生生成轨迹。在每个位置 n，它们
[L335] steps and teach itself—analogous to a student reviewing a                At each position n, they induce next-token distributions over                                                              在相同学生前缀条件下，诱导出在 yn ∈ V 上的 下一词元 分
[L336]                                                                                                                                                 追溯其为何有效。这一直觉启发了我们的框架：我们
[L337] solution and retracing why it works. This intuition motivates            yn ∈ V conditioned on the same student prefix:                                                                             布：
[L338] our framework: we exploit the ground-truth solution y ⋆ di-                                                                                     在训练期间直接将真实解 y ⋆ 作为特权信息加以利用，
[L339] rectly as privileged information during training, enabling the                    pS (yn | x, ŷ<n ) ,          pT (yn | x, y ⋆ , ŷ<n ) ,      使模型能够充当自己的教师，而无需外部奖励模型或                                    pS (yn | x, ŷ<n ) ,         pT (yn | x, y ⋆ , ŷ<n ) ,
[L340] model to serve as its own teacher without requiring external                                                                                    更大的教师模型。
[L341] reward models or larger teacher models.                                  where ŷ<n ≜ (ŷ1 , . . . , ŷn−1 ).                                                                                       其中 ˆy<n ≜ (ˆy1, . . . , ˆyn−1)。

[L343] Teacher and student policies. We instantiate two condi-                  Training objective: Full-vocabulary logit distillation.                教师与学生策略。 我们从同一语言模型 pθ 实例化两个                         训练目标：全词表 logit 蒸馏。我们实例化一个全词表散
[L344] tional distributions from the same language model pθ by                  We instantiate a full-vocabulary divergence objective that             条件分布，具体通过                                           度目标，该目标

[L346]                                                                      4                                                                                                                          4


[L348] <PARSED TEXT FOR PAGE: 5 / 16>

[L349]                                      On-Policy Self-Distillation for Large Language Models                                                                                            面向大语言模型的同策略自蒸馏

[L351] Algorithm 1 On-Policy Self-Distillation (OPSD)                                                                                                    算法 1 同策略自蒸馏（OPSD）
[L352] Require: Reasoning dataset S = {(xi , yi⋆ )}N    i=1 ; language model pθ ; divergence D (e.g., JSDβ )                                             要求：推理数据集 S = {(xi, yi⋆ )}N     i=1；语言模型 pθ；散度 D （例如，JSD ） 1：令 pS
                                                                                                                                                                                                         β
[L354]  1: Let pS (· | x) and pT (· | x, y ⋆ ) be the same model pθ under different conditioning.                                                        (· | x) 和 pT (· | x, y ) 为同一模型 pθ 在不同条件下。 2：当未收敛时执行3：采样一个小
                                                                                                                                                                        ⋆
[L356]  2: while not converged do
[L357]                                                                                                                                                   批量 B ⊂ S4：对于所有 (x, y ⋆) ∈ B 执行5：采样同策略响应 ˆy ∼ pS(· | x) 6：计算沿学
[L358]  3:    Sample a minibatch B ⊂ S
[L359]  4:    for all (x, y ⋆ ) ∈ B do                                                                                                                   生轨迹的逐 token 散度：
[L360]  5:        Sample on-policy response ŷ ∼ pS (· | x)
[L361]  6:        Compute the token-wise divergence along the student rollout:
[L362]                                                                         |ŷ|                                                                                                                                       |ŷ|
[L363]                                                            1 X                                                                                                                                    1 X
[L364]                         ℓ(x, y ⋆ ) ← D pT ∥ pS (ŷ | x) =          D pT (· | ŷ<n , x, y ⋆ ) pS (· | ŷ<n , x)                                                 ℓ(x, y ⋆ ) ← D pT ∥ pS (ŷ | x) =          D pT (· | ŷ<n , x, y ⋆ ) pS (· | ŷ<n , x)
[L365]                                                                                                                                                                                                                                                   
[L366]                                                           |ŷ| n=1                                                                                                                               |ŷ| n=1
                                                                                                                                                                          1
[L368]                                                                                                                                                    7：计算损失 LOPSD(θ) ← |B| (x,y⋆)∈B ℓ(x, y ⋆) 并更新 θ
                                                                                                                                                                            P
[L370]                                     1                             ⋆
                                           P
[L372]  7:     Calculate loss LOPSD (θ) ← |B|        (x,y ⋆ )∈B ℓ(x, y       ) and update θ


[L375] matches the teacher and student next-token distributions at                training signal to be dominated by stylistic patterns. To              匹配每个位置的教师与学生下一词元分布。给定学生                                              训练信号被风格模式所主导。为了解决这个问题，我
[L376] each position. Given a student-generated sequence ŷ, define               address this, we apply pointwise clipping to the vocabulary-           生成序列 ˆy，定义轨迹平均的词元级散度                                                 们对词汇表级散度贡献应用逐点裁剪。令 Df (pT ∥pS)
[L377] the trajectory-averaged, token-wise divergence                             level divergence contributions. Let Df (pT ∥pS ) denote an
[L378]                                                                                                                                                                                                                        表示一个f‑散度。在每个 token 位置 n 和词表条目
[L379]                                                                            f -divergence. At each token position n and vocabulary
[L380]                              |ŷ|                                         entry v, define:                                                                                   |ŷ|                                       v 处，定义：
[L381]                         1 X                                                                                                                                              1 X
[L382]                                   D pT (· | x, y ⋆ , ŷ<n )                                                                                                                        D pT (· | x, y ⋆ , ŷ<n )
[L383]                                                                                                                                                              
[L384]   D pT ∥ pS (ŷ | x) ≜                                                                                                                             D pT ∥ pS (ŷ | x) ≜
[L385]                        |ŷ| n=1                                                                              
[L386]                                                                                                                pS (v | ·)
[L387]                                                                                                                                                                        |ŷ| n=1                                                                                
[L388]                                                                                                                                                                                                                                                                     pS (v | ·)
                                                                                                                                                                                                                                                                                 
[L390]                                                             (6)                           (f )
[L391]                                                                                          ℓn,v = pT (v | ·) f                                                                                                 (6)                          ℓ(f )
[L392]                                                                                                                             .                                                                                                              n,v = pT (v | ·) f                        .
[L393]                                                                                                                pT (v | ·)                                                                                                                                           pT (v | ·)
[L394]                                                                                                                                                                                              
[L395]                             pS (· | x, ŷ<n ) ,                                                                                                                              pS (· | x, ŷ<n ) ,
[L396]                                                                            We compute the clipped divergence:                                                                                                          我们计算裁剪散度：
[L397] where pS (· | x, ŷ<n ) and pT (· | x, y ⋆ , ŷ<n ) denote dis-                                              |ŷ|                                 其中， pS(· | x, ˆy<n) 和 pT (· | x, y ⋆, ˆy<n) 表示在下                                                         |ŷ|
[L398]                                                                                                          1 XX                                                                                                                                           1 XX
[L399] tributions over the next token yn ∈ V. Here, D can be                                                                                             一词元 yn ∈ V 上的分布。这里， D 可以是任意分
[L400]                                                                                      (f )                                                                                                                                          (f )
[L401]                                                                                     Dclip (pT ∥pS ) =            min(ℓ(f )
[L402]                                                                                                                       n,v , τ ).                                                                                                Dclip (pT ∥pS ) =               min(ℓ(f )
[L403]                                                                                                                                                                                                                                                                      n,v , τ ).
[L404] any distribution divergence measure such as the generalized                                             |ŷ| n=1                                                                                                                                       |ŷ| n=1
[L405]                                                                                                                     v∈V                           布散度度量，例如广义詹森-香农散度 JSDβ，对于权                                                                                      v∈V
[L406] Jensen-Shannon divergence JSDβ , defined for a weight
[L407] β ∈ [0, 1] as:                                                                                                                                    重 β ∈ [0, 1] 定义为：
[L408]                                                                            Alternative objective: Sampled-token distillation                                                                                           备选目标：通过策略梯度的采样 token 蒸馏。 遵循
[L409]  JSDβ (pT ∥pS ) = βDKL (pT ∥m) + (1 − β)DKL (pS ∥m)                        through policy gradient. Following recent on-policy dis-               JSDβ (pT ∥pS ) = βDKL (pT ∥m) + (1 − β)DKL (pS ∥m)                   近期的同策略蒸馏方法（Lu & Lab，2025），我们构
[L410]                                                           (7)              tillation methods (Lu & Lab, 2025), we form a sampled-                                                                 (7)                  建采样 token 奖励信号（基于采样动作的反向KL信
[L411] where m = βpT + (1 − β)pS is the interpolated mixture dis-                 token reward signal (a reverse-KL signal on sampled ac-                其中， m = βpT +(1 − β)pS 是插值混合分布。这种全
[L412]                                                                                                                                                                                                                        号），并用策略梯度进行优化。对于每个位置n在一个
[L413] tribution. This full-vocabulary formulation provides dense,                tions) and optimize with policy gradient. For each position            词汇表表述提供了密集的词元级反馈：教师根据 y ⋆获
[L414] token-level feedback: the teacher, informed by y ⋆ , exposes               n in a sampled sequence ŷ, define the advantage term                                                                                       采样序列中 ˆy，定义优势项
[L415]                                                                                                                                                   得信息，使学生模型接触所有可能的下一词元上的完
[L416] the student to the entire distribution over plausible next to-
[L417] kens and guides it toward reasoning paths that lead to the                 An (x, ŷ) = log pT (ŷn | x, y ⋆ , ŷ<n )−log pS (ŷn | x, ŷ<n ) ,   整分布，并引导其走向通向正确答案的推理路径。                                               An (x, ŷ) = log pT (ŷn | x, y ⋆ , ŷ<n )−log pS (ŷn | x, ŷ<n ) ,
[L418] correct answer.                                                            and optimize the policy-gradient-style objective                                                                                            并优化策略梯度式目标
[L419] We minimize the expected divergence between teacher and                                                                 |ŷ|
[L420]                                                                                                                                                   我们在同策略学生样本上最小化教师与学生之间的期望                                                                                          |ŷ|
                                                                                                                                                  散度：
[L422]                                                                                                                                                                                                                                                          
[L423] student over on-policy student samples:                                                                            1 X                                                                                                                                         1 X
[L424]                                                                                L(θ) = −E(x,y⋆ )∼S Eŷ∼pS (·|x)               An (x, ŷ)                                                                                    L(θ) = −E(x,y⋆ )∼S Eŷ∼pS (·|x)               An (x, ŷ)
[L425]                                                                                                                   |ŷ| n=1                                                                                                                                    |ŷ| n=1
[L426]                                               
[L427]    L(θ) = E(x,y⋆ )∼S Eŷ∼pS (·|x) D pT ∥ pS (ŷ | x) .
                                                          
[L429]                                                                                                                                          (9)                                                   
[L430]                                                                                                                                                    L(θ) = E(x,y⋆ )∼S Eŷ∼pS (·|x) D pT ∥ pS (ŷ | x) .                                                                                 (9)
[L431]                                                              (8)                       × log pS (ŷn | x, ŷ<n ) .                                                                                     (8)                         × log pS (ŷn | x, ŷ<n ) .
[L432] Gradients are backpropagated only through the student pol-                                                                                        梯度仅通过学生策略 pS 反向传播，而教师 pT 则作
[L433] icy pS , while the teacher pT acts as a fixed full-distribution            An (x, ŷ) is treated as a constant with respect to θ (i.e.,           为以特权信息（x， y ⋆）为条件的固定全分布目标。                                           An（x，ˆy）相对于 θ 被视为常量（即梯度不会流经
[L434] target conditioned on privileged information (x, y ⋆ ).                    gradients do not flow through the advantage), so that gra-                                                                                  优势），因此梯度采用通常的策略梯度形式 An ∇θ
[L435]                                                                           

[L446] <PARSED TEXT FOR PAGE: 6 / 16>

[L447]                                                                                               On-Policy Self-Distillation for Large Language Models                                                                                                                                                                                                                                                  面向大语言模型的同策略自蒸馏

[L449]                                        AIME24                                                       AIME25                                                       HMMT25                                                      Average                                        Zero Reward Std Frac. of GRPO                                        AIME24                                                   AIME25                                                     HMMT25                                                   平均值                                       GRPO 的零奖励标准差比例
[L450]                                                                                    46                                                           32                                                                                                                    1.0                                                                                                                  46                                                       32                                                                                                            1.0
[L451]                       58                                                                                                                                                                                     42                                                                                                                   58                                                                                                                                                                            42
[L452] Avg@12 Accuracy (%)




[L457]                                                              Avg@12 Accuracy (%)




[L462]                                                                                                                           Avg@12 Accuracy (%)




[L467]                                                                                                                                                                                        Avg@12 Accuracy (%)




[L472]                                                                                                                                                                                                                                                                                                             Avg@12 Accuracy (%)




[L477]                                                                                                                                                                                                                                                                                                                                                                      Avg@12 Accuracy (%)




[L482]                                                                                                                                                                                                                                                                                                                                                                                                                               Avg@12 Accuracy (%)




[L487]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           Avg@12 Accuracy (%)
[L488]                                                                                    44                                                           30                                                                                                                                                                                                                                         44                                                       30




[L493]                                                                                                                                                                                                                                                 Fraction of Batches




[L498]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             Fraction of Batches
[L499]                       56                                                                                                                                                                                     41                                                       0.8                                                         56                                                                                                                                                                            41                                                0.8
[L500]                                                                                    42                                                                                                                                                                                                                                                                                                      42
[L501]                       54                                                                                                                        28                                                                                                                                                                                54                                                                                                                28
[L502]                                                                                    40                                                                                                                        40                                                       0.6                                                                                                                  40                                                                                                                   40                                                0.6
[L503]                       52                                                                                                                        26                                                                                                                                                                                52                                                                                                                26
[L504]                                                                                    38                                                                                                                        39                                                       0.4                                                                                                                  38                                                                                                                   39                                                0.4
[L505]                       50                                                           36                                                           24                                                           38                                                                                                                   50                                                       36                                                       24                                                          38
[L506]                                                                                                                                                                                                                                                                       0.2                                                                                                                                                                                                                                                                                         0.2
[L507]                       48                                                           34                                                           22                                                           37                                                                                                                   48                                                       34                                                       22                                                          37
[L508]                                                                                                                                                                                                                                                                       0.0                                                                                                                                                                                                                                                                                         0.0
[L509]                            0      25     50     75     100                              0      25     50     75     100                              0      25     50     75     100                              0          10        20                                   10 30 50 70 90                                             0    25      50    75   100                              0    25      50    75   100                              0      25     50      75   100                              0         10      20                               10 30 50 70 90
[L510]                                Gradient Update Steps                                        Gradient Update Steps                                        Gradient Update Steps                                        Tokens Generated (×106)                                Gradient Update Steps                                         梯度更新步数                                                   梯度更新步数                                                   梯度更新步数                                                      生成 token 数（×106）                               梯度更新步数

[L512]                                                                                                                                                      GRPO          OPSD                                                                                                                                                                                                                                                                                  GRPO           OPSD

[L514] Figure 3. Token Efficiency of OPSD. We compare OPSD and GRPO on Qwen3-1.7B under the same effective training batch size,                                                                                                                                                                                    图 3。 OPSD 的词元效率。 我们在相同有效训练批次大小下，比较 Qwen3‑1.7B 上的 OPSD 和 GRPO，并报告随训练步数和总生
[L515] reporting Avg@12 accuracy with training steps and total tokens generated. Generation is capped at 1024 tokens for OPSD and 16k for                                                                                                                                                                          成 token 数变化的 Avg@12 准确率。OPSD 的生成上限为 1024 个 token，GRPO 为 16k。在相同训练步数下，OPSD 使用的词元
[L516] GRPO. At the same number of training steps, OPSD uses significantly fewer tokens but outperforms GRPO on all benchmarks. Despite
[L517]                                                                                                                                                                                                                                                                                                             显著更少，但在所有基准上都优于 GRPO。尽管 GRPO 采样了更多词元，它只获得二元结果奖励，并因奖励多样性崩溃（最右侧图）
[L518] sampling more tokens, GRPO only receives a binary outcome reward, and stagnates due to reward diversity collapse (rightmost plot):
[L519] more than half of its batches have zero reward standard deviation within 100 steps, yielding no gradient signal. OPSD sidesteps this                                                                                                                                                                        而停滞：在 100 步内，其超过一半的批次奖励标准差为零，无法产生梯度信号。OPSD 即使生成 token 更少，也能通过从稠密蒸馏
[L520] disadvantage of outcome-based rewards by learning from a dense distillation loss even with fewer generated tokens.                                                                                                                                                                                          损失中学习，规避基于结果的奖励的这一劣势。


[L523] OPSD as dense-reward policy gradient and comparison                                                                                                               Baselines. We compare against two methods trained on the                                                                                  OPSD 作为稠密奖励策略梯度及其与 STaR 的比较。式                                                                                                                             基线。我们与在同一数据集上训练的两种方法进行比
[L524] to STaR. The objective in Equation (9) can be seen as pol-                                                                                                        same dataset: (1) SFT, standard supervised fine-tuning on                                                                                 （9）可视为具有稠密词元级奖励的策略梯度。在附录                                                                                                                                  较：（1）监督微调，即在专家轨迹上进行标准监督微
[L525] icy gradient with dense, token-level rewards. In Appendix                                                                                                         expert trajectories, which can be seen as off-policy distilla-                                                                            D 节，我们对此进行形式化，并与 STaR（Zelikman 等，                                                                                                                         调，这可视为来自生成推理轨迹的更强大 大语言模型
[L526] Section D, we formalize this and contrast with STaR (Ze-                                                                                                          tion from a more powerful LLM that generated the reasoning
[L527] likman et al., 2022), a closely related method that also uses                                                                                                     traces; (2) GRPO (Shao et al., 2024), group relative policy
[L528]                                                                                                                                                                                       

[L579] <PARSED TEXT FOR PAGE: 7 / 16>

[L580]                                       On-Policy Self-Distillation for Large Language Models                                                                          面向大语言模型的同策略自蒸馏

[L582] Table 2. Performance comparison on mathematical reasoning benchmarks for Qwen3 models. We report Avg@12 under the sampling               表 2。 Qwen3 模型在数学推理基准上的性能比较。我们按照 Qwen3 博客推荐的采样配置报告 Avg@12（温度 1.0，最大生成长度
[L583] configuration recommended in the Qwen3 blog (temperature 1.0, maximum generation length 38k); full details are provided in Table 10.     38k）；完整细节见表 10。对于 OPSD，我们每 20 步评估一次检查点，直到 100 步，并报告最佳分数。对于 GRPO，我们报告
[L584] For OPSD, we evaluate checkpoints every 20 steps up to 100 steps and report the best score. For GRPO, we report the peak performance
[L585]                                                                                                                                          500 个训练步数内的峰值性能，不过我们发现由于后续步骤中的熵坍缩，GRPO 在某些任务上的性能会下降。对于监督微调，我们
[L586] within 500 training steps, though we find GRPO performance to decrease for some tasks due to entropy collapse in later steps. For SFT,
[L587] we train on the same number of samples as OPSD. SFT performance degrades due to fine-tuning on concise reasoning solutions and           使用与 OPSD 相同数量的样本进行训练。监督微调的性能会因在简洁推理解答上微调而下降，并在测试时间缩短生成长度，而
[L588] reduces generation length at test time, whereas OPSD transforms them into dense learning signal through rationalization.                 OPSD 通过合理化将其转化为密集学习信号。

[L590]                           Method                  AIME24          AIME25         HMMT25          Average                                                  方法                 AIME24 AIME25 HMMT25 平均值
[L591]                           Qwen3-8B                                                                                                                        Qwen3-8B
[L592]                            Base (Instruct)           75.8             65.6          43.9           61.8                                                     Base（Instruct）    75.8       65.6        43.9         61.8
[L593]                                                                                                                                                             + 监督微调
[L594]                            + SFT                     72.3             64.2          42.9           59.8                                                                       72.3       64.2        42.9         59.8
[L595]                            + GRPO                    76.4             68.9          46.7           64.0                                                     + GRPO            76.4       68.9        46.7         64.0
[L596]                            + OPSD                    77.8             70.8          45.8           64.8                                                     + OPSD            77.8       70.8        45.8         64.8
[L597]                           Qwen3-4B                                                                                                                        Qwen3-4B
[L598]                            Base (Instruct)           74.9             66.4          42.2           61.2                                                     Base（Instruct）    74.9       66.4        42.2         61.2
[L599]                                                                                                                                                             + 监督微调
[L600]                            + SFT                     70.2             62.3          43.4           58.6                                                                       70.2       62.3        43.4         58.6
[L601]                            + GRPO                    75.6             68.1          44.4           62.7                                                     + GRPO            75.6       68.1        44.4         62.7
[L602]                            + OPSD                    76.4             68.3          46.1           63.6                                                     + OPSD            76.4       68.3        46.1         63.6
[L603]                           Qwen3-1.7B                                                                                                                      Qwen3-1.7B
[L604]                            Base (Instruct)           51.5             36.7          23.1           37.1                                                     Base（Instruct）    51.5       36.7        23.1         37.1
[L605]                                                                                                                                                             + 监督微调
[L606]                            + SFT                     48.4             36.3          22.7           35.8                                                                       48.4       36.3        22.7         35.8
[L607]                            + GRPO                    51.1             38.3          23.7           37.7                                                     + GRPO            51.1       38.3        23.7         37.7
[L608]                            + OPSD                    57.2             43.9          29.2           43.4                                                     + OPSD            57.2       43.9        29.2         43.4


[L611] esize that earlier tokens may contribute more to effective            JSD on AIME25 with Qwen3-1.7B in Table 3. All ob-                  我们假设，较早的词元可能对有效蒸馏贡献更大，因                         在 AIME25 上使用 Qwen3‑1.7B 的 JSD，见表 3。所
[L612] distillation as they could represent more critical branching          jectives are evaluated under the same pointwise clipping           为它们可能代表推理过程中更关键的分支点。                            有目标均在相同的逐点裁剪方案下进行评估以确保稳
[L613] points in the reasoning process.                                      scheme for stability. Forward KL consistently yields the
[L614]                                                                                                                                                                                          定性。前向 KL 始终带来最强增益，在第 50 步将性能
[L615]                                                                       strongest gains, improving performance from 36.7 to 43.9
[L616] As shown in Figure 3, OPSD achieves higher token learn-                                                                                  如图3所示，与 GRPO 相比，OPSD 在 100 个训练步                 从 36.7 提升至 43.9，并在第 100 步仍高于基线。相
[L617]                                                                       at step 50 and remaining above the baseline at step 100.
[L618] ing efficiency within 100 steps of training as compared to
[L619]                                                                       In contrast, reverse KL and JSD provide limited or nega-           内实现了更高的 token 学习效率。在 100 步内，当采                  比之下，反向 KL 和 JSD 带来的提升有限或为负。因
[L620] GRPO. Within 100 steps, GRPO’s performance stagnates
[L621]                                                                       tive improvements. We therefore adopt forward KL in all            样组内的结果奖励保持不变时，GRPO 的性能会因学                       此，我们在所有剩余实验中采用前向 KL。
[L622] with less learning signal when the outcome reward within as
[L623] sampling group remains the same, leading to zero gradient.
[L624]                                                                       remaining experiments.                                             习信号较少而停滞，导致零梯度。这些结果表明，
[L625] These results suggest that OPSD may extract learning signal           Table 3. Comparison of divergence objectives on AIME25 with        OPSD 可能比 GRPO 和 SFT 更高效地从相同的推理                  表 3. 在 AIME25 上使用 Qwen3‑1.7B 的散度目标比较。我
[L626] from the same reasoning datasets more efficiently than both           Qwen3-1.7B. We report Avg@12 at different training steps. For-     数据集中提取学习信号，同时大幅减少训练时间。                          们报告不同训练步数下的 Avg@12。前向 KL 相较基础模型
[L627] GRPO and SFT, while substantially reducing training time.             ward KL significantly improves performance over the base model,
[L628]                                                                       while reverse KL and JSD (β = 0.5) show limited or negative                                                        显著提升性能，而反向 KL 和 JSD (β = 0.5) 则表现出有限
[L629]                                                                                                                                                                                          或负面的增益。
[L630]                                                                                                                                          4.3. 消融实验与讨论
[L631]                                                                       gains.
[L632] 4.3. Ablation Studies & Discussions
[L633] In this section, we conduct extensive ablations to study                Method                         Base    Step 50    Step 100       在本节中，我们进行了大量消融实验，以研究 OPSD 中                       方法                       Base   第50步   第100步
[L634] key design choices in OPSD, including (1) the divergence                Forward KL (KL(pT ∥ pS ))      36.7      43.9       41.1         的关键设计选择，包括 (1) 散度目标，(2) 学生模型和教                    前向 KL (KL(pT ∥ pS))      36.7   43.9    41.1
[L635] objective, (2) the generation styles of the student and teacher         Reverse KL (KL(pS ∥ pT ))      36.7      37.5       35.0
[L636]                                                                                                                                          师的生成风格（例如，思考模式开/关），(3) 逐token                     反向 KL (KL(pS ∥ pT ))     36.7   37.5    35.0
[L637] (e.g., thinking-mode on/off), (3) the effect of per-token KL            JSD (β = 0.5)                  36.7      36.9       39.0                                                           JSD（β = 0.5）             36.7   36.9    39.0
[L638]                                                                                                                                          KL裁剪的效果，(4) 学生生成长度的影响，以及 (5) 全词
[L639] clipping, (4) the impact of student generation length, and (5)
[L640] comparison between full-vocabulary logit distillation with                                                                               表 logit 蒸馏与采样 token 蒸馏之间的比较。
[L641]                                                                       4.3.2. E FFECT OF G ENERATION S TYLES AND                                                                          4.3.2. 生成风格与逐token KL裁剪的影响
[L642] sampled-token distillation.
[L643]                                                                              PER - TOKEN KL C LIPPING

[L645] 4.3.1. E FFECT OF D IVERGENCE O BJECTIVE                              Another key design choice in OPSD is the generation style          4.3.1. 散度目标的影响                                  OPSD 中另一个关键设计选择是学生模型和教师模型的
[L646] A key design choice in OPSD is the divergence used for per-
[L647]                                                                       of the student and teacher models, as it determines both           OPSD 的一个关键设计选择是用于特权教师与学生模型之间                    生成风格，因为它既决定了学生模型从哪些词元中学习，
[L648] token distribution matching between the privileged teacher
[L649]                                                                       which tokens the student learns from and the style of super-
[L650]                                                                                                                                          逐 token 分布匹配的散度。我们比较了前向 KL、反向 KL                也决定了教师模型所提供监督的风格。Qwen3 模型支持
[L651]                                                                       vision provided by the teacher. Qwen3 models support two
[L652] and the student. We compare forward KL, reverse KL, and                                                                                  和                                               两种生成模式：思考模式开启 (TM‑on)，其中
[L653]                                                                       generation modes: Thinking Mode on (TM-on), in which

[L655]                                                                   7                                                                                                                  7


[L657] <PARSED TEXT FOR PAGE: 8 / 16>

[L658]                                                             On-Policy Self-Distillation for Large Language Models                                                                                                                                                         面向大语言模型的同策略自蒸馏

[L660] the model produces self-reflective chain-of-thought tokens,                                                    46
[L661]                                                                                                                         AIME25 (Qwen3-1.7B)                                         AIME24 (Qwen3-1.7B)            模型会生成自反思思维链词元，并且 思考模式关闭                                                                       46
[L662]                                                                                                                                                                                                                                                                                                                           AIME25（Qwen3‑1.7B）                                    AIME24（Qwen3‑1.7B）
[L663] and Thinking Mode off (TM-off), in which it generates re-                                                                                                                  60
[L664]                                                                                                                                                                                                                    (TM‑off)，其中模型直接生成响应。为了确定哪种组                                                                                                                         60




[L669]                                                                                          Avg@12 Accuracy (%)




[L674]                                                                                                                                                      Avg@12 Accuracy (%)




[L679]                                                                                                                                                                                                                                                                                            Avg@12 Accuracy (%)




[L684]                                                                                                                                                                                                                                                                                                                                                  Avg@12 Accuracy (%)
[L685]                                                                                                                44                                                                                                                                                                                                44
[L686] sponses directly. To determine which combination yields                                                                                                                    58                                                                                                                                                                                          58
[L687]                                                                                                                42                                                                                                  合能产生最有效的学习信号，我们分析前向 KL 散度                                                                     42
[L688] the most effective learning signal, we analyze the forward                                                                                                                 56                                                                                                                                                                                          56
[L689] KL divergence KL(pT ∥pS ) across all four student/teacher
                                                                                                               40
[L691]                                                                                                                                                                            54                                      KL(pT ∥pS) 在全部四种学生/教师模式配对中，将词元                                                                40
                                                                                                                                                                                                                                                                                                                                                                       54
[L693]                                                                                                                38                                                                                                                                                                                                38
[L694] mode pairings, categorizing tokens into three groups: math                                                                         Gen Length 4096
                                                                                                                                                                           52
[L696]                                                                                                                                                                                                Gen Length 4096     划分为三类： 数学(数字、运算符和数学关键词)， 风                                                                                                                          52
[L697]                                                                                                                36                                                                                                                                                                                                36                生成长度 4096                                             生成长度 4096
[L698] (numerals, operators, and mathematical keywords), style
                                                                                                               34
[L700]                                                                                                                                    Gen Length 1024                         50                  Gen Length 1024
[L701]                                                                                                                                                                                                                    格(推理连接词)，以及 其他. 表 7 报告了每个类别中                                                                  34
[L702]                                                                                                                                                                                                                                                                                                                                    生成长度 1024                           50                生成长度 1024

[L704] (reasoning connectives), and other. Table 7 reports the                                                             0      25     50     75      100                            0      25     50     75      100                                                                                                      0      25   50    75     100                          0      25   50    75     100
[L705]                                                                                                                          Gradient Update Steps                                       Gradient Update Steps         每个词元的平均 KL。                                                                                             梯度更新步数                                                梯度更新步数
[L706] mean per-token KL within each category.
[L707] Across all model sizes, the TM-off student paired with a                                 Figure 5. Effect of Generation Length on Qwen3-1.7B. We com-                                                              在所有模型规模上，与 TM‑on 教师配对的 TM‑off 学                                         图 5。 生成长度对 Qwen3‑1.7B 的影响。我们在 AI
[L708] TM-on teacher yields the largest KL on math tokens, in-                                  pare student generation length of 1024 vs 4096 on AIME25 and
[L709]                                                                                                                                                                                                                    生模型在数学词元上产生最大的 KL，表明对数学相关                                               ME25 和 AIME24 上比较了 1024 与 4096 的学生生成长度。
[L710]                                                                                          AIME24.
[L711] dicating stronger supervision on mathematically relevant
[L712]                                                                                                                                                                                                                    token 的监督更强。报告的 KL 值对应于每个位置上
[L713] tokens. The reported KL values correspond to the expected
[L714]                                                                                                                                                                                                                    词汇表上的期望散度；如表7，该期望高度偏斜，风格
[L715] divergence over the vocabulary at each position; as shown                                the amount of supervision signal available to the student.                                                                                                                                        学生模型可获得的监督信号量。更长的序列让学生模
[L716] in Table 7, this expectation is highly skewed, with stylistic                                                                                                                                                      词元贡献了不成比例的大值。这促使我们使用逐点裁
[L717]                                                                                          Longer sequences expose the student to more teacher feed-                                                                                                                                         型接触到更多教师反馈，但也会增加计算成本，并可
[L718] tokens contributing disproportionately large values. This                                back, but they also increase computational cost and may                                                                   剪来控制此类重尾贡献。从经验上看，该配置取得了
[L719] motivates our use of pointwise clipping to control such                                                                                                                                                                                                                                    能引入噪声或无信息续写。为研究这一权衡，我们在
[L720]                                                                                          introduce noisy or uninformative continuations. To study                                                                  最佳下游性能。因此，我们采用 TM‑off 学生 /
[L721] heavy-tailed contributions. Empirically, this configuration                              this trade-off, we conduct an ablation on Qwen3-1.7B by                                                                                                                                           Qwen3‑1.7B 上进行消融实验，将同策略采样的学生
[L722]                                                                                                                                                                                                                    TM‑on 教师配置。
[L723] achieves the best downstream performance. We therefore                                   varying the generation length of on-policy sampled stu-                                                                                                                                           模型回答的生成长度在 1024 与 4096 个词元之间变化，
[L724] adopt the TM-off student / TM-on teacher configuration.                                  dent responses among 1024 and 4096 tokens and use full-                                                                                                                                           并使用全词汇表 logit 蒸馏。如图 5，增加生成长度在
[L725]                                                                                          vocabulary logit distillation. As shown in Figure 5, in-
[L726]                                                                                                                                                                                                                                                                                            任一任务上都未带来一致的提升。我们将此归因于早
[L727]    Avg@12 AIME24 Accuracy (%)




[L732]                                                                                                                                                                                                                      Avg@12 AIME24 Accuracy (%)
[L733]                                 58       w/o per-token KL Clipping                       creasing the generation length does not lead to consistent
[L734]                                                                                                                                                                                                                                                   58       无逐token KL裁剪                    期 token 对学习更为关键：随着学生模型生成长度增
[L735]                                          w/ per-token KL Clipping                        improvements across either task. We attribute this to early                                                                                                       有逐token KL裁剪
[L736]                                 56                                                       tokens being more critical for learning: as the student gen-                                                                                             56                                       加，在给定足够长的学生前缀条件下，后期 token 对
[L737]                                                                                          eration grows longer, later tokens become increasingly pre-                                                                                                                                       教师模型而言变得越来越可预测，因此对后期 t
[L738]                                 54                                                       dictable to the teacher when conditioned on a sufficiently                                                                                               54                                       oken 施加的惩罚更少。这一现象也在（Lu &Lab，
[L739]                                                                                          long student prefix so less penalties are applied to later to-
[L740]                                 52                                                       kens. This phenomenon is also noted in (Lu & Lab, 2025).                                                                                                 52                                       2025）。

[L742]                                 50                                                       4.3.5. L EARNING O BJECTIVE C OMPARISON : F ULL                                                                                                          50                                       4.3.5. 学习目标比较：完整词汇表 logits 蒸馏 vs. 采样
[L743]                                                                                                 VOCABULARY L OGITS D ISTILLATION VS .                                                                                                                                                      token 蒸馏
[L744]                                 48                                                              S AMPLED -T OKEN D ISTILLATION                                                                                                                

[L784] <PARSED TEXT FOR PAGE: 9 / 16>

[L785]                                       On-Policy Self-Distillation for Large Language Models                                                                               面向大语言模型的同策略自蒸馏

[L787] Table 4. Ablation on divergence computation strategies for OPSD on Qwen3-4B with 2048 generation length for distillation. We report       表 4. 在 Qwen3‑4B 上使用 2048 生成长度进行蒸馏时，针对 OPSD 的散度计算策略消融实验。我们报告在 AIME25 和 HMMT25 上的
[L788] pass@8 accuracy on AIME25 and HMMT25. Full-distribution objectives (logit distillation) outperform sampled-token objectives.              pass@8 准确率。全分布目标（logit 蒸馏）优于采样 token 目标。

[L790]                 Method Variant                                                               AIME25       HMMT25                                        方法变体                                                             AIME25 HMMT25

[L792]                 OPSD w/ Full-vocabulary logit distillation (Agarwal et al., 2024)               84.1          60.0                                      OPSD 采用全词表 logit 蒸馏（Agarwal 等，2024）                                84.1         60.0
[L793]                 OPSD w/ Sampled-token distillation (Lu & Lab, 2025)                             82.1          57.3                                      OPSD 采用采样 token 蒸馏（Lu &Lab，2025）                                   82.1         57.3


[L796] richer supervision than relying solely on per-token on-policy           Xiaomi, 2026; Yang et al., 2025). These approaches miti-          相比仅依赖逐 token 的同策略塑造，这能提供更丰富                                小米，2026； Yang 等， 2025）。这些方法通过在学
[L797] shaping. However, the full-vocabulary computation incurs                gate distribution shift by optimizing directly on the student’s   的监督。然而，全词表计算会因在每个位置存储词汇                                    生模型的访问分布上直接优化来缓解分布偏移，但它
[L798] higher peak memory usage due to storing vocabulary-sized                visitation distribution, but they typically rely on a distinct
[L799]                                                                                                                                           表大小的 logits 而带来更高的峰值内存占用，这表明                               们通常依赖于一个独立且往往更大的教师模型。在本
[L800] logits at every position, indicating a trade-off between per-           and often larger teacher model. In this work, we explore
[L801] formance and efficiency.                                                whether an LLM can teach itself by conditioning on more           性能与效率之间存在权衡。                                               工作中，我们探索大语言模型能否通过以更多特权答
[L802]                                                                         privileged answer information and leveraging its own rea-                                                                    案信息为条件，并利用自身的推理能力来引导一个更
[L803] 5. Related Work                                                         soning capability to guide a weaker version of itself toward      5. 相关工作                                                    弱的自身版本走向更好的推理，从而实现自我教学。
[L804]                                                                         improved reasoning. On-policy training paradigms are also
[L805]                                                                                                                                                                                                      同策略训练范式也被广泛用于机器人学和深度强化学
[L806] LLM Self-Training. Our work connects to a line of re-                   widely used in robotics and deep reinforcement learning,          LLM 自训练。我们的工作与一系列研究相关，这些研究
[L807] search showing that LLMs can improve by generating and                  such as DAgger (Ross et al., 2011), where a human teacher         表明，大语言模型可以通过生成并利用自身的监督信号
[L808]                                                                                                                                                                                                      习，例如 DAgger（Ross 等， 2011），其中人类教
[L809] exploiting their own supervision signals (Allen-Zhu & Li,               provides corrective supervision on the states visited by the      来获得提升（Allen‑Zhu & Li, 2020; Xu et al., 2024                师对学生策略所访问的状态提供纠正性监督。
[L810] 2020; Xu et al., 2024b; Chen et al., 2024; Wang et al., 2023;           student policy.
[L811]                                                                                                                                           b; Chen et al., 2024; Wang et al., 2023; Sun et al.,
[L812] Sun et al., 2023; Yuan et al., 2024; Yang et al., 2024). Clos-                                                                                                                                       通过监督微调和强化学习提升大语言模型推理能力。监督微
[L813] est in spirit is context distillation (Snell et al., 2022), which
[L814]                                                                         Improving LLM Reasoning through SFT and RL. SFT                   2023; Yuan et al., 2024; Yang et al., 2024）。在思想
[L815]                                                                         and RL are two primary methods for improving LLM rea-             上最接近的是上下文蒸馏（Snell et al., 2022），它通                         调和强化学习是提升大语言模型推理能力的两种主要方法。
[L816] uses the same underlying model as both teacher and student
[L817]                                                                         soning ability. SFT on high-quality reasoning traces has                                                                     在高质量推理轨迹上进行监督微调已展现出强劲性能（Yu
[L818] by providing the teacher with privileged context and then                                                                                 过为教师提供特权上下文，然后在不提供上下文的情况
[L819]                                                                         demonstrated strong performance (Yu et al., 2023; LI et al.,                                                                 et al., 2023; LI et al., 2024; Paster et al., 2023; Team,
[L820] SFT the student on the teacher’s generated outputs without
[L821]                                                                         2024; Paster et al., 2023; Team, 2025a; Ye et al., 2025;          下，对学生模型在教师生成的输出上进行监督微调，从
[L822] context. This can be viewed as off-policy, where the learn-                                                                                                                                          2025a; Ye et al., 2025; Muennighoff et al., 2025; Z
[L823]                                                                         Muennighoff et al., 2025; Zhou et al., 2023). However,            而将同一个底层模型同时用作教师与学生。这可以视为
[L824] ing signal is a discrete token sequence. In the reasoning                                                                                                                                            hou et al., 2023）。然而，已有工作表明，监督微调可能
[L825]                                                                         prior work shows that SFT can rely on memorization rather         异策略，其中学习信号是离散 token 序列。在推理领域，
[L826] domain, ReST (Gulcehre et al., 2023) and STaR (Zelik-                                                                                                                                                依赖记忆而非稳健泛化（Chu et al., 2025）。相比之下，
[L827]                                                                         than robust generalization (Chu et al., 2025). In contrast,       ReST（Gulcehre et al., 2023）和 STaR（Zelikman
[L828] man et al., 2022) similarly rely on iterative self-training
[L829]                                                                         RL optimizes directly for outcome-based objectives can ex-                                                                   强化学习直接针对基于结果的目标进行优化，能够表现出更
[L830] loops—generate rationales conditioned on hints or answers,                                                                                et al., 2022）同样依赖迭代自训练循环——根据提示或                            好的泛化能力（Huan et al., 2025）。诸如 GRPO（Guo
[L831]                                                                         hibit better generalization (Huan et al., 2025). More recent
[L832] filter by rewards or ground-truth answers, and fine-tune
[L833]                                                                         algorithms such as GRPO (Guo et al., 2025; Shao et al.,           答案生成推理过程，依据奖励或真实答案进行筛选，并                                   et al., 2025; Shao et al., 2024）等较新的算法通过从组级
[L834] on successful trajectories—again yielding hard distillation;                                                                              在成功轨迹上微调——这同样产生硬蒸馏；Mitra &
[L835] Mitra & Ulukus (2025) extends this to soft distillation. In-
[L836]                                                                         2024) enable scalable RL by estimating advantages from                                                                       奖励中估计优势来实现可扩展的强化学习，而无需像 PPO
[L837]                                                                         group-level rewards without requiring an explicit critic as in    Ulukus（2025）将其扩展到软蒸馏。上下文内编辑（                               （Schulman et al., 2017）那样依赖显式评论家。在这一
[L838] context editing (Qi et al., 2025) does on-policy sample from
[L839] student and shows that context-induced knowledge can be
[L840]                                                                         PPO (Schulman et al., 2017). Building on this line of work,       Qi et al., 2025）从学生模型进行同策略采样，并表明通                          研究方向的基础上，越来越多的研究强调了 RLVR 在推理
[L841]                                                                         a growing body of research highlights the effectiveness of
[L842] internalized via soft distillation by minimizing divergences                                                                              过最小化散度，上下文诱导知识可以通过软蒸馏被内化，                                  任务中的有效性（Yu et al., 2025; Liu et al., 2025; Yue
[L843]                                                                         RLVR for reasoning tasks (Yu et al., 2025; Liu et al., 2025;
[L844] and demonstrates this in knowledge editing settings. OPSD
[L845]                                                                         Yue et al., 2025; An et al., 2025; Zheng et al., 2025).           同时在知识编辑设置中展示了这一点。OPSD 与这些方                                 et al., 2025; An et al., 2025; Zheng et al., 2025）。
[L846] differs from these approaches in that we perform on-policy,                                                                               法的不同之处在于，我们针对推理任务在学生自身轨迹
[L847] soft distillation on the student’s own rollouts for reasoning
[L848]                                                                         6. Conclusion                                                     上执行同策略软蒸馏：教师的监督是逐 token 分布匹配，                              6. 结论
[L849] tasks: the teacher’s supervision is per-token distribution
[L850] matching rather than generating a rationale for SFT. OPSD                                                                                 而不是生成用于监督微调的推理过程。OPSD 将推理能
[L851]                                                                         We introduced On-Policy Self-Distillation (OPSD), a sim-          力的提升视为学习一种由数据集的真实解和模型自身推                                   我们提出了同策略自蒸馏（OPSD），一个简单而有
[L852] frames reasoning improvement as learning a conditional
[L853] distribution induced jointly by the dataset’s ground-truth so-
[L854]                                                                         ple yet effective framework for post-training large language
[L855]                                                                                                                                           理能力共同诱导的条件分布。与此同时，SDPO（H¨                                  效的框架，用于在推理任务上后训练大语言模型。
[L856]                                                                         models on reasoning tasks. The intuition behind OPSD is
[L857] lutions and the model’s own reasoning ability. Concurrently,                                                                              ubotter et al., 2026）探索了以环境反馈作为特权信息                        OPSD 背后的直觉是：一个能力足够强的推理大语言
[L858]                                                                         that a sufficiently capable reasoning LLM can teach itself
[L859] SDPO (Hübotter et al., 2026) explored similar algorithm
[L860]                                                                         when it has access to privileged information about the an-        的类似算法，SDFT（Shenfeld et al., 2026）则探索了                      模型在能够获得关于某个推理问题答案的特权信息时，
[L861] with environment feedbacks as privilledged information
[L862]                                                                         swer to a reasoning problem, utilizing its own rationalization    持续学习任务上的同策略自蒸馏。                                            可以借助自身的合理化能力，为无法获得真实答案的
[L863] and SDFT (Shenfeld et al., 2026) explored on-policy self-
[L864] distillation on continual learning tasks.
[L865]                                                                         ability to grade its weaker self without access to the ground                                                                较弱自我评分，从而实现自我教导。我们通过实验证
[L866]                                                                         truth. We experimentally demonstrated that OPSD achieves
[L867]                                                                                                                                                                                                      明，OPSD 的性能优于离策略蒸馏/监督微调，与
[L868] On-Policy Distillation methods train a student model di-                better performance than off-policy distillation/SFT, and per-     同策略蒸馏 方法直接在从其自身策略采样得到的轨迹
[L869]                                                                                                                                                                                                      GRPO 持平或更优，同时样本效率显著优于 GRPO。
[L870] rectly on trajectories sampled from its own policy, while               forms on par with or better than GRPO, while exhibiting           上训练学生模型，而教师模型通过基于 KL 的正则化
[L871] a teacher model provides per-token guidance through KL-                 significantly better sample efficiency than GRPO.
[L872]                                                                                                                                           或相关目标提供逐词元指导（Agarwal 等，2024；
[L873] based regularization or related objectives (Agarwal et al.,
[L874] 2024; Xu et al., 2024a; Gu et al., 2024; Lu & Lab, 2025;                                                                                  Xu et al.， 2024a；Gu 等， 2024； Lu & Lab， 2025；


[L877]                                                                     9                                                                                                                            9


[L879] <PARSED TEXT FOR PAGE: 10 / 16>

[L880]                                    On-Policy Self-Distillation for Large Language Models                                                                                   面向大语言模型的同策略自蒸馏

[L882] Impact Statement                                                      A., Chang, K.-W., Shankar, V., Gokaslan, A., Merrill,           影响声明                                                                    A., Chang, K.‑W., Shankar, V., Gokaslan, A., Merrill,
[L883]                                                                       M. A., Hashimoto, T., Choi, Y., Jitsev, J., Heckel, R.,                                                                                 M. A., Hashimoto, T., Choi, Y., Jitsev, J., Heckel, R.,
[L884] This paper presents work whose goal is to advance the field           Sathiamoorthy, M., Dimakis, A. G., and Schmidt, L.              本文介绍的工作旨在推动机器学习领域的发展。我们                                                 Sathiamoorthy, M., Dimakis, A. G. 和 Schmidt, L.
[L885] of machine learning. Our method improves the efficiency               Openthoughts: Data recipes for reasoning models, 2025.          的方法提高了针对推理任务训练语言模型的效率，与                                                 OpenThoughts：推理模型数据配方，2025。URL
[L886] of training language models for reasoning tasks, reducing             URL https://arxiv.org/abs/2506.04178.                           现有强化学习方法相比降低了计算成本。我们没有预                                                 https://arxiv.org/abs/2506.04178。
[L887] computational costs compared to existing reinforcement
[L888] learning approaches. We do not foresee specific negative            Gulcehre, C., Paine, T. L., Srinivasan, S., Konyushkova,          见到具体的负面社会后果。                                                        Gulcehre, C., Paine, T. L., Srinivasan, S., Konyushkova,
[L889] societal consequences.                                                K., Weerts, L., Sharma, A., Siddhant, A., Ahern, A.,                                                                                K., Weerts, L., Sharma, A., Siddhant, A., Ahern, A.,
[L890]                                                                      Wang, M., Gu, C., et al. Reinforced self-training (rest)                                                                             Wang, M., Gu, C., 等. 用于语言建模的强化自训练（ReST）。
[L891]                                                                       for language modeling. arXiv preprint arXiv:2308.08998,                                                                             arXiv 预印本 arXiv:2308.08998，2023。
[L892] Acknowledgements
[L893]                                                                       2023.                                                           致谢
[L894] AG was supported by NSF CAREER Grant # 2341040 and                                                                                    AG 获得了 NSF CAREER Grant # 2341040 和
[L895]                                                                     Guo, D., Yang, D., Zhang, H., Song, J., Zhang, R., Xu, R.,                                                                            Guo, D., Yang, D., Zhang, H., Song, J., Zhang, R., Xu,
[L896] a Schmidt AI 2050 Fellowship.                                                                                                         Schmidt AI2050 Fellowship 的支持。
[L897]                                                                       Zhu, Q., Ma, S., Wang, P., Bi, X., et al. Deepseek-r1: In-                                                                          R., Zhu, Q., Ma, S., Wang, P., Bi, X., 等. DeepSeek‑R1：通
[L898]                                                                       centivizing reasoning capability in llms via reinforcement                                                                          过强化学习激励大语言模型的推理能力。arXiv 预印本
[L899] References                                                            learning. arXiv preprint arXiv:2501.12948, 2025.                参考文献                                                                arXiv:2501.12948，2025。
[L900] Agarwal, R., Vieillard, N., Zhou, Y., Stanczyk, P., Garea,                                                                            Agarwal, R., Vieillard, N., Zhou, Y., Stanczyk,
[L901]                                                                     Hinton, G., Vinyals, O., and Dean, J. Distilling the                                                                                  Hinton, G.、Vinyals, O. 和 Dean, J. 将知识蒸馏到神经网络
[L902]   S. R., Geist, M., and Bachem, O. On-policy distillation
[L903]                                                                       knowledge in a neural network, 2015. URL https:                 P., Garea, S. R., Geist, M., and Bachem, O. 语言                      中，2015。网址 https://arxiv.org/abs/1503.02531。
[L904]   of language models: Learning from self-generated mis-
[L905]                                                                       //arxiv.org/abs/1503.02531.                                     模型的同策略蒸馏：从自生成的错误中学习。载于 第
[L906]   takes. In The twelfth international conference on learning
[L907]                                                                                                                                       十二届国际学习表征会议，2024。
[L908]   representations, 2024.                                            Hu, E. J., Shen, Y., Wallis, P., Allen-Zhu, Z., Li, Y., Wang,                                                                         Hu, E. J.、Shen, Y.、Wallis, P.、Allen‑Zhu, Z.、Li,
[L909] Allen-Zhu, Z. and Li, Y. Towards understanding ensem-                 S., Wang, L., and Chen, W. LoRA: Low-rank adaptation            Allen‑Zhu, Z. 和 Li, Y. 理解深度学习中的集成、知                                 Y.、Wang, S.、Wang, L. 和 Chen, W. LoRA：大语言模
[L910]                                                                       of large language models. In International Conference                                                                               型的低秩适应。载于 国际学习表征会议，2022。网址
[L911]   ble, knowledge distillation and self-distillation in deep                                                                           识蒸馏和自蒸馏。载于第十一届国际学习表征会议，
[L912]   learning. In The Eleventh International Conference on               on Learning Representations, 2022. URL https://                                                                                     https://openreview.net/forum?id=
[L913]                                                                       openreview.net/forum?id=nZeVKeeFYf9.                            2020。                                                               nZeVKeeFYf9。
[L914]   Learning Representations, 2020.
[L915] An, C., Xie, Z., Li, X., Li, L., Zhang, J., Gong, S., Zhong,        Huan, M., Li, Y., Zheng, T., Xu, X., Kim, S., Du, M.,             An, C., Xie, Z., Li, X., Li, L., Zhang, J., Gong, S., Zhong,        Huan, M.、Li, Y.、Zheng, T.、Xu, X.、Kim, S.、Du,
[L916]   M., Xu, J., Qiu, X., Wang, M., and Kong, L. Polaris: A              Poovendran, R., Neubig, G., and Yue, X. Does math               M., Xu, J., Qiu, X., Wang, M. 和 Kong, L. Polaris：一种用                M.、Poovendran, R.、Neubig, G. 和 Yue, X. 数学推理
[L917]   post-training recipe for scaling reinforcement learning             reasoning improve general llm capabilities? understand-         于在高级推理模型上扩展强化学习的后训练方案，2025。网址                                       能提升大语言模型的通用能力吗？理解大语言模型推理的可
[L918]   on advanced reasoning models, 2025. URL https:                      ing transferability of llm reasoning. arXiv preprint            https://hkunlp.github.io/blog/2025/Polaris.                         迁移性。arXiv 预印本 arXiv:2507.00432，2025。
[L919]  //hkunlp.github.io/blog/2025/Polaris.                                arXiv:2507.00432, 2025.

[L921] Chen, Z., Deng, Y., Yuan, H., Ji, K., and Gu, Q. Self-play          Hübotter, J., Lübeck, F., Behric, L., Baumann, A., Bagatella,   Chen, Z., Deng, Y., Yuan, H., Ji, K. 和 Gu, Q. 自博                    H¨ubotter, J., L¨ubeck, F., Behric, L., Baumann, A.,
[L922]                                                                       M., Marta, D., Hakimi, I., Shenfeld, I., Kleine Buening,                                                                            Bagatella, M., Marta, D., Hakimi, I., Shenfeld, I.,
[L923]   fine-tuning converts weak language models to strong lan-                                                                            弈微调将弱语言模型转化为强语言模型。载于国际机
[L924]   guage models. In International Conference on Machine                T., Guestrin, C., and Krause, A. Reinforcement learning                                                                             Kleine Buening, T., Guestrin, C. 和 Krause, A. 通过自蒸馏
[L925]                                                                       via self-distillation. arXiv preprint arXiv:2601.20802,         器学习大会，第 6621–6642 页。PMLR，2024。                                      进行强化学习。arXiv 预印本 arXiv:2601.20802，2026。
[L926]   Learning, pp. 6621–6642. PMLR, 2024.
                                                                      2026.
[L928] Chu, T., Zhai, Y., Yang, J., Tong, S., Xie, S., Schuurmans,                                                                           Chu, T., Zhai, Y., Yang, J., Tong, S., Xie, S.,
[L929]   D., Le, Q. V., Levine, S., and Ma, Y. Sft memorizes, rl           Kim, Y. and Rush, A. M. Sequence-level knowledge distilla-        Schuurmans, D., Le, Q. V., Levine, S. 和 Ma, Y. 监督微调                 Kim, Y. 和 Rush, A. M. 序列级知识蒸馏。载于
[L930]   generalizes: A comparative study of foundation model                tion. In Proceedings of the 2016 conference on empirical        记忆，强化学习泛化：基础模型后训练的比较研究。arXiv预印                                      2016年自然语言处理经验方法会议论文集，第1317–
[L931]                                                                       methods in natural language processing, pp. 1317–1327,          本 arXiv:2501.17161，2025。
[L932]   post-training. arXiv preprint arXiv:2501.17161, 2025.                                                                                                                                                   1327页，2016。
                                                                      2016.
[L934] Gu, Y., Dong, L., Wei, F., and Huang, M. MiniLLM: Knowl-                                                                              Gu, Y., Dong, L., Wei, F., and Huang, M. MiniLLM：
[L935]                                                                                                                                                                                                           Li, J., Beeching, E., Tunstall, L., Lipkin, B., Soletskyi, R., Huang, S. C., Rasul, K., Yu, L., Jiang,
[L936]   edge distillation of large language models. In The Twelfth        LI, J., Beeching, E., Tunstall, L., Lipkin, B., Soletskyi,        大语言模型的知识蒸馏。载于 第十二届国际学习表征会议，                                         A., Shen, Z., Qin, Z., Dong, B., Zhou, L., Fleureau, Y., Lample, G. 和 Polu, S. Numinamath.

[L938]   International Conference on Learning Representations,               R., Huang, S. C., Rasul, K., Yu, L., Jiang, A., Shen, Z.,       2024。URLhttps://openreview.net/forum?id=5
[L939]                                                                                                                                                                                                           https://github.com/project-numina/aimo-progress-prize/blob/main/report/numina_
[L940]                                                                                                                                                                                                           dataset.pdf，2024。

[L942]   2024. URL https://openreview.net/forum?                             Qin, Z., Dong, B., Zhou, L., Fleureau, Y., Lample, G.,          h0qf7IBZZ。
[L943]   id=5h0qf7IBZZ.                                                      and Polu, S. Numinamath. https://github.com/
[L944]                                                                       project-numina/aimo-progress-prize/
[L945] Guha, E., Marten, R., Keh, S., Raoof, N., Smyrnis, G.,                                                                                Guha, E., Marten, R., Keh, S., Raoof, N., Smyrnis, G.,
[L946]                                                                       blob/main/report/numina_dataset.pdf,
[L947]   Bansal, H., Nezhurina, M., Mercat, J., Vu, T., Sprague,                                                                             Bansal, H., Nezhurina, M., Mercat, J., Vu, T., Sprague, Z.,
                                                                      2024.
[L949]   Z., Suvarna, A., Feuer, B., Chen, L., Khan, Z., Frankel,                                                                            Suvarna, A., Feuer, B., Chen, L., Khan, Z., Frankel, E.,
[L950]   E., Grover, S., Choi, C., Muennighoff, N., Su, S., Zhao,          Lightman, H., Kosaraju, V., Burda, Y., Edwards, H., Baker,        Grover, S., Choi, C., Muennighoff, N., Su, S., Zhao, W.,            Lightman, H., Kosaraju, V., Burda, Y., Edwards,
[L951]  W., Yang, J., Pimpalgaonkar, S., Sharma, K., Ji, C. C.-J.,           B., Lee, T., Leike, J., Schulman, J., Sutskever, I., and        Yang, J., Pimpalgaonkar, S., Sharma, K., Ji, C.C.‑J., Deng,         H., Baker, B., Lee, T., Leike, J., Schulman, J.,
[L952]                                                                                                                                       Y., Pratt, S., Ramanujan, V., Saad‑Falcon, J., Li, J., Dave,
[L953]   Deng, Y., Pratt, S., Ramanujan, V., Saad-Falcon, J., Li,            Cobbe, K. Let’s verify step by step. In The Twelfth                                                                                 Sutskever, I., and Cobbe, K. 让我们逐步验证。载于
[L954]  J., Dave, A., Albalak, A., Arora, K., Wulfe, B., Hegde,              International Conference on Learning Representations,           A., Albalak, A., Arora, K., Wulfe, B., Hegde, C., Durrett,
[L955]                                                                                                                                       G., Oh, S., Bansal, M., Gabriel, S., Grover,                        第十二届国际学习表征会议，2023。
[L956]   C., Durrett, G., Oh, S., Bansal, M., Gabriel, S., Grover,           2023.

[L958]                                                                10                                                                                                                                    10


[L960] <PARSED TEXT FOR PAGE: 11 / 16>

[L961]                                      On-Policy Self-Distillation for Large Language Models                                                                                  面向大语言模型的同策略自蒸馏

[L963] Liu, Z., Chen, C., Li, W., Qi, P., Pang, T., Du, C., Lee,              Shenfeld, I., Damani, M., Hübotter, J., and Agrawal, P.         Liu, Z., Chen, C., Li, W., Qi, P., Pang, T., Du, C.,              Shenfeld, I.、Damani, M.、H¨ubotter, J. 和 Agrawal, P.
[L964]   W. S., and Lin, M. Understanding r1-zero-like training:                Self-distillation enables continual learning, 2026. URL        Lee, W. S., and Lin, M. 理解 R1‑Zero 式训练：批判性                        自蒸馏实现持续学习，2026。
[L965]   A critical perspective. arXiv preprint arXiv:2503.20783,               https://arxiv.org/abs/2601.19897.                              视角。arXiv 预印本 arXiv:2503.20783，2025。                               URLhttps://arxiv.org/abs/2601.19897。
  2025.
[L967]                                                                        Snell, C., Klein, D., and Zhong, R. Learning by distilling                                                                         Snell, C.、Klein, D. 和 Zhong, R. 通过蒸馏上下文学
[L968] Loshchilov, I. and Hutter, F. Decoupled weight decay regu-               context. arXiv preprint arXiv:2209.15189, 2022.                Loshchilov, I. 和 Hutter, F. 解耦权重衰减正则化。                            习。arXiv 预印本 arXiv:2209.15189，2022。
[L969]   larization. arXiv preprint arXiv:1711.05101, 2017.                                                                                    arXiv 预印本 arXiv:1711.05101，2017。
[L970]                                                                        Sun, Z., Shen, Y., Zhou, Q., Zhang, H., Chen, Z., Cox, D.,                                                                         Sun, Z.、Shen, Y.、Zhou, Q.、Zhang, H.、Chen, Z.、
[L971] Lu, K. and Lab, T. M. On-policy distillation. Thinking                                                                                  Lu, K. 和 Lab, T. M. 同策略蒸馏。Thinking Machines Lab：连
[L972]                                                                          Yang, Y., and Gan, C. Principle-driven self-alignment                                                                            Cox, D.、Yang, Y. 和 Gan, C. 在最少人工监督下从零开始
[L973]   Machines Lab: Connectionism, 2025. doi: 10.64434/tml.                                                                                 接主义，2025。doi: 10.64434/tml. 20251026.
[L974]                                                                          of language models from scratch with minimal human                                                                               实现语言模型的原则驱动的自对齐。载于第三十七届神经信
[L975]   20251026. https://thinkingmachines.ai/blog/on-policy-                                                                                 https://thinkingmachines.ai/blog/on‑policy‑ distillation.
[L976]                                                                          supervision. In Thirty-seventh Conference on Neural                                                                              息处理系统大会，2023。网址
[L977]   distillation.                                                          Information Processing Systems, 2023. URL https:                                                                                 https://openreview.net/forum?id=p40XRfBX96。
[L978] Mitra, P. and Ulukus, S. Semantic soft bootstrapping: Long               //openreview.net/forum?id=p40XRfBX96.                          Mitra, P. 和 Ulukus, S. 语义软自举：无需强化学习的大语
[L979]  context reasoning in llms without reinforcement learning.                                                                              言模型长上下文推理。arXiv 预印本 arXiv:2512.05105，                             Sun, Z.、Yu, L.、Shen, Y.、Liu, W.、Yang, Y.、
[L980]                                                                        Sun, Z., Yu, L., Shen, Y., Liu, W., Yang, Y., Welleck, S.,
[L981]  arXiv preprint arXiv:2512.05105, 2025.
[L982]                                                                          and Gan, C. Easy-to-hard generalization: Scalable align-       2025。                                                             Welleck, S. 和 Gan, C. 由易到难泛化：超越人工监督的可扩
[L983] Muennighoff, N., Yang, Z., Shi, W., Li, X. L., Fei-Fei, L.,              ment beyond human supervision. Advances in Neural              Muennighoff, N.、Yang, Z.、Shi, W.、Li, X. L.、                       展对齐。神经信息处理系统进展，37:51118–51168，2024。
[L984]  Hajishirzi, H., Zettlemoyer, L., Liang, P., Candès, E.,                Information Processing Systems, 37:51118–51168, 2024.          Fei‑Fei, L.、Hajishirzi, H.、Zettlemoyer, L.、
[L985]  and Hashimoto, T. s1: Simple test-time scaling. arXiv
[L986]                                                                        Team, K., Bai, Y., Bao, Y., Chen, G., Chen, J., Chen,            Liang, P.、Cand`es, E. 和 Hashimoto, T. s1：简单                       Team, K., Bai, Y., Bao, Y., Chen, G., Chen, J., Chen, N.,
[L987]  preprint arXiv:2501.19393, 2025.
[L988]                                                                          N., Chen, R., Chen, Y., Chen, Y., Chen, Y., et al.             测试时扩展。arXiv 预印本 arXiv:2501.19393，                                 Chen, R., Chen, Y., Chen, Y., Chen, Y., 等. Kimi k2：开放
[L989] Naor, M. Evaluation may be easier than generation. In                    Kimi k2: Open agentic intelligence. arXiv preprint                                                                               智能体智能. arXiv预印本 arXiv:2507.20534，2025。
[L990]                                                                                                                                         2025。Naor, M. 评估可能比生成更容易。载于第二
[L991]   Proceedings of the twenty-eighth annual ACM symposium                  arXiv:2507.20534, 2025.
[L992]   on Theory of computing, pp. 74–83, 1996.                                                                                              十八届 ACM 计算理论研讨会论文集，第 74–83 页，
[L993]                                                                        Team, O. Open Thoughts. https://open-thoughts.ai, January        1996。Paster, K.、Santos, M. D.、Azerbayev, Z.                       Team, O. Open Thoughts.
[L994] Paster, K., Santos, M. D., Azerbayev, Z., and Ba, J. Open-               2025a.                                                                                                                           https://open‑thoughts.ai，2025a年1月。Team,
[L995]   webmath: An open dataset of high-quality mathematical                                                                                 和 Ba, J. Open‑webmath：一个高质量数学网络文
[L996]   web text, 2023.                                                      Team, Q. Qwen3 technical report, 2025b. URL https:               本的开放数据集，2023。Qi, S.、Yang, B.、Jiang,                               Q. Qwen3技术报告，2025b。URL
[L997]                                                                          //arxiv.org/abs/2505.09388.                                    K.、Wang, X.、Li, J.、Zhong, Y.、Yang, Y. 和                           https://arxiv.org/abs/2505.09388.
[L998] Qi, S., Yang, B., Jiang, K., Wang, X., Li, J., Zhong, Y., Yang,                                                                                                                                           Wang, Y., Kordi, Y., Mishra, S., Liu, A., Smith,
[L999]   Y., and Zheng, Z. In-context editing: Learning knowl-                Wang, Y., Kordi, Y., Mishra, S., Liu, A., Smith, N. A.,          Zheng, Z. 上下文编辑：从自诱导分布中学习知识。
[L1000]                                                                                                                                                                                                           N. A., Khashabi, D., 和 Hajishirzi, H.
[L1001]   edge from self-induced distributions. In The Thirteenth               Khashabi, D., and Hajishirzi, H. Self-instruct: Aligning        载于 第十三届国际学习表征会议，2025。
[L1002]   International Conference on Learning Representations,                 language models with self-generated instructions. In                                                                              Self‑instruct：使语言模型与自生成指令对齐。载于
[L1003]   2025.                                                                 Proceedings of the 61st annual meeting of the association                                                                         第61届计算语言学协会年会论文集（第1卷：长论文），
[L1004] Rastogi, A., Jiang, A. Q., Lo, A., Berrada, G., Lample,
[L1005]                                                                         for computational linguistics (volume 1: long papers), pp.
[L1006]                                                                                                                                         Rastogi, A., Jiang, A.Q., Lo, A., Berrada, G., Lample, G.,        第13484–13508页，2023。
[L1007]                                                                         13484–13508, 2023.
[L1008]   G., Rute, J., Barmentlo, J., Yadav, K., Khandelwal,                                                                                   Rute, J., Barmentlo, J., Yadav, K., Khandelwal, K.,
[L1009]   K., Chandu, K. R., et al. Magistral. arXiv preprint                  Xiaomi, L.-C. Mimo-v2-flash technical report, 2026. URL          Chandu, K. R., 等. Magistral. arXiv 预印本                            小米, L.‑C. Mimo‑v2‑flash技术报告，2026。
[L1010]   arXiv:2506.10910, 2025.                                                https://arxiv.org/abs/2601.02780.                              arXiv:2506.10910，2025。                                            URLhttps://arxiv.org/abs/2601.02780。
[L1011] Ross, S., Gordon, G., and Bagnell, D. A reduction of imita-            Xu, W., Han, R., Wang, Z., Le, L., Madeka, D., Li, L., Wang,     Ross, S., Gordon, G., 和 Bagnell, D. 将模仿学习与                        Xu, W., Han, R., Wang, Z., Le, L., Madeka, D.,
[L1012]   tion learning and structured prediction to no-regret online            W. Y., Agarwal, R., Lee, C.-Y., and Pfister, T. Speculative    结构化预测归约到无遗憾在线学习。见 第十四届国际                                          Li, L., Wang, W. Y., Agarwal, R., Lee, C.‑Y., 和
[L1013]   learning. In Proceedings of the fourteenth international               knowledge distillation: Bridging the teacher-student gap       人工智能与统计会议论文集，第 627–635 页。J                                        Pfister, T. 推测性知识蒸馏：通过交错采样弥合师生
[L1014]   conference on artificial intelligence and statistics, pp.              through interleaved sampling. In The Thirteenth Interna-
[L1015]   627–635. JMLR Workshop and Conference Proceedings,                                                                                    MLR 研讨会与会议论文集，2011。                                               差距。见第十三届国际学习表征会议，2024a。
[L1016]                                                                          tional Conference on Learning Representations, 2024a.
  2011.
[L1018]                                                                        Xu, X., Li, M., Tao, C., Shen, T., Cheng, R., Li, J., Xu, C.,                                                                      Xu, X., Li, M., Tao, C., Shen, T., Cheng, R., Li, J., Xu,
[L1019] Sanh, V., Debut, L., Chaumond, J., and Wolf, T. Distilbert,                                                                             Sanh, V., Debut, L., Chaumond, J., 和 Wolf, T.
[L1020]                                                                         Tao, D., and Zhou, T. A survey on knowledge distillation                                                                          C., Tao, D., 和 Zhou, T. 大语言模型知识蒸馏综述。
[L1021]   a distilled version of bert: smaller, faster, cheaper and              of large language models. CoRR, 2024b.                         DistilBERT，一种 BERT 的蒸馏版本：更小、更快、更便
[L1022]                                                                                                                                                                                                           CoRR，2024b。
[L1023]   lighter. arXiv preprint arXiv:1910.01108, 2019.                                                                                       宜且更轻。 arXiv 预印本 arXiv:1910.01108，2019。
[L1024]                                                                        Yang, A., Li, A., Yang, B., Zhang, B., Hui, B., Zheng, B.,                                                                         Yang, A., Li, A., Yang, B., Zhang, B., Hui, B., Zheng, B., Yu,
[L1025] Schulman, J., Wolski, F., Dhariwal, P., Radford, A., and                                                                                Schulman, J.、Wolski, F.、Dhariwal, P.、Radford,
[L1026]                                                                          Yu, B., Gao, C., Huang, C., Lv, C., Zheng, C., Liu, D.,                                                                          B., Gao, C., Huang, C., Lv, C., Zheng, C., Liu, D., Zhou, F.,
[L1027]   Klimov, O. Proximal policy optimization algorithms.                                                                                   A. 和 Klimov, O. 近端策略优化算法。arXiv 预印本                                Huang,F., Hu, F., Ge,H., Wei, H., Lin,H., Tang, J., Yang, J.,
[L1028]                                                                          Zhou, F., Huang, F., Hu, F., Ge, H., Wei, H., Lin, H., Tang,
[L1029]   arXiv preprint arXiv:1707.06347, 2017.
[L1030]                                                                          J., Yang, J., Tu, J., Zhang, J., Yang, J., Yang, J., Zhou,     arXiv:1707.06347，2017。                                            Tu, J., Zhang, J., Yang, J., Yang, J., Zhou, J., Zhou, J., Lin, J.,
[L1031] Shao, Z., Wang, P., Zhu, Q., Xu, R., Song, J., Bi, X., Zhang,            J., Zhou, J., Lin, J., Dang, K., Bao, K., Yang, K., Yu, L.,    Shao, Z.、Wang, P.、Zhu, Q.、Xu, R.、Song, J.、Bi, X.、                 Dang, K., Bao, K., Yang, K., Yu, L., Deng, L., Li, M., Xue,
[L1032]   H., Zhang, M., Li, Y., Wu, Y., et al. Deepseekmath: Push-              Deng, L., Li, M., Xue, M., Li, M., Zhang, P., Wang, P.,        Zhang, H.、Zhang, M.、Li, Y.、Wu, Y. 等。                              M., Li, M., Zhang, P., Wang, P., Zhu, Q., Men, R., Gao, R.,
[L1033]   ing the limits of mathematical reasoning in open language              Zhu, Q., Men, R., Gao, R., Liu, S., Luo, S., Li, T., Tang,     DeepSeekMath：推动开放语言模型中数学推理的极限。                                    Liu, S., Luo, S., Li, T., Tang, T., Yin, W., Ren, X., Wang, X.,
[L1034]   models. arXiv preprint arXiv:2402.03300, 2024.                         T., Yin, W., Ren, X., Wang, X., Zhang, X., Ren, X., Fan,       arXiv 预印本 arXiv:2402.03300，2024。                                  Zhang, X., Ren, X., Fan,


[L1037]                                                                   11                                                                                                                                 11


[L1039] <PARSED TEXT FOR PAGE: 12 / 16>

[L1040]                                     On-Policy Self-Distillation for Large Language Models                                       面向大语言模型的同策略自蒸馏

[L1042]   Y., Su, Y., Zhang, Y., Zhang, Y., Wan, Y., Liu, Y., Wang,                                   Y., Su, Y., Zhang,Y.,Zhang, Y., Wan,Y.,Liu,Y.,
[L1043]   Z., Cui, Z., Zhang, Z., Zhou, Z., and Qiu, Z. Qwen3                                         Wang, Z., Cui, Z., Zhang, Z., Zhou, Z., 和 Qiu, Z.
[L1044]   technical report. arXiv preprint arXiv:2505.09388, 2025.                                    Qwen3技术报告。arXiv预印本 arXiv:2505.09388，2025。

[L1046] Yang, Z., Pang, T., Feng, H., Wang, H., Chen, W., Zhu, M.,                                  Yang, Z., Pang, T., Feng, H., Wang, H., Chen,
[L1047]   and Liu, Q. Self-distillation bridges distribution gap in                                 W., Zhu, M., and Liu, Q. 自蒸馏弥合语言模型微调
[L1048]   language model fine-tuning. In Proceedings of the 62nd
[L1049]                                                                                             中的分布差距。载于第62届计算语言学协会年会论文
[L1050]   Annual Meeting of the Association for Computational
[L1051]   Linguistics (Volume 1: Long Papers), pp. 1028–1043,                                       集（第1卷：长论文），第1028–1043页，2024。
  2024.
[L1053] Ye, Y., Huang, Z., Xiao, Y., Chern, E., Xia, S., and Liu, P.                                Ye, Y., Huang, Z., Xiao, Y., Chern, E., Xia, S., and Liu,
[L1054]   Limo: Less is more for reasoning, 2025. URL https:                                        P. Limo：推理中少即是多，2025。URL
[L1055]   //arxiv.org/abs/2502.03387.                                                               https://arxiv.org/abs/2502.03387。

[L1057] Yu, L., Jiang, W., Shi, H., Yu, J., Liu, Z., Zhang, Y., Kwok,                               Yu, L., Jiang, W., Shi, H., Yu, J., Liu, Z., Zhang, Y.,
[L1058]   J. T., Li, Z., Weller, A., and Liu, W. Metamath: Boot-                                    Kwok, J. T., Li, Z., Weller, A., and Liu, W. Metamath：为
[L1059]   strap your own mathematical questions for large language                                  大语言模型自举你自己的数学问题。arXiv预印本
[L1060]   models. arXiv preprint arXiv:2309.12284, 2023.                                            arXiv:2309.12284，2023。

[L1062] Yu, Q., Zhang, Z., Zhu, R., Yuan, Y., Zuo, X., Yue, Y., Fan,                                Yu, Q., Zhang, Z., Zhu, R., Yuan, Y., Zuo, X., Yue, Y.,
[L1063]   T., Liu, G., Liu, L., Liu, X., et al. Dapo: An open-source                                Fan, T., Liu, G., Liu, L., Liu, X., 等. Dapo：一个开源的大规
[L1064]   llm reinforcement learning system at scale, 2025. URL                                     模大语言模型强化学习系统，2025。URLhttps://arxiv.
[L1065]   https://arxiv. org/abs/2503.14476, 2025.                                                  org/abs/2503.14476，2025。

[L1067] Yuan, W., Pang, R. Y., Cho, K., Li, X., Sukhbaatar, S., Xu,                                 Yuan, W., Pang, R. Y., Cho, K., Li, X., Sukhbaatar,
[L1068]   J., and Weston, J. E. Self-rewarding language models.                                     S., Xu, J., 和 Weston, J. E. 自奖励语言模型。载于国际机
[L1069]   In International Conference on Machine Learning, pp.                                      器学习大会，第 57905–57923 页。PMLR，2024。
[L1070]   57905–57923. PMLR, 2024.
[L1071] Yue, Y., Yuan, Y., Yu, Q., Zuo, X., Zhu, R., Xu, W., Chen,                                  Yue, Y., Yuan, Y., Yu, Q., Zuo, X., Zhu, R., Xu, W.,
[L1072]   J., Wang, C., Fan, T., Du, Z., et al. Vapo: Efficient and                                 Chen, J., Wang, C., Fan, T., Du, Z., 等. Vapo：面向高级推
[L1073]   reliable reinforcement learning for advanced reasoning                                    理任务的高效可靠强化学习。arXiv 预印本
[L1074]   tasks. arXiv preprint arXiv:2504.05118, 2025.                                             arXiv:2504.05118，2025。

[L1076] Zelikman, E., Wu, Y., Mu, J., and Goodman, N. Star: Boot-                                   Zelikman, E.、Wu, Y.、Mu, J. 和 Goodman, N. Star：
[L1077]   strapping reasoning with reasoning. Advances in Neural                                    用推理自举推理。神经信息处理系统进展，35:15476–
[L1078]   Information Processing Systems, 35:15476–15488, 2022.                                     15488，2022。
[L1079] Zhang, Z., Zheng, C., Wu, Y., Zhang, B., Lin, R., Yu, B.,                                   Zhang, Z.、Zheng, C.、Wu, Y.、Zhang, B.、Lin, R.、
[L1080]   Liu, D., Zhou, J., and Lin, J. The lessons of developing                                  Yu, B.、Liu, D.、Zhou, J. 和 Lin, J. 在数学推理中开发过程
[L1081]   process reward models in mathematical reasoning. arXiv                                    奖励模型的经验教训。arXiv 预印本 arXiv:2501.07301，
[L1082]   preprint arXiv:2501.07301, 2025.                                                          2025。

[L1084] Zhao, S., Liu, M., Huang, J., Liu, M., Wang, C., Liu, B.,                                   Zhao, S.、Liu, M.、Huang, J.、Liu, M.、Wang, C.、
[L1085]   Tian, Y., Pang, G., Bell, S., Grover, A., et al. Inpainting-                              Liu, B.、Tian, Y.、Pang, G.、Bell, S.、Grover, A. 等。
[L1086]   guided policy optimization for diffusion large language                                   面向扩散大语言模型的修复引导策略优化。arXiv 预印本
[L1087]   models. arXiv preprint arXiv:2509.10396, 2025.
[L1088]                                                                                             arXiv:2509.10396，2025。Zheng, C. 、 Liu, S. 、
[L1089] Zheng, C., Liu, S., Li, M., Chen, X.-H., Yu, B., Gao,                                       Li, M.、Chen, X.‑H.、Yu, B.、Gao, C.、Dang, K.、
[L1090]   C., Dang, K., Liu, Y., Men, R., Yang, A., et al.                                          Liu, Y.、Men, R.、Yang, A. 等。组序列策略优化。
[L1091]   Group sequence policy optimization. arXiv preprint
[L1092]                                                                                             arXiv 预印本 arXiv:2507.18071，2025。Zhou, C.、
[L1093]   arXiv:2507.18071, 2025.
[L1094]                                                                                             Liu, P.、Xu, P.、Iyer, S.、Sun, J.、Mao, Y.、Ma,
[L1095] Zhou, C., Liu, P., Xu, P., Iyer, S., Sun, J., Mao, Y., Ma,                                  X.、Efrat, A.、Yu, P.、Yu, L. 等。Lima：少即是多用
[L1096]   X., Efrat, A., Yu, P., Yu, L., et al. Lima: less is more
[L1097]                                                                                             于对齐。见第37届国际神经信息处理系统会议论文集，
[L1098]   for alignment. In Proceedings of the 37th International
[L1099]   Conference on Neural Information Processing Systems,                                      第 55006–55021 页，2023。
[L1100]   pp. 55006–55021, 2023.

[L1102]                                                                  12                                                                                     12


[L1104] <PARSED TEXT FOR PAGE: 13 / 16>

[L1105]                                       On-Policy Self-Distillation for Large Language Models                                                                              面向大语言模型的同策略自蒸馏

[L1107] A. Limitations and Future Directions                                                                                                     A. 局限性与未来方向
[L1108] Due to computational constraints, our experiments are limited to models up to 8B parameters. It remains an open question                 受计算资源限制，我们的实验仅限于参数量不超过 8B 的模型。这一趋势在超过 8B 参数的规模上是否延续，以
[L1109] whether this trend continues at scales beyond 8B parameters and if larger LLMs brings more stability with OPSD as                        及更大的大语言模型在 OPSD 下是否会带来更高稳定性，仍是未解问题，因为我们在后续训练步数中观察到了
[L1110] we have observed instability and performance drop in later training steps. Several promising directions warrant further
[L1111]                                                                                                                                          不稳定性和性能下降。若干有前景的方向值得进一步研究。首先，我们当前的框架并未显式利用生成答案的正
[L1112] investigation. First, our current framework does not explicitly leverage correctness verification of generated answers;
[L1113] incorporating such signals could provide additional learning objectives and more stability beyond distribution matching.                 确性验证；引入此类信号可以提供额外的学习目标，并在分布匹配之外带来更高稳定性。最后，问题难度在自
[L1114] Finally, problem difficulty plays a crucial role in self-distillation: if reasoning problems exceed the model’s comprehension            蒸馏中起着关键作用：如果推理问题超出模型的理解阈值，那么即使能够访问真值解，教师策略也无法提供有
[L1115] threshold, the teacher policy cannot provide meaningful supervision even with access to ground-truth solutions. This                     意义的监督。这表明，课程学习策略——随着模型提升逐步增加问题难度——可能增强训练效果。探索能够将问
[L1116] suggests that curriculum learning strategies—gradually increasing problem difficulty as the model improves—could enhance
[L1117]                                                                                                                                          题保持在模型能力前沿的自适应课程，是将 OPSD 扩展到更具挑战性的推理任务的一个重要方向。
[L1118] training effectiveness. Exploring adaptive curricula that maintain problems at the frontier of model capabilities represents an
[L1119] important direction for scaling OPSD to more challenging reasoning tasks.

[L1121] B. Experimental Details                                                                                                                  B. 实验细节
[L1122] Non-thinking mode results. We further evaluate a fully non-thinking configuration on the Qwen3 family, where both the                    非思考模式结果。我们进一步在 Qwen3 系列上评估了一种完全非思考模式的配置，其中学生模型和教师模型
[L1123] student and teacher operate with Qwen3 thinking mode disabled during training, and evaluation is also conducted under                    在训练期间均禁用 Qwen3 思考模式，并且评估也在非思考推理下进行。如表 5 所示，OPSD 在大多数设置下
[L1124] non-thinking inference. As shown in Table 5, OPSD improves over the corresponding non-thinking base model in most
[L1125]                                                                                                                                          优于相应的非思考基础模型，其中在 Qwen3‑8B 上观察到的增益最大： +23.3（AIME24）， +15.3（
[L1126] settings, with the largest gains observed on Qwen3-8B: +23.3 on AIME24, +15.3 on AIME25, and +7.5 on HMMT25. The
[L1127] gains are not uniform across scales: the 8B model benefits more substantially than the 4B and 1.7B models.                               AIME25），以及 +7.5（HMMT25）。增益在不同规模上并不均匀：8B 模型比 4B 和 1.7B 模型受益更显著。

[L1129] Table 5. Fully non-thinking OPSD results across model scales. Both student and teacher use Qwen3 non-thinking mode during training,      表 5。完全非思考模式的 OPSD 在不同模型规模上的结果。学生模型和教师模型在训练期间均使用 Qwen3 非思考模式，并
[L1130] and evaluation is also performed with non-thinking inference. We report Avg@12 accuracy. For each model and benchmark, full results      且评估也在非思考推理下进行。我们报告 Avg@12 准确率。对于每个模型和基准，跨步骤的完整结果如表 6所示。
[L1131] across steps are shown in Table 6.

[L1133]                                   AIME24                  AIME25                       HMMT25                                                                       AIME24                        AIME25                      HMMT25
[L1134]             Model                                                                                         Avg. Performance Gain                模型                                                                                                平均性能增益
[L1135]                           Base OPSD         ∆      Base OPSD             ∆     Base OPSD           ∆                                                        Base OPSD             ∆       Base OPSD              ∆     Base OPSD          ∆
[L1136]             Qwen3-1.7B     11.9    15.0    +3.1     9.2     6.2      -3.0        5.0     5.8      +0.8            +0.3                         Qwen3‑1.7B   11.9      15.0      +3.1       9.2      6.2      -3.0      5.0      5.8      +0.8          +0.3
[L1137]             Qwen3-4B       23.1    31.1    +8.0    21.4    21.1      -0.3       10.8    16.4      +5.6            +4.4                         Qwen3‑4B     23.1      31.1      +8.0       21.4    21.1      -0.3      10.8     16.4     +5.6          +4.4
[L1138]             Qwen3-8B       26.4    49.7    +23.3   19.7    35.0     +15.3       10.8    18.3      +7.5            +15.4                        Qwen3‑8B     26.4      49.7      +23.3      19.7    35.0     +15.3      10.8     18.3     +7.5          +15.4




[L1143] Table 6. Full step-wise results for fully non-thinking OPSD on Qwen3 models. Both student and teacher use Qwen3 non-thinking mode        表 6. 在 Qwen3 模型上完全非思考 OPSD 的完整逐步结果。训练期间，学生模型和教师均使用 Qwen3 非思考模式，评估也
[L1144] during training, and evaluation is also performed with non-thinking inference. We report Avg@12 accuracy. The best checkpoint for each   采用非思考推理进行。我们报告 Avg@12 准确率。每个模型和基准测试的最佳检查点用于表 5。
[L1145] model and benchmark is used in Table 5.

[L1147]                                                                                                                                                                                                                      第 50 步     第 75 步     第 100 步
[L1148]                                Model            Benchmark      Base          Step 50    Step 75     Step 100                                                       模型                   基准测试           Base
[L1149]                                                 AIME24            11.9        15.0       13.9            12.5                                                                           AIME24            11.9        15.0       13.9           12.5
[L1150]                                Qwen3-1.7B       AIME25             9.2         6.2        8.3             8.1                                                      Qwen3‑1.7B           AIME25             9.2         6.2        8.3            8.1
[L1151]                                                 HMMT25             5.0         5.8        5.0             5.4                                                                           HMMT25             5.0         5.8        5.0            5.4
[L1152]                                                 AIME24            23.1        20.3       27.5            31.1                                                                           AIME24            23.1        20.3       27.5           31.1
[L1153]                                Qwen3-4B         AIME25            21.4        21.4       20.8            21.1                                                      Qwen3‑4B             AIME25            21.4        21.4       20.8           21.1
[L1154]                                                 HMMT25            10.8        11.1       13.1            16.4                                                                           HMMT25            10.8        11.1       13.1           16.4
[L1155]                                                 AIME24            26.4        49.7       45.3            38.3                                                                           AIME24            26.4        49.7       45.3           38.3
[L1156]                                Qwen3-8B         AIME25            19.7        35.0       26.9            27.5                                                      Qwen3‑8B             AIME25            19.7        35.0       26.9           27.5
[L1157]                                                 HMMT25            10.8        18.3       17.5            15.3                                                                           HMMT25            10.8        18.3       17.5           15.3


[L1160] We provide the training and evaluation configurations for our SFT, GRPO and OPSD experiments in Tables 9, 8 and 10.                      我们在表 9、8 和10中提供了我们的监督微调、GRPO 和 OPSD 实验的训练与评估配置。请注意，主要 OPSD
[L1161] Note that we adopt the Thinking-Mode-off student / Thinking-Mode-on teacher configuration for main OPSD experiments.                     实验采用思考模式关闭的学生/思考模式开启的教师配置。更多实验细节，请参阅我们在
[L1162] For more experiment details, please refer to our released training code in https://github.com/siyan-zhao/OPSD.We didn’t
[L1163]                                                                                                                                          https://github.com/siyan-zhao/OPSD 发布的训练代码。我们未对裁剪参数 τ进行调优，在更大的模型上优化该超
[L1164] conduct tuning for the clipping parameter τ , optimizing this hyperparameter may yield further performance gains within the
[L1165] same 100-step budget for larger models.                                                                                                  参数，可能会在相同的 100 步预算内带来进一步的性能提升。

[L1167] All experiments were conducted using 8 A100 or H100 GPUs with gradient checkpointing and Flash Attention 2 for memory                    为提升内存效率，所有实验均在 8 块 A100 或 H100 GPU 上使用梯度检查点和 Flash Attention 2 进行。我们使用
[L1168] efficiency. We use the AdamW (Loshchilov & Hutter, 2017) optimizer and bfloat16 precision for all training runs. For                     AdamW（Loshchilov &Hutter，2017）优化器和 bfloat16 精度进行所有训练运行。对于 OPSD，除非另有说明，我们使用
[L1169] OPSD, unless otherwise stated, we used full-vocabulary logit distillation.                                                               全词表 logit 蒸馏。

[L1171]                                                                    13                                                                                                                                      13


[L1173] <PARSED TEXT FOR PAGE: 14 / 16>

[L1174]                                      On-Policy Self-Distillation for Large Language Models                                                                       面向大语言模型的同策略自蒸馏

[L1176] Table 7. Per-token KL divergence by token category across generation styles. Mean per-token KL divergence broken down by token         表 7. 按词元类别划分、跨生成风格的每词元KL散度。 按词元类别细分的平均每词元KL散度（详细定义见附录 C），在10个
[L1177] category (see Appendix C for detailed definitions), averaged over 10 problems. Thinking Mode OFF/ON indicates whether the student or   问题上取平均。思考模式关闭/开启表示学生模型或教师大语言模型的提示格式是否启用思考模式。我们发现，当学生模型的
[L1178] teacher LLM’s prompt format enables thinking mode. We find when student’s generation’s thinking mode is off and when the teacher’s
[L1179] thinking mode is on, the KL signal on math related tokens are the highest. And we choose this setup for our experiments.               生成处于思考模式关闭、而教师的思考模式开启时，数学相关词元上的KL信号最高。我们因此在实验中选择此设置。

[L1181]                                               Qwen3-1.7B              Qwen3-4B              Qwen3-8B                                                                      Qwen3‑1.7B               Qwen3‑4B               Qwen3‑8B

[L1183]                        Student Teacher Style Math Other Style Math Other Style Math Other                                                          学生模型 教师 风格 数学 其他 风格 数学 其他 风格 数学 其他
[L1184]                        TM-off TM-off       0.68    0.12   0.11    0.61   0.06     0.10   0.56    0.05   0.11                                       TM‑off TM‑off        0.68   0.12    0.11    0.61    0.06     0.10   0.56 0.05     0.11
[L1185]                        TM-on TM-off        0.51    0.10   0.17    0.41   0.05     0.18   0.33    0.05   0.15                                       TM‑on     TM‑off     0.51   0.10    0.17    0.41    0.05     0.18   0.33 0.05     0.15
[L1186]                        TM-on TM-on         0.51    0.09   0.08    0.50   0.04     0.09   0.42    0.04   0.08                                       TM‑on     TM‑on      0.51   0.09    0.08    0.50    0.04     0.09   0.42 0.04     0.08
[L1187]                        TM-off TM-on        0.85    0.14   0.25    0.92   0.10     0.29   0.79    0.06   0.25                                       TM‑off TM‑on         0.85   0.14    0.25    0.92    0.10     0.29   0.79 0.06     0.25


[L1190]                                        Table 8. Training Configuration for GRPO and OPSD                                                                              表 8. GRPO 和 OPSD 的训练配置

[L1192]                              Parameter                                   GRPO             OPSD                                                             参数                                         GRPO              OPSD
[L1193]                              Learning Rate                            5 × 10    −6
[L1194]                                                                                          5 × 10   −6
[L1195]                                                                                                                                                            学习率                                     5 × 10     −6
[L1196]                                                                                                                                                                                                                        5 × 10−6
[L1197]                              Effective Batch Size                        32                 32                                                             有效批量大小                                     32                  32
[L1198]                              LoRA Rank (r)                                64               64                                                              LoRA 秩（r）                                     64              64
[L1199]                              LoRA Alpha (α)                              128              128                                                              LoRA Alpha（α）                                128              128
[L1200]                              LoRA Target Modules                      q proj, k proj, v proj, o proj,                                                      LoRA 目标模块                                  q 投影、k 投影、v 投影、o 投影，
[L1201]                                                                       gate proj, up proj, down proj                                                                                                   gate 投影、up 投影、down 投影

[L1203]                              Max Completion Length                       16,000           1024                                                             最大补全长度                                      16,000            1024
[L1204]                              Number of Generations per Prompt              8                1                                                              每个提示的生成次数                                     8                1
[L1205]                              Sampling Temperature                         1.2              1.1                                                             采样温度                                         1.2              1.1
[L1206]                              KL Coefficient (β)                           0.0               –                                                              KL系数 (β)                                     0.0               –
[L1207]                              Training Steps                               500              100                                                             训练步数                                         500              100




[L1212] C. Token Category Definitions                                                                                                          C. 词元类别定义
[L1213] We categorize tokens into style and math groups using predefined keyword lists. These keyword sets are used to analyze the             我们将词元分为 风格 和 数学 组，使用预定义关键词列表。这些关键词集用于分析风格词元和数学知识词元的每词元
[L1214] per-token KL divergence stylistic tokens and mathematical knowledge tokens as in Section 4.3.1.                                        KL散度，如第 4.3.1节。



[L1218] Style Tokens. maybe, perhaps, probably, possibly, let, okay, ok, alright, hmm, wait, because, since, so, thus, hence,                  风格词元。 可能、也许、大概、或许、让、好的、好、行、嗯、等等、因为、由于、所以、因此、因而、但是、然而、虽然、尽管、
[L1219] therefore, but, however, although, though, yet, or, alternatively, instead, otherwise, actually, really, just, simply, basically,      可是、或者、或者、相反、否则、实际上、真的、只是、仅仅、基本上、非常、相当、挺、颇、还算、现在、然后、接下来、首先、
[L1220] very, quite, pretty, rather, fairly, now, then, next, first, second, finally, try, see, check, note, recall, think, idea, strategy,    其次、最后、尝试、看看、检查、注意、回想、认为、想法、策略、方法、方式、会、能够、应该、可能、可以、巨大、大、小、
[L1221] approach, method, way, would, could, should, might, can, huge, large, big, small, tiny, interesting, tricky, complex, simple.          微小、有趣、棘手、复杂、简单。



[L1225] Math Tokens. exponential, exponent, power, powers, base, logarithm, logarithms, log, ln, compare, comparing, compari-                  数学词元。 指数、指数、幂、幂、底数、对数、对数、对数、自然对数、比较、比较、比较、小于、等于、更大、更
[L1226] son, less, equal, larger, smaller, greater, factor, factors, prime, divisible, equation, expression, formula, inequality, rational,    小、大于、因子、因子、质数、可整除、方程、表达式、公式、不等式、有理数、无理数、实数、整数、系数、变量、
[L1227] irrational, real, integer, coefficient, variable, constant, sum, product, difference, quotient, fraction, denominator, numerator,      常数、和、积、差、商、分数、分母、分子、根、平方、立方、n 次、最大值、最小值、优化、界。
[L1228] root, square, cube, nth, maximum, minimum, optimize, bound.

[L1230] D. Policy-Gradient Interpretation of OPSD and Comparison to STaR                                                                       D. OPSD 的策略梯度解释及与 STaR 的比较
[L1231] Our OPSD objective in Equation (9) can be interpreted as a policy-gradient update with a dense, token-level reward signal              我们的 OPSD 目标在式 (9) 中可解释为具有稠密、词元级 奖励信号的策略梯度更新，该奖励信号来自特权信息。在本节中，
[L1232] derived from privileged information. In this section, we show: (1) OPSD can be seen as a dense-reward policy gradient, and             我们说明：(1) OPSD 可被视为稠密奖励策略梯度，(2) 我们将 OPSD 与 STaR 进行对比，表明 STaR 的学习信号是 序列级
[L1233] (2) we contrast OPSD with STaR, demonstrating that STaR’s learning signal is sequence-level while OPSD is token-level.                 而 OPSD 是 词元级。

[L1235]                                                                  14                                                                                                                           14


[L1237] <PARSED TEXT FOR PAGE: 15 / 16>

[L1238]                                      On-Policy Self-Distillation for Large Language Models                                                                   大语言模型的同策略自蒸馏

[L1240]                                               Table 9. Training Configuration for SFT.                                                                                 表 9. 监督微调的训练配置。

[L1242]                                   Parameter                                       SFT                                                                     参数                                               SFT
[L1243]                                   Learning Rate                                 5 × 10  −6
[L1244]                                                                                                                                                           学习率                                            5 × 10−6
[L1245]                                   Effective Batch Size                             32                                                                     有效批量大小                                            32
[L1246]                                   LoRA Rank (r)                                   64                                                                      LoRA 秩 (r)                                        64
[L1247]                                   LoRA Alpha (α)                                 128                                                                      LoRA Alpha（α）                                     128
[L1248]                                   LoRA Target Modules               q proj, k proj, v proj, o proj,                                                       LoRA 目标模块                           q 投影，k 投影，v 投影，o 投影，
[L1249]                                                                     gate proj, up proj, down proj                                                                                            gate 投影，up 投影，down 投影

[L1251]                                   Max Sequence Length                            16000                                                                    最大序列长度                                          16000
[L1252]                                   Number of Training Step                         100                                                                     训练步数                                             100

[L1254]                                                  Table 10. Evaluation Parameters.                                                                                            表 10. 评估参数。

[L1256]                                                 Parameter                     Value                                                                                      参数                            值
[L1257]                                                 Max New Tokens                38912                                                                                      最大新令牌数                        38912
[L1258]                                                 Thinking Mode                 Enabled                                                                                    思考模式                          启用
[L1259]                                                 Top-p                         0.95                                                                                       Top‑p                         0.95
[L1260]                                                 Top-k                         -1                                                                                         Top‑k                         -1
[L1261]                                                 Min-p                         0.0                                                                                        Min‑p                         0.0
[L1262]                                                 Presence Penalty              0.0                                                                                        存在惩罚                          0.0
[L1263]                                                 Samples per Prompt            12                                                                                         每个提示的样本数                      12
[L1264]                                                 Temperature                   1.0                                                                                        温度                            1.0


[L1267] D.1. STaR as Sequence-Level Policy-Gradient                                                                                           D.1. STaR 作为序列级策略梯度
[L1268] STaR (Zelikman et al., 2022) can be viewed as an approximation to an RL-style policy gradient objective. The language                 STaR（Zelikman 等，2022）可被视为 RL风格策略梯度目标的一种近似。语言模型 pθ 在推理过程 r 与答案 y上诱
[L1269] model pθ induces a joint distribution over rationale r and answer y:                                                                  导出联合分布：
[L1270]                                               pθ (r, y | x) = pθ (r | x) pθ (y | x, r),                                                                                pθ (r, y | x) = pθ (r | x) pθ (y | x, r),
[L1271] where the model first samples a latent rationale r before predicting the final answer y. Given an indicator reward R(y) =             其中模型首先采样一个潜在推理过程 r ，然后预测最终答案 y。给定指示奖励 R(y) =1(y = y ⋆)，数据集 S = {(xi, yi⋆ )
[L1272]                                                                                                                                        i=1 上的期望回报为
[L1273] 1(y = y ⋆ ), the expected return across the dataset S = {(xi , yi⋆ )}N
[L1274]                                                                      i=1 is                                                           }N
                                                         N
[L1276]                                                          X                                                                                                                        N
                                                                                                                                                                                  X
[L1278]                                                                E(r,y)∼pθ (·|xi ) 1(y = yi⋆ ) .                                                                                          E(r,y)∼pθ (·|xi ) 1(y = yi⋆ ) .
[L1279]                                                                                                                                                                                                                   
[L1280]                                           JSTaR (θ) =                                                                         (10)                                JSTaR (θ) =                                                         (10)
[L1281]                                                          i=1                                                                                                                      i=1

[L1283] Applying the log-derivative trick yields a policy gradient:                                                                           应用对数导数技巧可得到策略梯度：
                                              N
[L1285]                                               X                      h                                  i                                                              N
[L1286]                                                                                                                                                                        X                      h                                  i
[L1287]                              ∇θ JSTaR (θ) =         E(r,y)∼pθ (·|xi ) 1(y = yi⋆ ) ∇θ log pθ (r, y | xi ) .                    (11)                    ∇θ JSTaR (θ) =         E(r,y)∼pθ (·|xi ) 1(y = yi⋆ ) ∇θ log pθ (r, y | xi ) .   (11)
[L1288]                                               i=1                                                                                                                      i=1

[L1290] Note that the indicator function discards the gradient for all sampled rationales that do not lead to the correct answer yi⋆ : this   注意，指示函数会丢弃所有未导向正确答案 yi⋆ 的采样推理过程的梯度：这对应于 STaR 中的过滤步骤。
[L1291] corresponds to the filtering step in STaR.
[L1292] One limitation is that STaR’s reward is sequence-level: the binary indicator 1(y = y ⋆ ) provides the same signal to all tokens       一个局限在于，STaR 的奖励是 序列级的：二元指示符1(y = y ⋆) 为轨迹中的所有词元提供相同的信号，无法进
[L1293] in a trajectory, offering no intermediate credit assignment. When all sampled trajectories are all incorrect, the learning signal     行中间信用分配。当所有采样轨迹全部不正确时，学习信号会消失。
[L1294] vanishes.

[L1296] D.2. OPSD as Dense-Reward Policy Gradient                                                                                             D.2. OPSD 作为稠密奖励策略梯度
[L1297] The sampled-token objective in Equation (9) can also be viewed as a policy-gradient method, but with a token-level reward.            公式 (9) 中的采样 token 目标也可以视为一种策略梯度方法，但采用词元级奖励。固定一个训练对 (x, y ⋆) ，并
[L1298] Fix a training pair (x, y ⋆ ) and let the student generate a trajectory ŷ ∼ pS (· | x). At each position n, define the per-token     令学生模型生成一条轨迹 ˆy ∼ pS(· | x)。在每个位置 n，定义逐词元奖励：
[L1299] reward:
[L1300]                                    rn (x, ŷ) ≜ log pT (ŷn | x, y ⋆ , ŷ<n ) − log pS (ŷn | x, ŷ<n ).                                                  rn (x, ŷ) ≜ log pT (ŷn | x, y ⋆ , ŷ<n ) − log pS (ŷn | x, ŷ<n ).

[L1302]                                                                     15                                                                                                                       15


[L1304] <PARSED TEXT FOR PAGE: 16 / 16>

[L1305]                                     On-Policy Self-Distillation for Large Language Models                                                                  面向大语言模型的同策略自蒸馏

[L1307] This reward measures how much the privileged teacher prefers the sampled token ŷn relative to the student. As stated in the      该奖励衡量特权教师对采样词元 ˆyn 相较于学生模型的偏好程度。如正文所述，我们将 rn （等价地，优势 An）
[L1308] main text, we treat rn (equivalently, the advantage An ) as a constant with respect to θ when computing gradients—that is,        视为相对于 θ 的常数，在计算梯度时——也就是说，我们在奖励计算中对 pT 和 pS 都停止梯度。在这种处理下，
[L1309] we stop gradients through both pT and pS in the reward computation. Under this treatment, the gradient of Equation (9)
[L1310]                                                                                                                                   公式 (9) 的梯度取标准策略梯度形式：
[L1311] takes the standard policy-gradient form:
[L1312]                                                                                                                                                                                                                            
[L1313]                                                                   |ŷ|                                                                                                                 |ŷ|
[L1314]                                                              1   X                                                                                                                1   X
[L1315]                     ∇θ L(θ) = −E(x,y⋆ )∼S Eŷ∼pS (·|x)               rn (x, ŷ) ∇θ log pS (ŷn | x, ŷ<n ) ,                           ∇θ L(θ) = −E(x,y⋆ )∼S Eŷ∼pS (·|x)             rn (x, ŷ) ∇θ log pS (ŷn | x, ŷ<n ) ,
[L1316]                                                             |ŷ| n=1                                                                                                             |ŷ| n=1

[L1318] which corresponds to maximizing the expected per-token reward along on-policy student rollouts:                                   w这对应于在同策略学生轨迹上最大化每词元期望奖励                                                                    s:
[L1319]                                                                                                                                                                                                               
[L1320]                                                                            |ŷ|                                                                                                                      |ŷ|
[L1321]                                                                       1   X                                                                                                                     1   X
[L1322]                              JOP SD (θ) = E(x,y⋆ )∼S Eŷ∼pS (·|x)             rn (x, ŷ) .                                                         JOP SD (θ) = E(x,y⋆ )∼S Eŷ∼pS (·|x)             rn (x, ŷ) .
[L1323]                                                                      |ŷ| n=1                                                                                                                  |ŷ| n=1

[L1325] This reward is dense: it provides a learning signal at every token position, regardless of whether the final answer is correct.   该奖励是稠密的：它提 在每个 token 位置提供学习信号，无论最终答案是否正确                                                              t.

[L1327] Comparison. Both STaR and OPSD can be understood as policy-gradient methods, but their reward structures differ                   比较。 STaR 和 OPSD 都可以理解为策略梯度方法，但它们的奖励结构存在根本差异。STaR 使用序列级指示
[L1328] fundamentally. STaR uses a sequence-level indicator 1(y = y ⋆ ) that assigns the same signal to all tokens; when all sampled      函数 1(y = y ⋆)，给所有词元分配相同的信号；当所有采样轨迹都不正确时，学习信号会完全消失。相比之下，
[L1329] trajectories are incorrect, the learning signal vanishes entirely. In contrast, OPSD provides a token-level reward rn at every
[L1330]                                                                                                                                   OPSD 在每个位置提供词元级奖励 rn ，即使最终答案错误也能实现细粒度信用分配。
[L1331] position, enabling fine-grained credit assignment even when the final answer is wrong.




[L1336]                                                              16                                                                                                                       16


---

## Assistant
*2026-10-24 06:10*
这篇论文是 **《Self-Distilled Reasoner: On-Policy Self-Distillation for Large Language Models》**，核心研究问题是：**能不能不使用额外的、更强大的教师模型，让一个 LLM 利用标准答案教会自己更好地推理？**

我按照引言的原始叙事顺序，带你理解作者为什么提出这个问题、已有方法哪里不够好、OPSD 的关键思路是什么，以及作者声称自己贡献了什么。<FileCite ref="turn0file0" line_range_start={69} line_range_end={180} />

## 一、引言的整体逻辑

<box border radius="xl" padding={4} gap={3}>
  <box gap={1}>
    <text color="secondary" size="sm">Step 1 · 研究背景</text>
    **LLM 推理能力可以通过后训练提升**

    常见方法包括 SFT、强化学习和知识蒸馏。
  </box>
  <divider color="subtle"/>
  <box gap={1}>
    <text color="secondary" size="sm">Step 2 · 发现局限</text>
    **现有方法各自存在问题**

    SFT 有分布偏移问题；强化学习的反馈稀疏、采样昂贵；传统蒸馏需要独立教师。
  </box>
  <divider color="subtle"/>
  <box gap={1}>
    <text color="secondary" size="sm">Step 3 · 关键观察</text>
    **理解正确答案，可能比独立生成正确答案容易**

    模型即使不会直接解题，也可能在看到标准解法后理解其中的推理。
  </box>
  <divider color="subtle"/>
  <box gap={1}>
    <text color="secondary" size="sm">Step 4 · 提出方法</text>
    **让同一个模型同时充当学生和教师**

    学生只看到题目；教师额外看到正确答案，并对学生自己的生成过程提供逐 Token 监督。
  </box>
  <divider color="subtle"/>
  <box gap={1}>
    <text color="secondary" size="sm">Step 5 · 实验验证</text>
    **争取以更少的生成 Token 获得更好的推理能力**

    作者进一步设计逐 Token 散度裁剪，处理训练信号被某些风格词主导的问题。
  </box>
</box>

这就是整段引言的论证链条：**现有训练方法存在效率或监督上的缺陷 → 利用标准答案作为额外信息 → 通过自蒸馏提供稠密监督 → 尝试同时改善推理性能和训练效率。**

## 二、第一部分：作者为什么重新审视现有训练方法？

引言开头先介绍三类提升 LLM 推理能力的常见方式。作者并不是说这些方法无效，而是认为它们各自还有可以改进的地方。

### 1. SFT：监督微调

SFT（Supervised Fine-Tuning）使用高质量的题目与标准解答训练模型，让模型学习复现这些推理轨迹。

例如，训练数据给出：

- 题目：求 \(f(x)=3x^2+2x-5\) 在 \(x=2\) 处的导数。
- 标准解答：\(f'(x)=6x+2\)，所以 \(f'(2)=14\)。

模型通过学习标准解答，逐渐掌握解题方式。

问题在哪里？

训练时，模型跟随的是数据集给定的标准轨迹；推理时，它必须根据自己生成的前文继续回答。一旦前面生成的内容偏离标准轨迹，后面的生成条件也会发生变化，错误可能逐渐累积。

这就是论文提到的 **exposure bias（暴露偏差）与训练、推理之间的分布不匹配**。

需要注意：作者并没有说 SFT 一定无效，而是指出单纯模仿固定轨迹可能不够。

### 2. 强化学习：RLVR / GRPO

RLVR 是 Reinforcement Learning with Verifiable Rewards，即带可验证奖励的强化学习。GRPO 是论文重点讨论的代表方法。

它的基本流程是：

1. 模型针对同一道题生成一组答案。
2. 使用标准答案或验证器判断每个答案是否正确。
3. 根据奖励更新模型。

例如，同一道题采样 8 次，其中 3 次正确、5 次错误，算法可以利用这些结果的相对差异来更新策略。

作者指出两个主要问题。

- **采样开销大：** 为了得到足够有用的奖励差异，需要生成多个候选答案，而且推理轨迹可能很长。
- **奖励信号稀疏：** 一个答案最终正确还是错误，通常是对整条轨迹的评价，并没有直接告诉模型中间究竟哪个 Token 或推理步骤出了问题。

更麻烦的是，如果一组答案全部正确，或者全部错误，那么在 GRPO 的组相对奖励机制下，组内奖励可能没有差异，优势信号就会变成零，无法产生有效的策略更新。

这意味着：**模型可能已经花费大量计算生成答案，却没有获得有效的学习信号。**

这里要注意，零优势是针对组内奖励相同的情况，并不意味着 GRPO 在所有训练批次中都会失效。

### 3. 知识蒸馏与同策略蒸馏

传统知识蒸馏的思路是让学生模型学习教师模型的行为。教师不仅能给出一个正确答案，还可以提供每个位置上不同候选 Token 的概率分布。

例如，面对某个数学推理前缀，教师可能认为：

| 下一 Token 的候选 | 教师给出的概率（示意） |
|---|---:|
| `+` | 0.70 |
| `−` | 0.15 |
| `×` | 0.10 |
| 其他 | 0.05 |

这种概率分布比单独告诉学生“正确 Token 是 `+`”包含更多信息，因此能够提供更稠密的学习信号。

但是，传统蒸馏通常使用固定的教师生成轨迹，学生学习的数据分布与自己实际生成的轨迹不完全一致。

于是，出现了 **On-Policy Distillation（同策略蒸馏）**：

- 学生先生成自己的轨迹。
- 教师再对学生生成的轨迹提供逐 Token 监督。

这样既保留了学生实际会遇到的生成状态，又能获得教师提供的稠密反馈。

但它仍然存在一个成本：通常需要一个独立的教师模型，而且教师往往比学生更大。

作者由此提出了真正想解决的问题：**如果同策略蒸馏已经有效，能不能连独立教师模型都省掉？** <FileCite ref="turn0file0" line_range_start={127} line_range_end={156} />

## 三、第二部分：引言最关键的洞察是什么？

我认为，这是整篇论文引言中最值得理解的一句话背后的思想：

**生成正确解答，与理解一个已经给出的正确解答，是两种难度不同的任务。**

作者借用了人类学习的类比。

假设一个学生独立做数学题时做错了。老师给出正确解法之后，学生重新检查步骤，可能就能理解自己为什么错了。

作者认为，LLM 也可能存在类似能力：

- 不看答案时，模型可能无法独立生成正确的推理过程。
- 看到标准答案或参考推理后，模型可能能够理解解法，并据此判断自己生成的推理中哪些地方需要改变。

这与论文引用的一个观察相呼应：**对于模型，评估往往比生成更容易。**

这里的“评估”并不意味着模型一定能正确判断每一道题，而是作者提出的研究假设：模型在获得正确解答作为额外上下文后，可能更容易形成有用的推理监督。

于是，作者将标准答案看成一种训练期间才可用的 **特权信息（privileged information）**。

为什么这个洞察重要？

因为它改变了传统蒸馏的一个前提：

| 传统思路 | OPSD 的思路 |
|---|---|
| 需要另一个教师来教学生 | 同一个模型可以承担两个角色 |
| 教师提供额外的模型能力 | 教师通过额外的答案信息获得优势 |
| 学生学习教师的生成结果 | 学生学习教师对自身轨迹的概率分布评价 |

这也是为什么论文叫做 *Self-Distilled Reasoner*：它不是简单地让模型重复自己之前生成的答案，而是利用同一模型在不同信息条件下产生的行为差异来训练自己。<FileCite ref="turn0file0" line_range_start={69} line_range_end={140} />

## 四、第三部分：OPSD 究竟怎么实现？

OPSD 的全称是 **On-Policy Self-Distillation（同策略自蒸馏）**。

先记住一句话：

**学生负责生成自己的轨迹，教师负责利用标准答案评估这条轨迹，训练则让学生逐渐接近教师的 Token 概率分布。**

<box border radius="xl" padding={3} gap={3}>
  <box background="surface-secondary" radius="lg" padding={3} gap={1}>
    <title size="md">① 学生策略 Student</title>
    <text color="secondary" size="sm">输入：题目 \(x\)，不提供标准答案</text>
    学生按照当前模型生成一条轨迹：

    \[
    \hat y\sim p_S(\cdot\mid x)
    \]

    例如，它生成了自己的解题步骤，其中可能存在错误。
  </box>
  <box align="center">
    <icon name="arrow-down" size="xl" color="secondary"/>
  </box>
  <box background="surface" border radius="lg" padding={3} gap={1}>
    <title size="md">② 教师策略 Teacher</title>
    <text color="secondary" size="sm">输入：题目 \(x\)、标准答案 \(y^\star\)、学生当前生成的前缀</text>
    教师计算每个位置的下一 Token 概率：

    \[
    p_T(\cdot\mid x,y^\star,\hat y_{<n})
    \]

    它利用标准答案提供的信息，形成更有针对性的监督。
  </box>
  <box align="center">
    <icon name="arrow-down" size="xl" color="secondary"/>
  </box>
  <box background="surface-secondary" radius="lg" padding={3} gap={1}>
    <title size="md">③ 计算蒸馏损失</title>
    比较学生和教师在每个 Token 位置的概率分布：

    \[
    \mathcal L
    =
    \mathbb E_{\hat y\sim p_S}
    \left[
    \sum_n
    D(p_T^{(n)}\Vert p_S^{(n)})
    \right]
    \]

    通过优化损失，更新学生模型参数。
  </box>
</box>

<text color="secondary" size="sm">上式是对论文目标函数的简化表达；论文对序列长度进行了归一化，并研究了不同散度目标。<FileCite ref="turn0file0" line_range_start={118} line_range_end={124} /></text>

这里有三个很容易混淆的细节。

**第一，学生和教师是同一个模型，不是两个不同大小的模型。**

两者共享同一底层模型参数，但条件上下文不同：

\[
p_S(\cdot\mid x)=p_\theta(\cdot\mid x)
\]

\[
p_T(\cdot\mid x,y^\star)=p_\theta(\cdot\mid x,y^\star)
\]

学生只看到题目，教师额外看到标准答案。

**第二，教师不需要再独立生成一条教师解题轨迹。**

在论文给出的实现方式中，教师通过一次前向计算获得相应的 Token 概率分布。它的核心作用是提供监督目标，而不是重新采样一整条答案。<FileCite ref="turn0file0" line_range_start={289} line_range_end={299} />

**第三，学生学习的是概率分布，不只是最终答案。**

教师可以对学生轨迹上的每一个位置提供反馈，因此，即使学生最终答错，也不意味着整条轨迹完全没有学习价值。

这正是 OPSD 与只根据最终答案正确与否进行奖励的强化学习方法之间的重要差别。

## 五、第四部分：为什么一定要强调 On-Policy？

你可以把 On-Policy 理解为：**训练时，让模型学习自己当前实际会走过的生成路径。**

假设训练数据中的正确推理是：

\[
A\rightarrow B\rightarrow C\rightarrow D
\]

但学生实际生成的是：

\[
A\rightarrow B'\rightarrow C'\rightarrow D'
\]

SFT 主要让模型模仿标准轨迹 \(A\rightarrow B\rightarrow C\rightarrow D\)。

OPSD 则先让学生生成自己的轨迹 \(A\rightarrow B'\rightarrow C'\rightarrow D'\)，然后教师利用标准答案提供的额外信息，对这条实际轨迹逐 Token 计算监督信号。

为什么这样做有价值？

因为学生不只是学习“正确答案应该怎么写”，还能够在自己真实生成的上下文中接受指导。这与同策略训练希望缓解的分布偏移问题是一致的。

但要注意：On-Policy 并不保证学生一定能产生高质量的推理轨迹。它只是让训练样本来自学生自身的策略，而教师能否给出有用的指导，仍然取决于模型能力和任务难度。

## 六、第五部分：作者还提出了什么创新？

引言并不只介绍自蒸馏框架，还指出了一个更具体的训练问题。

### 逐 Token 的散度可能被风格词主导

作者发现，学生和教师的概率分布之间存在差异时，不同词表条目产生的散度可能非常不均衡。

例如：

- 数学相关 Token：数字、运算符、数学概念。
- 风格相关 Token：`perhaps`、`therefore`、`however` 等推理连接词。

如果风格词的散度远高于数学相关词，那么训练损失可能主要在优化表达风格，而不是作者真正关心的数学推理能力。

为了解决这个问题，作者提出了 **Per-Token Pointwise KL Clipping（逐 Token 逐点 KL 裁剪）**。

直观地说，它限制单个词表条目对训练信号的过度贡献，避免少数特别大的散度值主导整体损失。

可以将它理解成：

\[
\ell_{n,v}^{\mathrm{clip}}
=\min(\ell_{n,v},\tau)
\]

其中 \(\ell_{n,v}\) 是第 \(n\) 个 Token 位置上、词表条目 \(v\) 对散度的贡献，\(\tau\) 是裁剪阈值。

这项设计的目的不是让模型忽略风格，而是避免风格词产生的异常大梯度贡献淹没更有价值的推理学习信号。<FileCite ref="turn0file0" line_range_start={375} line_range_end={407} />

## 七、第六部分：引言最后总结了哪些贡献？

作者将贡献概括为三个方面。<FileCite ref="turn0file0" line_range_start={170} line_range_end={180} />

| 贡献 | 作者做了什么 | 主要想解决什么 |
|---|---|---|
| 1. OPSD 框架 | 同一模型同时充当学生与教师，利用标准答案提供逐 Token 监督 | 不再依赖独立的外部教师 |
| 2. 逐 Token 散度裁剪 | 限制少数词表条目的过度贡献 | 稳定训练，避免风格词主导信号 |
| 3. 数学推理实验 | 在 AIME24、AIME25、HMMT25 等基准上比较 OPSD、GRPO 和 SFT | 验证推理性能与 Token 效率 |

作者声称，OPSD 能够达到与 GRPO 相当或更好的推理表现，同时显著减少生成 Token，并且优于 SFT。

不过，这些属于作者提出的实验结论。引言本身只是概述，是否有充分证据支持，需要结合后文实验设置、对比基线和消融实验来判断。

---

## 最后，用四句话真正记住这篇引言

1. **问题：** SFT、强化学习和知识蒸馏都能提高 LLM 推理能力，但分别存在分布偏移、奖励稀疏或外部教师成本等问题。

2. **洞察：** 模型独立生成正确推理可能很难，但看到标准答案后，可能更容易理解解法并为自己的推理提供有效监督。

3. **方法：** OPSD 让同一个模型在不同上下文中扮演学生与教师：学生只看题目并生成轨迹，教师额外看到标准答案，再通过逐 Token 概率分布差异训练学生。

4. **创新目标：** 在不依赖独立教师的情况下，结合稠密的同策略监督与逐 Token 散度裁剪，以更高的 Token 效率提升推理能力。

**我建议你读这篇论文时，最值得追问的其实是：** 教师与学生共享参数时，额外的标准答案究竟能产生多大、多少真正有利于数学推理的监督信号？以及这种信号是否比直接做 SFT 或 GRPO 更有效？

这两个问题，才是从理解引言走向判断这篇论文研究价值的关键。

---

## User
*2026-10-24 06:27*
\[
\mathcal L
=
\mathbb E_{\hat y\sim p_S}
\left[
\sum_n
D(p_T^{(n)}\Vert p_S^{(n)})
\right]
\]所以这就是 OPS-D 的真理嘛：
1. 先让一个模型根据训练样本和任务自己生成结果；
2. 再让同一个模型根据标准答案生成轨迹；
3. 然后逐个采样，计算每个 token 生成之间的概率差；
4. 最后再进行训练。

那假如 token 长度不一样，这个怎么弄呢？

因为我是这方面的初学者，所以想知道它到底是怎么训练的，希望你能给我补充讲解一下。

---

## Assistant
*2026-10-24 06:27*
<details><summary>工具调用 · api_tool.call_tool</summary>

```python3
{"path":"/files/search","args":{"query":"Self-Distilled Reasoner On-Policy Self-Distillation for Large Language Models OPSD token length normalization objective sequence masks teacher student distribution KL","scope":{"surfaces":["conversation"]}}}
```

</details>

---

## Tool
*2026-10-24 06:27*
```json
{"api_tool_source":"files/search","results":[{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451"},{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451"},{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451"},{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451"},{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451"},{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451"},{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451"},{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451"},{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451"},{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451"}]}
```

---

## Assistant
*2026-10-24 06:28*
<details><summary>工具调用 · api_tool.call_tool</summary>

```python3
{"path":"/files/read","args":{"read":[{"ref_id":"turn1file4","mode":"chunk_context","context_before_lines":25,"context_after_lines":70},{"ref_id":"turn1file3","mode":"chunk_context","context_before_lines":15,"context_after_lines":35}]}}
```

</details>

---

## Tool
*2026-10-24 06:28*
```json
{"api_tool_source":"files/read","results":[{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451","api_tool_source":"files/read"},{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451","api_tool_source":"files/read"}]}
```

---

## Assistant
*2026-10-24 06:29*
你的理解已经抓住 OPSD 的核心了。不过有两个关键细节需要纠正：

1. **教师不是根据标准答案再生成一条自己的轨迹。** 它只需要根据标准答案和学生已经生成的前缀，计算下一 Token 的概率分布。
2. **学生与教师比较的不是两条答案中对应位置的 Token，而是每个位置上，整个词表的概率分布。**

这两个细节弄懂之后，你就能理解 OPSD 到底是怎么训练的了。

## 一、先回答你最关心的问题：Token 长度不一样怎么办？

答案是：**不需要对齐两条答案的 Token 长度，因为 OPSD 根本不是在逐 Token 对齐两条答案。**

假设有一道数学题：

- 题目 \(x\)：计算 \(3+4\)。
- 标准答案 \(y^\star\)：`7`。
- 学生生成的答案 \(\hat y\)：`3 + 4 = 8`。

为了方便讲解，先把这些内容当作单个 Token 来看，真实模型的分词可能完全不同。

<box border radius="xl" padding={3} gap={3}>
  <row align="center" justify="between">
    **标准答案**
    <badge color="info">教师的额外信息</badge>
  </row>
  <box background="surface-secondary" radius="md" padding={3}>
    `7`

    <text color="secondary" size="sm">假设长度为 1</text>
  </box>
  <row align="center" justify="between">
    **学生生成**
    <badge>实际训练轨迹</badge>
  </row>
  <box background="surface" border radius="md" padding={3}>
    `3` → `+` → `4` → `=` → `8`

    <text color="secondary" size="sm">假设长度为 5</text>
  </box>
  <divider color="subtle"/>
  <title size="md">OPSD 实际怎么计算？</title>
  它会沿着学生的 5 个生成位置，分别计算教师和学生的下一 Token 概率分布之间的差异。

  <row align="center" gap={2}>
    <box background="surface-secondary" radius="md" padding={2} flex="1" align="center">
      <title size="lg">5</title>
      <text size="xs" color="secondary">学生生成位置</text>
    </box>
    <icon name="arrow-right" color="secondary" size="lg"/>
    <box background="surface-secondary" radius="md" padding={2} flex="1" align="center">
      <title size="lg">5</title>
      <text size="xs" color="secondary">逐位置散度</text>
    </box>
  </row>
  **不会因为标准答案只有 1 个 Token，就只计算 1 次损失。**
</box>

原因在于，标准答案在这里的作用是提供额外的上下文信息，而不是作为一串需要与学生输出逐位置对齐的标签。

论文的目标函数明确地沿着学生自己的生成轨迹计算损失，计算次数由学生生成的长度 \(|\hat y|\) 决定。<FileCite ref="turn1file4" />

## 二、真正的训练流程是什么？

我们用一个具体例子，把整个过程从头走一遍。

### 第 1 步：学生根据题目生成答案

输入题目：

> 计算 \(3+4\)。

学生只看到题目，不看到标准答案。

假设它生成：

`3 + 4 = 8`

记作：

\[
\hat y=(\hat y_1,\hat y_2,\ldots,\hat y_5)
\]

这一步叫 **on-policy sampling（同策略采样）**：训练数据中的这条轨迹，是模型使用自己当前的策略生成的，而不是直接从数据集抄来的标准解答。

### 第 2 步：同一个模型切换为教师角色

此时，模型获得标准答案 `7`。

但是注意，教师不是重新生成一条答案 `7`，而是针对学生已经生成的轨迹进行评估。

在每个位置，教师都能看到：

- 原始题目；
- 标准答案；
- 学生在该位置之前已经生成的内容。

例如，在预测第 5 个 Token 时，学生的前缀是：

`3 + 4 =`

此时：

<box border radius="lg" padding={3} gap={3}>
  <box gap={1}>
    <title size="md">学生策略 \(p_S\)</title>
    <text color="secondary" size="sm">输入：题目 + 学生前缀</text>
    `计算 3+4。3+4=`

    学生根据自身已有的知识，预测下一个 Token。
  </box>
  <divider color="subtle"/>
  <box gap={1}>
    <title size="md">教师策略 \(p_T\)</title>
    <text color="secondary" size="sm">输入：题目 + 标准答案 + 同一个学生前缀</text>
    `计算 3+4。标准答案是 7。学生前缀：3+4=`

    教师利用标准答案这一额外信息，预测同一个位置的下一个 Token。
  </box>
</box>

这里的教师和学生使用的是**同一套模型参数**，只是输入上下文不同。论文还特别说明，教师通过前向计算提供分布，不需要另外生成一条教师轨迹。<FileCite ref="turn1file4" />

### 第 3 步：比较两个概率分布，而不是只比较一个 Token

这是你需要重点掌握的地方。

假设模型的词表中有很多候选 Token。为了简化，我们只列出三个候选：

| 下一 Token | 学生概率 | 教师概率 |
|---|---:|---:|
| `7` | 0.20 | 0.80 |
| `8` | 0.70 | 0.10 |
| `9` | 0.10 | 0.10 |

这些数字仅为教学示例，不是论文的实测数据。

学生倾向于生成 `8`，但教师结合标准答案后，更倾向于生成 `7`。

OPSD 就会计算两个分布之间的散度：

\[
D(p_T\Vert p_S)
\]

它衡量的是教师分布和学生分布的差异。具体可以使用 KL 散度或论文讨论的其他散度目标。

**这里比较的是整个概率分布，不是简单地判断学生答案对不对，也不是只比较 `8` 这个 Token 的概率。**

在实际的全词表蒸馏中，每个位置都会考虑词表中的所有候选 Token，而不只是模型最终采样出来的那个 Token。

### 第 4 步：沿整条学生轨迹计算损失

继续前面的例子：

| 位置 | 学生已有前缀 | 学生预测 | 教师预测 | 计算散度 |
|---|---|---|---|---|
| 1 | 空 | 下一 Token 分布 | 下一 Token 分布 | \(D_1\) |
| 2 | `3` | 下一 Token 分布 | 下一 Token 分布 | \(D_2\) |
| 3 | `3 +` | 下一 Token 分布 | 下一 Token 分布 | \(D_3\) |
| 4 | `3 + 4` | 下一 Token 分布 | 下一 Token 分布 | \(D_4\) |
| 5 | `3 + 4 =` | 下一 Token 分布 | 下一 Token 分布 | \(D_5\) |

实际模型的输出可能包含更多 Token，表格只是简化示意。

论文将这些位置的散度按生成长度取平均：

\[
\ell(x,y^\star)
=
\frac{1}{|\hat y|}
\sum_{n=1}^{|\hat y|}D_n
\]

所以刚才的例子就是：

\[
\ell=\frac{D_1+D_2+D_3+D_4+D_5}{5}
\]

为什么要除以长度？

因为不同题目生成的 Token 数量不同。按每条轨迹的有效生成长度求平均，可以避免仅仅因为某条答案更长，就天然积累更大的总损失。

### 第 5 步：更新模型参数

这里还有一个非常重要的细节：

**虽然教师和学生是同一个模型，但反向传播时，只让学生分支的 logits 接受梯度更新；教师分布作为监督目标使用。** <FileCite ref="turn1file4" />

你可以这样理解：

- 教师分支：负责告诉模型，结合标准答案后，当前应该倾向于什么样的 Token 分布。
- 学生分支：负责调整模型参数，让它在没有标准答案的情况下，也逐渐产生更接近教师分布的预测。

优化器根据损失更新模型参数 \(\theta\)。

下一轮训练时，学生再用更新后的模型生成新的轨迹，然后重复整个流程。

这就构成了一个持续迭代的训练闭环。

---

## 三、如果一个 Batch 里每道题生成长度都不同呢？

这属于实际实现中的问题，可以分成两个层次理解。

### 1. 数学上怎么处理？

假设一个 Batch 有三道题：

| 样本 | 学生生成长度 | 单条样本损失 |
|---|---:|---|
| A | 100 Token | 100 个位置的散度取平均 |
| B | 200 Token | 200 个位置的散度取平均 |
| C | 50 Token | 50 个位置的散度取平均 |

每道题先计算自己的平均损失，再对 Batch 内的样本损失求平均：

\[
\mathcal L_{\text{batch}}
=\frac{1}{3}(\ell_A+\ell_B+\ell_C)
\]

这样，每道题在样本级别上都有自己的损失，不需要把三条答案强行裁成同样的有效长度。

这也是论文算法中先计算每条轨迹的损失，再对小批量样本取平均的思路。<FileCite ref="turn1file4" />

### 2. 程序里怎么处理？

神经网络通常会将同一个 Batch 的序列补齐到相同的张量长度，以便并行计算。

例如：

<box border radius="lg" padding={3} gap={3}>
  <box gap={1}>
    <text color="secondary" size="sm">原始序列</text>
    <text preserveWhitespace>{`A:  [a1, a2, a3, a4]\nB:  [b1, b2]\nC:  [c1, c2, c3]`}</text>
  </box>
  <divider color="subtle"/>
  <box gap={1}>
    <text color="secondary" size="sm">补齐后的张量（示意）</text>
    <text preserveWhitespace>{`A:  [a1, a2, a3, a4]\nB:  [b1, b2, PAD, PAD]\nC:  [c1, c2, c3, PAD]`}</text>
  </box>
  <box background="surface-secondary" radius="md" padding={3}>
    <row align="start" gap={2}>
      <icon name="check-circle" size="lg" color="success"/>
      <box flex="1" gap={1}>
        **有效 Token 参与损失计算**

        <text size="sm">通过 mask 屏蔽 PAD 位置，避免补齐内容影响损失和梯度。</text>
      </box>
    </row>
  </box>
</box>

补齐只是为了方便批量计算，不代表模型真的生成了那些 PAD Token。

另外，真实生成通常会在遇到结束标记 EOS 或达到生成上限时停止。实现时需要正确处理结束标记、有效长度和 padding mask；EOS 是否计入损失，应与具体实现的序列定义保持一致。

## 四、你最后还需要区分两种“长度不一致”

这是初学者很容易混淆的地方。

| 问题 | OPSD 如何处理 |
|---|---|
| 标准答案比学生答案短 | 不需要 Token 对齐；标准答案是教师的额外上下文 |
| 不同学生样本的生成长度不同 | 每条轨迹按自身有效长度计算平均损失 |
| Batch 中需要统一张量长度 | 使用 padding 和 mask |
| 教师输入加上学生前缀后超过上下文窗口 | 这是上下文长度限制，需要通过生成预算、截断或样本过滤等工程策略处理 |

最后一行尤其值得注意：**虽然不需要对齐两条答案的长度，但教师仍然必须能够处理它的输入上下文。** 标准答案和学生前缀都可能占用上下文窗口，因此它们的长度仍然影响实际训练成本。

---

## 五、用一句话重新理解 OPSD

OPSD 不是让模型先生成一个答案、再生成另一个标准答案，然后把两条答案逐 Token 对齐。

它真正做的是：

**学生先根据自己的能力生成一条轨迹；教师利用标准答案作为额外信息，对这条轨迹的每个位置计算更有指导意义的下一 Token 概率分布；最后通过逐位置的分布差异更新学生，让模型逐渐学会在没有标准答案的情况下，也能做出更好的推理。**

你现在只需要牢牢记住三个概念：

- **On-Policy：** 学生学习的是自己实际生成的轨迹。
- **Self-Distillation：** 教师与学生共享模型参数，但教师拥有额外的标准答案信息。
- **Token-Level Distribution Matching：** 每个生成位置都比较整个词表上的概率分布，而不是只根据最终答案的正确或错误来提供奖励。

这三个概念就是读懂 OPSD 后续公式、训练算法和实验设计的基础。

---

## User
*2026-10-24 06:33*
标准答案比学生答案短
不需要 Token 对齐；标准答案是教师的额外上下文
其实我的问题更多在于教师模型：
1. 因为有了额外的上下文，生成的教师轨迹和学生轨迹可能不一样。那么散度长度不一样的话，散度就没法对齐了呀。
2. 即使是同一模型，针对同一问题，因为概率的问题，导致生成结果可能也不一样。

所以说，这个地方你怎么进行解释呢？

---

## Assistant
*2026-10-24 06:33*
你这个问题问到了 OPSD 最核心的实现细节。你的疑问完全合理：**如果教师和学生各自生成一条不同长度的答案，那么确实很难直接逐 Token 计算散度。**

关键在于：**OPSD 根本不让教师独立生成一条轨迹。教师和学生评估的是同一条学生轨迹，只是看到的信息不同。**

我前面使用“教师轨迹”这个说法不够准确，容易让你误以为教师还要生成一条自己的答案。我们现在严格按照论文的数学定义重新梳理。

## 一、先纠正一个关键误解：教师不生成自己的答案

论文定义了两个策略：

\[
p_S(\cdot\mid x,\hat y_{<n})
\]

\[
p_T(\cdot\mid x,y^\star,\hat y_{<n})
\]

其中：

- \(x\)：题目。
- \(y^\star\)：标准答案。
- \(\hat y_{<n}\)：学生已经生成的前 \(n-1\) 个 Token。
- \(p_S\)：学生策略。
- \(p_T\)：教师策略。

注意两个公式中最重要的共同部分：

\[
\boxed{\text{相同的学生前缀 }\hat y_{<n}}
\]

区别仅在于，教师额外获得了标准答案 \(y^\star\)。

论文明确说明，教师通过前向计算提供概率分布，不需要实际生成 Token。<FileCite ref="turn1file4" />

## 二、用一个例子理解：两者如何对齐？

假设题目是计算 \(3+4\)，标准答案为 `7`，学生生成了错误的答案：

`3 → + → 4 → = → 8`

我们逐个位置来看。

<box border radius="xl" padding={3} gap={3}>
  <title size="lg">第 1 个位置</title>
  <text color="secondary" size="sm">学生还没有生成任何 Token</text>
  <box background="surface-secondary" radius="md" padding={3} gap={1}>
    **学生看到**

    题目：计算 \(3+4\)。

    **教师看到**

    题目：计算 \(3+4\)。

    标准答案：`7`
  </box>
  两者分别计算下一个 Token 的概率分布，得到 \(p_S^{(1)}\) 和 \(p_T^{(1)}\)，然后计算散度 \(D_1\)。

  <divider color="subtle"/>
  <title size="lg">第 2 个位置</title>
  <text color="secondary" size="sm">学生已经生成了 `3`</text>
  <box background="surface-secondary" radius="md" padding={3} gap={1}>
    **学生看到**

    题目 + 前缀 `3`

    **教师看到**

    题目 + 标准答案 `7` + 前缀 `3`
  </box>
  两者仍然评估同一个前缀，只是教师多知道标准答案，因此分别得到两个新的概率分布，计算 \(D_2\)。

  <divider color="subtle"/>
  <title size="lg">第 5 个位置</title>
  <text color="secondary" size="sm">学生已经生成了 `3 + 4 =`</text>
  <box background="surface-secondary" radius="md" padding={3} gap={1}>
    **学生分布可能是**

    `8`：70%，`7`：20%，其他：10%。

    **教师分布可能是**

    `7`：80%，`8`：10%，其他：10%。
  </box>
  <text color="secondary" size="sm">以上概率纯属示例。</text>
  两者都在预测同一个位置的下一个 Token。教师不需要先生成 `7`，也不需要将自己的答案与学生的 `8` 对齐。
</box>

这样一来，教师和学生之间就可以逐位置计算散度。

## 三、那你提出的两个问题，分别怎么解决？

### 问题 1：标准答案和学生答案长度不同，散度怎么对齐？

**答案：不按答案之间的位置对齐，而是按学生轨迹的生成位置对齐。**

假设：

- 标准答案长度是 1 个 Token。
- 学生生成长度是 5 个 Token。

OPSD 计算的是：

\[
\mathcal L
=\frac{1}{5}\sum_{n=1}^{5}
D\left(
p_T^{(n)}\Vert p_S^{(n)}
\right)
\]

这里的 \(n=1,\ldots,5\) 表示学生轨迹中的五个预测位置，而不是标准答案中的五个位置。

每个位置上，教师和学生都输出一个定义在相同词表 \(\mathcal V\) 上的概率分布：

\[
p_T^{(n)},p_S^{(n)}\in\mathbb R^{|\mathcal V|}
\]

因此，两个分布具有相同的维度，可以直接计算散度。

**标准答案的长度影响教师输入上下文的长度，但不影响教师输出概率分布的维度。**

### 问题 2：同一个模型具有随机性，教师和学生可能生成不同答案，怎么办？

这里需要区分两件事。

- 学生生成答案时，确实可能受到采样随机性的影响。
- 教师在 OPSD 中并不进行独立采样，而是计算下一 Token 的概率分布。

假设学生在某一轮生成了：

`3 + 4 = 8`

这条轨迹确定之后，教师和学生都会在这条轨迹的各个前缀上计算概率分布。

教师不会再采样出另一条 `3 + 4 = 7` 的轨迹。

因此，**教师与学生的随机生成结果不一致，不是 OPSD 的对齐问题，因为教师根本没有独立生成结果需要对齐。**

当然，下一轮训练时，学生可能生成另一条轨迹，例如 `3 + 4 = 7`。这正是同策略训练的一部分：每一轮都可以根据当前学生策略重新采样。

## 四、把真正的训练过程压缩成一张图

<box border radius="xl" padding={3} gap={2} align="center">
  <box border radius="lg" padding={3} width="100%" gap={1}>
    <title size="md">① 学生采样</title>
    输入题目 \(x\)，生成一条轨迹 \(\hat y\)。

    <text color="secondary" size="sm">例如：`3 + 4 = 8`</text>
  </box>
  <icon name="arrow-down" color="secondary" size="lg"/>
  <box border radius="lg" padding={3} width="100%" gap={1}>
    <title size="md">② 两个策略评估同一轨迹</title>
    <text size="sm">学生：题目 + 学生前缀</text>
    <text size="sm">教师：题目 + 标准答案 + 同一个学生前缀</text>
  </box>
  <icon name="arrow-down" color="secondary" size="lg"/>
  <box border radius="lg" padding={3} width="100%" gap={1}>
    <title size="md">③ 逐位置计算散度</title>
    每个位置比较两个策略对整个词表的概率分布。

    \[
    D_n=D(p_T^{(n)}\Vert p_S^{(n)})
    \]
  </box>
  <icon name="arrow-down" color="secondary" size="lg"/>
  <box background="surface-secondary" radius="lg" padding={3} width="100%" gap={1}>
    <title size="md">④ 计算损失并更新参数</title>
    对学生轨迹上的有效位置求平均，通过学生分支的 logits 反向传播更新模型。

    <text color="secondary" size="sm">教师分布作为监督目标，不通过教师分支反向传播梯度。</text>
  </box>
</box>

这里还有一个容易忽略的细节：虽然教师和学生共享同一套参数，但它们在本轮训练中的作用不同。教师分支提供目标分布，学生分支负责学习这个目标。模型参数更新后，下一轮教师分支也会使用更新后的参数重新计算分布。<FileCite ref="turn1file4" />

**最后，你可以把 OPSD 理解成：让模型在自己实际走过的每一个推理步骤上，比较“没有标准答案时的自己”和“知道标准答案时的自己”，然后利用两者的概率分布差异来训练前者。**

这也是它既不需要对齐两条答案，又能为学生轨迹中的每个位置提供学习信号的根本原因。

---

## User
*2026-10-24 06:37*
所以说，你说的这个策略是个策略函数，对不对呀？

可是我还有一个问题：如果不生成轨迹的话，你怎么就能知道它提供的教师答案能起作用了呢？我还是不太理解，感觉就相当于你每次改变一个输入，然后去预算一次输出啊。

因为我不太懂大模型，你去给我讲清楚这个逻辑，我还是非常懵。如果你不真正把这个答案到模型里去，算出来每次的概率偏差的话，你咋能算出这些差距来呢？

---

## Assistant
*2026-10-24 06:38*
你其实已经快理解了。你刚才这句话非常关键：

> 感觉就相当于你每次改变一个输入，然后去预测一次输出。

**对！OPSD 的核心计算，确实就是改变输入上下文，然后分别计算模型的输出概率分布。** 这不是它的漏洞，恰恰是它的核心机制。

你现在困惑的地方，是把大模型的三个不同动作混在了一起：**输入、预测概率、生成答案**。我从最基础的原理讲起，再把它们和 OPSD 对应起来。

## 一、首先，什么叫策略函数？

你可以暂时把大模型想象成一个函数。

输入一段文字，它就会告诉你：接下来每一个可能的 Token，分别有多大的概率出现。

例如，输入：

> 计算 3+4，答案是

模型可能输出如下概率分布：

<box border radius="xl" padding={3} gap={3}>
  <text color="secondary" size="sm">模型对下一个 Token 的预测（教学示例）</text>
  {#each [{token:"7",p:0.7},{token:"8",p:0.2},{token:"9",p:0.1}] as item}
    <box gap={1}>
      <row align="center" justify="between">
        <text weight="medium">{item.token}</text>
        <title size="sm" color="default">{Math.round(item.p*100)}%</title>
      </row>
      <box background="surface-tertiary" radius="full" height="8px" clip>
        <box background="rgb(65,125,220)" height="8px" radius="full" width={`${item.p*100}%`}/>
      </box>
    </box>
  {/each}
  <text color="secondary" size="xs">真实大模型的词表可能有数万至数十万个 Token，这里只展示三个候选。</text>
</box>

这个模型并不只会说“答案是 7”，它实际上先计算出一整套概率。

数学上，我们把这个函数写作：

\[
p_\theta(\cdot\mid x)
\]

其中：

- \(x\)：输入的上下文。
- \(\theta\)：模型的参数，也就是训练过程中要调整的参数。
- \(p_\theta\)：给定输入后，模型对下一个 Token 的条件概率分布。

在强化学习和序列决策领域，我们通常把这种根据当前上下文产生动作概率分布的函数叫作 **策略（Policy）**。对于大语言模型，动作就是选择下一个 Token。

所以，你理解得没错：**这里的策略就是一个根据上下文计算 Token 概率分布的函数。**

## 二、最重要的区别：预测概率，不等于生成答案

这是你理解 OPSD 的关键。

大模型有两种相关但不同的操作。

<box border radius="xl" padding={3} gap={3}>
  <box gap={1}>
    <title size="lg">操作 A：前向计算（Forward Pass）</title>
    <text color="secondary" size="sm">输入文字 → 计算概率分布</text>
    例如：

    输入：`3+4=`

    输出：`7` 的概率为 70%，`8` 的概率为 20%，其他为 10%。

    **到这里就结束了，不需要真的生成任何 Token。**
  </box>
  <divider color="subtle"/>
  <box gap={1}>
    <title size="lg">操作 B：生成（Generation）</title>
    <text color="secondary" size="sm">计算概率分布 → 选出一个 Token → 再次计算</text>
    例如：

    1. 输入 `3+4=`，计算概率。
    2. 从概率分布中采样，得到 `8`。
    3. 将 `8` 接到输入后面，变成 `3+4=8`。
    4. 再次计算下一个 Token 的概率，直到结束。

    **生成一条完整答案，需要反复执行前向计算。**
  </box>
</box>

因此，教师不生成一条新的答案，并不意味着它不计算输出。

恰恰相反，**教师仍然要把输入送进模型，经过神经网络计算，得到每个位置的概率分布。只是它不需要从这些分布中采样 Token，拼成一条新答案。**

这就是你刚才疑惑的地方。

## 三、现在把标准答案真正放进 OPSD 的模型中

我们用一道简单的题目来还原整个过程。

题目是：

> 计算 \(3+4\)。

标准答案是 `7`。

假设学生生成了一条错误的推理轨迹：

`3 → + → 4 → = → 8`

注意，学生已经生成的这条轨迹是真实存在的。OPSD 并不是只输入一道题，然后凭空计算某种差距。

### 第一步：学生生成轨迹

学生只看到题目：

`计算 3+4`

经过模型计算和逐步采样，生成：

`3 + 4 = 8`

这就是学生的 on-policy 轨迹。

### 第二步：把标准答案作为额外上下文，输入教师分支

接下来，我们把标准答案 `7` 提供给同一个模型。

在学生生成轨迹的第 5 个位置，学生已有的前缀是：

`3 + 4 =`

现在，两个分支分别进行计算：

<box border radius="xl" padding={3} gap={3}>
  <box gap={1}>
    <title size="lg">学生分支</title>
    <text color="secondary" size="sm">输入：题目 + 学生前缀</text>
    <box background="surface-secondary" radius="md" padding={3}>
      `计算 3+4；当前前缀：3+4=`
    </box>
    模型计算得到：

    \[
    p_S(\cdot\mid x,\hat y_{<5})
    \]
  </box>
  <divider color="subtle"/>
  <box gap={1}>
    <title size="lg">教师分支</title>
    <text color="secondary" size="sm">输入：题目 + 标准答案 + 同一个学生前缀</text>
    <box background="surface-secondary" radius="md" padding={3}>
      `计算 3+4；标准答案：7；当前前缀：3+4=`
    </box>
    同一个模型，在获得额外信息后计算：

    \[
    p_T(\cdot\mid x,y^\star,\hat y_{<5})
    \]
  </box>
</box>

这里请特别注意：

**标准答案确实被输入了模型。它不是被教师重新生成的，而是作为额外的上下文信息参与前向计算。**

模型的参数可以相同，但因为输入不同，计算得到的隐藏状态和最终的概率分布也可能不同。

这就像同一个人，在不知道答案和看过标准答案之后，对下一步该怎么做可能会有不同判断。

## 四、那么，教师提供的信号究竟在哪里？

现在到了最核心的地方。

假设经过上面的计算，得到了下面两组概率。

<box border radius="xl" padding={3} gap={3}>
  <title size="lg">学生：没有标准答案</title>
  <text color="secondary" size="sm">以下概率纯属教学示例。</text>
  {#each [{token:"7",p:0.2},{token:"8",p:0.7},{token:"9",p:0.1}] as item}
    <box gap={1}>
      <row align="center" justify="between">
        <text>{item.token}</text>
        <text color="secondary" size="sm">{Math.round(item.p*100)}%</text>
      </row>
      <box background="surface-tertiary" height="7px" radius="full" clip>
        <box background="rgb(210,140,65)" height="7px" radius="full" width={`${item.p*100}%`}/>
      </box>
    </box>
  {/each}
  <divider color="subtle"/>
  <title size="lg">教师：获得了标准答案</title>
  {#each [{token:"7",p:0.8},{token:"8",p:0.1},{token:"9",p:0.1}] as item}
    <box gap={1}>
      <row align="center" justify="between">
        <text>{item.token}</text>
        <text color="secondary" size="sm">{Math.round(item.p*100)}%</text>
      </row>
      <box background="surface-tertiary" height="7px" radius="full" clip>
        <box background="rgb(65,125,220)" height="7px" radius="full" width={`${item.p*100}%`}/>
      </box>
    </box>
  {/each}
</box>

你看，教师的作用不是给出另一条轨迹，而是提供一个不同的概率分布。

- 学生认为下一个 Token 更可能是 `8`。
- 教师认为下一个 Token 更可能是 `7`。

这两个概率分布之间存在差异。

OPSD 就计算这个差异。以 KL 散度为例：

\[
D_{\mathrm{KL}}(p_T\Vert p_S)
=\sum_{v\in\mathcal V}
p_T(v)\log\frac{p_T(v)}{p_S(v)}
\]

这里的 \(v\) 遍历整个词表。

这个公式衡量的是：学生的概率分布与教师的概率分布相差多远。

**这就是教师信号的来源。不是教师生成了一条更好的答案，而是教师在看到标准答案之后，给出了一个可以与学生分布比较的监督目标。**

## 五、计算出差距之后，模型怎么学习？

你可能接着会问：既然教师不生成答案，那么计算出来的概率差距，怎么能让模型真正学会做题？

答案在于神经网络的反向传播。

我们仍然用刚才的例子。

1. 学生分支算出概率分布。
2. 教师分支算出目标概率分布。
3. 计算两个分布的散度，得到损失。
4. 通过反向传播，计算学生模型参数应该怎样调整，才能减小这个损失。
5. 优化器更新参数 \(\theta\)。

这里有一个关键细节：教师分布作为监督目标使用，梯度只通过学生分支的 logits 反向传播。由于教师和学生共享参数，更新的是模型的那套共同参数；下一轮教师分支也会使用更新后的参数。<FileCite ref="turn1file4" />

可以用一个简化的训练闭环表示：

<box border radius="xl" padding={3} align="center" gap={2}>
  <box background="surface-secondary" radius="lg" padding={3} width="100%" align="center">
    **模型当前参数 \(\theta\)**

    <text color="secondary" size="sm">同一套模型参数</text>
  </box>
  <icon name="arrow-down" color="secondary" size="lg"/>
  <grid columns={2} gap={2}>
    <grid-item>
      <box border radius="lg" padding={3} gap={1} height="100%">
        <title size="md">学生分支</title>
        只看题目，采样生成轨迹。
      </box>
    </grid-item>
    <grid-item>
      <box border radius="lg" padding={3} gap={1} height="100%">
        <title size="md">教师分支</title>
        额外看到标准答案，计算目标分布。
      </box>
    </grid-item>
  </grid>
  <icon name="arrow-down" color="secondary" size="lg"/>
  <box border radius="lg" padding={3} width="100%" align="center" gap={1}>
    **计算逐 Token 散度**

    <text color="secondary" size="sm">衡量学生分布与教师分布的差异</text>
  </box>
  <icon name="arrow-down" color="secondary" size="lg"/>
  <box background="surface" border radius="lg" padding={3} width="100%" align="center" gap={1}>
    **反向传播 + 参数更新**

    <text color="secondary" size="sm">让学生分支的输出分布向教师目标靠近</text>
  </box>
  <icon name="refresh-cw" color="secondary" size="xl"/>
  <text color="secondary" size="sm">使用更新后的模型，再开始下一轮训练。</text>
</box>

这里要强调：模型不会因为这一次训练就必然学会正确答案。训练只是根据损失调整参数，让模型在类似上下文中逐渐改变预测倾向。是否真的提升推理能力，还需要通过后续实验验证。

## 六、最后，回答你最深层的疑惑

你一直在问：

> 如果不真正把这个答案到模型里去，算出来每次的概率偏差的话，你咋能算出这些差距来？

**事实上，OPSD 正是把标准答案输入模型，然后计算概率偏差。**

唯一不同的是，它没有让教师把标准答案重新生成一遍。

我们可以把两件事彻底区分开：

| 你可能以为的过程 | OPSD 实际的过程 |
|---|---|
| 教师看到答案，再生成一条教师轨迹 | 教师看到答案，再计算学生轨迹各位置的概率分布 |
| 对齐教师和学生生成的 Token | 对齐同一学生前缀下的两个概率分布 |
| 比较两条答案是否相同 | 计算两个概率分布之间的散度 |
| 通过教师答案直接训练学生 | 通过教师分布构造损失，再更新学生参数 |

还有一个很重要的限制：**教师分布不保证一定比学生分布更正确。** 模型可能没有正确理解标准答案，也可能在某些情况下提供不够好的监督。因此，标准答案提供的是额外信息，而不是自动保证正确的教师信号。OPSD 的有效性最终要看训练实验的结果。

你现在可以先记住这个最核心的逻辑：

**生成轨迹是为了得到模型实际会犯错的上下文；输入标准答案是为了让同一个模型在额外信息下重新计算概率分布；比较两个分布是为了获得训练信号；反向传播则是把这个信号转化为参数更新。**

---

## User
*2026-10-24 06:42*
我还是不太理解。

首先，你使用的模型肯定是个 Transformer，它的结构就是 pre-view 和 decode。每一次的输出都会作为下一个位置的输入，也就是说，除了输入提示词之外，每一个输出都会在下一轮加入到输入里面，作为下一个输出一个个吐出来。

那么，教师模型是怎么加入的呢？而且我觉得，如果你要加入的话，这就相当于在同一个模型上使用了两组提示词呀。而且听你的意思，是在一开始不加，只在最后加上，我觉得还是很混乱。

我建议你还是认真给我想清楚，最好是用数学实例的方式给我拆分清楚。

---

## Assistant
*2026-10-24 06:43*
<details><summary>工具调用 · api_tool.call_tool</summary>

```python3
{"path":"/files/read","args":{"read":[{"ref_id":"turn1file0","mode":"pages","start_page":4,"end_page":5,"include_images":true}]}}
```

</details>

---

## Tool
*2026-10-24 06:43*
```json
{"api_tool_source":"files/read","results":[{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451","api_tool_source":"files/read"}]}
```

---

## Assistant
*2026-10-24 06:45*
我重新对照了这篇论文的 Figure 2、公式和算法。你这次提出的问题确实抓住了关键：**如果 Transformer 是自回归模型，那么教师究竟在什么时候把标准答案放进去？它又是怎么利用这份答案，对学生已经生成的每一个 Token 提供监督的？**

我前面没有把 Transformer 的实际计算过程讲透，尤其没有讲清楚“生成轨迹”和“计算概率分布”是两个不同阶段。我们这次从 Transformer 的运行方式开始，严格按照论文的设计，一步一步推导。

## 一、先明确：OPSD 不是两个模型，而是同一模型的两种运行方式

你对 Transformer 的理解基本正确。

一个自回归 Transformer 在生成文本时，通常经历两个阶段：

- **Prefill（预填充）：** 把已有的提示词输入模型，计算各个位置的表示和预测结果。
- **Decode（解码）：** 根据当前的预测分布选出一个 Token，把它接到已有文本后面，再预测下一个 Token，如此循环。

例如，输入：

`计算 3+4。答案是：`

模型可能预测下一个 Token 的概率：

| 候选 Token | 概率（示例） |
|---|---:|
| `7` | 70% |
| `8` | 20% |
| `9` | 10% |

如果采样得到 `8`，下一轮就把 `8` 加入上下文，再预测后续 Token。

但这里要区分两件事：

**计算概率分布，不等于必须采样一个 Token。**

模型可以计算出所有候选 Token 的概率，却不实际生成任何新文本。这正是 OPSD 中教师分支的关键。

另外，Prefill 和 Decode 是 Transformer 的推理执行阶段，并不是两种不同的模型，也不是说模型训练时只能逐 Token 计算。

## 二、论文里的学生提示词和教师提示词，究竟有什么区别？

我们直接看论文 Figure 2 的实际设计。作者确实使用了两种不同的提示词模板，但两者共享同一套模型参数。<FileCite ref="turn1file0" />

为了让你看清区别，我把它们简化成下面的形式。

<box border radius="xl" padding={3} gap={3}>
  <box gap={2}>
    <title size="lg">① 学生提示词</title>
    <box background="surface-secondary" radius="md" padding={3}>
      <text preserveWhitespace>{`问题：计算 3+4。\n\n答案：`}</text>
    </box>
    <text color="secondary" size="sm">不提供标准答案。学生必须依靠自己已有的知识生成答案。</text>
  </box>
  <divider color="subtle"/>
  <box gap={2}>
    <title size="lg">② 教师提示词</title>
    <box background="surface-secondary" radius="md" padding={3}>
      <text preserveWhitespace>{`问题：计算 3+4。\n\n参考解答：7。\n\n请理解参考解答，然后用你自己的方法解题。\n\n答案：`}</text>
    </box>
    <text color="secondary" size="sm">在提示词中加入标准答案，并要求模型理解它，再尝试独立解题。</text>
  </box>
</box>

注意：这里的标准答案并不是等学生生成完整答案之后才突然加到末尾的。

**教师提示词从一开始就包含标准答案，并且把它放在学生解题内容之前。**

这正是论文图中教师提示词的设计。标准答案属于教师的额外上下文；学生提示词没有这部分信息。

接下来，真正重要的是：这两种提示词如何与学生生成的轨迹结合起来。

## 三、现在真正开始生成：学生先产生一条轨迹

假设学生模型生成了下面这条轨迹：

\[
\hat y=(\hat y_1,\ldots,\hat y_5)
=(3,+,4,=,8)
\]

这个过程完全符合你所说的自回归生成机制。

| 生成步骤 | 学生实际输入 | 新生成的 Token |
|---|---|---|
| 1 | 学生提示词 \(P_S\) | `3` |
| 2 | \(P_S+\texttt{3}\) | `+` |
| 3 | \(P_S+\texttt{3 +}\) | `4` |
| 4 | \(P_S+\texttt{3 + 4}\) | `=` |
| 5 | \(P_S+\texttt{3 + 4 =}\) | `8` |

其中 \(P_S\) 表示完整的学生提示词。

这里有一个关键事实：**学生确实生成了完整轨迹，而且轨迹中可以包含错误。**

OPSD 就是要利用这条学生实际生成的轨迹进行训练，而不是把标准答案直接拿来让学生照抄。

## 四、最关键的一步：教师如何使用这条轨迹？

现在进入训练信号计算阶段。

我们已经有了学生轨迹：

`3 → + → 4 → = → 8`

接下来，分别构造两种输入。

学生分支的输入是：

\[
P_S+\hat y_{<n}
\]

教师分支的输入是：

\[
P_T+\hat y_{<n}
\]

其中：

- \(P_S\)：不含标准答案的学生提示词。
- \(P_T\)：包含标准答案的教师提示词。
- \(\hat y_{<n}\)：学生在第 \(n\) 个位置之前生成的所有 Token。

注意，这两个输入使用的是**同一个学生前缀**。

举个最具体的例子：我们现在要计算第 5 个位置的概率分布。

学生已经生成了：

`3 + 4 =`

于是，两个分支分别输入：

<box border radius="xl" padding={3} gap={3}>
  <box gap={1}>
    <title size="lg">学生分支输入</title>
    <box background="surface-secondary" radius="md" padding={3}>
      <text preserveWhitespace>{`问题：计算 3+4。\n答案：3+4=`}</text>
    </box>
    模型计算：

    \[
    p_S(\cdot\mid x,\texttt{3+4=})
    \]
  </box>
  <divider color="subtle"/>
  <box gap={1}>
    <title size="lg">教师分支输入</title>
    <box background="surface-secondary" radius="md" padding={3}>
      <text preserveWhitespace>{`问题：计算 3+4。\n参考解答：7。\n请理解参考解答，然后用自己的方法解题。\n答案：3+4=`}</text>
    </box>
    同一个模型计算：

    \[
    p_T(\cdot\mid x,y^\star,\texttt{3+4=})
    \]
  </box>
</box>

这就是论文公式中两个条件概率分布的实际含义。<FileCite ref="turn1file4" />

**教师并没有生成另一条 `3+4=7` 的轨迹。它是在已经看到参考解答 `7` 的情况下，对学生的同一个前缀 `3+4=` 计算下一 Token 的概率分布。**

为什么这样做是有意义的？

因为教师的输入上下文包含标准答案，而学生的输入上下文不包含。即使使用同一套 Transformer 参数，两种输入也可能产生不同的隐藏状态和 logits，进而产生不同的概率分布。

这就是教师提供额外监督信息的来源。

## 五、你可能还会问：学生和教师的输入长度不同，Transformer 怎么计算？

这个问题也可以通过 Transformer 的实际执行过程来解释。

在学生生成轨迹之后，OPSD 需要计算两个分支的损失：

- 学生分支：题目提示词 + 学生生成轨迹。
- 教师分支：教师提示词 + 同一条学生生成轨迹。

这两条序列的总长度确实可能不同，因为教师提示词中多了标准答案和相关指令。

但是，Transformer 的输出不是一个只有一个位置的结果。对于一条输入序列，它可以计算每个位置对应的隐藏状态和下一 Token 的 logits。

例如，假设学生轨迹为：

`3 + 4 = 8`

在计算损失时，可以把完整的学生轨迹放入输入序列，并使用因果注意力掩码（causal attention mask）。这样，模型能够并行计算多个位置的 logits，同时保证第 5 个 Token 对应的预测只依赖前面的上下文，不会偷看后面的 Token。

教师分支同理：把教师提示词与学生轨迹组合起来，利用因果注意力掩码计算各个生成位置的 logits。

因此：

- 不需要让教师再逐 Token 生成一遍。
- 不需要让教师答案与学生答案进行逐 Token 对齐。
- 只需要按照学生轨迹中的第 \(n\) 个预测位置，取出学生和教师各自对应的概率分布。

即使两个分支的提示词长度不同，它们在同一个生成位置上得到的概率向量仍然定义在相同的词表上，可以计算散度。

这就是为什么 OPSD 可以利用一条学生轨迹，在两个不同的条件上下文中计算逐 Token 的训练损失。

## 六、最后一步：到底怎样把概率差距变成训练信号？

继续使用第 5 个位置的例子。假设模型计算出了下面两组概率：

| Token | 学生分布 \(p_S\) | 教师分布 \(p_T\) |
|---|---:|---:|
| `7` | 0.20 | 0.80 |
| `8` | 0.70 | 0.10 |
| `9` | 0.10 | 0.10 |

这些数字是为了讲解而假设的。

学生更倾向于输出 `8`，教师则更倾向于输出 `7`。

于是，OPSD 计算两个分布的差异。假设使用 KL 散度：

\[
D_{\mathrm{KL}}(p_T\Vert p_S)
=\sum_{v\in\mathcal V}
p_T(v)\log\frac{p_T(v)}{p_S(v)}
\]

这个损失会告诉优化器：学生分布与教师目标分布之间存在多大的差异。

然后，通过反向传播更新学生分支对应的模型参数。教师分支的概率分布在本次优化中作为固定目标，不通过教师分支反向传播梯度。

下一轮训练时，模型参数已经更新，教师分支也会使用更新后的参数重新计算概率分布。

需要强调的是，教师提供的信号不保证一定正确。OPSD 的研究假设是：同一个模型在获得标准答案之后，能够产生更有利于推理的概率分布。这个假设是否成立，需要由论文的实验来验证。

---

## 七、把整个 OPSD 过程串起来

<box border radius="xl" padding={3} gap={2} align="center">
  <box border radius="lg" padding={3} width="100%" gap={1}>
    **阶段 1：学生生成轨迹**

    <text size="sm">只输入题目，使用自回归 Decode 生成 \(\hat y\)。</text>
  </box>
  <icon name="arrow-down" color="secondary" size="lg"/>
  <box border radius="lg" padding={3} width="100%" gap={1}>
    **阶段 2：构造两种条件上下文**

    <text size="sm">学生：\(P_S+\hat y\)</text>
    <text size="sm">教师：\(P_T+\hat y\)</text>

    <text color="secondary" size="xs">教师提示词中包含标准答案；两者使用同一条学生轨迹。</text>
  </box>
  <icon name="arrow-down" color="secondary" size="lg"/>
  <box border radius="lg" padding={3} width="100%" gap={1}>
    **阶段 3：计算两组 logits**

    <text size="sm">使用 Transformer 前向计算，取得每个生成位置对应的概率分布。</text>
  </box>
  <icon name="arrow-down" color="secondary" size="lg"/>
  <box border radius="lg" padding={3} width="100%" gap={1}>
    **阶段 4：逐位置计算散度**

    <text size="sm">比较同一个学生前缀下的教师分布与学生分布。</text>
  </box>
  <icon name="arrow-down" color="secondary" size="lg"/>
  <box background="surface-secondary" radius="lg" padding={3} width="100%" gap={1}>
    **阶段 5：反向传播与更新参数**

    <text size="sm">让学生分布向教师目标靠近，再开始下一轮训练。</text>
  </box>
</box>

最后，我想帮你把最重要的区别固定下来：

**学生的轨迹是真正生成出来的；教师的轨迹并不存在。教师使用的是另一套提示词模板，但共享同一模型参数。它把标准答案放进上下文，再对学生实际生成的每一个前缀计算下一 Token 的概率分布。学生和教师的这些分布之间的差异，就是 OPSD 用来训练模型的信号。**

---

## Assistant
*2026-10-24 06:45*
> ❔ text

---

## User
*2026-10-24 09:59*
这里有一个关键细节：教师分布作为监督目标使用，梯度只通过学生分支的 logits 反向传播。由于教师和学生共享参数，更新的是模型的那套共同参数；下一轮教师分支也会使用更新后的参数。这个共享参数的细节你给我说一下
而且还有一个重要的问题，就是在什么时候进行介入？比如你刚才举的那个题，在最后一步才进行了教师模型的介入。那么这个散度到底是一直算，还是只算一次？

包括答案的话，肯定不只是只有一点点。如果是正常的生成小说的任务，那长得没边儿了，那啥时候更新呢？你也没给我说明白。

阶段 3：计算两组 logits
使用 Transformer 前向计算，取得每个生成位置对应的概率分布。
这不就相当于跑两遍吗 不过只是没有输出而已 只是逐个位置去算概率 然后求散度
我大概总结一下，就是先跑出一遍答案，然后根据这个轨迹，在每个位置去重新复现它当时的计算概率：

1. 学生轨迹：在生成轨迹的时候就已经算出来了。
2. 教师轨迹：在当前位置，将学生轨迹已有的 token 加上标准答案，看看输出是多少。

然后算一下 KL 散度，每个位置都这么算。

我不知道我这么说对不对，你需要帮我核实一下。另外，你也需要给我补充一下 KL 散度等相关概念，这个我也不懂。

---

## Assistant
*2026-10-24 09:59*
我会按论文的实际训练实现，把你总结的流程逐项核对。这里有一个必须纠正的细节：论文在方法定义中说师生共享参数，但实验里又明确将教师固定为初始模型；这两种说法需要区分。

---

## Assistant
*2026-10-24 09:59*
<details><summary>工具调用 · container.exec</summary>

```unknown
bash -lc sed -n '1,170p' /home/oai/skills/pdfs/SKILL.md
```

</details>

---

## Tool
*2026-10-24 09:59*
---
name: pdfs
description: Reliable, workflow-driven PDF processing: render → verify → operate → re-render/verify, covering reading, inspection, extraction, editing, forms, OCR, redaction, conversion, and diffing. Prefer authoring in DOCX or PPTX (then converting to PDF) for text-heavy docs or slide-like layouts; use ReportLab here for programmatic PDF generation.
---

# PDF Skill (Read • Inspect • Extract • Edit • Render • Forms • OCR • Redact • Convert • Diff)

This skill is designed for **reliable, workflow-driven** PDF work: **render -> verify -> operate -> re-render verify**.

## Before you touch PDFs: should this be DOCX/PPTX instead?

Even if the user asks for a PDF deliverable, the best workflow is often:

- **Text-heavy, business-doc layout (headings, TOC, long tables, rich lists)** -> use the **DOCX skill** to author, then convert to PDF with `lo_convert_to_pdf.py`.
- **Slide-like visual layout (charts, callouts, fixed positioning, figure captions)** -> use the **Slides skill** (PPTX) to author, then export to PDF.
- **Programmatic generation** -> ReportLab (this skill) is fine.

If you find yourself hand-tuning line breaks or typography in ReportLab, you probably picked the wrong authoring format.

---

## Core loop (always)

1) Render to images

```bash
python /home/oai/skills/pdfs/scripts/render_pdf.py input.pdf --out_dir /mnt/data/_renders/in --dpi 200
```

2) Inspect PNGs (tables/figures/layout are authoritative)

3) Perform the edit/extract/create

4) Re-render and compare

```bash
python /home/oai/skills/pdfs/scripts/compare_renders.py before.pdf after.pdf --out_dir /mnt/data/_diff --dpi 200
```

---

## Task index (progressive)

Start with the smallest task that answers the user:

### Read / review
- `tasks/read_review.md`

### Extract (text/layout/tables/images/attachments/forms)
- `tasks/extract.md`
- `tasks/coords.md` (coordinate sanity)

### Edit (merge/split/rotate/crop/watermark/paginate/encrypt/repair)
- `tasks/edit.md`
- `tasks/compare.md` (visual regression)

### Forms
- Fillable forms: `tasks/forms_annotations.md`
- Debugging/introspection: `tasks/forms_debugging.md`
- Non-fillable / stamping workflow: `tasks/forms_nonfillable.md`

### OCR
- `tasks/ocr.md`

### Preflight / normalize
- `tasks/preflight.md`

### Redaction
- `tasks/redact.md`

### Renderer parity
- `tasks/parity.md`

### Batch processing
- `tasks/batch.md`

### Create / convert
- `tasks/create.md`
- `tasks/convert.md`
- `tasks/js_tools.md` (pdf-lib, pdfjs)


---

## Package map (where things live)

This pack includes a `manifest.txt` that is a **pure list of relative file paths** used by download tooling.

Quick map:

- **tasks/** (what to do)
  - `read_review.md` - render-first reading/review
  - `extract.md` - extract text/layout/tables/images/attachments/forms
  - `coords.md` - coordinate system cheatsheet (PDF pt vs image px)
  - `edit.md` - merge/split/select/rotate/crop/watermark/paginate/encrypt/repair
  - `compare.md` - visual diff workflow
  - `forms_annotations.md` - fillable forms + appearance pitfalls + correctness checklist
  - `forms_debugging.md` - widget-level introspection + acceptable values
  - `forms_nonfillable.md` - stamp-by-boxes workflow for non-fillable forms
  - `ocr.md` - OCR scanned PDFs to searchable
  - `preflight.md` - quick triage + normalization guidance
  - `redact.md` - true redaction workflows
  - `parity.md` - render parity across engines
  - `batch.md` - batch helpers for corpora
  - `create.md` - choose reportlab/latex/html/docx/pptx pipeline
  - `convert.md` - docx/pptx/html/markdown/latex to PDF conversion
  - `js_tools.md` - pdf-lib/pdfjs helper CLIs

- **scripts/** (run these)
  - `render_pdf.py` - render to PNGs (pdfium or poppler)
  - `compare_renders.py` - render-and-diff two PDFs (pixel diff)
  - `pdf_inspect.py` - metadata/structure overview
  - `pdf_extract.py` - text/words/chars/tables/images/attachments/annots/forms
  - `pdf_edit.py` - editing toolkit (merge/split/select/rotate/crop/watermark/paginate/encrypt/repair/optimize)
  - `pdf_preflight.py` - preflight/triage warnings
  - `pdf_redact.py` - true redaction (remove underlying content)
  - `renderer_parity.py` - diff pdftoppm vs pdfium renders
  - `batch_pdf.py` - batch runner for common ops
  - `box_picker_html.py` - generate interactive HTML to pick rectangles -> JSON in PDF coords
  - `place_text_by_boxes.py` - stamp text/checkmarks into rectangles (non-fillable forms)
  - `ocr_pdf.py` - OCR wrapper
  - `html_to_pdf.py`, `md_to_pdf.py`, `latex_to_pdf.py`, `lo_convert_to_pdf.py` - conversion helpers

- **js/** (Node helpers)
  - `install_deps.sh` - installs pdf-lib + pdfjs-dist
  - `fill_form.mjs` - fill + optional flatten (supports flags and positional args)
  - `extract_form_fields.mjs` - list AcroForm fields
  - `extract_text_pdfjs.mjs` - extract text via pdfjs-dist

- **examples/**
  - `smoke_test.md` - runnable smoke flows

- **troubleshooting/**
  - `common.md` - common pitfalls and fixes

---

## Final deliverable expectations

- No clipped text, overlaps, black squares, or broken glyphs in rendered PNGs.
- Verify in at least **one** renderer (`pdfium` or `pdftoppm`). For tricky forms, verify in **two**.
- Remove intermediate artifacts from the deliverable folder (keep only final PDF(s)).
- Avoid Unicode dashes that some renderers mishandle; prefer ASCII `-`.


---

## Assistant
*2026-10-24 10:00*
你的总结基本正确，而且你已经抓住了 OPSD 的真正计算过程：**先让学生生成完整轨迹，再用同一条轨迹分别计算学生和教师的 Token 概率分布，求 KL 散度，最后通过反向传播更新模型。**

不过，我重新核对了论文的 §3.2、§4.1 和 Algorithm 1，发现有一个需要纠正的重要细节：

**论文在方法定义中让教师与学生共享参数，但在实际实验中，作者把教师固定为初始模型，而不是让教师始终跟着学生一起更新。** 这一点我之前没有区分清楚。<FileCite ref="turn0file0" line_range_start={533} line_range_end={540}/>

下面我按你关心的四件事讲：参数共享、教师什么时候介入、到底计算几次，以及 KL 散度怎样真正训练 Transformer。

## 一、首先，纠正并完善你的总结

| 你的理解 | 核实结果 |
|---|---|
| 1. 学生生成轨迹时已经算出了概率 | <icon name="check" color="success" inline/> 正确，但训练求梯度时通常还要重新前向计算 |
| 2. 教师使用标准答案和学生已有的 Token，重新计算概率 | <icon name="check" color="success" inline/> 正确，不过标准答案从教师提示词的开头就已经提供 |
| 3. 每个位置都计算一次 KL 散度 | <icon name="check" color="success" inline/> 正确，可以通过一次并行前向计算取得所有位置的 logits |
| 4. 每算一个 Token 的 KL 就立即更新模型 | <icon name="x" color="danger" inline/> 不对，通常汇总整条轨迹、整个 Batch 的损失后再更新 |
| 5. 教师和学生参数始终同步 | <icon name="x" color="danger" inline/> 论文方法定义如此，但正式实验把教师固定在初始参数 |

你现在缺少的其实只有一个概念：**训练时计算多少个 Token 的损失，与模型执行多少次参数更新，是两回事。**

---

## 二、教师和学生共享参数，到底是什么意思？

先从 Transformer 的参数说起。

一个 Transformer 可以抽象为：

\[
p_\theta(\cdot\mid x)
\]

其中 \(\theta\) 代表模型内部需要学习的所有参数，例如注意力层和前馈网络中的权重。

当输入发生变化时，即使模型参数完全相同，输出也可能不同。

例如：

\[
p_\theta(\cdot\mid\text{计算 }3+4)
\]

与

\[
p_\theta(\cdot\mid\text{计算 }3+4,\text{参考答案是 }7)
\]

这两组分布通常不完全一样。

原因很简单：**Transformer 不只由参数决定输出，也由上下文决定输出。**

### 1. 论文的方法定义：一套参数，两种上下文

作者最初将教师和学生定义为：

\[
p_S=p_\theta(\cdot\mid x)
\]

\[
p_T=p_\theta(\cdot\mid x,y^\star)
\]

在这个数学定义中，两者使用同一套参数 \(\theta\)。

如果严格按照这种共享权重方式训练，那么：

- 第 \(t\) 轮，教师与学生使用相同参数 \(\theta_t\)。
- 教师分支只负责计算监督目标，不通过教师分支反向传播。
- 学生分支产生梯度，优化器将参数更新为 \(\theta_{t+1}\)。
- 下一轮，两种上下文都会使用 \(\theta_{t+1}\)。

注意：**不通过教师分支反向传播，不等于共享的模型参数不会被更新。**

因为学生分支更新的就是两者共同使用的那套参数。

### 2. 论文的实际实验：教师冻结，学生更新

而作者在 §4.1 中明确采用了一个更稳定的实现：**教师固定为训练开始时的初始策略。**

也就是说，假设初始模型参数是 \(\theta_0\)：

<box border radius="xl" padding={3} gap={2}>
  <grid columns={2} gap={3}>
    <grid-item>
      <box background="surface-secondary" radius="lg" padding={3} gap={2} height="100%">
        <title size="md">教师 Teacher</title>
        <title size="xl" color="default">\(\theta_0\)</title>
        <badge>固定初始参数</badge>
        <text size="sm">一直使用初始模型，额外输入标准答案。</text>
      </box>
    </grid-item>
    <grid-item>
      <box background="surface-secondary" radius="lg" padding={3} gap={2} height="100%">
        <title size="md">学生 Student</title>
        <title size="xl" color="default">\(\theta_t\)</title>
        <badge color="success">持续训练</badge>
        <text size="sm">根据逐 Token 蒸馏损失更新参数。</text>
      </box>
    </grid-item>
  </grid>
  <divider color="subtle"/>
  <text size="sm" color="secondary">两者来自同一个预训练模型，具有相同的模型结构和初始能力；学生更新后，教师仍然保持原来的参数。</text>
</box>

于是实际实验更准确的数学表达是：

\[
p_T=p_{\theta_0}(\cdot\mid x,y^\star)
\]

\[
p_S=p_{\theta_t}(\cdot\mid x)
\]

这就回答了一个非常重要的问题：

**为什么一个不随训练更新的教师，还能教不断变强的学生？**

因为教师虽然参数固定，但它能看到学生看不到的标准答案。

学生需要学习的是：如何把教师借助额外上下文才能表现出来的能力，逐渐内化到自己的参数中。

这也是一种典型的知识蒸馏思想。它不要求教师和学生的参数始终相同，只要求教师提供有价值的监督分布。

论文表示，固定教师有助于稳定训练，并限制学生偏离初始策略过远。它仍被称为自蒸馏，因为教师来自同一个初始模型，而不是一个独立训练的、更大的外部模型。

---

## 三、教师究竟什么时候介入？KL 是一直算，还是只算一次？

这是你最关心的问题。我们用一条时间线来解释。

假设一条学生轨迹有 100 个 Token。

<box border radius="xl" padding={3} gap={3}>
  <box gap={1}>
    <title size="md">阶段 A：生成学生轨迹</title>
    <text color="secondary" size="sm">先生成，再计算训练损失</text>
    <row gap="3px">
      {#each Array.from({length:10},(_,i)=>i) as i}
        <box flex="1" background="rgba(59,130,246,0.15)" radius="xs" padding={{y:2,x:0}} align="center">
          <text size="3xs" color="default">{i*10+1}–{i*10+10}</text>
        </box>
      {/each}
    </row>
    <caption>学生自回归生成 Token 1–100。此时不需要每生成一个 Token 就更新模型。</caption>
  </box>
  <divider color="subtle"/>
  <box gap={1}>
    <title size="md">阶段 B：教师与学生评估轨迹</title>
    <row gap="3px">
      {#each Array.from({length:10},(_,i)=>i) as i}
        <box flex="1" background="rgba(22,163,74,0.17)" radius="xs" padding={{y:2,x:0}} align="center">
          <text size="3xs" color="default">{i*10+1}–{i*10+10}</text>
        </box>
      {/each}
    </row>
    <caption>在同一条轨迹的 100 个预测位置，分别得到教师分布和学生分布，并计算 100 个散度值。</caption>
  </box>
  <divider color="subtle"/>
  <box gap={1}>
    <title size="md">阶段 C：汇总损失</title>
    \[
    \ell=\frac{1}{100}\sum_{n=1}^{100}D_n
    \]
    得到这条轨迹的一个标量损失。
  </box>
  <divider color="subtle"/>
  <box gap={1}>
    <title size="md">阶段 D：反向传播与参数更新</title>
    <row align="center" gap={2}>
      <box background="surface-secondary" radius="md" padding={3} flex="1" align="center">
        **反向传播**
      </box>
      <icon name="arrow-right" color="secondary"/>
      <box background="surface-secondary" radius="md" padding={3} flex="1" align="center">
        **优化器更新**
      </box>
    </row>
    <caption>如果使用 Batch 训练，还需要先汇总 Batch 内多条轨迹的损失。</caption>
  </box>
</box>

所以，需要区分两个数量：

- **KL 计算的数量：** 一条 100 Token 的轨迹，会在 100 个预测位置计算散度。
- **参数更新的数量：** 不一定是 100 次。按照论文的 Mini-batch 训练方式，汇总整个 Batch 的损失后，再执行一次优化步骤（不考虑可能存在的梯度累积细节）。

这才是它真正的训练节奏。

### 那教师是不是要运行 100 次 Transformer？

不需要。

这里就涉及你对 Transformer 的 Prefill 和 Decode 的理解。

对于一个采用因果注意力机制的 Transformer，只要给定完整的输入序列，它可以在一次前向传播中，并行计算每一个位置的 logits。

例如：

输入：

`计算 3+4。答案：3+4=8`

Transformer 能够计算：

| 位置 | 当前可见的回答前缀 | 预测什么 |
|---|---|---|
| 1 | 空 | 第 1 个 Token |
| 2 | `3` | 第 2 个 Token |
| 3 | `3+` | 第 3 个 Token |
| 4 | `3+4` | 第 4 个 Token |
| 5 | `3+4=` | 第 5 个 Token |

因为存在 Causal Mask，位置 2 不能偷看位置 3、4、5 的答案 Token。

**因此，在计算训练损失时，可以把已知的完整学生轨迹送入 Transformer，一次前向计算得到所有生成位置的 logits，而不用像自回归生成一样逐个采样。**

这和 SFT 中常见的 Teacher Forcing（教师强制）计算方式非常接近，只不过 OPSD 使用的监督目标是教师概率分布，而不是简单的正确 Token 标签。

## 四、你说“相当于跑两遍”，到底对不对？

**对，甚至需要区分三项计算开销。**

| 计算 | 做什么 | 是否需要生成新 Token |
|---|---|---|
| 学生 Rollout | 自回归采样，得到学生自己的轨迹 | 是 |
| 教师 Forward | 在教师提示词和学生轨迹上计算目标 logits | 否 |
| 学生训练 Forward / Backward | 在学生轨迹上计算 logits、损失和梯度 | 否 |

你可能会问：

学生在生成轨迹的时候，不是已经计算过 logits 了吗？为什么还需要重新计算？

因为通常在生成阶段，我们不保留用于反向传播的完整计算图。虽然已经得到了每一步的预测概率，但这些数值本身不足以完成之后的反向传播。

因此，在常见实现中，需要重新对固定的学生轨迹执行学生分支的前向计算，建立梯度计算所需的计算图。

这个计算过程可以并行处理多个 Token 位置。

所以 OPSD 并不是没有额外成本：

- 要生成学生轨迹。
- 要计算教师 logits。
- 要进行学生的训练前向传播和反向传播。

作者强调的是 **生成 Token 的效率与训练效果**，不能简单理解为 OPSD 的总训练计算量必然比所有其他方法更低。

论文正式实验采用全词表 logits 蒸馏，也明确指出了这种方法可能带来较高的显存占用。<FileCite ref="turn0file0" line_range_start={746} line_range_end={801}/>

---

## 五、现在用真实数字理解 KL 散度

这部分是理解它怎么训练的关键。

### 1. 什么是 KL 散度？

KL 散度（Kullback–Leibler Divergence）用于衡量两个概率分布的差异。

在 OPSD 中，教师给出目标分布 \(p_T\)，学生给出预测分布 \(p_S\)。

以论文实验中主要使用的前向 KL 为例：

\[
D_{\mathrm{KL}}(p_T\Vert p_S)
=\sum_{v\in\mathcal V}
p_T(v)\ln\frac{p_T(v)}{p_S(v)}
\]

我们把这个公式拆开：

- \(\mathcal V\)：词表，包含所有可能的候选 Token。
- \(p_T(v)\)：教师认为 Token \(v\) 出现的概率。
- \(p_S(v)\)：学生认为 Token \(v\) 出现的概率。
- \(\ln\)：自然对数。
- \(\sum\)：遍历所有候选 Token，将贡献相加。

如果两个分布完全相同，KL 散度就是 0；如果不同，KL 散度大于 0。

需要注意，KL 散度通常不对称：

\[
D_{\mathrm{KL}}(p_T\Vert p_S)
\ne D_{\mathrm{KL}}(p_S\Vert p_T)
\]

论文还比较了反向 KL 和 JSD，但我们先掌握前向 KL 就足够了。

### 2. 亲手计算一次 KL

继续使用前面的教学示例：

| Token | 教师概率 \(p_T\) | 学生概率 \(p_S\) |
|---|---:|---:|
| `7` | 0.8 | 0.2 |
| `8` | 0.1 | 0.7 |
| `9` | 0.1 | 0.1 |

代入公式：

\[
\begin{aligned}
D_{\mathrm{KL}}(p_T\Vert p_S)
={}&0.8\ln\frac{0.8}{0.2}\\
&+0.1\ln\frac{0.1}{0.7}\\
&+0.1\ln\frac{0.1}{0.1}
\end{aligned}
\]

最后得到：

\[
\boxed{D_{\mathrm{KL}}\approx0.914}
\]

这表示在当前这个位置上，学生与教师分布存在明显差异。

<box border radius="xl" padding={3} gap={2}>
  <text color="secondary" size="sm">你可以尝试调整学生对 `7` 的预测概率，直观感受 KL 如何变化。其余概率按原有比例分配。</text>
  {@body const [p7,setP7] = DIL.useState(0.2)}
  {@body const p8=(1-p7)*0.875}
  {@body const p9=(1-p7)*0.125}
  {@body const teacher=[0.8,0.1,0.1]}
  {@body const student=[p7,p8,p9]}
  {@body const kl=teacher.reduce((s,p,i)=>s+p*Math.log(p/student[i]),0)}
  <row align="center" justify="between">
    **学生预测 `7` 的概率**
    <title size="md" tabularNums>{(p7*100).toFixed(1)}%</title>
  </row>
  <slider min={0.05} max={0.95} step={0.01} value={p7} onChange={setP7}/>
  <table>
    <table-row><table-cell>Token</table-cell><table-cell>教师概率</table-cell><table-cell>学生概率</table-cell></table-row>
    {#each ["7","8","9"] as tk,i}
      <table-row>
        <table-cell>{tk}</table-cell>
        <table-cell>{(teacher[i]*100).toFixed(1)}%</table-cell>
        <table-cell>{(student[i]*100).toFixed(1)}%</table-cell>
      </table-row>
    {/each}
  </table>
  <box background="surface-secondary" radius="lg" padding={3} gap={1}>
    <text color="secondary" size="xs">当前 KL 散度（nat）</text>
    <title size="2xl" tabularNums>{kl.toFixed(4)}</title>
    <text size="sm">{kl<0.02?"学生分布已经非常接近教师分布。":p7<0.8?"尝试调高学生对正确答案 `7` 的概率，观察散度如何降低。":"继续调节，注意 KL 在两个分布完全一致时达到 0。"}</text>
  </box>
</box>

### 3. KL 算出来以后，究竟怎么改变模型参数？

再深入一步，你就能明白 OPSD 的优化机制。

当我们将教师分布视为固定目标、使用未经裁剪的前向 KL 时，损失对学生 logit \(z_v\) 的梯度有一个很直观的形式：

\[
\frac{\partial D_{\mathrm{KL}}}{\partial z_v}
=p_S(v)-p_T(v)
\]

这非常重要。

对于刚才的三个 Token：

| Token | 学生−教师 | 梯度下降时的变化趋势 |
|---|---:|---|
| `7` | \(0.2-0.8=-0.6\) | 提高 `7` 的 logit |
| `8` | \(0.7-0.1=+0.6\) | 降低 `8` 的 logit |
| `9` | \(0.1-0.1=0\) | 该 logit 的直接梯度为零 |

这就是 KL 如何转化为训练信号的直观解释。

优化器不是直接改写这三个概率，而是利用反向传播将梯度传到 Transformer 的可训练权重，更新参数，再由新的参数产生新的概率分布。

上面解释的是没有裁剪的前向 KL。OPSD 还引入了逐点 KL 裁剪来稳定训练，因此实际裁剪损失的梯度不一定完全等于这个简化公式。

---

## 六、如果答案很长，比如写小说，那什么时候更新？

你举的小说例子非常好，因为它揭示了 OPSD 的适用范围和计算限制。

先说训练机制：**OPSD 不要求每生成一个 Token 就立即更新模型，而是按训练样本和 Batch 进行优化。**

例如，我们有 32 道数学题，采用 Batch Size = 32：

1. 学生分别对 32 道题生成轨迹。
2. 教师对每条学生轨迹提供概率分布。
3. 计算每条轨迹各位置的 KL 散度。
4. 对每条轨迹的有效 Token 损失取平均。
5. 汇总 32 条轨迹，得到一个 Batch Loss。
6. 反向传播，进行一次优化器更新。

如果有的轨迹长 200 Token，有的长 800 Token，也不需要完全相同。通过有效长度归一化与 padding mask，就可以进行 Batch 计算。

### 论文实际上怎么做？

根据论文的实验设置：

| 参数 | OPSD 实验设置 |
|---|---|
| 模型 | Qwen3-1.7B / 4B / 8B |
| 有效 Batch Size | 32 |
| 每题学生 Rollout 数量 | 1 |
| 主要实验最大生成长度 | 1024 Token |
| 主要训练步数 | 100 |
| 训练方式 | LoRA |
| 教师 | 固定初始策略 |

这些是论文使用的实验配置，并不是 OPSD 算法理论上必须采用的参数。<FileCite ref="turn0file0" line_range_start={1190} line_range_end={1207}/>

论文还比较过 1024 和 4096 Token 的生成长度，并发现更长的生成并没有带来一致的性能提升。<FileCite ref="turn0file0" line_range_start={715} line_range_end={740}/>

### 那如果是 10 万 Token 的小说？

这种场景有两个额外问题。

**第一，计算代价。** 如果对整个长序列计算逐 Token 的全词表分布，计算和显存需求会变得很高，还可能超过模型的上下文窗口。

**第二，也是更根本的问题：哪里来的标准答案？**

数学题通常具有可验证的参考解答，教师能够利用这个答案理解问题。但是小说创作往往不存在唯一正确解法。

因此，这篇 OPSD 论文主要研究的是具有参考答案的数学推理任务，没有证明原方法可以直接扩展到任意长度的开放式小说生成。

对于特别长的序列，可以研究分段训练、长度预算、局部监督等扩展方式，但这些不应被当成论文已经实现的机制。

---

## 七、把你现在的理解整理成最终版本

你可以这样理解整篇 OPSD 的训练：

<box border radius="xl" padding={3} gap={2}>
  <list marker="number" gap={2}>
    <list-item>**初始化教师和学生。** 从同一个基础模型出发。在论文正式实验中，教师固定为初始策略，学生参与训练。</list-item>
    <list-item>**学生 Rollout。** 学生只根据题目生成一条完整轨迹，例如 200 Token。</list-item>
    <list-item>**重新评估学生轨迹。** 使用两套不同提示词，把相同学生轨迹输入学生与教师分支。教师额外拥有标准答案。</list-item>
    <list-item>**计算 Token 分布。** 分别得到学生与教师在 200 个生成位置的概率分布；通过 Transformer 的因果注意力计算这些位置，不需要让教师重新生成答案。</list-item>
    <list-item>**计算 KL 损失。** 每个位置比较两套概率分布，汇总得到轨迹平均损失，再汇总 Batch 损失。</list-item>
    <list-item>**反向传播更新学生。** 教师作为固定监督目标，梯度通过学生分支传播，完成一次优化步骤。</list-item>
    <list-item>**下一轮重新采样。** 使用更新后的学生模型处理新的训练批次，重复上述流程。</list-item>
  </list>
</box>

最后再强调两个容易混淆的点：

**第一，“每个 Token 计算 KL”不等于“每个 Token 更新一次参数”。** 一条轨迹可以产生上百、上千个 KL 项，但通常汇总整个 Batch 后才执行一次参数更新。

**第二，“自蒸馏”不等于“教师和学生的参数在整个训练过程中始终相同”。** 在这篇论文里，两者来自相同的初始模型，但作者的正式实验固定教师，仅更新学生。

如果你要真正掌握这篇论文，我认为下一步最值得理解的是：**既然教师没有比学生更大的模型参数，只是多看了标准答案，为什么它产生的概率分布就有可能比学生更有价值？** 这是 OPSD 的核心假设，也直接决定这项研究为什么可能有效、又会在什么条件下失效。

---

## Assistant
*2026-10-24 10:01*
> ❔ text

---

## User
*2026-10-24 10:04*
根据逐 Token 蒸馏损失更新参数。这个是什么意思，如果你说 1 你这个训练肯定是后训练了 相当于还是啥 我需要知道它与 SFT 的区别 你说什么蒸馏啥的 我也不太懂 还是说目前这个范式 弄完一轮之后通过散度去计算 然后来更新参数 不然的话 和之前的传统方案感觉没区别了

---

## Assistant
*2026-10-24 10:04*
<details><summary>工具调用 · container.exec</summary>

```unknown
bash -lc cat /home/oai/skills/pdfs/SKILL.md
```

</details>

---

## Tool
*2026-10-24 10:04*
---
name: pdfs
description: Reliable, workflow-driven PDF processing: render → verify → operate → re-render/verify, covering reading, inspection, extraction, editing, forms, OCR, redaction, conversion, and diffing. Prefer authoring in DOCX or PPTX (then converting to PDF) for text-heavy docs or slide-like layouts; use ReportLab here for programmatic PDF generation.
---

# PDF Skill (Read • Inspect • Extract • Edit • Render • Forms • OCR • Redact • Convert • Diff)

This skill is designed for **reliable, workflow-driven** PDF work: **render -> verify -> operate -> re-render verify**.

## Before you touch PDFs: should this be DOCX/PPTX instead?

Even if the user asks for a PDF deliverable, the best workflow is often:

- **Text-heavy, business-doc layout (headings, TOC, long tables, rich lists)** -> use the **DOCX skill** to author, then convert to PDF with `lo_convert_to_pdf.py`.
- **Slide-like visual layout (charts, callouts, fixed positioning, figure captions)** -> use the **Slides skill** (PPTX) to author, then export to PDF.
- **Programmatic generation** -> ReportLab (this skill) is fine.

If you find yourself hand-tuning line breaks or typography in ReportLab, you probably picked the wrong authoring format.

---

## Core loop (always)

1) Render to images

```bash
python /home/oai/skills/pdfs/scripts/render_pdf.py input.pdf --out_dir /mnt/data/_renders/in --dpi 200
```

2) Inspect PNGs (tables/figures/layout are authoritative)

3) Perform the edit/extract/create

4) Re-render and compare

```bash
python /home/oai/skills/pdfs/scripts/compare_renders.py before.pdf after.pdf --out_dir /mnt/data/_diff --dpi 200
```

---

## Task index (progressive)

Start with the smallest task that answers the user:

### Read / review
- `tasks/read_review.md`

### Extract (text/layout/tables/images/attachments/forms)
- `tasks/extract.md`
- `tasks/coords.md` (coordinate sanity)

### Edit (merge/split/rotate/crop/watermark/paginate/encrypt/repair)
- `tasks/edit.md`
- `tasks/compare.md` (visual regression)

### Forms
- Fillable forms: `tasks/forms_annotations.md`
- Debugging/introspection: `tasks/forms_debugging.md`
- Non-fillable / stamping workflow: `tasks/forms_nonfillable.md`

### OCR
- `tasks/ocr.md`

### Preflight / normalize
- `tasks/preflight.md`

### Redaction
- `tasks/redact.md`

### Renderer parity
- `tasks/parity.md`

### Batch processing
- `tasks/batch.md`

### Create / convert
- `tasks/create.md`
- `tasks/convert.md`
- `tasks/js_tools.md` (pdf-lib, pdfjs)


---

## Package map (where things live)

This pack includes a `manifest.txt` that is a **pure list of relative file paths** used by download tooling.

Quick map:

- **tasks/** (what to do)
  - `read_review.md` - render-first reading/review
  - `extract.md` - extract text/layout/tables/images/attachments/forms
  - `coords.md` - coordinate system cheatsheet (PDF pt vs image px)
  - `edit.md` - merge/split/select/rotate/crop/watermark/paginate/encrypt/repair
  - `compare.md` - visual diff workflow
  - `forms_annotations.md` - fillable forms + appearance pitfalls + correctness checklist
  - `forms_debugging.md` - widget-level introspection + acceptable values
  - `forms_nonfillable.md` - stamp-by-boxes workflow for non-fillable forms
  - `ocr.md` - OCR scanned PDFs to searchable
  - `preflight.md` - quick triage + normalization guidance
  - `redact.md` - true redaction workflows
  - `parity.md` - render parity across engines
  - `batch.md` - batch helpers for corpora
  - `create.md` - choose reportlab/latex/html/docx/pptx pipeline
  - `convert.md` - docx/pptx/html/markdown/latex to PDF conversion
  - `js_tools.md` - pdf-lib/pdfjs helper CLIs

- **scripts/** (run these)
  - `render_pdf.py` - render to PNGs (pdfium or poppler)
  - `compare_renders.py` - render-and-diff two PDFs (pixel diff)
  - `pdf_inspect.py` - metadata/structure overview
  - `pdf_extract.py` - text/words/chars/tables/images/attachments/annots/forms
  - `pdf_edit.py` - editing toolkit (merge/split/select/rotate/crop/watermark/paginate/encrypt/repair/optimize)
  - `pdf_preflight.py` - preflight/triage warnings
  - `pdf_redact.py` - true redaction (remove underlying content)
  - `renderer_parity.py` - diff pdftoppm vs pdfium renders
  - `batch_pdf.py` - batch runner for common ops
  - `box_picker_html.py` - generate interactive HTML to pick rectangles -> JSON in PDF coords
  - `place_text_by_boxes.py` - stamp text/checkmarks into rectangles (non-fillable forms)
  - `ocr_pdf.py` - OCR wrapper
  - `html_to_pdf.py`, `md_to_pdf.py`, `latex_to_pdf.py`, `lo_convert_to_pdf.py` - conversion helpers

- **js/** (Node helpers)
  - `install_deps.sh` - installs pdf-lib + pdfjs-dist
  - `fill_form.mjs` - fill + optional flatten (supports flags and positional args)
  - `extract_form_fields.mjs` - list AcroForm fields
  - `extract_text_pdfjs.mjs` - extract text via pdfjs-dist

- **examples/**
  - `smoke_test.md` - runnable smoke flows

- **troubleshooting/**
  - `common.md` - common pitfalls and fixes

---

## Final deliverable expectations

- No clipped text, overlaps, black squares, or broken glyphs in rendered PNGs.
- Verify in at least **one** renderer (`pdfium` or `pdftoppm`). For tricky forms, verify in **two**.
- Remove intermediate artifacts from the deliverable folder (keep only final PDF(s)).
- Avoid Unicode dashes that some renderers mishandle; prefer ASCII `-`.


---

## Assistant
*2026-10-24 10:04*
**对，你现在的理解是正确的：OPSD 本质上也是一种后训练（Post-training）方法。它和 SFT 一样，最终都需要计算 Loss，然后反向传播，更新 Transformer 的参数。**

真正的区别不在于“怎么更新参数”，而在于：

**SFT 让模型模仿标准答案；OPSD 让模型模仿一个看过标准答案的教师所给出的概率分布。**

这是两种不同的学习信号。

## 一、先理解 SFT 和 OPSD 的本质区别

假设我们已经有一个 Qwen3 模型，想进一步提高它的数学推理能力。

训练数据中有一道题：

\[
3+4=?
\]

标准解答是：

`3 + 4 = 7`

### 方案 A：传统 SFT 怎么训练？

SFT 的过程很简单：

1. 把题目和标准解答提供给模型。
2. 模型按照标准解答的前缀预测下一个 Token。
3. 检查模型对标准 Token 分配了多大的概率。
4. 计算交叉熵损失（Cross Entropy Loss）。
5. 反向传播，更新模型参数。

例如在预测最后一个 Token 时：

输入：`3+4=`

模型预测：

| Token | 模型概率 |
|---|---:|
| `7` | 20% |
| `8` | 70% |
| `9` | 10% |

但标准答案是 `7`。

所以 SFT 的目标很明确：

**让模型提高对 `7` 的预测概率，降低对其他 Token 的预测概率。**

对应的损失为：

\[
\mathcal L_{\mathrm{SFT}}=-\log p_\theta(7\mid 3+4=)
\]

如果模型给正确 Token 的概率越高，损失就越低。

这里标准答案是一个确定标签，模型直接学习这个标签。

### 方案 B：OPSD 怎么训练？

OPSD 则多了一个关键步骤。

1. 学生先根据题目自己生成一条完整轨迹。
2. 教师看到标准答案，对学生轨迹的每个位置计算下一 Token 概率分布。
3. 学生也对同一轨迹计算概率分布。
4. 比较两者的分布，得到 KL Loss。
5. 反向传播，更新学生模型。

例如，还是预测 `3+4=` 之后的下一个 Token：

| Token | 学生概率 | 教师概率 |
|---|---:|---:|
| `7` | 20% | 80% |
| `8` | 70% | 10% |
| `9` | 10% | 10% |

OPSD 并不是直接告诉学生 `7` 是唯一的正确标签，而是要求学生的概率分布向教师分布靠近。

因此：

\[
\mathcal L_{\mathrm{OPSD}}
=D_{\mathrm{KL}}(p_T\Vert p_S)
\]

注意两者的重要区别：

- SFT 的目标是一个确定的正确 Token（硬标签）。
- OPSD 的目标是教师在整个词表上的概率分布（软标签）。

这就是所谓的 **知识蒸馏（Knowledge Distillation）**：让学生学习教师给出的概率分布，而不只是学习某一个确定答案。

## 二、为什么两者都能更新 Transformer 参数？

其实，它们底层的优化机制非常相似。

我们看刚才的例子。

学生当前的预测概率是：

\[
p_S=[0.2,\ 0.7,\ 0.1]
\]

SFT 和 OPSD 的训练目标分别是：

<box border radius="xl" padding={3} gap={3}>
  <grid columns={2} gap={3}>
    <grid-item>
      <box gap={2}>
        <title size="md">SFT：硬标签</title>
        <text color="secondary" size="xs">目标概率分布</text>
        {#each [{t:"7",p:1},{t:"8",p:0},{t:"9",p:0}] as v}
          <box gap={1}>
            <row justify="between">
              <text size="sm">{v.t}</text>
              <text size="xs" color="secondary">{v.p*100}%</text>
            </row>
            <box background="surface-tertiary" height="9px" radius="sm" clip>
              <box background="#64748b" width={`${v.p*100}%`} height="100%"/>
            </box>
          </box>
        {/each}
      </box>
    </grid-item>
    <grid-item>
      <box gap={2}>
        <title size="md">OPSD：软标签</title>
        <text color="secondary" size="xs">教师目标概率分布</text>
        {#each [{t:"7",p:.8},{t:"8",p:.1},{t:"9",p:.1}] as v}
          <box gap={1}>
            <row justify="between">
              <text size="sm">{v.t}</text>
              <text size="xs" color="secondary">{v.p*100}%</text>
            </row>
            <box background="surface-tertiary" height="9px" radius="sm" clip>
              <box background="#64748b" width={`${v.p*100}%`} height="100%"/>
            </box>
          </box>
        {/each}
      </box>
    </grid-item>
  </grid>
  <divider color="subtle"/>
  <text color="secondary" size="sm">两个目标都鼓励模型提高 `7` 的概率，但优化方向和程度并不完全一样。</text>
</box>

现在，我们再引入一点点梯度的知识。

模型会先产生 logits，经过 Softmax 得到概率分布。

如果目标分布为 \(q\)，那么标准交叉熵在学生 logits 上的梯度是：

\[
\frac{\partial \mathcal L}{\partial z_v}
=p_S(v)-q(v)
\]

在固定教师目标且没有裁剪时，前向 KL 对学生 logits 也有同样形式的梯度。

所以：

| Token | SFT 的梯度 | OPSD 的梯度 |
|---|---:|---:|
| `7` | \(0.2-1=-0.8\) | \(0.2-0.8=-0.6\) |
| `8` | \(0.7-0=0.7\) | \(0.7-0.1=0.6\) |
| `9` | \(0.1-0=0.1\) | \(0.1-0.1=0\) |

这些梯度再通过反向传播传递到 Transformer 的可训练参数中，由优化器更新权重。

你可以看到：

**SFT 和 OPSD 并没有发明两种完全不同的参数更新技术，而是在使用不同的训练目标，产生不同的梯度。**

实际 OPSD 还使用了散度裁剪，所以它的完整训练损失会比这里的示例复杂一些。

## 三、但只有软标签还不够，OPSD 真正重要的是 On-Policy

如果只讨论硬标签与软标签，OPSD 确实与传统知识蒸馏非常接近。

但它还有第二个重要区别：**它在学生自己生成的轨迹上训练，而不是只在标准答案轨迹上训练。**

举个稍微复杂一点的例子。

假设标准推理是：

`3 + 4 = 7`

但是学生生成了：

`3 + 5 = 8`

SFT 主要学习的是标准轨迹：

`3 → + → 4 → = → 7`

而 OPSD 会在学生自己生成的轨迹：

`3 → + → 5 → = → 8`

上计算学生与教师的分布差异。

在学生已经生成 `3+5=` 的时候，教师依然会在看到原题和参考解答的条件下，计算这个学生前缀之后的预测分布。

注意：这不保证教师一定能把错误前缀纠正回来。OPSD 是让教师在学生实际访问的上下文中提供监督，不是保证每个位置的分布都正确。

这就是 On-Policy 的意义：

**不是永远按照标准轨迹训练，而是让学生在自己真实走过的生成路径上接受指导。** <FileCite ref="turn0file0" line_range_start={326} line_range_end={341}/>

## 四、所以 OPSD 一轮训练到底在做什么？

你提出的理解：

> 弄完一轮之后通过散度去计算，然后来更新参数。

基本正确，但要区分“一轮生成”和“一次参数更新”。

以论文中的有效 Batch Size = 32 为例：

<box border radius="xl" padding={3} gap={2}>
  <list marker="number" gap={3}>
    <list-item>
      **准备一个 Batch**

      选取 32 道带参考解答的数学题。
    </list-item>
    <list-item>
      **学生生成 Rollout**

      每道题生成一条自己的回答轨迹，总共 32 条。每条轨迹可能长短不同。
    </list-item>
    <list-item>
      **教师评估**

      教师利用标准答案，对这 32 条学生轨迹的各个有效位置计算概率分布。
    </list-item>
    <list-item>
      **计算 Loss**

      每条轨迹沿 Token 位置计算 KL 散度并取平均，然后汇总 32 道题的损失。
    </list-item>
    <list-item>
      **执行一次优化器更新**

      对 Batch Loss 反向传播，更新学生的可训练参数。论文采用 LoRA 进行后训练。
    </list-item>
    <list-item>
      **进入下一个训练 Step**

      使用更新后的学生模型生成新轨迹，继续重复。
    </list-item>
  </list>
</box>

这是论文 Algorithm 1 的基本学习流程。实验中作者固定教师为初始策略，更新学生，使用 AdamW 和 LoRA。<FileCite ref="turn0file0" line_range_start={351} line_range_end={372}/><FileCite ref="turn0file0" line_range_start={533} line_range_end={545}/>

## 五、最后，OPSD 与 SFT 到底有多大区别？

| 比较 | SFT | OPSD |
|---|---|---|
| 是否属于后训练 | 是 | 是 |
| 是否需要标准答案 | 是 | 是 |
| 是否使用反向传播 | 是 | 是 |
| 训练轨迹来自哪里 | 参考答案轨迹 | 学生当前策略生成的轨迹 |
| 训练目标 | 正确 Token 的硬标签 | 教师提供的软概率分布 |
| 是否需要额外采样学生轨迹 | 通常不需要 | 需要 |
| 是否使用教师分支 | 常规 SFT 不需要 | 需要 |
| 损失函数 | 交叉熵 CE | 逐 Token 分布散度，如 KL |
| 最后更新什么 | 模型参数 | 学生模型参数 |

作者的创新并不是发明了一种全新的反向传播机制，而是把 **学生同策略采样、利用参考答案构造教师分布、逐 Token 软蒸馏** 结合起来，希望比直接 SFT 或 GRPO 更有效地利用推理数据。

而论文的实验确实报告，在所测试的 Qwen3 数学推理设置中，OPSD 优于 SFT，并达到或超过 GRPO 的整体表现；但这是特定数据与实验配置下的结果，不能直接推广到所有任务。<FileCite ref="turn0file0" line_range_start={582} line_range_end={608}/>

**最值得记住的一句话：SFT 是“标准答案告诉你应该生成什么”，OPSD 是“你先自己生成，教师结合标准答案告诉你，在你走过的各个位置应该如何调整预测概率”。两者最终都是计算损失、反向传播、更新参数。**

你感觉它与传统方案很接近，这个判断并没有错。OPSD 的创新主要在**训练数据从哪里来、监督信号怎么构造**，而不是模型架构或优化器本身。

---

## User
*2026-10-24 12:16*
这种范式对比 sft 包括 gpro 啥的会有什么优势吗

---

## Assistant
*2026-10-24 12:17*
有，而且我认为 OPSD 相比 SFT 和 GRPO 的优势，主要体现在**监督信号的质量、Token 利用效率以及训练样本分布**三个方面。

但需要强调：**OPSD 并不是在所有方面都优于 SFT 和 GRPO。它利用更多计算来构造高质量监督信号，试图用更少的生成 Token 获得更好的训练效果。**

我们结合这篇论文的实际实验，来分析这个问题。

## 一、先看三种方法的根本区别

假设有一道数学题，学生模型目前只能以 20% 的概率答对。

| 方法 | 学生怎么学习 | 最主要的问题 |
|---|---|---|
| SFT | 直接学习标准解答中的 Token | 只学习固定的专家轨迹，存在分布偏移 |
| GRPO | 自己生成多条答案，根据正确率获得奖励 | 奖励稀疏、采样昂贵 |
| OPSD | 自己生成轨迹，再学习看过标准答案的教师分布 | 需要教师额外计算，且教师监督未必正确 |

### 1. 相比 SFT：OPSD 能够利用学生自己犯的错误

假设标准解答是：

`3 + 4 = 7`

但是学生实际生成：

`3 + 4 = 8`

**SFT：** 直接让学生学习 `3+4=7`，提高生成标准 Token 的概率。

**OPSD：** 学生先生成 `3+4=8`，然后教师利用标准答案，对学生轨迹的各个位置提供概率分布，让学生在自己实际访问的上下文中接受训练。

区别是：

- SFT 学的是“标准答案如何生成”。
- OPSD 学的是“在我自己的生成路径上，拥有标准答案信息的教师会怎样预测”。

这就有可能减轻 SFT 的 Exposure Bias（暴露偏差）。

不过，这不意味着 SFT 永远不能在错误轨迹上训练。区别在于论文所比较的**标准 SFT 设置**通常使用固定的专家轨迹。

### 2. 相比 GRPO：OPSD 不必等最终答案才能获得学习信号

这是我认为最重要的优势。

假设学生针对同一道题生成了 4 个答案：

| 轨迹 | 最终是否正确 | GRPO 的组内奖励情况 | OPSD |
|---|---|---|---|
| A | 错误 | 0 | 可以计算逐 Token 散度 |
| B | 错误 | 0 | 可以计算逐 Token 散度 |
| C | 错误 | 0 | 可以计算逐 Token 散度 |
| D | 错误 | 0 | 可以计算逐 Token 散度 |

由于 GRPO 这组答案全部错误，组内的奖励没有差异：

\[
A_i=\frac{r_i-\operatorname{mean}(r)}{\operatorname{std}(r)}
\]

在通常的零方差处理下，优势信号为零。

**结果就是：GRPO 生成了四条答案，却没有得到有效的组相对学习信号。**

OPSD 不一样。

即使最终答案全部错误，教师仍然可以利用参考答案，对学生每个生成位置计算概率分布差异：

\[
D_n=D_{\mathrm{KL}}(p_T^{(n)}\Vert p_S^{(n)})
\]

于是，不依赖最终答案是否正确，也可以产生训练信号。

但有一点必须区分：**逐 Token KL 是密集的监督信号，不等于教师准确地判断出了每一步的数学错误。** 教师本身仍然可能判断失误。

---

## 二、最直观的优势：训练 Token 效率

论文主要实验采用以下配置：

| 参数 | GRPO | OPSD |
|---|---:|---:|
| 每个问题采样的轨迹数量 | 8 | 1 |
| 每条轨迹最大生成长度 | 16,000 | 1,024 |
| 有效 Batch Size | 32 | 32 |
| 训练步数 | 500 | 100 |

<FileCite ref="turn0file0" line_range_start={1190} line_range_end={1207}/>

假如仅按照最大生成预算计算：

- GRPO 每题最多生成 \(8\times16000=128000\) Token。
- OPSD 每题最多生成 \(1024\) Token。

两者的最大生成预算相差 125 倍。

但这只是**理论上的生成预算差异**，不是说 OPSD 的实际端到端训练速度快了 125 倍。真实采样可能提前停止，而且 OPSD 还需要教师前向传播、学生训练前向传播与反向传播。

作者的核心主张是：相比基于最终结果奖励的训练，**OPSD 用更少的学生采样 Token，就能获得足够密集的学习信号。**

## 三、论文实际效果有多好？

下面是论文 Table 2 中三个数学基准的平均准确率，评价指标为 Avg@12。

<Chart content={{"chartType":"bar","meta":{"title":"OPSD 对比 SFT / GRPO","description":"AIME24、AIME25、HMMT25 平均准确率（Avg@12），单位 %"},"xKey":"model","series":[{"dataKey":"sft","label":"SFT"},{"dataKey":"grpo","label":"GRPO"},{"dataKey":"opsd","label":"OPSD"}],"yAxisMin":0,"data":[{"model":"Qwen3-1.7B","sft":35.8,"grpo":37.7,"opsd":43.4},{"model":"Qwen3-4B","sft":58.6,"grpo":62.7,"opsd":63.6},{"model":"Qwen3-8B","sft":59.8,"grpo":64,"opsd":64.8}]}}/>

<text color="secondary" size="xs">来源：论文 Table 2。<FileCite ref="turn0file0" line_range_start={582} line_range_end={608}/></text>

我觉得这组数据能够说明三个现象。

**第一，OPSD 对小模型的提升非常明显。**

在 Qwen3-1.7B 上：

- SFT：35.8%
- GRPO：37.7%
- OPSD：43.4%

OPSD 相比 GRPO 提高了 5.7 个百分点。

**第二，模型规模增大之后，OPSD 相比 GRPO 的优势明显缩小。**

到了 Qwen3-8B，OPSD 的平均准确率只有 0.8 个百分点的提升。而且在 HMMT25 单独这个基准上，GRPO 为 46.7%，OPSD 为 45.8%，并不是 OPSD 全面胜出。

**第三，SFT 在论文的实验设置中反而损害了原始模型的性能。**

作者认为，训练数据中的参考解答比较简洁，导致 SFT 后的模型在测试时也倾向于生成更短的推理过程，影响了数学推理表现。

这并不能证明 OPSD 普遍优于高质量的 SFT。更合理的理解是：在这组训练数据和配置下，OPSD 比直接模仿参考解答更有效。

---

## 四、OPSD 的代价与缺陷是什么？

这部分对判断论文的研究价值非常重要。

| 问题 | 具体影响 |
|---|---|
| 需要参考答案 | 不适用于没有可靠标准答案的所有任务 |
| 教师不一定正确 | 看过答案的模型也未必能真正理解复杂推理 |
| 计算额外的教师分布 | 比普通 SFT 增加了计算开销 |
| 全词表 KL 消耗显存 | 每个位置都需要处理词表维度的概率分布 |
| 训练稳定性问题 | 论文观察到后续训练步数可能出现性能下降 |
| 实验规模有限 | 正文主要验证到 8B 模型，缺少更大规模证明 |

其中作者在附录中明确承认：如果问题难度已经超出模型的理解能力，即使提供标准答案，教师也可能无法给出有意义的监督。<FileCite ref="turn0file0" line_range_start={1107} line_range_end={1119}/>

这也是 OPSD 的一个关键限制。

---

## 五、如果从科研角度看，这篇论文真正有价值的创新是什么？

我认为不是“使用 KL 散度”，因为 KL 蒸馏已经非常成熟。

也不是“教师和学生来自同一个模型”，因为此前已有自蒸馏和上下文蒸馏研究。

**它真正值得关注的是这样一种训练思想：**

> 在学生自己生成的轨迹上，通过给同源教师提供额外的正确答案信息，把模型已有的条件推理能力转换成更密集的训练信号。

也就是三个要素的组合：

\[
\underbrace{\text{On-Policy Rollout}}_{\text{学生自己的轨迹}}
+
\underbrace{\text{Privileged Context}}_{\text{教师额外看到答案}}
+
\underbrace{\text{Dense Distillation}}_{\text{逐Token监督}}
\]

这与 GRPO 最大的思路区别是：

**GRPO 主要通过采样和结果奖励，推动模型发现更好的行为；OPSD 则利用参考答案，让模型从自己当前生成的行为中提取更细粒度的学习信号。**

### 我的判断

这篇 OPSD 是值得学习的后训练方法论文，尤其适合用来理解 SFT、RLVR、知识蒸馏和 On-Policy Learning 之间的关系。

但它还不足以证明可以全面取代 GRPO。特别是两者在实验中的生成长度、采样预算和训练步数存在明显差别，而 OPSD 还依赖参考解答。

**最后给你一个真正值得进一步思考的问题：如果 OPSD 已经知道标准答案，为什么不直接 SFT，而要先让学生生成错误轨迹，再让教师计算概率分布？**

这正是它的核心研究假设：**学生自己访问的状态分布，加上教师提供的软监督，可能比单纯模仿专家轨迹更有利于提高泛化能力。** 论文给出了支持这一假设的实验，但该假设能否推广到其他模型、任务和更大规模，仍然需要进一步验证。

---

## User
*2026-10-24 12:57*
2.2. Reinforcement Learning with Verifiable Rewards  Reinforcement learning with verifiable rewards (RLVR) has emerged as a popular approach for post-training large language models, particularly on tasks with easily verifiable outcomes such as mathematics and coding, using algorithms like Proximal Policy Optimization (PPO) (Schulman et al., 2017) and Group Relative Policy Optimization (GRPO) (Shao et al., 2024).  GRPO trains by sampling a group of G responses {o1, o2, . . . , oG} from the current policy πθ for each problem x. Each response oi receives a binary reward ri ∈ {0, 1} indicating correctness. The method then assigns advantages to all tokens k = 1, . . . , |oi| within response oi using a group-normalized reward:  Ai = ri − mean({rj}G  j=1)  std({rj }G  j=1) . (4)  This formulation can be understood through the value function lens: mean({rj}G  j=1) serves as a G-sample Monte Carlo estimate of the value function V (x), while the sparse binary reward ri represents the (undiscounted) state-action value Q(x, oi). Critically, all tokens within a response share the same advantage, as the reward signal is provided only  at the sequence level. The GRPO objective incorporates a clipped surrogate loss to moderate policy updates, along with a reverse KL penalty to prevent excessive deviation from a reference policy:  LGRPO(θ) = E x∼S  o1,...,oG∼πθ (·|x)  "  1 G  G  X  i=1  1 |oi|  |oi |  X  n=1  min (ρn  i Ai, clip (ρn  i , 1 − ε, 1 + ε) Ai)  −β DKL [πθ (·|x)∥πref (·|x)]  #  (5) where ρn  i = πθ(on  i |x,o<n  i) πθold (on  i |x,o<n  i ) is the importance ratio, πθold is  the policy before the update, and ε controls the clipping range.  While RLVR methods have demonstrated strong empirical performance, they face two key limitations: (1) the reward signal is sparse, providing only sequence-level feedback rather than token-level guidance on where errors occur, and (2) when all sampled responses receive identical rewards (all correct or all incorrect), the advantages become zero, preventing any policy update despite the computational cost of sampling.
请你给我讲解一下以上内容，包括公式等

---

## Assistant
*2026-10-24 12:57*
这一节 **2.2 Reinforcement Learning with Verifiable Rewards（RLVR）** 非常重要，因为作者正是通过分析 GRPO 的训练机制及其缺陷，引出 OPSD。

我建议你把这节拆成五个问题来理解：

1. GRPO 到底怎样训练一个 Transformer？
2. 为什么要计算 Advantage（优势值）？
3. 公式 (4) 为什么要减去平均奖励、再除以标准差？
4. 公式 (5) 中的概率比率、Clip 和 KL 分别有什么作用？
5. 作者为什么说 GRPO 存在稀疏奖励和梯度消失的问题？

我们直接用**一个完整的数学实例**，从生成答案开始，一直讲到参数更新。

## 一、GRPO 到底在做什么？

首先，RLVR 的全称是：

**Reinforcement Learning with Verifiable Rewards（带可验证奖励的强化学习）。**

它适用于答案能够自动判断正确与否的任务，例如：

- 数学题：最终答案是否正确。
- 编程题：生成的代码是否通过测试用例。
- 形式化证明：是否通过验证器。

其中 GRPO（Group Relative Policy Optimization）是一种典型的 RLVR 算法。

与 SFT 不同，GRPO 不要求模型直接模仿标准推理轨迹，而是：

**让模型自己尝试解题，根据最终结果给予奖励，再通过奖励更新模型参数。**

### 假设我们用 Qwen 训练数学推理

给模型一道题：

\[
x:\quad 12\times 3=?
\]

每次生成答案具有一定随机性。因此，我们让模型独立生成 4 条回答：

<box border radius="xl" padding={3} gap={3}>
  <text color="secondary" size="xs">示例：同一道题的 4 次独立采样</text>
  {#each [{id:"o₁",ans:"12 × 3 = 36",r:1},{id:"o₂",ans:"12 × 3 = 32",r:0},{id:"o₃",ans:"12 × 3 = 36",r:1},{id:"o₄",ans:"12 × 3 = 38",r:0}] as item}
    <row align="center" gap={3}>
      <box width="34px">
        **{item.id}**
      </box>
      <box flex="1" background="surface-secondary" padding={3} radius="md">
        <text size="sm">{item.ans}</text>
      </box>
      {#if item.r===1}
        <badge color="success">奖励 1</badge>
      {:else}
        <badge color="danger">奖励 0</badge>
      {/if}
    </row>
  {/each}
</box>

这里有几个符号：

- \(x\)：输入的问题。
- \(G=4\)：一次采样 4 条回答。
- \(o_i\)：第 \(i\) 条完整回答，也称为 Rollout 或轨迹。
- \(r_i\)：第 \(i\) 条回答获得的奖励。

论文采用二元奖励：

\[
r_i=
\begin{cases}
1,&\text{最终答案正确}\\
0,&\text{最终答案错误}
\end{cases}
\]

现在模型有了四条轨迹，以及对应的奖励：

\[
\mathbf r=[1,0,1,0]
\]

但接下来有一个问题：

**为什么不直接用奖励 \(r_i\) 更新模型，而要计算所谓的 Advantage？**

---

## 二、公式 (4)：Advantage 究竟是什么？

论文给出的公式是：

\[
\boxed{
A_i=
\frac{r_i-\operatorname{mean}(\{r_j\}_{j=1}^{G})}
{\operatorname{std}(\{r_j\}_{j=1}^{G})}
}
\tag{4}
\]

这里的 \(A_i\) 就是第 \(i\) 条回答的优势值（Advantage）。

### 1. 首先理解 Advantage 的直觉

假设某道题很容易，模型十次里能做对九次。

另一道题很难，模型十次里只能做对一次。

对于容易的题，做对其实不算特别出色；对于困难的题，做对反而是相对突出的表现。

所以强化学习不一定只关心“你做对了吗”，还关心：

**相对于当前模型在这个问题上的通常表现，这次结果是更好还是更差？**

这就是 Advantage 要表达的思想。

### 2. 第一步：计算平均奖励

在我们的例子中：

\[
\mathbf r=[1,0,1,0]
\]

平均奖励：

\[
\bar r=\frac{1+0+1+0}{4}=0.5
\]

它可以粗略反映当前模型解决这道题的成功水平。

### 3. 第二步：计算标准差

标准差用来衡量这一组奖励之间的离散程度。

\[
\sigma_r=
\sqrt{\frac{1}{G}\sum_{j=1}^{G}(r_j-\bar r)^2}
\]

代入：

\[
\sigma_r
=\sqrt{\frac{4\times 0.5^2}{4}}
=0.5
\]

这里用的是总体标准差的计算约定，具体实现中的数值约定可能略有不同。

### 4. 第三步：计算四条轨迹的 Advantage

第一条回答正确：

\[
A_1=\frac{1-0.5}{0.5}=+1
\]

第二条回答错误：

\[
A_2=\frac{0-0.5}{0.5}=-1
\]

另外两条同理：

\[
\boxed{\mathbf A=[+1,-1,+1,-1]}
\]

什么意思？

| 轨迹 | 奖励 | Advantage | 训练方向 |
|---|---:|---:|---|
| \(o_1\) | 1 | +1 | 鼓励这条轨迹 |
| \(o_2\) | 0 | −1 | 抑制这条轨迹 |
| \(o_3\) | 1 | +1 | 鼓励这条轨迹 |
| \(o_4\) | 0 | −1 | 抑制这条轨迹 |

你可以把 Advantage 简单理解成：

- \(A_i>0\)：这条回答比组内平均表现更好。
- \(A_i<0\)：这条回答比组内平均表现更差。
- \(A_i=0\)：没有表现出相对于组内平均的优势或劣势。

**所以公式 (4) 并不是直接更新模型，而是先为每条轨迹计算一个用于指导训练的分数。**

---

## 三、论文为什么突然引入 V(x) 和 Q(x,o)？

原文说：

> mean rewards serves as a G-sample Monte Carlo estimate of the value function V(x).

这里涉及强化学习中的两个概念。

### 1. Value Function：\(V(x)\)

\(V(x)\) 表示：

**当前模型面对问题 \(x\)，预计能够获得多少奖励。**

例如，如果模型回答某题的正确概率是 60%，而奖励只有 0 或 1，那么：

\[
V(x)=\mathbb E_{o\sim\pi_\theta(\cdot\mid x)}[r(o)]
\approx0.6
\]

它可以理解为模型面对这道题的平均预期表现。

但实际训练中，我们不知道真正的 \(V(x)\)。

怎么办？

通过多次采样估计。

例如采样四次：

\[
[1,0,1,0]
\]

就得到：

\[
\hat V(x)=0.5
\]

这就是论文所说的 Monte Carlo（蒙特卡洛）估计。

### 2. Q Function：\(Q(x,o_i)\)

这里的 \(Q(x,o_i)\) 可以理解为：

在给定问题 \(x\) 时，选择完整回答 \(o_i\) 所获得的结果价值。

因为当前讨论的是完整序列的终局奖励，论文用：

\[
Q(x,o_i)\approx r_i
\]

来理解这个量。

严格来说，这里的 \(o_i\) 是一整条回答，不是单个 Token 的动作，因此这是一个以完整轨迹为单位的价值解释。

### 3. Advantage 就是 Q 减 V

强化学习中常见的思想是：

\[
A=Q-V
\]

也就是：

\[
\text{优势}=\text{这次实际表现}-\text{通常预期表现}
\]

GRPO 的公式 (4) 就相当于在这个差值基础上，再除以组内标准差进行归一化。

到这里你应该已经理解，**GRPO 不需要额外训练一个 Critic 网络去估计 \(V(x)\)，它使用一组采样结果的平均奖励作为基线。**

这也是它相比一些传统 Actor-Critic 算法更简洁的地方。

---

## 四、特别重要：为什么一条轨迹中的所有 Token 共用一个 Advantage？

假设某一条错误轨迹为：

`12 × 3 = 32`

为了教学方便，假设它拆成五个 Token。

因为最终答案错误，所以它在前面的例子中得到：

\[
A_2=-1
\]

GRPO 会把这个优势值分配给整条轨迹：

| Token | `12` | `×` | `3` | `=` | `32` |
|---|---|---|---|---|---|
| Advantage | −1 | −1 | −1 | −1 | −1 |

这就出现了一个问题。

前面的 `12 × 3 =` 其实没有错，真正的错误在最后的 `32`。

但是 GRPO 采用的是序列级别的最终奖励，所以**它没有直接获得“最后那个 Token 才是错误来源”的信息。**

当然，这不代表这些 Token 的参数梯度完全相同。每个 Token 对应的概率和梯度不同，GRPO 只是给了它们相同的序列级优势系数。

这是作者说的第一个局限：

**Sparse Reward（稀疏奖励）以及缺乏细粒度的 Credit Assignment（信用分配）。**

这里 Credit Assignment 的意思就是：

> 当最终结果正确或错误时，到底应该把功劳或责任分配给前面哪些动作？

GRPO 使用一个最终结果奖励，并不能直接精确定位每个推理步骤是否正确。

而 OPSD 的思路是利用拥有参考答案的教师，为学生每个生成位置提供分布监督。

---

## 五、公式 (5)：GRPO 究竟如何更新模型？

这是这部分最复杂的公式，我们先不看所有符号，而是把它拆成三部分。

论文原式可以整理为：

\[
\boxed{
\begin{aligned}
J_{\mathrm{GRPO}}(\theta)
=\mathbb E\Bigg[
&\frac{1}{G}\sum_{i=1}^{G}
\frac{1}{|o_i|}\sum_{n=1}^{|o_i|}
\min\big(
\rho_i^n A_i,\\
&\qquad\operatorname{clip}(\rho_i^n,1-\epsilon,1+\epsilon)A_i
\big)\\
&-\beta D_{\mathrm{KL}}(\pi_\theta\Vert\pi_{\mathrm{ref}})
\Bigg]
\end{aligned}
}
\]

这里我把它写成了**要最大化的目标 \(J\)**，便于解释。若用梯度下降来实现，通常对其取负作为损失（具体实现还可能包含其他细节）。

整个公式其实就是：

\[
\boxed{
\text{训练目标}
=
\text{奖励驱动的策略更新}
-
\text{偏离参考模型的惩罚}
}
\]

接下来逐一拆解。

### 1. 最重要的比例：\(\rho_i^n\)

论文定义：

\[
\boxed{
\rho_i^n=
\frac{
\pi_\theta(o_i^n\mid x,o_i^{<n})
}{
\pi_{\theta_{\mathrm{old}}}(o_i^n\mid x,o_i^{<n})
}
}
\]

各符号含义如下：

- \(\pi_\theta\)：当前正在训练、更新的模型策略。
- \(\pi_{\theta_{\mathrm{old}}}\)：采样这批轨迹时使用的旧策略。
- \(o_i^n\)：第 \(i\) 条轨迹中的第 \(n\) 个 Token。
- \(o_i^{<n}\)：它前面已经生成的 Token。

所以 \(\rho_i^n\) 表示：

**当前模型生成这个 Token 的概率，是采样时旧模型的多少倍？**

例如，对于一条正确回答中的 Token `36`：

<box border radius="lg" padding={3} gap={2}>
  <grid columns={2} gap={2}>
    <grid-item>
      <box background="surface-secondary" padding={3} radius="md" gap={1}>
        <text color="secondary" size="xs">旧策略概率</text>
        <title size="xl" tabularNums>0.20</title>
      </box>
    </grid-item>
    <grid-item>
      <box background="surface-secondary" padding={3} radius="md" gap={1}>
        <text color="secondary" size="xs">当前策略概率</text>
        <title size="xl" tabularNums>0.26</title>
      </box>
    </grid-item>
  </grid>
  \[
  \rho=\frac{0.26}{0.20}=1.3
  \]
  <text size="sm">这表示当前模型对这个已采样 Token 的概率提高到了原来的 1.3 倍。</text>
</box>

这里需要理解为什么还有旧策略。

假设模型用 \(\theta_{\mathrm{old}}\) 生成了一批答案，之后优化器开始更新参数。

在更新期间，模型参数可能已经变为 \(\theta\)。为了衡量当前策略相对采样策略的变化，GRPO 就使用这个概率比率。

它也是 PPO 类算法中常见的重要性比率。

### 2. Clip：为什么不允许模型变化太大？

论文中有：

\[
\operatorname{clip}(\rho,1-\epsilon,1+\epsilon)
\]

假设：

\[
\epsilon=0.2
\]

则：

\[
1-\epsilon=0.8,\qquad1+\epsilon=1.2
\]

它将比率的裁剪值限制在：

\[
[0.8,1.2]
\]

但是注意：**这不是强行把模型参数的变化限制在 20% 以内，而是利用裁剪后的代理目标限制进一步优化的收益。**

我们继续使用前面的例子。

正确轨迹的 Advantage：

\[
A_i=+1
\]

概率比率：

\[
\rho=1.3
\]

那么：

\[
\rho A_i=1.3
\]

而裁剪项：

\[
\operatorname{clip}(1.3,0.8,1.2)\times1=1.2
\]

取最小值：

\[
\min(1.3,1.2)=1.2
\]

这样，当一个正确 Token 的概率已经向鼓励方向上升过多时，裁剪项就不再提供继续提高它的代理目标收益。

对于错误轨迹，\(A_i<0\)，裁剪也会阻止模型从某些过度降低概率的更新中继续获得收益。

你可以交互式查看这个公式。

{@body const [ratio,setRatio]=DIL.useState(1.3)}
{@body const [adv,setAdv]=DIL.useState("1")}
{@body const [eps,setEps]=DIL.useState(0.2)}
{@body const a=Number(adv)}
{@body const clipped=Math.max(1-eps,Math.min(1+eps,ratio))}
{@body const raw=ratio*a}
{@body const clippedTerm=clipped*a}
{@body const surrogate=Math.min(raw,clippedTerm)}
<box border radius="xl" padding={3} gap={3}>
  <title size="lg">GRPO Clip 数值实验</title>
  <box gap={1}>
    <label>选择轨迹的 Advantage</label>
    <radio-group direction="row" value={adv} onChange={setAdv}>
      <radio value="1">正确轨迹 A=+1</radio>
      <radio value="-1">错误轨迹 A=−1</radio>
    </radio-group>
  </box>
  <box gap={1}>
    <row align="center" justify="between">
      <label>概率比率 \(\rho\)</label>
      **{ratio.toFixed(2)}**
    </row>
    <slider min={0.5} max={1.6} step={0.05} value={ratio} onChange={setRatio}/>
  </box>
  <box gap={1}>
    <row justify="between" align="center">
      <label>裁剪参数 \(\epsilon\)</label>
      **{eps.toFixed(2)}**
    </row>
    <slider min={0.1} max={0.3} step={0.05} value={eps} onChange={setEps}/>
  </box>
  <divider color="subtle"/>
  <table>
    <table-row><table-cell>未裁剪项 \(\rho A\)</table-cell><table-cell align="end"><text tabularNums>{raw.toFixed(3)}</text></table-cell></table-row>
    <table-row><table-cell>裁剪项</table-cell><table-cell align="end"><text tabularNums>{clippedTerm.toFixed(3)}</text></table-cell></table-row>
    <table-row><table-cell>最终取最小值</table-cell><table-cell align="end">**<text tabularNums>{surrogate.toFixed(3)}</text>**</table-cell></table-row>
  </table>
  <box background="surface-secondary" radius="lg" padding={3} gap={1}>
    {#if (a>0&&ratio>1+eps)||(a<0&&ratio<1-eps)}
      <row align="center" gap={2}>
        <icon name="shield-check" color="success"/>
        **触发收益裁剪**
      </row>
      <text size="sm">进一步沿当前奖励所鼓励的方向改变概率，不再增加这个 Token 的代理目标收益。</text>
    {:else}
      <row align="center" gap={2}>
        <icon name="check-circle" color="secondary"/>
        **没有触发收益裁剪**
      </row>
      <text size="sm">当前数值下，目标使用未被收益上限限制的项。</text>
    {/if}
  </box>
</box>

### 3. 为什么公式里面还有 KL 惩罚？

最后一项：

\[
-\beta D_{\mathrm{KL}}
\left[
\pi_\theta(\cdot\mid x)
\Vert
\pi_{\mathrm{ref}}(\cdot\mid x)
\right]
\]

它的意思是：

**不要让当前训练模型过度偏离一个参考模型。**

这里有两个模型概念必须区分：

| 符号 | 作用 |
|---|---|
| \(\pi_{\theta_{\mathrm{old}}}\) | 采样轨迹时的旧策略，用于计算概率比率 |
| \(\pi_{\mathrm{ref}}\) | 参考策略，用于计算 KL 惩罚 |

它们不是同一个概念。

例如，模型原本具备不错的通用语言能力，但为了提高数学题正确率，强化学习可能推动它过度偏向某些输出模式。

KL 惩罚就像一种约束：

- 鼓励提高奖励。
- 同时惩罚与参考策略的分布差异。

\(\beta\) 控制惩罚强度：

- \(\beta\) 越大，越重视保持接近参考策略。
- \(\beta=0\)，就不使用这一项惩罚。

值得注意的是，你读的这篇 OPSD 论文在附录 Table 8 中，对比实验的 GRPO 配置使用了 \(\beta=0\)。因此，正文的式 (5) 描述了带 KL 正则的通用形式，但其具体实验没有启用这一额外惩罚。<FileCite ref="turn0file0" line_range_start={1190} line_range_end={1207}/>

---

## 六、最后：作者为什么要攻击 GRPO？

现在我们已经知道 GRPO 完整的训练机制，可以理解原文最后一段的两个缺陷。

### 缺陷 1：奖励稀疏

假设一条推理轨迹包含 1,000 个 Token。

其中前面 900 个 Token 完全正确，最后 100 个 Token 出现错误。

GRPO 如果只使用最终结果奖励，那么整条轨迹都获得同一个结果奖励：

\[
r=0
\]

随后根据组内奖励计算一个 \(A_i\)，并把这个优势值用于整条轨迹的所有 Token。

问题是：

**算法没有直接得到哪一步真正出错的信息。**

这属于稀疏奖励和信用分配问题。

OPSD 的对策则是：让教师利用标准答案，对学生每个生成位置提供更细粒度的概率分布监督。

### 缺陷 2：奖励全部相同，优势变为零

这个问题更有代表性。

假设四条轨迹全部错误：

\[
\mathbf r=[0,0,0,0]
\]

组内平均奖励：

\[
\bar r=0
\]

标准差：

\[
\sigma_r=0
\]

公式 (4) 形式上会出现 \(0/0\)，不能直接计算。

实际实现通常通过零方差处理或数值稳定项，将这一组的优势信号置为零。

于是：

\[
A_1=A_2=A_3=A_4=0
\]

对于 GRPO 的奖励驱动代理目标：

\[
\rho_i^n A_i=0
\]

这样，即使模型生成了四条很长的回答，也没有获得有用的组相对奖励梯度。

全对的情况也类似：

\[
\mathbf r=[1,1,1,1]
\]

由于没有相对差异，同样无法从组内奖励中得到优势信号。

要准确理解作者的说法：这里消失的是**来自组相对奖励的学习信号**。如果还有非零 KL 正则或其他辅助损失，理论上仍可能产生梯度；但本文的 GRPO 对比实验采用 \(\beta=0\)，因此不存在 KL 惩罚带来的这类额外梯度。

OPSD 的优势就在于：**即使最终答案全部错误，只要教师和学生在某些位置的概率分布存在差异，就仍有可能计算出非零的蒸馏损失。**

当然，非零损失不一定代表有用的推理指导，教师监督本身是否可靠依然非常重要。

---

## 七、把整个 GRPO 训练流程串起来

<box border radius="xl" padding={3} gap={2} align="center">
  <box background="surface-secondary" radius="lg" padding={3} width="100%" gap={1}>
    **Step 1：学生模型生成 G 条轨迹**

    对每个问题，使用当前采样策略生成多个回答。
  </box>
  <icon name="arrow-down" color="secondary"/>
  <box border radius="lg" padding={3} width="100%" gap={1}>
    **Step 2：验证最终答案**

    每条回答得到奖励 \(r_i\)，例如正确为 1、错误为 0。
  </box>
  <icon name="arrow-down" color="secondary"/>
  <box border radius="lg" padding={3} width="100%" gap={1}>
    **Step 3：计算组相对 Advantage**

    \[
    A_i=\frac{r_i-\bar r}{\sigma_r}
    \]

    同一条轨迹中的所有 Token 共享这个优势值。
  </box>
  <icon name="arrow-down" color="secondary"/>
  <box border radius="lg" padding={3} width="100%" gap={1}>
    **Step 4：计算 GRPO 目标**

    利用 Token 概率比率 \(\rho_i^n\)、Clip 以及可选的 KL 惩罚，构造策略优化目标。
  </box>
  <icon name="arrow-down" color="secondary"/>
  <box background="surface-secondary" radius="lg" padding={3} width="100%" gap={1}>
    **Step 5：反向传播更新参数**

    将要最大化的策略目标转换为训练损失，反向传播更新 Transformer 的可训练参数，再重新采样进入下一轮。
  </box>
</box>

## 八、这一节真正需要掌握什么？

读完这一节，我希望你掌握以下四个核心概念：

| 概念 | 一句话理解 |
|---|---|
| Reward | 这次回答最终得到了多少分 |
| Value \(V\) | 当前模型通常能拿多少分 |
| Advantage \(A\) | 这次回答比通常表现好多少 |
| Policy Ratio \(\rho\) | 当前模型对已采样 Token 的概率，相比采样时变化多少 |

而 GRPO 的整个公式 (5)，本质上是在做：

**根据 Advantage 鼓励或抑制采样得到的 Token，同时通过 Clip 控制单次策略优化的幅度。**

至于这篇 OPSD 为什么要专门介绍 GRPO，是因为它想解决两个问题：

1. GRPO 只有最终结果奖励，难以直接进行细粒度信用分配。
2. 当一个组的答案全部正确或全部错误时，GRPO 的组相对奖励不能提供有效学习信号。

**OPSD 的研究思路，就是把“依靠最终答案得到一个序列级奖励”转变为“利用参考答案，在学生轨迹的每个位置计算教师与学生的分布差异”。**

这就是 §2.2 和后面 §3 Methods 之间最重要的逻辑联系。

---

## User
*2026-10-24 14:19*
Algorithm 1 On-Policy Self-Distillation (OPSD) Require: Reasoning dataset S = {(xi, y⋆  i )}N  i=1; language model pθ; divergence D (e.g., JSDβ)  1: Let pS(· | x) and pT (· | x, y⋆) be the same model pθ under different conditioning. 2: while not converged do 3: Sample a minibatch B ⊂ S 4: for all (x, y⋆) ∈ B do  5: Sample on-policy response yˆ ∼ pS(· | x) 6: Compute the token-wise divergence along the student rollout:  l(x, y⋆) ← D pT ∥ pS (yˆ | x) = 1  |yˆ|  |yˆ|  X  n=1  D pT (· | yˆ<n, x, y⋆) pS(· | yˆ<n, x)  7: Calculate loss LOPSD(θ) ← 1  |B|  P  (x,y⋆)∈B l(x, y⋆) and update θ  matches the teacher and student next-token distributions at each position. Given a student-generated sequence yˆ, define the trajectory-averaged, token-wise divergence  D pT ∥ pS (yˆ | x) ≜ 1  |yˆ|  |yˆ|  X  n=1  D pT (· | x, y⋆, yˆ<n) pS(· | x, yˆ<n) ,  (6)  where pS(· | x, yˆ<n) and pT (· | x, y⋆, yˆ<n) denote distributions over the next token yn ∈ V. Here, D can be any distribution divergence measure such as the generalized Jensen-Shannon divergence JSDβ, defined for a weight β ∈ [0, 1] as:  JSDβ(pT ∥pS) = βDKL(pT ∥m) + (1 − β)DKL(pS∥m)  (7) where m = βpT + (1 − β)pS is the interpolated mixture distribution. This full-vocabulary formulation provides dense, token-level feedback: the teacher, informed by y⋆, exposes the student to the entire distribution over plausible next tokens and guides it toward reasoning paths that lead to the correct answer.  We minimize the expected divergence between teacher and student over on-policy student samples:  L(θ) = E(x,y⋆)∼S Eyˆ∼pS(·|x) D pT ∥ pS (yˆ | x) .  (8) Gradients are backpropagated only through the student policy pS, while the teacher pT acts as a fixed full-distribution target conditioned on privileged information (x, y⋆).  Per-Token Pointwise Divergence Clipping. In our experiments, we observe that token-level divergence is highly skewed across vocabulary entries: a small subset of stylistic tokens exhibits much higher divergence than mathematically meaningful tokens (see Table 7). This imbalance causes the  training signal to be dominated by stylistic patterns. To address this, we apply pointwise clipping to the vocabularylevel divergence contributions. Let Df (pT ∥pS) denote an f -divergence. At each token position n and vocabulary entry v, define:  l(f )  n,v = pT (v | ·) f pS(v | ·)  pT (v | ·) .  We compute the clipped divergence:  D(f )  clip(pT ∥pS ) = 1  |yˆ|  |yˆ|  X  n=1  X  v∈V  min(l(f )  n,v, τ ).  Alternative objective: Sampled-token distillation through policy gradient. Following recent on-policy distillation methods (Lu & Lab, 2025), we form a sampledtoken reward signal (a reverse-KL signal on sampled actions) and optimize with policy gradient. For each position n in a sampled sequence yˆ, define the advantage term  An(x, yˆ) = log pT (yˆn | x, y⋆, yˆ<n)−log pS(yˆn | x, yˆ<n) ,  and optimize the policy-gradient-style objective  L(θ) = −E(x,y⋆)∼S Eyˆ∼pS(·|x)  1 |yˆ|  |yˆ|  X  n=1  An(x, yˆ)  × log pS(yˆn | x, yˆ<n) .  (9)  An(x, yˆ) is treated as a constant with respect to θ (i.e., gradients do not flow through the advantage), so that gradients take the usual policy-gradient form An∇θ log pS. Compared to the full-vocabulary divergence objective, this on-policy shaping objective operates only on sampled tokens, using the teacher’s log-probabilities to provide dense, trajectory-level shaping signals without explicitly matching the full distribution at each step.OPSD as dense-reward policy gradient and comparison to STaR. The objective in Equation (9) can be seen as policy gradient with dense, token-level rewards. In Appendix Section D, we formalize this and contrast with STaR (Zelikman et al., 2022), a closely related method that also uses the same model to generate reasoning traces, then performs rejection sampling followed by SFT on correct traces. This procedure can be viewed as policy gradient with a sequencelevel binary reward that assigns identical credit to all tokens and vanishes when samples are incorrect. In contrast, OPSD provides feedback at every token position regardless of finalanswer correctness.
请你拆分给我讲解一下以上内容

---

## Assistant
*2026-10-24 14:20*
<details><summary>工具调用 · container.exec</summary>

```unknown
bash -lc cat /home/oai/skills/pdfs/SKILL.md
```

</details>

---

## Tool
*2026-10-24 14:20*
---
name: pdfs
description: Reliable, workflow-driven PDF processing: render → verify → operate → re-render/verify, covering reading, inspection, extraction, editing, forms, OCR, redaction, conversion, and diffing. Prefer authoring in DOCX or PPTX (then converting to PDF) for text-heavy docs or slide-like layouts; use ReportLab here for programmatic PDF generation.
---

# PDF Skill (Read • Inspect • Extract • Edit • Render • Forms • OCR • Redact • Convert • Diff)

This skill is designed for **reliable, workflow-driven** PDF work: **render -> verify -> operate -> re-render verify**.

## Before you touch PDFs: should this be DOCX/PPTX instead?

Even if the user asks for a PDF deliverable, the best workflow is often:

- **Text-heavy, business-doc layout (headings, TOC, long tables, rich lists)** -> use the **DOCX skill** to author, then convert to PDF with `lo_convert_to_pdf.py`.
- **Slide-like visual layout (charts, callouts, fixed positioning, figure captions)** -> use the **Slides skill** (PPTX) to author, then export to PDF.
- **Programmatic generation** -> ReportLab (this skill) is fine.

If you find yourself hand-tuning line breaks or typography in ReportLab, you probably picked the wrong authoring format.

---

## Core loop (always)

1) Render to images

```bash
python /home/oai/skills/pdfs/scripts/render_pdf.py input.pdf --out_dir /mnt/data/_renders/in --dpi 200
```

2) Inspect PNGs (tables/figures/layout are authoritative)

3) Perform the edit/extract/create

4) Re-render and compare

```bash
python /home/oai/skills/pdfs/scripts/compare_renders.py before.pdf after.pdf --out_dir /mnt/data/_diff --dpi 200
```

---

## Task index (progressive)

Start with the smallest task that answers the user:

### Read / review
- `tasks/read_review.md`

### Extract (text/layout/tables/images/attachments/forms)
- `tasks/extract.md`
- `tasks/coords.md` (coordinate sanity)

### Edit (merge/split/rotate/crop/watermark/paginate/encrypt/repair)
- `tasks/edit.md`
- `tasks/compare.md` (visual regression)

### Forms
- Fillable forms: `tasks/forms_annotations.md`
- Debugging/introspection: `tasks/forms_debugging.md`
- Non-fillable / stamping workflow: `tasks/forms_nonfillable.md`

### OCR
- `tasks/ocr.md`

### Preflight / normalize
- `tasks/preflight.md`

### Redaction
- `tasks/redact.md`

### Renderer parity
- `tasks/parity.md`

### Batch processing
- `tasks/batch.md`

### Create / convert
- `tasks/create.md`
- `tasks/convert.md`
- `tasks/js_tools.md` (pdf-lib, pdfjs)


---

## Package map (where things live)

This pack includes a `manifest.txt` that is a **pure list of relative file paths** used by download tooling.

Quick map:

- **tasks/** (what to do)
  - `read_review.md` - render-first reading/review
  - `extract.md` - extract text/layout/tables/images/attachments/forms
  - `coords.md` - coordinate system cheatsheet (PDF pt vs image px)
  - `edit.md` - merge/split/select/rotate/crop/watermark/paginate/encrypt/repair
  - `compare.md` - visual diff workflow
  - `forms_annotations.md` - fillable forms + appearance pitfalls + correctness checklist
  - `forms_debugging.md` - widget-level introspection + acceptable values
  - `forms_nonfillable.md` - stamp-by-boxes workflow for non-fillable forms
  - `ocr.md` - OCR scanned PDFs to searchable
  - `preflight.md` - quick triage + normalization guidance
  - `redact.md` - true redaction workflows
  - `parity.md` - render parity across engines
  - `batch.md` - batch helpers for corpora
  - `create.md` - choose reportlab/latex/html/docx/pptx pipeline
  - `convert.md` - docx/pptx/html/markdown/latex to PDF conversion
  - `js_tools.md` - pdf-lib/pdfjs helper CLIs

- **scripts/** (run these)
  - `render_pdf.py` - render to PNGs (pdfium or poppler)
  - `compare_renders.py` - render-and-diff two PDFs (pixel diff)
  - `pdf_inspect.py` - metadata/structure overview
  - `pdf_extract.py` - text/words/chars/tables/images/attachments/annots/forms
  - `pdf_edit.py` - editing toolkit (merge/split/select/rotate/crop/watermark/paginate/encrypt/repair/optimize)
  - `pdf_preflight.py` - preflight/triage warnings
  - `pdf_redact.py` - true redaction (remove underlying content)
  - `renderer_parity.py` - diff pdftoppm vs pdfium renders
  - `batch_pdf.py` - batch runner for common ops
  - `box_picker_html.py` - generate interactive HTML to pick rectangles -> JSON in PDF coords
  - `place_text_by_boxes.py` - stamp text/checkmarks into rectangles (non-fillable forms)
  - `ocr_pdf.py` - OCR wrapper
  - `html_to_pdf.py`, `md_to_pdf.py`, `latex_to_pdf.py`, `lo_convert_to_pdf.py` - conversion helpers

- **js/** (Node helpers)
  - `install_deps.sh` - installs pdf-lib + pdfjs-dist
  - `fill_form.mjs` - fill + optional flatten (supports flags and positional args)
  - `extract_form_fields.mjs` - list AcroForm fields
  - `extract_text_pdfjs.mjs` - extract text via pdfjs-dist

- **examples/**
  - `smoke_test.md` - runnable smoke flows

- **troubleshooting/**
  - `common.md` - common pitfalls and fixes

---

## Final deliverable expectations

- No clipped text, overlaps, black squares, or broken glyphs in rendered PNGs.
- Verify in at least **one** renderer (`pdfium` or `pdftoppm`). For tricky forms, verify in **two**.
- Remove intermediate artifacts from the deliverable folder (keep only final PDF(s)).
- Avoid Unicode dashes that some renderers mishandle; prefer ASCII `-`.


---

## Assistant
*2026-10-24 14:20*
这部分是 OPSD 整篇论文中**最核心的方法设计**，主要包括 Algorithm 1、公式 (6)–(9)，以及逐 Token KL 裁剪和策略梯度两种实现思路。

你已经理解了 Transformer 的 Prefill、Decode、SFT 和 GRPO，所以这次我们直接从**数学公式、具体数值和参数更新**三个角度拆解。

先告诉你一个重要结论：

**OPSD 的核心算法很简单：学生自己生成轨迹，教师利用标准答案对这条轨迹计算概率分布，通过逐 Token 的分布差异训练学生。后面的四个公式，只是在回答“差异怎么计算、怎么稳定训练，以及能否换成强化学习形式”。**

## 一、先建立整体框架：四个公式分别在解决什么？

| 公式 | 核心作用 | 你应该理解什么 |
|---|---|---|
| Algorithm 1 | OPSD 的完整训练流程 | 一轮训练如何执行 |
| (6) | 逐 Token 分布散度 | 如何计算一条轨迹的损失 |
| (7) | JSD 散度 | 如何定义另一种分布距离 |
| (8) | 总体优化目标 | 整个数据集的训练目标是什么 |
| Pointwise Clipping | 对散度贡献进行裁剪 | 避免部分 Token 主导梯度 |
| (9) | 采样 Token 的策略梯度 | 如何把蒸馏改写成类似 RL 的训练 |

先记住：**公式 (6) 和 (8) 描述主要蒸馏目标；公式 (9) 是作者额外研究的替代优化方式，不需要两种方法同时执行。**

---

## 二、Algorithm 1：一次完整训练到底怎么运行？

### Step 0：准备训练数据和模型

论文写的是：

\[
S=\{(x_i,y_i^\star)\}_{i=1}^{N}
\]

这里：

- \(S\)：整个训练数据集。
- \(N\)：数据集包含多少道题。
- \(x_i\)：第 \(i\) 道题。
- \(y_i^\star\)：该题的参考答案或推理过程。
- \(p_\theta\)：待训练的语言模型。

假设我们有 1000 道数学题，选择其中一道：

\[
x:\quad 3+4=?
\]

参考答案：

\[
y^\star=7
\]

训练刚开始，我们有一个已完成预训练或指令微调的 Qwen 模型。

OPSD 不需要从零训练一个 Transformer，而是在现有模型上继续后训练。

### Step 1：构造 Student 和 Teacher

论文定义：

\[
p_S(\cdot\mid x)=p_\theta(\cdot\mid x)
\]

\[
p_T(\cdot\mid x,y^\star)=p_\theta(\cdot\mid x,y^\star)
\]

核心区别是：

- Student 只看到问题。
- Teacher 额外看到参考答案。

在算法定义上，两者从同一个模型构造；在论文正式实验中，作者进一步选择**冻结初始教师参数、只训练学生参数**，以提高稳定性。

### Step 2：采样一个 Mini-batch

论文：

\[
B\subset S
\]

例如从 1000 道数学题中选出 32 道：

\[
|B|=32
\]

这是一个 Mini-batch（小批量）。

我们接下来先只分析其中一道题，最后再把 32 道题的损失汇总。

### Step 3：学生生成自己的轨迹

论文第 5 行：

\[
\hat y\sim p_S(\cdot\mid x)
\]

意思是：

学生根据自己的当前策略，自回归生成一条回答。

比如：

\[
\hat y=(3,+,4,=,8)
\]

这就是 Rollout。

注意，学生生成的答案是错的，但 **OPSD 不需要因为答案错误就丢弃它**。

这与 STaR 中只保留正确轨迹进行 SFT 的做法有所不同。

### Step 4：教师和学生计算每个位置的概率分布

我们现在有了完整的学生轨迹：

`3 + 4 = 8`

教师拿到的是：

`问题 + 参考答案 + 学生轨迹`

学生训练分支拿到的是：

`问题 + 学生轨迹`

二者都计算学生轨迹各个位置的下一 Token 分布。

<box border radius="xl" padding={3} gap={3}>
  <title size="md">同一学生轨迹上的分布对齐</title>
  <table>
    <table-row>
      <table-cell width="12%">位置</table-cell>
      <table-cell>共有的学生前缀</table-cell>
      <table-cell>比较的概率分布</table-cell>
    </table-row>
    {#each [{n:1,s:"空"},{n:2,s:"3"},{n:3,s:"3 +"},{n:4,s:"3 + 4"},{n:5,s:"3 + 4 ="}] as x}
      <table-row>
        <table-cell>{x.n}</table-cell>
        <table-cell>`{x.s}`</table-cell>
        <table-cell><math value={String.raw`p_T^{(${x.n})}\ \text{vs.}\ p_S^{(${x.n})}`}/></table-cell>
      </table-row>
    {/each}
  </table>
  <caption>教师在每一个位置都额外看到标准答案 7，但两个分支用于预测的学生前缀相同。这个教学示例假设每个显示的符号对应一个 Token。</caption>
</box>

这一步不需要教师再生成一遍答案。

对于 Causal Transformer，可以将学生轨迹送入模型，通过因果注意力并行计算各个预测位置的 logits。

### Step 5：计算散度、汇总损失并更新模型

假设每个位置的散度分别是：

\[
D_1,D_2,D_3,D_4,D_5
\]

那么这道题的损失：

\[
\ell(x,y^\star)
=\frac{D_1+D_2+D_3+D_4+D_5}{5}
\]

等到 Batch 中 32 道题都计算完成：

\[
L_{\text{batch}}
=\frac{1}{32}\sum_{i=1}^{32}\ell_i
\]

然后进行：

\[
\theta_{t+1}
=\theta_t-\eta\nabla_\theta L_{\text{batch}}
\]

其中：

- \(\eta\)：学习率。
- \(\nabla_\theta L\)：Loss 对模型参数的梯度。
- \(\theta_t\)：当前训练步的学生参数。
- \(\theta_{t+1}\)：更新后的参数。

**这里是一次参数更新，而不是生成 5 个 Token 就更新 5 次。**

这就是 Algorithm 1 的完整训练闭环。

---

## 三、公式 (6)：什么叫逐 Token 散度？

论文给出的公式：

\[
\boxed{
D(p_T\Vert p_S)(\hat y\mid x)
=
\frac{1}{|\hat y|}
\sum_{n=1}^{|\hat y|}
D\left(
p_T(\cdot\mid x,y^\star,\hat y_{<n}),
p_S(\cdot\mid x,\hat y_{<n})
\right)
}
\tag{6}
\]

它看起来复杂，但拆开只有三部分。

**第一部分：\(|\hat y|\)**

学生生成轨迹的 Token 数量。

例如生成 5 个 Token：

\[
|\hat y|=5
\]

**第二部分：\(\hat y_{<n}\)**

学生已经生成的前缀。

例如 \(n=5\)：

\[
\hat y_{<5}=(3,+,4,=)
\]

**第三部分：\(D(p_T,p_S)\)**

在当前生成位置，教师和学生对整个词表的概率预测有多大差异。

### 我们实际计算一次

假设现在到达最后一个位置：

`3+4=`

为了简单，只考虑 `7`、`8`、`9` 三个候选 Token。

| Token | 教师概率 \(p_T\) | 学生概率 \(p_S\) |
|---|---:|---:|
| `7` | 0.8 | 0.2 |
| `8` | 0.1 | 0.7 |
| `9` | 0.1 | 0.1 |

假设选择前向 KL：

\[
D_{\mathrm{KL}}(p_T\Vert p_S)
=\sum_v p_T(v)\ln\frac{p_T(v)}{p_S(v)}
\]

代入：

\[
\begin{aligned}
D_5
={}&0.8\ln\frac{0.8}{0.2}\\
&+0.1\ln\frac{0.1}{0.7}\\
&+0.1\ln\frac{0.1}{0.1}
\end{aligned}
\]

计算得到：

\[
\boxed{D_5\approx0.9144}
\]

这就得到第五个预测位置的 KL 散度。

其他位置完全类似。

假设五个位置最终算出：

\[
[D_1,D_2,D_3,D_4,D_5]
=[0.1,0.2,0.3,0.4,0.9144]
\]

那么：

\[
\ell=\frac{0.1+0.2+0.3+0.4+0.9144}{5}
\]

\[
\boxed{\ell\approx0.3829}
\]

这就是一条学生轨迹的平均蒸馏损失。

这里有一个值得你理解的事实：

**轨迹最后是不是正确答案，并没有直接进入公式 (6)。**

正确答案只是作为教师的额外上下文，帮助教师形成监督分布。

因此，即使学生最后回答错误，只要教师与学生的分布不同，仍然可以产生蒸馏损失。

当然，有非零损失不代表一定能改善推理；教师提供的目标分布也需要足够可靠。

---

## 四、公式 (7)：JSD 散度又是什么？和 KL 有什么区别？

公式 (6) 中使用了一个比较抽象的符号：

\[
D(p_T,p_S)
\]

这里的 \(D\) 可以选择不同的散度函数。

例如：

- Forward KL：\(D_{\mathrm{KL}}(p_T\Vert p_S)\)
- Reverse KL：\(D_{\mathrm{KL}}(p_S\Vert p_T)\)
- JSD：Jensen–Shannon Divergence

论文定义了一个广义的 JSD：

\[
\boxed{
\operatorname{JSD}_\beta(p_T\Vert p_S)
=
\beta D_{\mathrm{KL}}(p_T\Vert m)
+
(1-\beta)D_{\mathrm{KL}}(p_S\Vert m)
}
\tag{7}
\]

其中：

\[
m=\beta p_T+(1-\beta)p_S
\]

我们逐项理解。

### 1. 什么是混合分布 \(m\)？

还是刚才的例子：

\[
p_T=[0.8,0.1,0.1]
\]

\[
p_S=[0.2,0.7,0.1]
\]

如果取：

\[
\beta=0.5
\]

则：

\[
m=0.5p_T+0.5p_S
\]

得到：

\[
\boxed{m=[0.5,0.4,0.1]}
\]

也就是教师与学生分布的平均值。

### 2. JSD 是如何计算的？

JSD 不直接只计算教师与学生之间的 KL，而是分别计算：

\[
D_{\mathrm{KL}}(p_T\Vert m)
\]

以及：

\[
D_{\mathrm{KL}}(p_S\Vert m)
\]

最后进行加权平均。

对于我们的例子：

\[
D_{\mathrm{KL}}(p_T\Vert m)\approx0.2374
\]

\[
D_{\mathrm{KL}}(p_S\Vert m)\approx0.2085
\]

因此：

\[
\operatorname{JSD}_{0.5}
=\frac{0.2374+0.2085}{2}
\]

\[
\boxed{\operatorname{JSD}_{0.5}\approx0.2229}
\]

这就得到了两个概率分布之间的另一种散度。

### 3. 为什么要研究 JSD？

因为不同散度会产生不同的优化行为。

| 方法 | 直观特点 |
|---|---|
| Forward KL | 更重视覆盖教师认为有概率的候选 |
| Reverse KL | 更倾向集中在学生已经选择的高概率区域 |
| JSD | 通过混合分布进行比较，具有较好的对称性（\(\beta=0.5\) 时） |

但是需要注意：

**论文并没有证明 JSD 是最好的选择。**

事实上，作者在后续消融实验中发现，前向 KL 在其实验设置中效果更好，因此后续实验主要采用 Forward KL。<FileCite ref="turn0file0" line_range_start={611} line_range_end={637}/>

所以你学习这篇论文时，**优先掌握 Forward KL 即可**。JSD 主要说明 OPSD 是一个可以使用不同分布散度函数的通用框架。

---

## 五、Per-Token Pointwise Divergence Clipping：为什么还要裁剪 KL？

这是作者提出的一个更具体的训练优化机制。

你先思考一个问题：

> 如果教师和学生的概率分布相差很大，是不是代表这里的学习信号一定很重要？

不一定。

作者通过实验发现，某些与表达风格相关的 Token，会产生非常大的 KL 贡献。

例如：

- `however`
- `perhaps`
- `therefore`
- `wait`

它们可能更多反映模型的表达习惯，而不是数学推理本身。

如果少数这样的 Token 对损失贡献特别大，就可能让模型主要学习写作风格，而没有充分学习数学内容。

### 1. 为什么要在词表级别裁剪？

标准前向 KL 可以写成：

\[
D_{\mathrm{KL}}(p_T\Vert p_S)
=
\sum_{v\in V}
\underbrace{
p_T(v)\log\frac{p_T(v)}{p_S(v)}
}_{\ell_v}
\]

其中 \(\ell_v\) 就是某个候选 Token 对 KL 的贡献。

还记得我们之前算出的例子吗？

| 候选 Token | KL 单项贡献 |
|---|---:|
| `7` | +1.1090 |
| `8` | −0.1946 |
| `9` | 0 |
| 合计 | 0.9144 |

这里有一个容易忽略的细节：**单个 KL 求和项可以是负数，但完整的 KL 散度一定非负。**

现在假设裁剪阈值：

\[
\tau=0.5
\]

作者的思路是限制单个贡献：

\[
\ell_v^{\text{clip}}=\min(\ell_v,\tau)
\]

那么：

| 候选 Token | 原始贡献 | 裁剪后的贡献 |
|---|---:|---:|
| `7` | 1.1090 | 0.5000 |
| `8` | −0.1946 | −0.1946 |
| `9` | 0 | 0 |
| 合计 | 0.9144 | 0.3054 |

你可以看到，最大的贡献从 1.1090 被限制在 0.5。

这里的数值只是演示裁剪机制，不是论文采用的具体阈值。

### 2. 论文为什么还引入 f-divergence？

作者为了让裁剪适用于更一般的分布散度，定义：

\[
\ell_{n,v}^{(f)}
=
p_T(v\mid\cdot)
f\left(
\frac{p_S(v\mid\cdot)}
{p_T(v\mid\cdot)}
\right)
\]

其中：

- \(n\)：学生轨迹的预测位置。
- \(v\)：词表中的某个候选 Token。
- \(f\)：决定采用哪一种散度的函数。

如果选择：

\[
f(t)=-\log t
\]

就得到前向 KL 的单项贡献：

\[
\ell_{n,v}
=p_T(v)\log\frac{p_T(v)}{p_S(v)}
\]

随后作者对这些单项贡献进行裁剪：

\[
\boxed{
D_{\text{clip}}^{(f)}
=
\frac{1}{|\hat y|}
\sum_{n=1}^{|\hat y|}
\sum_{v\in V}
\min(\ell_{n,v}^{(f)},\tau)
}
\]

注意，这里存在**两层求和**。

第一层：

\[
\sum_{v\in V}
\]

遍历当前位置整个词表中的候选 Token。

第二层：

\[
\sum_{n=1}^{|\hat y|}
\]

遍历学生轨迹的所有预测位置。

所以裁剪发生在：

**某个生成位置 × 某个词表条目** 的粒度上。

它不是将一整条轨迹的 KL Loss 简单截断。

另外，由于裁剪发生在求和之前，最终的裁剪损失甚至可能为负，这也是论文明确提到的现象。它并不再严格具备普通 KL 散度的全部性质。<FileCite ref="turn0file0" line_range_start={758} line_range_end={774}/>

---

## 六、公式 (8)：整体优化目标到底是什么意思？

论文写道：

\[
\boxed{
L(\theta)
=
\mathbb E_{(x,y^\star)\sim S}
\mathbb E_{\hat y\sim p_S(\cdot\mid x)}
\left[
D(p_T\Vert p_S)(\hat y\mid x)
\right]
}
\tag{8}
\]

这里有两个期望符号：

\[
\mathbb E_{(x,y^\star)\sim S}
\]

代表从整个数学训练数据集中采样题目。

而：

\[
\mathbb E_{\hat y\sim p_S(\cdot\mid x)}
\]

代表学生针对某道题，根据当前策略采样生成轨迹。

也就是说，公式 (8) 的含义是：

**希望在整个训练数据集、学生可能生成的各种轨迹上，教师与学生的平均分布差异尽量小。**

但我们不可能枚举：

- 数据集中所有问题；
- 每个问题所有可能的答案；
- 每条答案所有可能的生成路径。

因此，实际训练使用采样近似。

例如：

- 随机采样 32 道题。
- 每道题生成一条学生轨迹。
- 计算 32 条轨迹的蒸馏损失。
- 对 Batch 求平均。
- 反向传播更新参数。

这就是 Algorithm 1 对公式 (8) 的实际近似求解。

还有一个细节：论文计算直接蒸馏损失时，将已经采样出来的学生轨迹视作固定的训练序列，不通过离散采样过程本身进行普通反向传播。

因此，公式 (8) 是描述整体训练目标，而 Algorithm 1 才是实际的迭代训练程序。

---

## 七、公式 (9)：为什么突然又出现 Policy Gradient？

这里是整个方法部分第二个值得重点理解的地方。

作者提出：

**除了比较整个词表上的教师、学生概率分布，还可以只利用学生实际采样的 Token 来构造强化学习式的更新信号。**

这是两个不同的实现思路。

### 方法 A：Full-Vocabulary Logit Distillation

也就是前面讲的方法。

假设当前位置学生实际采样了 `8`，但是模型仍然比较整个词表：

| Token | Student | Teacher |
|---|---:|---:|
| `7` | 0.2 | 0.8 |
| `8` | 0.7 | 0.1 |
| `9` | 0.1 | 0.1 |

利用所有候选的概率计算 KL。

### 方法 B：Sampled-Token Distillation

另一种方法只关注学生实际采样得到的 Token。

假设学生实际采样的是：

`8`

它只需要查询：

\[
p_T(8)=0.1
\]

以及：

\[
p_S(8)=0.7
\]

然后定义：

\[
\boxed{
A_n=
\log p_T(\hat y_n\mid x,y^\star,\hat y_{<n})
-
\log p_S(\hat y_n\mid x,\hat y_{<n})
}
\]

这里也叫 Advantage，但它不同于 GRPO 的组相对 Advantage。

在 OPSD 的这个替代方法中：

\[
A_n=\log\frac{p_T(\hat y_n)}{p_S(\hat y_n)}
\]

### 1. 计算一个具体的 Advantage

如果学生采样了错误的 `8`：

\[
A_n=\log\frac{0.1}{0.7}
\]

得到：

\[
\boxed{A_n\approx-1.946}
\]

它是负数。

这说明教师相比学生，更不支持当前采样的 Token `8`。

因此训练应该降低学生将来选择这个 Token 的倾向。

反过来，如果学生采样到了 `7`：

\[
A_n=\log\frac{0.8}{0.2}
\]

\[
\boxed{A_n\approx+1.386}
\]

说明教师比学生更支持 `7`。

因此训练应该鼓励它。

这里就很像强化学习了：

- \(A_n>0\)：鼓励采样的 Token。
- \(A_n<0\)：抑制采样的 Token。

### 2. 公式 (9) 是怎么更新参数的？

论文给出的损失：

\[
\boxed{
L(\theta)
=
-\mathbb E
\left[
\frac{1}{|\hat y|}
\sum_{n=1}^{|\hat y|}
A_n\log p_S(\hat y_n\mid x,\hat y_{<n})
\right]
}
\tag{9}
\]

前面的负号，是因为我们通过梯度下降最小化 Loss。

其中 \(A_n\) 被视为固定数值，不通过 \(A_n\) 本身反向传播。

所以：

\[
\nabla_\theta L
=
-\mathbb E
\left[
\frac{1}{|\hat y|}
\sum_n
A_n\nabla_\theta\log p_S(\hat y_n)
\right]
\]

它与强化学习中的 Policy Gradient 形式非常接近。

对单个位置来说：

- 正优势：提高这个采样 Token 的对数概率。
- 负优势：降低这个采样 Token 的对数概率。

注意，这里的优势值来自教师与学生的对数概率比，而不是像 GRPO 一样来自整条轨迹的最终正确率。

### 3. 那这两种方法究竟有什么差异？

| 对比 | Full-Vocabulary | Sampled-Token |
|---|---|---|
| 监督范围 | 每个位置的整个词表 | 每个位置实际采样的 Token |
| 主要训练方式 | 概率分布匹配 | Policy Gradient 式更新 |
| 学习信号 | 分布散度 | \(A_n=\log p_T-\log p_S\) |
| 计算特点 | 需要处理完整概率分布 | 不需要显式计算完整词表的散度 |
| 与 RL 的关系 | 直接知识蒸馏 | 更接近带逐 Token 奖励的 RL |

还有一个理论上的联系：

如果从学生分布中取期望，

\[
\mathbb E_{\hat y_n\sim p_S}[A_n]
=
-D_{\mathrm{KL}}(p_S\Vert p_T)
\]

所以采样 Token 形式与反向 KL 有联系。

但它和直接最小化前向 KL 的全词表蒸馏，**并不是完全等价的优化实现**。

### 4. 作者最终选择哪个？

论文比较了这两种方法。

<box border radius="lg" padding={3} gap={2}>
  <title size="md">论文 Table 4：Qwen3-4B 实验</title>
  <Chart content={{"chartType":"bar","meta":{"description":"pass@8 准确率（%）"},"xKey":"benchmark","series":[{"dataKey":"full","label":"全词表蒸馏"},{"dataKey":"sampled","label":"采样 Token 蒸馏"}],"yAxisMin":0,"data":[{"benchmark":"AIME25","full":84.1,"sampled":82.1},{"benchmark":"HMMT25","full":60,"sampled":57.3}]}}/>
  <caption>论文使用 2048 Token 生成预算进行这一消融比较。<FileCite ref="turn0file0" line_range_start={787} line_range_end={793}/></caption>
</box>

在这组实验里，Full-Vocabulary 方法表现更好，因此作者的主要实验采用全词表 Logit Distillation。

这也说明：**公式 (9) 是一个替代方案，而不是实现 OPSD 必须采用的核心损失。**

---

## 八、最后一段：OPSD 为什么要和 STaR 比较？

STaR（Self-Taught Reasoner）是较早的一种推理自训练方法。

它的核心流程是：

<box border radius="lg" padding={3} gap={1}>
  **STaR**

  生成推理轨迹 → 根据正确答案筛选 → 保留成功轨迹 → 使用 SFT 训练。
</box>

例如，同一道数学题产生四条轨迹：

| 轨迹 | 最终结果 | STaR | OPSD |
|---|---|---|---|
| A | 正确 | 保留，SFT | 计算逐 Token 监督 |
| B | 错误 | 丢弃 | 仍可计算逐 Token 监督 |
| C | 错误 | 丢弃 | 仍可计算逐 Token 监督 |
| D | 正确 | 保留，SFT | 计算逐 Token 监督 |

因此两者最大的区别是：

**STaR 主要从成功轨迹学习，而 OPSD 也尝试从失败轨迹中提取学习信号。**

对于 STaR，如果一批轨迹全部失败，那么该批轨迹可能全部被过滤掉，没有成功轨迹可用于这一轮的 SFT。

但 OPSD 并不需要最终答案正确，仍然可以计算教师与学生在各个位置上的分布差异。

### 和 GRPO 再联系起来

| 方法 | 学习信号 | 粒度 |
|---|---|---|
| SFT | 标准答案中的 Token | Token 级硬标签 |
| STaR | 成功轨迹筛选后进行 SFT | 序列级筛选 + Token 级监督 |
| GRPO | 最终奖励构造的 Advantage | 序列级优势，共享给轨迹内各 Token |
| OPSD Full-Vocab | 教师、学生的分布差异 | 每个位置的全词表监督 |
| OPSD Sampled-Token | 教师对采样 Token 的对数概率优势 | 逐 Token 优势 |

这就是作者在最后一段强调 *dense-reward policy gradient* 的原因。

其意思并不是 OPSD 完全等于 GRPO，而是说：**OPSD 的采样 Token 版本可以解释为一种具有稠密逐 Token 学习信号的策略梯度算法。**

---

## 九、整段 Methods 最值得记住的五个知识点

我给你按照重要性做个总结：

1. **Algorithm 1：** 学生先生成轨迹，然后教师和学生分别对这条轨迹计算概率分布，汇总损失并更新学生模型。

2. **公式 (6)：** 在学生每个生成位置上，计算教师与学生的概率分布散度，再沿整条轨迹取平均。

3. **公式 (7)：** JSD 是一种替代 KL 的分布散度，但论文实验更支持 Forward KL。

4. **Pointwise Clipping：** 限制某些词表条目过大的散度贡献，防止训练被少数风格相关 Token 主导。

5. **公式 (9)：** 可以将监督改写成 Policy Gradient 形式，通过 \(A_n=\log p_T-\log p_S\) 鼓励或抑制学生实际采样的 Token。

**我的建议是：先把公式 (6) 和公式 (8) 完全理解，再研究公式 (9)。** 因为作者最终采用的主要实验方法是全词表蒸馏。公式 (9) 更重要的意义，是帮你理解 OPSD、知识蒸馏和强化学习之间的数学联系。

从科研视角看，这篇文章最核心的创新并不是 KL、JSD 或 Policy Gradient 本身，而是**在学生自己的 On-Policy 轨迹上，通过给同源教师提供标准答案这一特权信息，构造稠密的学习信号**。

---

## Assistant
*2026-10-24 14:21*
> ❔ text

---

## User
*2026-10-24 15:19*
，但完整的 KL 散度一定非负。这是什么原因导致的，2. 论文为什么还引入 f-divergence？
作者为了让裁剪适用于更一般的分布散度，定义：的公式我看明白了，但是结果没有看明白，或者这个公式要去实现或者说明什么我没有明白
在你的讲解过程中 我发现包括你也说了 作者其实讲了很多除了算法本身之外的内容 为了方便读者了解 你就直接说出来：作者在列出每个小方法的不同分支后 最后都选取了哪一个 以及整体顺下来是怎么个情况
你带我读一下并分析一下整个第 4 章节（即实验部分）的所有完整实验以及结论分析，具体包括：
1. 消融实验设置；
2. 数据集设置；
3. 从图 3 开始对应的图表内容讲解。

---

## Assistant
*2026-10-24 15:19*
我会按论文原文把第 4 章完整梳理：先解释 KL 非负性和 f-divergence 的作用，再列出作者最终采用的各项训练选择，最后逐一核对实验设置、Figure 3 及后续图表。之前有几处实验数字和结论需要重新对照原表，避免把消融结果误当作主实验。

---

## Assistant
*2026-10-24 15:19*
<details><summary>工具调用 · container.exec</summary>

```unknown
bash -lc cat /home/oai/skills/pdfs/SKILL.md | head -100 && ls -la /mnt/data | head
```

</details>

---

## Tool
*2026-10-24 15:19*
---
name: pdfs
description: Reliable, workflow-driven PDF processing: render → verify → operate → re-render/verify, covering reading, inspection, extraction, editing, forms, OCR, redaction, conversion, and diffing. Prefer authoring in DOCX or PPTX (then converting to PDF) for text-heavy docs or slide-like layouts; use ReportLab here for programmatic PDF generation.
---

# PDF Skill (Read • Inspect • Extract • Edit • Render • Forms • OCR • Redact • Convert • Diff)

This skill is designed for **reliable, workflow-driven** PDF work: **render -> verify -> operate -> re-render verify**.

## Before you touch PDFs: should this be DOCX/PPTX instead?

Even if the user asks for a PDF deliverable, the best workflow is often:

- **Text-heavy, business-doc layout (headings, TOC, long tables, rich lists)** -> use the **DOCX skill** to author, then convert to PDF with `lo_convert_to_pdf.py`.
- **Slide-like visual layout (charts, callouts, fixed positioning, figure captions)** -> use the **Slides skill** (PPTX) to author, then export to PDF.
- **Programmatic generation** -> ReportLab (this skill) is fine.

If you find yourself hand-tuning line breaks or typography in ReportLab, you probably picked the wrong authoring format.

---

## Core loop (always)

1) Render to images

```bash
python /home/oai/skills/pdfs/scripts/render_pdf.py input.pdf --out_dir /mnt/data/_renders/in --dpi 200
```

2) Inspect PNGs (tables/figures/layout are authoritative)

3) Perform the edit/extract/create

4) Re-render and compare

```bash
python /home/oai/skills/pdfs/scripts/compare_renders.py before.pdf after.pdf --out_dir /mnt/data/_diff --dpi 200
```

---

## Task index (progressive)

Start with the smallest task that answers the user:

### Read / review
- `tasks/read_review.md`

### Extract (text/layout/tables/images/attachments/forms)
- `tasks/extract.md`
- `tasks/coords.md` (coordinate sanity)

### Edit (merge/split/rotate/crop/watermark/paginate/encrypt/repair)
- `tasks/edit.md`
- `tasks/compare.md` (visual regression)

### Forms
- Fillable forms: `tasks/forms_annotations.md`
- Debugging/introspection: `tasks/forms_debugging.md`
- Non-fillable / stamping workflow: `tasks/forms_nonfillable.md`

### OCR
- `tasks/ocr.md`

### Preflight / normalize
- `tasks/preflight.md`

### Redaction
- `tasks/redact.md`

### Renderer parity
- `tasks/parity.md`

### Batch processing
- `tasks/batch.md`

### Create / convert
- `tasks/create.md`
- `tasks/convert.md`
- `tasks/js_tools.md` (pdf-lib, pdfjs)


---

## Package map (where things live)

This pack includes a `manifest.txt` that is a **pure list of relative file paths** used by download tooling.

Quick map:

- **tasks/** (what to do)
  - `read_review.md` - render-first reading/review
  - `extract.md` - extract text/layout/tables/images/attachments/forms
  - `coords.md` - coordinate system cheatsheet (PDF pt vs image px)
  - `edit.md` - merge/split/select/rotate/crop/watermark/paginate/encrypt/repair
  - `compare.md` - visual diff workflow
  - `forms_annotations.md` - fillable forms + appearance pitfalls + correctness checklist
  - `forms_debugging.md` - widget-level introspection + acceptable values
  - `forms_nonfillable.md` - stamp-by-boxes workflow for non-fillable forms
  - `ocr.md` - OCR scanned PDFs to searchable
total 1684
drwxrwsr-x 1 oai  oai_shared    4096 Oct 24 15:19 .
drwxr-xr-x 1 root root          4096 Oct  7 08:41 ..
-rw-r--r-- 1 root oai_shared 1711114 Oct 24 15:19 zhao26be.zh-CN.dual.pdf


---

## Assistant
*2026-10-24 15:19*
<details><summary>工具调用 · container.exec</summary>

```unknown
bash -lc pdfinfo /mnt/data/zhao26be.zh-CN.dual.pdf | head -20; pdftotext -f 6 -l 10 -layout /mnt/data/zhao26be.zh-CN.dual.pdf /mnt/data/section4.txt; wc -l /mnt/data/section4.txt; grep -n '4\.\|Table [2345678]\|Figure [345]' /mnt/data/section4.txt | head -110
```

</details>

---

## Tool
*2026-10-24 15:19*
Producer:        BabelDOCv0.6.2_1792773410.3218954_Translation_generated_by_AI,please_carefully_discern
Custom Metadata: no
Metadata Stream: no
Tagged:          no
UserProperties:  no
Suspects:        no
Form:            none
JavaScript:      no
Pages:           16
Encrypted:       no
Page size:       1224 x 792 pts
Page rot:        0
File size:       1711114 bytes
Optimized:       no
PDF version:     1.7
504 /mnt/data/section4.txt
68:Figure 3. Token Efficiency of OPSD. We compare OPSD and GRPO on Qwen3-1.7B under the same effective training batch size,                                                                                                                                                                                    图 3。 OPSD 的词元效率。 我们在相同有效训练批次大小下，比较 Qwen3-1.7B 上的 OPSD 和 GRPO，并报告随训练步数和总生
95:4. Experiments                                                                                                                                                    our experiments. All experiments are conducted on A100                                                                                    4. 实验                                                                                                                                                     实验均在配备 LoRA 的 A100 或 H100 GPU 上进行
101:     (1) How does OPSD compare to SFT and GRPO in rea-                                                                                                            4.2. Main Results                                                                                                                               (1) OPSD 在推理性能和样本效率方面与监督微调和                                                                                                                         4.2. 主要结果
102:         soning performance and sample efficiency? (§4.2)
103:                                                                                                                                                                  Table 2 reports results on competition-level mathematical                                                                                       GRPO 相比如何？(§4.2) (2) OPSD 中的逐词元逐点                                                                                                                   表2 报告了在竞赛级数学推理基准上的结果。OPSD
105:                                                                                                                                                                  reasoning benchmarks. OPSD consistently outperforms SFT                                                                                         KL 裁剪如何帮助稳定训练？(§4.3.3) (3) 生成风格、                                                                                                                    始终优于 SFT，并在所有规模上优于基础模型，在每
106:         help stabilizing training? (§4.3.3)
107:     (3) What is the effect of generation style, generation length                                                                                                and improves over the base model across all scales, match-                                                                                      生成长度对性能有何影响？(§4.3.4) (4) 全词表                                                                                                                        种设置下都匹配或超过 GRPO。值得注意的是，
108:         on performance? (§4.3.4)                                                                                                                                 ing or exceeding GRPO in every setting. Notably, OPSD                                                                                           logit 蒸馏相比采样词元策略梯度是否带来优势？                                                                                                                           OPSD 仅使用每个问题的单次 rollout 就实现了这些
111:                                                                                                                                                                  and converges within 100 steps, with each problem requir-                                                                                       (§4.3.5)                                                                                                                                            增益，并在 100 步内收敛，每个问题只需要 1024 个
112:         over sampled-token policy gradient? (§4.3.5)
115:4.1. Experimental Setup                                                                                                                                                                                                                                                                                     4.1. 实验设置                                                                                                                                                 16k 词元，并且由于熵坍缩可能在后续步骤中出现性
134:Table 2. Performance comparison on mathematical reasoning benchmarks for Qwen3 models. We report Avg@12 under the sampling               表 2。 Qwen3 模型在数学推理基准上的性能比较。我们按照 Qwen3 博客推荐的采样配置报告 Avg@12（温度 1.0，最大生成长度
146:                           + SFT                     72.3             64.2          42.9           59.8                                                                       72.3       64.2        42.9         59.8
147:                           + GRPO                    76.4             68.9          46.7           64.0                                                     + GRPO            76.4       68.9        46.7         64.0
148:                           + OPSD                    77.8             70.8          45.8           64.8                                                     + OPSD            77.8       70.8        45.8         64.8
150:                           Base (Instruct)           74.9             66.4          42.2           61.2                                                     Base（Instruct）    74.9       66.4        42.2         61.2
153:                           + GRPO                    75.6             68.1          44.4           62.7                                                     + GRPO            75.6       68.1        44.4         62.7
163:esize that earlier tokens may contribute more to effective            JSD on AIME25 with Qwen3-1.7B in Table 3. All ob-                  我们假设，较早的词元可能对有效蒸馏贡献更大，因                         在 AIME25 上使用 Qwen3-1.7B 的 JSD，见表 3。所
168:As shown in Figure 3, OPSD achieves higher token learn-                                                                                  如图3所示，与 GRPO 相比，OPSD 在 100 个训练步                 从 36.7 提升至 43.9，并在第 100 步仍高于基线。相
177:These results suggest that OPSD may extract learning signal           Table 3. Comparison of divergence objectives on AIME25 with        OPSD 可能比 GRPO 和 SFT 更高效地从相同的推理                  表 3. 在 AIME25 上使用 Qwen3-1.7B 的散度目标比较。我
182:                                                                                                                                         4.3. 消融实验与讨论
184:4.3. Ablation Studies & Discussions
193:                                                                      4.3.2. E FFECT OF G ENERATION S TYLES AND                                                                          4.3.2. 生成风格与逐token KL裁剪的影响
197:4.3.1. E FFECT OF D IVERGENCE O BJECTIVE                              Another key design choice in OPSD is the generation style          4.3.1. 散度目标的影响                                  OPSD 中另一个关键设计选择是学生模型和教师模型的
254:(reasoning connectives), and other. Table 7 reports the                                                             0      25     50     75      100                            0      25     50     75      100                                                                                                      0      25   50    75     100                          0      25   50    75     100
257:Across all model sizes, the TM-off student paired with a                                 Figure 5. Effect of Generation Length on Qwen3-1.7B. We com-                                                              在所有模型规模上，与 TM-on 教师配对的 TM-off 学                                         图 5。 生成长度对 Qwen3-1.7B 的影响。我们在 AI
260:                                                                                         AIME24.
266:in Table 7, this expectation is highly skewed, with stylistic                                                                                                                                                      词元贡献了不成比例的大值。这促使我们使用逐点裁
275:                                                                                         vocabulary logit distillation. As shown in Figure 5, in-
292:                                50                                                       4.3.5. L EARNING O BJECTIVE C OMPARISON : F ULL                                                                                                          50                                       4.3.5. 学习目标比较：完整词汇表 logits 蒸馏 vs. 采样
298:Figure 4. Effect of Per-Token pointwise KL Clipping on Qwen3-                            OPSD can instantiate this objective in two ways. (1) Full-                                                                图 4。逐词元逐点 KL 裁剪对在 AIME24 上评估的
299:1.7B evaluated on AIME24. Clipping prevents performance col-                                                                                                                                                       Qwen3-1.7B 的影响。裁剪可防止性能崩溃。
305:                                                                                                                                                                                                                   4.3.3. 逐 token 逐点裁剪的效果
306:4.3.3. E FFECT OF P ER -T OKEN P OINTWISE C LIPPING                                      proper token-level f -divergence between the two policies.                                                                                                                                        算，从而得到两个策略之间适当的词元级 f散度，即
308:As shown in Table 7, stylistic tokens can exhibit higher                                                                                                                                                           如表7，风格词元可能比数学相关 token 表现出更高                                             两个策略之间的差异。（2）采样 token 优势策略梯
314:ing per-token pointwise clipping. As shown in Figure 4
326:                                                                                         get during distillation. Table 4 summarizes the results. The                                                              4.3.4. 生成长度的影响
327:4.3.4. E FFECT OF G ENERATION L ENGTH                                                                                                                                                                                                                                                      Qwen3-4B 上比较这些变体。表 4总结了结果。全词
335:Table 4. Ablation on divergence computation strategies for OPSD on Qwen3-4B with 2048 generation length for distillation. We report       表 4. 在 Qwen3-4B 上使用 2048 生成长度进行蒸馏时，针对 OPSD 的散度计算策略消融实验。我们报告在 AIME25 和 HMMT25 上的
340:                OPSD w/ Full-vocabulary logit distillation (Agarwal et al., 2024)               84.1          60.0                                      OPSD 采用全词表 logit 蒸馏（Agarwal 等，2024）                                84.1         60.0
454:  representations, 2024.                                            Hu, E. J., Shen, Y., Wallis, P., Allen-Zhu, Z., Li, Y., Wang,                                                                         Hu, E. J.、Shen, Y.、Wallis, P.、Allen-Zhu, Z.、Li,
472:  Learning, pp. 6621–6642. PMLR, 2024.
488:  2024. URL https://openreview.net/forum?                             Qin, Z., Dong, B., Zhou, L., Fleureau, Y., Lample, G.,          h0qf7IBZZ。
494:                                                                      2024.


---

## Assistant
*2026-10-24 15:19*
<details><summary>工具调用 · container.exec</summary>

```unknown
bash -lc python - <<'PY'
import fitz
p=fitz.open('/mnt/data/zhao26be.zh-CN.dual.pdf')
for j in [5,6,7,8,9,10,11,12,13,14,15]:
 page=p[j];R=page.rect
 print('PAGE',j+1,'coords',R)
 text=page.get_text(clip=fitz.Rect(0,0,R.width/2,R.height))
 open(f'/mnt/data/english_page_{j+1}.txt','w').write(text)
 print('chars',len(text),'head=',repr(text[:155]))
PY
```

</details>

---

## Tool
*2026-10-24 15:19*
PAGE 6 coords Rect(0.0, 0.0, 1224.0, 792.0)
chars 4802 head= 'On-Policy Self-Distillation for Large Language Models\n0\n25\n50\n75\n100\nGradient Update Steps\n48\n50\n52\n54\n56\n58\nAvg@12 Accuracy (%)\nAIME24\n0\n25\n50\n75\n100\nGrad'
PAGE 7 coords Rect(0.0, 0.0, 1224.0, 792.0)
chars 3649 head= 'On-Policy Self-Distillation for Large Language Models\nTable 2. Performance comparison on mathematical reasoning benchmarks for Qwen3 models. We report Avg@'
PAGE 8 coords Rect(0.0, 0.0, 1224.0, 792.0)
chars 4758 head= 'On-Policy Self-Distillation for Large Language Models\nthe model produces self-reflective chain-of-thought tokens,\nand Thinking Mode off (TM-off), in which '
PAGE 9 coords Rect(0.0, 0.0, 1224.0, 792.0)
chars 5219 head= 'On-Policy Self-Distillation for Large Language Models\nTable 4. Ablation on divergence computation strategies for OPSD on Qwen3-4B with 2048 generation leng'
PAGE 10 coords Rect(0.0, 0.0, 1224.0, 792.0)
chars 4576 head= 'On-Policy Self-Distillation for Large Language Models\nImpact Statement\nThis paper presents work whose goal is to advance the field\nof machine learning. Our'
PAGE 11 coords Rect(0.0, 0.0, 1224.0, 792.0)
chars 4815 head= 'On-Policy Self-Distillation for Large Language Models\nLiu, Z., Chen, C., Li, W., Qi, P., Pang, T., Du, C., Lee,\nW. S., and Lin, M. Understanding r1-zero-li'
PAGE 12 coords Rect(0.0, 0.0, 1224.0, 792.0)
chars 2510 head= 'On-Policy Self-Distillation for Large Language Models\nY., Su, Y., Zhang, Y., Zhang, Y., Wan, Y., Liu, Y., Wang,\nZ., Cui, Z., Zhang, Z., Zhou, Z., and Qiu, '
PAGE 13 coords Rect(0.0, 0.0, 1224.0, 792.0)
chars 3853 head= 'On-Policy Self-Distillation for Large Language Models\nA. Limitations and Future Directions\nDue to computational constraints, our experiments are limited to'
PAGE 14 coords Rect(0.0, 0.0, 1224.0, 792.0)
chars 2923 head= 'On-Policy Self-Distillation for Large Language Models\nTable 7. Per-token KL divergence by token category across generation styles. Mean per-token KL diverg'
PAGE 15 coords Rect(0.0, 0.0, 1224.0, 792.0)
chars 1984 head= 'On-Policy Self-Distillation for Large Language Models\nTable 9. Training Configuration for SFT.\nParameter\nSFT\nLearning Rate\n5 × 10−6\nEffective Batch Size\n32'
PAGE 16 coords Rect(0.0, 0.0, 1224.0, 792.0)
chars 1314 head= 'On-Policy Self-Distillation for Large Language Models\nThis reward measures how much the privileged teacher prefers the sampled token ˆyn relative to the st'


---

## Assistant
*2026-10-24 15:19*
<details><summary>工具调用 · container.exec</summary>

```unknown
bash -lc for i in 6 7 8 9 13 14 15; do echo; echo =========PAGE$i=========; cat /mnt/data/english_page_$i.txt; done
```

</details>

---

## Tool
*2026-10-24 15:19*

=========PAGE6=========
On-Policy Self-Distillation for Large Language Models
0
25
50
75
100
Gradient Update Steps
48
50
52
54
56
58
Avg@12 Accuracy (%)
AIME24
0
25
50
75
100
Gradient Update Steps
34
36
38
40
42
44
46
Avg@12 Accuracy (%)
AIME25
0
25
50
75
100
Gradient Update Steps
22
24
26
28
30
32
Avg@12 Accuracy (%)
HMMT25
0
10
20
Tokens Generated (×106)
37
38
39
40
41
42
Avg@12 Accuracy (%)
Average
10
30
50
70
90
Gradient Update Steps
0.0
0.2
0.4
0.6
0.8
1.0
Fraction of Batches
Zero Reward Std Frac. of GRPO
GRPO
OPSD
Figure 3. Token Efficiency of OPSD. We compare OPSD and GRPO on Qwen3-1.7B under the same effective training batch size,
reporting Avg@12 accuracy with training steps and total tokens generated. Generation is capped at 1024 tokens for OPSD and 16k for
GRPO. At the same number of training steps, OPSD uses significantly fewer tokens but outperforms GRPO on all benchmarks. Despite
sampling more tokens, GRPO only receives a binary outcome reward, and stagnates due to reward diversity collapse (rightmost plot):
more than half of its batches have zero reward standard deviation within 100 steps, yielding no gradient signal. OPSD sidesteps this
disadvantage of outcome-based rewards by learning from a dense distillation loss even with fewer generated tokens.
OPSD as dense-reward policy gradient and comparison
to STaR.
The objective in Equation (9) can be seen as pol-
icy gradient with dense, token-level rewards. In Appendix
Section D, we formalize this and contrast with STaR (Ze-
likman et al., 2022), a closely related method that also uses
the same model to generate reasoning traces, then performs
rejection sampling followed by SFT on correct traces. This
procedure can be viewed as policy gradient with a sequence-
level binary reward that assigns identical credit to all tokens
and vanishes when samples are incorrect. In contrast, OPSD
provides feedback at every token position regardless of final-
answer correctness.
4. Experiments
We conduct comprehensive experiments to answer the fol-
lowing research questions:
(1) How does OPSD compare to SFT and GRPO in rea-
soning performance and sample efficiency? (§4.2)
(2) How does per-token pointwise KL clipping in OPSD
help stabilizing training? (§4.3.3)
(3) What is the effect of generation style, generation length
on performance? (§4.3.4)
(4) Does full-vocabulary logit distillation provide benefits
over sampled-token policy gradient? (§4.3.5)
4.1. Experimental Setup
Models and datasets.
We experiment with the
Qwen3 (Team, 2025b) model family at three scales: Qwen3-
1.7B, Qwen3-4B, and Qwen3-8B, using the instruct-tuned
versions. For training data, we use the mathematical reason-
ing subset of OpenThoughts (Guha et al., 2025), sampling
up to 30K problem-solution pairs with chain-of-thought
reasoning. We evaluate on competition-level mathematics
benchmarks including AIME 2024, AIME 2025, HMMT
2025.
Baselines. We compare against two methods trained on the
same dataset: (1) SFT, standard supervised fine-tuning on
expert trajectories, which can be seen as off-policy distilla-
tion from a more powerful LLM that generated the reasoning
traces; (2) GRPO (Shao et al., 2024), group relative policy
optimization with binary outcome rewards verified against
ground-truth answers. The max generation length is set to
16k.
Implementation details. We fix the teacher policy to be
the initial policy, rather than the currently updating learning
policy, as we find this helps stabilize training and implicitly
acts as regularization to prevent excessive deviation from
the initial policy. We use full-vocabulary logit distillation in
our experiments. All experiments are conducted on A100
or H100 GPUs with LoRA (Hu et al., 2022). More experi-
mental details are in Appendix B.
4.2. Main Results
Table 2 reports results on competition-level mathematical
reasoning benchmarks. OPSD consistently outperforms SFT
and improves over the base model across all scales, match-
ing or exceeding GRPO in every setting. Notably, OPSD
achieves these gains using only a single rollout per problem
and converges within 100 steps, with each problem requir-
ing only 1024 sampled tokens, whereas GRPO requires 8
rollouts of 16k tokens each and may exhibit performance
degradation in later steps due to entropy collapse—with
most of reward standard deviations within a group being
zero under this OpenThoughts dataset, yielding no learning
signal and wasting sampling budget. We also observe con-
sistent performance degradation under SFT across tasks and
model scales when trained on the same dataset, which we
attribute to the concise reasoning style of the ground truth
solutions which has reduced reasoning lengths at test time.
We attribute OPSD’s token efficiency to dense token-level
supervision from the teacher distribution, and we hypoth-
6

=========PAGE7=========
On-Policy Self-Distillation for Large Language Models
Table 2. Performance comparison on mathematical reasoning benchmarks for Qwen3 models. We report Avg@12 under the sampling
configuration recommended in the Qwen3 blog (temperature 1.0, maximum generation length 38k); full details are provided in Table 10.
For OPSD, we evaluate checkpoints every 20 steps up to 100 steps and report the best score. For GRPO, we report the peak performance
within 500 training steps, though we find GRPO performance to decrease for some tasks due to entropy collapse in later steps. For SFT,
we train on the same number of samples as OPSD. SFT performance degrades due to fine-tuning on concise reasoning solutions and
reduces generation length at test time, whereas OPSD transforms them into dense learning signal through rationalization.
Method
AIME24
AIME25
HMMT25
Average
Qwen3-8B
Base (Instruct)
75.8
65.6
43.9
61.8
+ SFT
72.3
64.2
42.9
59.8
+ GRPO
76.4
68.9
46.7
64.0
+ OPSD
77.8
70.8
45.8
64.8
Qwen3-4B
Base (Instruct)
74.9
66.4
42.2
61.2
+ SFT
70.2
62.3
43.4
58.6
+ GRPO
75.6
68.1
44.4
62.7
+ OPSD
76.4
68.3
46.1
63.6
Qwen3-1.7B
Base (Instruct)
51.5
36.7
23.1
37.1
+ SFT
48.4
36.3
22.7
35.8
+ GRPO
51.1
38.3
23.7
37.7
+ OPSD
57.2
43.9
29.2
43.4
esize that earlier tokens may contribute more to effective
distillation as they could represent more critical branching
points in the reasoning process.
As shown in Figure 3, OPSD achieves higher token learn-
ing efficiency within 100 steps of training as compared to
GRPO. Within 100 steps, GRPO’s performance stagnates
with less learning signal when the outcome reward within as
sampling group remains the same, leading to zero gradient.
These results suggest that OPSD may extract learning signal
from the same reasoning datasets more efficiently than both
GRPO and SFT, while substantially reducing training time.
4.3. Ablation Studies & Discussions
In this section, we conduct extensive ablations to study
key design choices in OPSD, including (1) the divergence
objective, (2) the generation styles of the student and teacher
(e.g., thinking-mode on/off), (3) the effect of per-token KL
clipping, (4) the impact of student generation length, and (5)
comparison between full-vocabulary logit distillation with
sampled-token distillation.
4.3.1. EFFECT OF DIVERGENCE OBJECTIVE
A key design choice in OPSD is the divergence used for per-
token distribution matching between the privileged teacher
and the student. We compare forward KL, reverse KL, and
JSD on AIME25 with Qwen3-1.7B in Table 3. All ob-
jectives are evaluated under the same pointwise clipping
scheme for stability. Forward KL consistently yields the
strongest gains, improving performance from 36.7 to 43.9
at step 50 and remaining above the baseline at step 100.
In contrast, reverse KL and JSD provide limited or nega-
tive improvements. We therefore adopt forward KL in all
remaining experiments.
Table 3. Comparison of divergence objectives on AIME25 with
Qwen3-1.7B. We report Avg@12 at different training steps. For-
ward KL significantly improves performance over the base model,
while reverse KL and JSD (β = 0.5) show limited or negative
gains.
Method
Base
Step 50
Step 100
Forward KL (KL(pT ∥pS))
36.7
43.9
41.1
Reverse KL (KL(pS ∥pT ))
36.7
37.5
35.0
JSD (β = 0.5)
36.7
36.9
39.0
4.3.2. EFFECT 
...[truncated]...
a crucial role in self-distillation: if reasoning problems exceed the model’s comprehension
threshold, the teacher policy cannot provide meaningful supervision even with access to ground-truth solutions. This
suggests that curriculum learning strategies—gradually increasing problem difficulty as the model improves—could enhance
training effectiveness. Exploring adaptive curricula that maintain problems at the frontier of model capabilities represents an
important direction for scaling OPSD to more challenging reasoning tasks.
B. Experimental Details
Non-thinking mode results.
We further evaluate a fully non-thinking configuration on the Qwen3 family, where both the
student and teacher operate with Qwen3 thinking mode disabled during training, and evaluation is also conducted under
non-thinking inference. As shown in Table 5, OPSD improves over the corresponding non-thinking base model in most
settings, with the largest gains observed on Qwen3-8B: +23.3 on AIME24, +15.3 on AIME25, and +7.5 on HMMT25. The
gains are not uniform across scales: the 8B model benefits more substantially than the 4B and 1.7B models.
Table 5. Fully non-thinking OPSD results across model scales. Both student and teacher use Qwen3 non-thinking mode during training,
and evaluation is also performed with non-thinking inference. We report Avg@12 accuracy. For each model and benchmark, full results
across steps are shown in Table 6.
Model
AIME24
AIME25
HMMT25
Avg. Performance Gain
Base
OPSD
∆
Base
OPSD
∆
Base
OPSD
∆
Qwen3-1.7B
11.9
15.0
+3.1
9.2
6.2
-3.0
5.0
5.8
+0.8
+0.3
Qwen3-4B
23.1
31.1
+8.0
21.4
21.1
-0.3
10.8
16.4
+5.6
+4.4
Qwen3-8B
26.4
49.7
+23.3
19.7
35.0
+15.3
10.8
18.3
+7.5
+15.4
Table 6. Full step-wise results for fully non-thinking OPSD on Qwen3 models. Both student and teacher use Qwen3 non-thinking mode
during training, and evaluation is also performed with non-thinking inference. We report Avg@12 accuracy. The best checkpoint for each
model and benchmark is used in Table 5.
Model
Benchmark
Base
Step 50
Step 75
Step 100
Qwen3-1.7B
AIME24
11.9
15.0
13.9
12.5
AIME25
9.2
6.2
8.3
8.1
HMMT25
5.0
5.8
5.0
5.4
Qwen3-4B
AIME24
23.1
20.3
27.5
31.1
AIME25
21.4
21.4
20.8
21.1
HMMT25
10.8
11.1
13.1
16.4
Qwen3-8B
AIME24
26.4
49.7
45.3
38.3
AIME25
19.7
35.0
26.9
27.5
HMMT25
10.8
18.3
17.5
15.3
We provide the training and evaluation configurations for our SFT, GRPO and OPSD experiments in Tables 9, 8 and 10.
Note that we adopt the Thinking-Mode-off student / Thinking-Mode-on teacher configuration for main OPSD experiments.
For more experiment details, please refer to our released training code in https://github.com/siyan-zhao/OPSD.We didn’t
conduct tuning for the clipping parameter τ, optimizing this hyperparameter may yield further performance gains within the
same 100-step budget for larger models.
All experiments were conducted using 8 A100 or H100 GPUs with gradient checkpointing and Flash Attention 2 for memory
efficiency. We use the AdamW (Loshchilov & Hutter, 2017) optimizer and bfloat16 precision for all training runs. For
OPSD, unless otherwise stated, we used full-vocabulary logit distillation.
13

=========PAGE14=========
On-Policy Self-Distillation for Large Language Models
Table 7. Per-token KL divergence by token category across generation styles. Mean per-token KL divergence broken down by token
category (see Appendix C for detailed definitions), averaged over 10 problems. Thinking Mode OFF/ON indicates whether the student or
teacher LLM’s prompt format enables thinking mode. We find when student’s generation’s thinking mode is off and when the teacher’s
thinking mode is on, the KL signal on math related tokens are the highest. And we choose this setup for our experiments.
Qwen3-1.7B
Qwen3-4B
Qwen3-8B
Student Teacher Style Math Other Style Math Other Style Math Other
TM-off TM-off
0.68
0.12
0.11
0.61
0.06
0.10
0.56
0.05
0.11
TM-on
TM-off
0.51
0.10
0.17
0.41
0.05
0.18
0.33
0.05
0.15
TM-on
TM-on
0.51
0.09
0.08
0.50
0.04
0.09
0.42
0.04
0.08
TM-off TM-on
0.85
0.14
0.25
0.92
0.10
0.29
0.79
0.06
0.25
Table 8. Training Configuration for GRPO and OPSD
Parameter
GRPO
OPSD
Learning Rate
5 × 10−6
5 × 10−6
Effective Batch Size
32
32
LoRA Rank (r)
64
64
LoRA Alpha (α)
128
128
LoRA Target Modules
q proj, k proj, v proj, o proj,
gate proj, up proj, down proj
Max Completion Length
16,000
1024
Number of Generations per Prompt
8
1
Sampling Temperature
1.2
1.1
KL Coefficient (β)
0.0
–
Training Steps
500
100
C. Token Category Definitions
We categorize tokens into style and math groups using predefined keyword lists. These keyword sets are used to analyze the
per-token KL divergence stylistic tokens and mathematical knowledge tokens as in Section 4.3.1.
Style Tokens.
maybe, perhaps, probably, possibly, let, okay, ok, alright, hmm, wait, because, since, so, thus, hence,
therefore, but, however, although, though, yet, or, alternatively, instead, otherwise, actually, really, just, simply, basically,
very, quite, pretty, rather, fairly, now, then, next, first, second, finally, try, see, check, note, recall, think, idea, strategy,
approach, method, way, would, could, should, might, can, huge, large, big, small, tiny, interesting, tricky, complex, simple.
Math Tokens.
exponential, exponent, power, powers, base, logarithm, logarithms, log, ln, compare, comparing, compari-
son, less, equal, larger, smaller, greater, factor, factors, prime, divisible, equation, expression, formula, inequality, rational,
irrational, real, integer, coefficient, variable, constant, sum, product, difference, quotient, fraction, denominator, numerator,
root, square, cube, nth, maximum, minimum, optimize, bound.
D. Policy-Gradient Interpretation of OPSD and Comparison to STaR
Our OPSD objective in Equation (9) can be interpreted as a policy-gradient update with a dense, token-level reward signal
derived from privileged information. In this section, we show: (1) OPSD can be seen as a dense-reward policy gradient, and
(2) we contrast OPSD with STaR, demonstrating that STaR’s learning signal is sequence-level while OPSD is token-level.
14

=========PAGE15=========
On-Policy Self-Distillation for Large Language Models
Table 9. Training Configuration for SFT.
Parameter
SFT
Learning Rate
5 × 10−6
Effective Batch Size
32
LoRA Rank (r)
64
LoRA Alpha (α)
128
LoRA Target Modules
q proj, k proj, v proj, o proj,
gate proj, up proj, down proj
Max Sequence Length
16000
Number of Training Step
100
Table 10. Evaluation Parameters.
Parameter
Value
Max New Tokens
38912
Thinking Mode
Enabled
Top-p
0.95
Top-k
-1
Min-p
0.0
Presence Penalty
0.0
Samples per Prompt
12
Temperature
1.0
D.1. STaR as Sequence-Level Policy-Gradient
STaR (Zelikman et al., 2022) can be viewed as an approximation to an RL-style policy gradient objective. The language
model pθ induces a joint distribution over rationale r and answer y:
pθ(r, y | x) = pθ(r | x) pθ(y | x, r),
where the model first samples a latent rationale r before predicting the final answer y. Given an indicator reward R(y) =
1(y = y⋆), the expected return across the dataset S = {(xi, y⋆
i )}N
i=1 is
JSTaR(θ) =
N
X
i=1
E(r,y)∼pθ(·|xi)

1(y = y⋆
i )

.
(10)
Applying the log-derivative trick yields a policy gradient:
∇θJSTaR(θ) =
N
X
i=1
E(r,y)∼pθ(·|xi)
h
1(y = y⋆
i ) ∇θ log pθ(r, y | xi)
i
.
(11)
Note that the indicator function discards the gradient for all sampled rationales that do not lead to the correct answer y⋆
i : this
corresponds to the filtering step in STaR.
One limitation is that STaR’s reward is sequence-level: the binary indicator 1(y = y⋆) provides the same signal to all tokens
in a trajectory, offering no intermediate credit assignment. When all sampled trajectories are all incorrect, the learning signal
vanishes.
D.2. OPSD as Dense-Reward Policy Gradient
The sampled-token objective in Equation (9) can also be viewed as a policy-gradient method, but with a token-level reward.
Fix a training pair (x, y⋆) and let the student generate a trajectory ˆy ∼pS(· | x). At each position n, define the per-token
reward:
rn(x, ˆy) ≜log pT (ˆyn | x, y⋆, ˆy<n) −log pS(ˆyn | x, ˆy<n).
15


---

## Assistant
*2026-10-24 15:19*
<details><summary>工具调用 · container.exec</summary>

```unknown
bash -lc cat /mnt/data/english_page_8.txt && printf '\n======PAGE9======\n' && cat /mnt/data/english_page_9.txt
```

</details>

---

## Tool
*2026-10-24 15:19*
On-Policy Self-Distillation for Large Language Models
the model produces self-reflective chain-of-thought tokens,
and Thinking Mode off (TM-off), in which it generates re-
sponses directly. To determine which combination yields
the most effective learning signal, we analyze the forward
KL divergence KL(pT ∥pS) across all four student/teacher
mode pairings, categorizing tokens into three groups: math
(numerals, operators, and mathematical keywords), style
(reasoning connectives), and other. Table 7 reports the
mean per-token KL within each category.
Across all model sizes, the TM-off student paired with a
TM-on teacher yields the largest KL on math tokens, in-
dicating stronger supervision on mathematically relevant
tokens. The reported KL values correspond to the expected
divergence over the vocabulary at each position; as shown
in Table 7, this expectation is highly skewed, with stylistic
tokens contributing disproportionately large values. This
motivates our use of pointwise clipping to control such
heavy-tailed contributions. Empirically, this configuration
achieves the best downstream performance. We therefore
adopt the TM-off student / TM-on teacher configuration.
0
25
50
75
100
Gradient Update Steps
48
50
52
54
56
58
Avg@12 AIME24 Accuracy (%)
w/o per-token KL Clipping
w/ per-token KL Clipping
Figure 4. Effect of Per-Token pointwise KL Clipping on Qwen3-
1.7B evaluated on AIME24. Clipping prevents performance col-
lapse.
4.3.3. EFFECT OF PER-TOKEN POINTWISE CLIPPING
As shown in Table 7, stylistic tokens can exhibit higher
KL divergence than math-related tokens, causing them to
dominate the training signal. We mitigate this issue us-
ing per-token pointwise clipping. As shown in Figure 4
for Qwen3-1.7B, clipping stabilizes training and prevents
performance degradation, which is particularly important
given that OPSD converges rapidly within a hundred steps
of training. Note that the training loss can be negative due
to pointwise clipping before aggregating.
4.3.4. EFFECT OF GENERATION LENGTH
Since our objective operates at the token level (Eq. 6), the
number of generated tokens per sample directly determines
0
25
50
75
100
Gradient Update Steps
34
36
38
40
42
44
46
Avg@12 Accuracy (%)
AIME25 (Qwen3-1.7B)
Gen Length 4096
Gen Length 1024
0
25
50
75
100
Gradient Update Steps
50
52
54
56
58
60
Avg@12 Accuracy (%)
AIME24 (Qwen3-1.7B)
Gen Length 4096
Gen Length 1024
Figure 5. Effect of Generation Length on Qwen3-1.7B. We com-
pare student generation length of 1024 vs 4096 on AIME25 and
AIME24.
the amount of supervision signal available to the student.
Longer sequences expose the student to more teacher feed-
back, but they also increase computational cost and may
introduce noisy or uninformative continuations. To study
this trade-off, we conduct an ablation on Qwen3-1.7B by
varying the generation length of on-policy sampled stu-
dent responses among 1024 and 4096 tokens and use full-
vocabulary logit distillation. As shown in Figure 5, in-
creasing the generation length does not lead to consistent
improvements across either task. We attribute this to early
tokens being more critical for learning: as the student gen-
eration grows longer, later tokens become increasingly pre-
dictable to the teacher when conditioned on a sufficiently
long student prefix so less penalties are applied to later to-
kens. This phenomenon is also noted in (Lu & Lab, 2025).
4.3.5. LEARNING OBJECTIVE COMPARISON: FULL
VOCABULARY LOGITS DISTILLATION VS.
SAMPLED-TOKEN DISTILLATION
Our objective in Eq. 6 is defined as a per-token discrepancy
between the teacher and student distributions. In practice,
OPSD can instantiate this objective in two ways. (1) Full-
vocabulary logit distillation (as in GKD (Agarwal et al.,
2024)): for each token position, we compute D(pT ∥pS)
over the entire vocabulary via a full softmax, yielding a
proper token-level f-divergence between the two policies.
(2) Sampled-token advantage policy-gradient objective
(as in the on-policy distillation method of Lu & Lab (2025)):
we evaluate teacher and student log-probabilities only at
the token actually sampled by the student, ˆyn, and use
the reverse-KL term as a scalar advantage inside a policy-
gradient-style loss. Thus, the first variant directly matches
full token distributions, whereas the second optimizes an on-
policy RL objective shaped by the teacher’s log-probabilities
rather than a full-distribution divergence. We compare these
variants on Qwen3-4B using a 2048-token generation bud-
get during distillation. Table 4 summarizes the results. The
full-vocabulary divergence objective provides a consistent
gain over the sampled-token objective. This suggests that
exposing the student to the full teacher distribution offers
8

======PAGE9======
On-Policy Self-Distillation for Large Language Models
Table 4. Ablation on divergence computation strategies for OPSD on Qwen3-4B with 2048 generation length for distillation. We report
pass@8 accuracy on AIME25 and HMMT25. Full-distribution objectives (logit distillation) outperform sampled-token objectives.
Method Variant
AIME25
HMMT25
OPSD w/ Full-vocabulary logit distillation (Agarwal et al., 2024)
84.1
60.0
OPSD w/ Sampled-token distillation (Lu & Lab, 2025)
82.1
57.3
richer supervision than relying solely on per-token on-policy
shaping. However, the full-vocabulary computation incurs
higher peak memory usage due to storing vocabulary-sized
logits at every position, indicating a trade-off between per-
formance and efficiency.
5. Related Work
LLM Self-Training.
Our work connects to a line of re-
search showing that LLMs can improve by generating and
exploiting their own supervision signals (Allen-Zhu & Li,
2020; Xu et al., 2024b; Chen et al., 2024; Wang et al., 2023;
Sun et al., 2023; Yuan et al., 2024; Yang et al., 2024). Clos-
est in spirit is context distillation (Snell et al., 2022), which
uses the same underlying model as both teacher and student
by providing the teacher with privileged context and then
SFT the student on the teacher’s generated outputs without
context. This can be viewed as off-policy, where the learn-
ing signal is a discrete token sequence. In the reasoning
domain, ReST (Gulcehre et al., 2023) and STaR (Zelik-
man et al., 2022) similarly rely on iterative self-training
loops—generate rationales conditioned on hints or answers,
filter by rewards or ground-truth answers, and fine-tune
on successful trajectories—again yielding hard distillation;
Mitra & Ulukus (2025) extends this to soft distillation. In-
context editing (Qi et al., 2025) does on-policy sample from
student and shows that context-induced knowledge can be
internalized via soft distillation by minimizing divergences
and demonstrates this in knowledge editing settings. OPSD
differs from these approaches in that we perform on-policy,
soft distillation on the student’s own rollouts for reasoning
tasks: the teacher’s supervision is per-token distribution
matching rather than generating a rationale for SFT. OPSD
frames reasoning improvement as learning a conditional
distribution induced jointly by the dataset’s ground-truth so-
lutions and the model’s own reasoning ability. Concurrently,
SDPO (H¨ubotter et al., 2026) explored similar algorithm
with environment feedbacks as privilledged information
and SDFT (Shenfeld et al., 2026) explored on-policy self-
distillation on continual learning tasks.
On-Policy Distillation methods train a student model di-
rectly on trajectories sampled from its own policy, while
a teacher model provides per-token guidance through KL-
based regularization or related objectives (Agarwal et al.,
2024; Xu et al., 2024a; Gu et al., 2024; Lu & Lab, 2025;
Xiaomi, 2026; Yang et al., 2025). These approaches miti-
gate distribution shift by optimizing directly on the student’s
visitation distribution, but they typically rely on a distinct
and often larger teacher model. In this work, we explore
whether an LLM can teach itself by conditioning on more
privileged answer information and leveraging its own rea-
soning capability to guide a weaker version of itself toward
improved reasoning. On-policy training paradigms are also
widely used in robotics and deep reinforcement learning,
such as DAgger (Ross et al., 2011), where a human teacher
provides corrective supervision on the states visited by the
student policy.
Improving LLM Reasoning through SFT and RL. SFT
and RL are two primary methods for improving LLM rea-
soning ability. SFT on high-quality reasoning traces has
demonstrated strong performance (Yu et al., 2023; LI et al.,
2024; Paster et al., 2023; Team, 2025a; Ye et al., 2025;
Muennighoff et al., 2025; Zhou et al., 2023). However,
prior work shows that SFT can rely on memorization rather
than robust generalization (Chu et al., 2025). In contrast,
RL optimizes directly for outcome-based objectives can ex-
hibit better generalization (Huan et al., 2025). More recent
algorithms such as GRPO (Guo et al., 2025; Shao et al.,
2024) enable scalable RL by estimating advantages from
group-level rewards without requiring an explicit critic as in
PPO (Schulman et al., 2017). Building on this line of work,
a growing body of research highlights the effectiveness of
RLVR for reasoning tasks (Yu et al., 2025; Liu et al., 2025;
Yue et al., 2025; An et al., 2025; Zheng et al., 2025).
6. Conclusion
We introduced On-Policy Self-Distillation (OPSD), a sim-
ple yet effective framework for post-training large language
models on reasoning tasks. The intuition behind OPSD is
that a sufficiently capable reasoning LLM can teach itself
when it has access to privileged information about the an-
swer to a reasoning problem, utilizing its own rationalization
ability to grade its weaker self without access to the ground
truth. We experimentally demonstrated that OPSD achieves
better performance than off-policy distillation/SFT, and per-
forms on par with or better than GRPO, while exhibiting
significantly better sample efficiency than GRPO.
9


---

## Assistant
*2026-10-24 15:20*
<details><summary>工具调用 · container.exec</summary>

```unknown
bash -lc python - <<'PY'
import fitz
pdf=fitz.open('/mnt/data/zhao26be.zh-CN.dual.pdf')
for idx in [5,7,13]:
 p=pdf[idx];r=fitz.Rect(0,0,610,792)
 pix=p.get_pixmap(matrix=fitz.Matrix(1.8,1.8),clip=r,alpha=False)
 fn=f'/mnt/data/paperpage_{idx+1}_en.png';pix.save(fn)
 print(fn,pix.width,pix.height)
PY
```

</details>

---

## Tool
*2026-10-24 15:20*
/mnt/data/paperpage_6_en.png 1098 1426
/mnt/data/paperpage_8_en.png 1098 1426
/mnt/data/paperpage_14_en.png 1098 1426


---

## Tool
*2026-10-24 15:20*
<<ImageDisplayed>>

---

## Tool
*2026-10-24 15:20*
<<ImageDisplayed>>

---

## Tool
*2026-10-24 15:20*
<<ImageDisplayed>>

---

## Assistant
*2026-10-24 15:21*
<details><summary>工具调用 · api_tool.call_tool</summary>

```python3
{"path":"/files/read","args":{"read":[{"ref_id":"turn1file0","mode":"pages","start_page":6,"end_page":9,"include_images":false},{"ref_id":"turn1file0","mode":"pages","start_page":13,"end_page":15,"include_images":false}]}}
```

</details>

---

## Tool
*2026-10-24 15:21*
```json
{"api_tool_source":"files/read","results":[{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451","api_tool_source":"files/read"},{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451","api_tool_source":"files/read"}]}
```

---

## Assistant
*2026-10-24 15:21*
<details><summary>工具调用 · container.exec</summary>

```unknown
bash -lc python - <<'PY'
import fitz
pdf=fitz.open('/mnt/data/zhao26be.zh-CN.dual.pdf')
for file,page,rect in [ ('fig3_opsd.png',5,(48,66,564,226)),('fig4_clipping.png',7,(55,330,285,496)),('fig5_length.png',7,(306,66,558,222)) ]:
 p=pdf[page];pix=p.get_pixmap(matrix=fitz.Matrix(2.5,2.5),clip=fitz.Rect(*rect),alpha=False);pix.save('/mnt/data/'+file);print(file,pix.width,pix.height)
PY
```

</details>

---

## Tool
*2026-10-24 15:21*
fig3_opsd.png 1290 400
fig4_clipping.png 576 415
fig5_length.png 630 390


---

## Tool
*2026-10-24 15:22*
<<ImageDisplayed>>

---

## Tool
*2026-10-24 15:22*
<<ImageDisplayed>>

---

## Assistant
*2026-10-24 15:22*
我把论文第 4 章（正文第 6–9 页）和附录中的实验表格全部核对了一遍。先给你一个阅读结论：

**OPSD 最终采用的主要方案是：学生关闭 Thinking Mode、教师开启 Thinking Mode、使用前向 KL、开启逐点裁剪、采用全词表蒸馏、学生单次生成上限为 1024 Token，并且冻结初始教师。**

作者后面的大量内容，实际上都是为了说明为什么要做这些选择。

# 一、先解决你的两个数学疑问

## 1. 为什么 KL 的单项可以为负，但总 KL 一定非负？

先看前向 KL：

\[
D_{\mathrm{KL}}(P\Vert Q)
=\sum_{v\in V}P(v)\ln\frac{P(v)}{Q(v)}
\]

对于某一个 Token，如果 \(P(v)<Q(v)\)，那么：

\[
\ln\frac{P(v)}{Q(v)}<0
\]

所以这个 Token 对 KL 的单项贡献可以为负。

但有一个关键约束：**\(P\) 和 \(Q\) 是完整的概率分布，所有候选的概率都必须加起来等于 1。**

\[
\sum_v P(v)=\sum_v Q(v)=1
\]

我们可以用一个很简单的数学不等式来证明 KL 非负：

\[
\ln u\leq u-1,\qquad u>0
\]

将 \(u\) 替换为 \(Q(v)/P(v)\)，就有：

\[
\ln\frac{P(v)}{Q(v)}
\geq 1-\frac{Q(v)}{P(v)}
\]

两边乘以 \(P(v)\)：

\[
P(v)\ln\frac{P(v)}{Q(v)}
\geq P(v)-Q(v)
\]

最后对整个词表求和：

\[
\begin{aligned}
D_{\mathrm{KL}}(P\Vert Q)
&\geq \sum_v[P(v)-Q(v)]\\
&=1-1\\
&=\boxed{0}
\end{aligned}
\]

在概率分布具有相同有效支持、各项有限的通常情形下，只有两个分布完全相同时 KL 才等于零；如果存在 \(P(v)>0,Q(v)=0\)，KL 甚至可以是正无穷。

**核心直觉：某些 Token 的负贡献可以抵消其他 Token 的一部分正贡献，但在完整的概率分布上，不可能把总和抵消到负数。**

这就是 KL 非负性的来源，也称为 Gibbs 不等式。

## 2. 作者为什么还要引入 f-divergence？

这一点特别容易让初学者误以为作者又提出了一个新算法。

**实际上，f-divergence 在这里主要是一个统一的数学表达框架，而不是一个需要额外运行的训练分支。**

先看论文的定义：

\[
D_f(P\Vert Q)
=\sum_{v\in V}
P(v)f\left(\frac{Q(v)}{P(v)}\right)
\]

这里 \(f\) 是一个满足相应条件的凸函数（通常取 \(f(1)=0\)）。

关键在于：**不同的 \(f\)，可以对应不同的散度。**

例如，选择：

\[
f(t)=-\ln t
\]

代入后：

\[
\begin{aligned}
D_f(P\Vert Q)
&=\sum_vP(v)\left[-\ln\frac{Q(v)}{P(v)}\right]\\
&=\sum_vP(v)\ln\frac{P(v)}{Q(v)}\\
&=D_{\mathrm{KL}}(P\Vert Q)
\end{aligned}
\]

你看，我们又回到了前向 KL。

如果选择：

\[
f(t)=t\ln t
\]

则可以得到反向 KL：

\[
D_f(P\Vert Q)=D_{\mathrm{KL}}(Q\Vert P)
\]

所以 f-divergence 的作用是：

<box border radius="xl" padding={3} gap={2} align="center">
  <box background="surface-secondary" radius="lg" padding={3} width="100%" align="center">
    **统一的 f-divergence 表达**
    \[
    \sum_vP(v)f(Q(v)/P(v))
    \]
  </box>
  <icon name="arrow-down" color="secondary" size="lg"/>
  <grid columns={2} gap={2}>
    <grid-item>
      <box border radius="lg" padding={3} gap={1} height="100%">
        **Forward KL**

        <math value={String.raw`f(t)=-\ln t`}/>
      </box>
    </grid-item>
    <grid-item>
      <box border radius="lg" padding={3} gap={1} height="100%">
        **Reverse KL**

        <math value={String.raw`f(t)=t\ln t`}/>
      </box>
    </grid-item>
  </grid>
  <text size="sm" color="secondary">不同散度可以用共同的数学结构描述，因此作者不需要为每一种散度分别定义一套裁剪公式。</text>
</box>

### 真正的目的：把裁剪作用到每一个词表条目上

作者定义：

\[
\ell_{n,v}^{(f)}
=
p_T(v)\,
f\left(\frac{p_S(v)}{p_T(v)}\right)
\]

这个量表示第 \(n\) 个生成位置、词表候选 \(v\) 对散度的贡献。

然后：

\[
\boxed{
D_{\mathrm{clip}}^{(f)}
=
\frac{1}{|\hat y|}
\sum_{n=1}^{|\hat y|}
\sum_{v\in V}
\min(\ell_{n,v}^{(f)},\tau)
}
\]

也就是将每个贡献限制到阈值 \(\tau\) 以下。

例如，一些 Token 的单项贡献是：

| Token | 原始贡献 | 设置 \(\tau=0.5\) 后 |
|---|---:|---:|
| `therefore` | 1.8 | 0.5 |
| `maybe` | 0.9 | 0.5 |
| `7` | 0.3 | 0.3 |
| `8` | −0.2 | −0.2 |

这些是假设数字。

作者的动机是防止少数具有极大散度贡献的风格 Token 主导训练。

但你要注意一个科研细节：**它并没有判断哪些 Token 是风格 Token，再专门裁剪它们。它仅仅根据数值大小裁剪，因此数学 Token 的贡献过大时也一样会被裁剪。**

而且，普通 KL 非负，不代表这个裁剪后的目标仍然非负。因为现在只截断了正向的大贡献，却没有要求负贡献对称地变化，原本保证非负性的数学结构已经被破坏了。

所以作者在 §4.3.3 中特意说明，裁剪损失可以为负。这并不等于普通 KL 散度变成了负数，而是**裁剪后的训练目标不再是未经修改的 KL**。<FileCite ref="turn1file0" />

从科研角度说，f-divergence 在这里不是独立创新点。真正有实验支持的设计是 **pointwise clipping（逐词表条目裁剪）**。

---

# 二、作者提出了哪些分支？最后分别选择了什么？

这是你想要的“不要绕来绕去，直接告诉我最终实现方案”。

| 设计决策 | 作者研究过的分支 | 最终主要采用 | 对应证据 |
|---|---|---|---|
| 散度函数 | Forward KL、Reverse KL、JSD | **Forward KL** | Table 3 |
| 学生生成模式 | Thinking On / Off | **TM-off** | Table 7 |
| 教师生成模式 | Thinking On / Off | **TM-on** | Table 7 |
| 散度裁剪 | 不裁剪、Pointwise Clipping | **开启裁剪** | Figure 4 |
| 学生生成长度 | 1024、4096 Token | **1024** | Figure 5 |
| 蒸馏目标 | Full-vocabulary、Sampled-token | **Full-vocabulary** | Table 4 |
| 教师参数 | 跟随学生更新、固定初始策略 | **固定初始教师** | §4.1 |
| 优化方式 | 公式 (6)/(8) 的分布匹配、公式 (9) 的策略梯度替代方案 | **分布匹配** | Table 4 |

注意两件事：

第一，**Figure 5 中的 1024 并非每个数据集、每个训练步都严格最优**。作者选择的是更低成本、整体表现没有明显稳定劣势的方案。

第二，作者并没有为每一项选择都做同等完整的消融。例如，固定教师的选择主要由 §4.1 的经验性说明支持；正文没有给出固定教师与同步教师的单独量化对照。

因此，我们应把“作者最终采用的方案”和“实验严格证明最优的方案”区分开。

接下来正式进入第 4 章。

# 三、第 4 章实验设置（§4.1）

作者围绕四个核心问题安排实验：

1. OPSD 与 SFT、GRPO 相比，性能和采样效率如何？
2. 逐点 KL 裁剪有没有用？
3. 不同 Thinking Mode、散度、生成长度会产生什么影响？
4. 全词表蒸馏是否优于只对采样 Token 计算策略梯度？

## 1. 模型与训练数据集

| 类别 | 具体设置 |
|---|---|
| 基础模型 | Qwen3-1.7B、Qwen3-4B、Qwen3-8B |
| 模型版本 | Instruct-tuned |
| 训练数据 | OpenThoughts 的数学推理子集 |
| 训练样本 | 最多约 30,000 个问题—解答对 |
| 数据内容 | 带 Chain-of-Thought 推理过程的参考解答 |
| 主要评估基准 | AIME 2024、AIME 2025、HMMT 2025 |

这三个基准都属于竞赛级数学推理任务。

- **AIME24 / AIME25**：美国数学邀请赛不同年份的题目，要求数学推理，最终答案容易验证。
- **HMMT25**：哈佛—麻省理工数学竞赛的 2025 年题目，属于另一套高难度数学评估。

这些是评估集，而不是作者直接拿来进行后训练的 OpenThoughts 训练集。

论文正文没有详细报告这里三个评估集各自的样本数量、每道题的难度分布或完整的训练数据筛选规则，因此不能仅凭本文做更精细的数据构成分析。

## 2. SFT、GRPO、OPSD 的训练设置

这里直接对照附录 Table 8、9、10。

| 参数 | SFT | GRPO | OPSD |
|---|---:|---:|---:|
| 学习率 | 5e−6 | 5e−6 | 5e−6 |
| Effective Batch Size | 32 | 32 | 32 |
| LoRA Rank | 64 | 64 | 64 |
| LoRA Alpha | 128 | 128 | 128 |
| 最大序列/生成长度 | 16,000 | 16,000 | 1,024 |
| 每道题生成轨迹数 | 不适用 | 8 | 1 |
| 采样温度 | 不适用 | 1.2 | 1.1 |
| 训练步数 | 100 | 500 | 100 |
| GRPO KL 惩罚系数 | 不适用 | 0 | 不适用 |

三种方法共享同一训练数据来源，也都使用 LoRA；但它们的生成长度、采样次数与训练预算并不相同。

硬件环境方面，作者使用 8 张 A100 或 H100 GPU，采用 AdamW、BF16、Gradient Checkpointing 和 Flash Attention 2。

### 需要特别理解主实验的 Thinking Mode

作者最终使用：

- 训练学生：TM-off（不显式输出 Thinking 模式的长推理）。
- 教师：TM-on（使用 Thinking 模式的提示词）。
- 正式主实验评估：Thinking Mode enabled（开启思考模式）。

所以不要把“学生训练时关闭 Thinking Mode”误理解为“OPSD 训练后的模型评估时也关闭 Thinking Mode”。

训练时如何形成监督信号，与评估时采用怎样的生成模式，是两件不同的事。

## 3. 评估指标：Avg@12 是什么意思？

论文 Table 2 使用的是 **Avg@12**。

例如，对同一道数学题独立生成 12 次：

- 其中 9 次正确；
- 3 次错误。

那么这一题的采样平均准确率就是：

\[
\frac{9}{12}=75\%
\]

再对评估题目取平均。

这样可以降低单次随机采样带来的波动。

论文评估时使用的主要参数是：

- Temperature = 1.0
- Top-p = 0.95
- Max New Tokens = 38,912
- 每题采样 12 次
- Thinking Mode 开启

注意，后面 Table 4 用的是 **pass@8**，它表示多次生成中至少有一次成功的概率或比例估计，和 Avg@12 不是同一个指标，不能直接比较数字大小。

---

# 四、主实验：Table 2——OPSD 到底有没有优于 SFT 和 GRPO？

这是整篇论文最重要的主结果。

<text color="secondary" size="xs">以下均为 Avg@12 准确率（%），来源：论文第 7 页 Table 2。<FileCite ref="turn1file0" /></text>

| 模型 | 方法 | AIME24 | AIME25 | HMMT25 | 平均 |
|---|---|---:|---:|---:|---:|
| 1.7B | Base | 51.5 | 36.7 | 23.1 | 37.1 |
|  | SFT | 48.4 | 36.3 | 22.7 | 35.8 |
|  | GRPO | 51.1 | 38.3 | 23.7 | 37.7 |
|  | **OPSD** | **57.2** | **43.9** | **29.2** | **43.4** |
| 4B | Base | 74.9 | 66.4 | 42.2 | 61.2 |
|  | SFT | 70.2 | 62.3 | 43.4 | 58.6 |
|  | GRPO | 75.6 | 68.1 | 44.4 | 62.7 |
|  | **OPSD** | **76.4** | **68.3** | **46.1** | **63.6** |
| 8B | Base | 75.8 | 65.6 | 43.9 | 61.8 |
|  | SFT | 72.3 | 64.2 | 42.9 | 59.8 |
|  | GRPO | 76.4 | 68.9 | **46.7** | 64.0 |
|  | **OPSD** | **77.8** | **70.8** | 45.8 | **64.8** |

### 结论 1：OPSD 对 1.7B 小模型特别有效

从模型平均准确率来看：

<Chart content={{"chartType":"bar","meta":{"title":"三种模型规模的平均性能","description":"Table 2，Avg@12（%）"},"xKey":"model","series":[{"dataKey":"base","label":"Base"},{"dataKey":"sft","label":"SFT"},{"dataKey":"grpo","label":"GRPO"},{"dataKey":"opsd","label":"OPSD"}],"yAxisMin":0,"data":[{"model":"1.7B","base":37.1,"sft":35.8,"grpo":37.7,"opsd":43.4},{"model":"4B","base":61.2,"sft":58.6,"grpo":62.7,"opsd":63.6},{"model":"8B","base":61.8,"sft":59.8,"grpo":64,"opsd":64.8}]}}/>

1.7B 模型中，OPSD 相对基础模型提高了：

\[
43.4-37.1=\boxed{6.3\text{ 个百分点}}
\]

相对 GRPO：

\[
43.4-37.7=\boxed{5.7\text{ 个百分点}}
\]

但到了 8B：

\[
64.8-64.0=\boxed{0.8\text{ 个百分点}}
\]

**我的分析：OPSD 在小规模模型上展现出更强的相对收益，但现有实验并不能证明这种优势随模型规模增大而保持。**

而且 Qwen3-8B 在 HMMT25 上，OPSD 实际低于 GRPO（45.8 对 46.7）。所以应将作者“与 GRPO 持平或更好”的表述理解为整体趋势，而不是所有单项基准均胜出。

### 结论 2：这篇论文中的 SFT 反而让模型退化

例如 Qwen3-4B：

\[
61.2\%\rightarrow58.6\%
\]

作者提出的解释是：

OpenThoughts 中的参考推理过程比较简洁，SFT 会让模型模仿这种较短的回答风格，导致评估时推理长度缩短，从而降低数学推理表现。

但需要注意，这是作者根据实验现象提出的解释。文中并没有通过更大规模的 SFT 数据质量消融，证明所有高质量 SFT 都会出现这个问题。

因此，更严谨的结论是：

**在这份数据集和训练配置上，直接模仿参考轨迹不如 OPSD。**

### 结论 3：OPSD 有效果，但主实验不等于公平计算预算对比

作者的选择方式是：

- OPSD：在前 100 个训练 Step 中，每 20 步评估，报告最好结果。
- GRPO：在最多 500 个训练 Step 中，报告峰值结果。
- SFT：使用与 OPSD 相同数量的训练样本。

它们的 Token 预算、训练步数与计算开销并不相同。

所以 Table 2 可以支持“作者配置下 OPSD 取得更好的性能”，但不能直接证明“同等 GPU 时间下 OPSD 必然更好”。

接下来 Figure 3 才是作者专门为**训练 Token 效率**提供的证据。

---

# 五、Figure 3：训练效率——OPSD 为什么能用更少 Token 学习？

<text color="secondary" size="xs">论文第 6 页原图。</text>

![Figure 3 — Token Efficiency of OPSD](sandbox:/mnt/data/fig3_opsd.png)

Figure 3 一共有五张子图。

## 前三张：AIME24、AIME25、HMMT25

- 横轴：Gradient Update Steps（优化器更新步数）。
- 纵轴：Avg@12 准确率。
- 蓝色：OPSD。
- 红色：GRPO。

图中最值得注意的是：

**OPSD 在前 100 步内，三套数学基准的准确率整体上比 GRPO 提升得更明显。**

例如 AIME25：

- 基础模型约 36.7%。
- OPSD 在第 50 步达到 43.9%。
- 随后下降，第 100 步约 41.1%。
- GRPO 的曲线整体低于 OPSD。

这同时告诉我们两个事实：

1. OPSD 前期确实能快速获得学习收益。
2. **OPSD 也会出现后期性能回落，因此并不是训练步数越多越好。**

## 第四张：Average vs. Tokens Generated

这是图中最有研究价值的一张。

横轴不再是训练步数，而是累计生成的 Token 数量，单位是百万。

你可以看到：

- OPSD 的性能提升发生在相对靠左的位置，即累计生成 Token 很少时。
- GRPO 消耗了更多生成 Token，却没有获得同等幅度的平均准确率提升。

为什么？

结合前面的 GRPO 原理：

GRPO 采样多条轨迹，最后通过正确或错误的结果奖励产生 Advantage。

但 OPSD 不需要等到模型生成正确答案后才学习。只要教师与学生分布不同，就可以形成训练信号。

因此，作者认为 OPSD 能够从每个采样 Token 中提取更多可用于训练的信息。

**这里证明的是生成 Token 效率，不是完整训练 FLOPs、峰值显存或 GPU 小时数的严格优势。**

## 第五张：Zero Reward Std Fraction of GRPO

这张图比较重要，因为它试图解释 GRPO 为什么训练停滞。

纵轴表示 GRPO 中奖励标准差为零的 Batch 比例。

在图示训练期间，这一比例经常超过 50%，有些点接近 90%。

什么意思？

假设一组回答的奖励都是：

\[
[0,0,0,0]
\]

或者：

\[
[1,1,1,1]
\]

此时标准差为零，GRPO 无法从组相对奖励中得到有用的 Advantage。

因此，即使生成了很多 Token，也可能没有相应的奖励驱动更新信号。

论文将其称为奖励多样性坍缩，并联系到训练后期的停滞。

不过图中并没有直接绘制策略熵，因此**奖励标准差为零的现象得到了直接展示，而它究竟在多大程度上由熵坍缩导致，仍属于作者的机制解释**。

### Figure 3 的研究结论

OPSD 的主要优势可能不是每次参数更新都更便宜，而是：

**对一条学生轨迹，它能够获得比最终二元奖励更密集的学习信号，从而提高学生采样 Token 的利用效率。**

这是这篇论文针对 GRPO 最有说服力的实验之一。

# 六、§4.3.1：Table 3——Forward KL、Reverse KL、JSD，到底选哪个？

作者首先比较三种散度函数。

实验设置：

- 模型：Qwen3-1.7B
- 数据集：AIME25
- 指标：Avg@12
- 控制条件：三种方法采用相同的 Pointwise Clipping 方案

| 散度函数 | Base | Step 50 | Step 100 |
|---|---:|---:|---:|
| **Forward KL** | 36.7 | **43.9** | **41.1** |
| Reverse KL | 36.7 | 37.5 | 35.0 |
| JSD（β=0.5） | 36.7 | 36.9 | 39.0 |

<FileCite ref="turn1file0"/>

三个结论：

**第一，Forward KL 明显最好。** 第 50 步从 36.7% 提升到 43.9%，增加 7.2 个百分点。

**第二，Reverse KL 不稳定。** 第 100 步甚至下降到 35.0%，低于基础模型。

**第三，JSD 并没有因为形式更对称就更有效。** 它在第 100 步达到 39.0%，但提升幅度有限。

### 为什么 Forward KL 可能更合适？

从数学上理解：

\[
D_{\mathrm{KL}}(p_T\Vert p_S)
=
\sum_vp_T(v)\log\frac{p_T(v)}{p_S(v)}
\]

这个目标比较重视教师认为有一定概率、但学生没有充分覆盖的候选 Token。

而反向 KL：

\[
D_{\mathrm{KL}}(p_S\Vert p_T)
\]

通常更倾向于让学生集中在教师支持的部分高概率区域。

对于数学推理，作者希望学生学习教师给出的完整候选分布，因此 Forward KL 可能提供更丰富的监督。

但注意：**这是对实验现象的一种解释，不是作者通过独立机制实验严格证明的因果原因。**

最终选择：**Forward KL**。

---

# 七、§4.3.2：Table 7——为什么学生关闭 Thinking，教师却开启 Thinking？

这是论文一个比较有意思的设计。

Qwen3 支持两种模式：

- TM-on：启用 Thinking Mode。
- TM-off：关闭 Thinking Mode。

作者测试了四种师生组合，并把词表条目分为 Math、Style、Other 三类，分析不同类别的 KL 信号。

例如，Style 类包括 `maybe`、`however`、`therefore` 等推理表达词，Math 类包括数学术语等。完整类别定义在附录 C。

### Table 7：四种模式组合的结果

为了方便阅读，下表主要展示作者最关心的 **Math 类 KL 贡献**，全部数据见 PDF 第 14 页 Table 7。

| 学生 | 教师 | 1.7B Math | 4B Math | 8B Math |
|---|---|---:|---:|---:|
| TM-off | TM-off | 0.12 | 0.06 | 0.05 |
| TM-on | TM-off | 0.10 | 0.05 | 0.05 |
| TM-on | TM-on | 0.09 | 0.04 | 0.04 |
| **TM-off** | **TM-on** | **0.14** | **0.10** | **0.06** |

作者认为，最后一种组合在三种模型规模上都能产生较强的数学相关 Token 监督信号。

为什么？

我们可以从角色分工理解：

**学生关闭 Thinking：** 它从较简洁的生成方式中采样轨迹。

**教师开启 Thinking：** 它在获得标准答案的情况下，使用支持推理模式的提示词，对学生轨迹进行分布评估。

作者希望借此形成更有指导意义的师生分布差异。

但有一个值得审查的问题：

**数学类 KL 更大，并不自动等于数学监督质量更高。**

更大的 KL 首先说明教师和学生在这些候选 Token 上分歧更大。要证明这是有效的数学知识转移，还需要看下游任务表现。

作者称该组合取得了最佳的下游表现，但正文没有给出四种师生组合对应的完整下游准确率矩阵。Table 7 更直接展示的是分布差异，而不是四种组合的完整性能对照。

另外，Table 7 的 KL 统计仅平均了 10 道问题，作为机制观察有参考价值，但证据规模不大。

### 这里又发现了一个问题：Style KL 太大

例如，最终选择的 TM-off 学生与 TM-on 教师组合：

| 模型 | Style | Math | Other |
|---|---:|---:|---:|
| 1.7B | 0.85 | 0.14 | 0.25 |
| 4B | 0.92 | 0.10 | 0.29 |
| 8B | 0.79 | 0.06 | 0.25 |

可以看到 Style 类的数值远大于 Math 类。

作者担心训练会被表达风格上的巨大分歧主导。

这就引出了下一个实验：**Figure 4 的 Pointwise Clipping**。

---

# 八、§4.3.3：Figure 4——KL 裁剪究竟有没有用？

![Figure 4 — KL Pointwise Clipping](sandbox:/mnt/data/fig4_clipping.png)

实验设置：

- 模型：Qwen3-1.7B
- 评估数据：AIME24
- 横轴：Gradient Update Steps
- 纵轴：Avg@12 准确率
- 蓝线：开启 Pointwise Clipping
- 红线：不开启 Pointwise Clipping

这是第 4 章比较有说服力的一项消融实验。

### 实际现象

| 训练步数 | 开启裁剪 | 不开启裁剪 |
|---|---:|---:|
| 0 | 约 51.5 | 约 51.5 |
| 25 | 约 51.3 | 约 52.5 |
| 50 | 约 52.8 | 约 50.3 |
| 75 | 约 54.4 | 约 51.5 |
| 100 | 约 57.2 | 约 49.2 |

这些数值根据原图读取，属于近似值。

到了第 100 步：

- 开启裁剪：约 57.2%。
- 不开启裁剪：约 49.2%。

差距约为 **8 个百分点**。

### 这说明什么？

不开启裁剪时，模型早期可能有所提升，但随后性能明显下降。

开启裁剪后，虽然早期提升不一定最快，但在图示范围内，整体性能更稳定，最终表现明显更好。

这表明：

**在作者的配置下，少数过大的散度贡献可能干扰训练，而 Pointwise Clipping 有助于缓解这种不稳定性。**

但是，要区分已经验证和没有验证的内容。

已验证：

- 裁剪与更好的训练稳定性、测试准确率相关。
- 不裁剪的模型在该实验中出现明显性能退化。

没有被单独严格验证：

- 性能退化究竟有多少由 Style Token 导致。
- 最优裁剪阈值是多少。
- 裁剪对所有模型、所有任务是否同样有效。

作者在附录中特别说明，没有系统调优裁剪阈值 \(\tau\)。

因此，这是一个**有明确正向消融证据，但机制归因和超参数分析仍不充分**的设计。

最终选择：**开启 Pointwise Clipping**。

---

# 九、§4.3.4：Figure 5——为什么最终只生成 1024 Token？

![Figure 5 — Generation Length](sandbox:/mnt/data/fig5_length.png)

这是我建议你认真观察的一张图，因为它反映了作者对计算成本和学习信号之间关系的思考。

实验设置：

- 模型：Qwen3-1.7B
- 方法：Full-vocabulary Logit Distillation
- 最大生成长度：1024 vs 4096 Token
- 数据集：AIME25、AIME24

红色为 4096 Token，蓝色为 1024 Token。

## 左图：AIME25

1024 Token 方案：

- 在第 25 步已经达到约 42.6%。
- 第 50 步约 43.9%，表现最好。
- 随后有所回落。

4096 Token 方案：

- 前期提升较慢。
- 第 75 步达到约 43%。
- 第 100 步表现与 1024 Token 接近。

因此，在 AIME25 上，**更长的生成预算没有形成稳定优势**。

## 右图：AIME24

情况稍有不同。

4096 Token 在第 50 步达到约 58.6%，这是图中更高的峰值。

而 1024 Token 的曲线前期较慢，但在第 100 步达到约 57.2%。

这意味着：

**4096 Token 并非没有收益，它在 AIME24 的某些训练步数上确实更好。**

但如果综合两套任务，以及生成预算增加约四倍这一成本，作者认为延长生成没有带来一致、稳定的提升。

### 为什么更长不一定更好？

作者提出一个解释：

较早的推理 Token 可能处于重要的推理分岔点，影响后面的解题方向。

而当学生已经生成较长前缀后，后续 Token 对教师而言可能更加容易预测，因而提供的额外分布纠正信号较少。

例如：

`设未知数为 x → 建立方程 → 推导关系 → ...`

最开始决定建立什么方程，可能比后面机械地展开计算更重要。

这里属于作者的**研究假设**。Figure 5 直接测量的是生成长度和最终准确率，并没有展示“前 100 个 Token 比后 100 个 Token 的梯度价值更高”的分位置因果实验。

### Figure 5 的真正结论

不能说“越短越好”，更准确的是：

> 在作者测试的 1024 与 4096 两种生成预算下，较长序列没有带来跨任务的一致收益，因此默认采用成本更低的 1024 Token。

最终选择：**1024 Token**。

---

# 十、§4.3.5：Table 4——全词表蒸馏与采样 Token 蒸馏，哪个更好？

这是对应你前面读过的公式 (6) 与公式 (9) 的直接实验。

作者比较两种方法。

**方法 A：Full-vocabulary**

对每个学生生成位置，比较教师和学生在整个词表上的概率分布。

**方法 B：Sampled-token**

只利用学生实际采样 Token 的教师与学生对数概率差，构造策略梯度式损失。

实验设置：

- 模型：Qwen3-4B
- 学生生成长度：2048 Token
- 评估指标：pass@8
- 数据集：AIME25、HMMT25

| 蒸馏方式 | AIME25 | HMMT25 |
|---|---:|---:|
| **Full-vocabulary** | **84.1** | **60.0** |
| Sampled-token | 82.1 | 57.3 |
| 提升 | +2.0 | +2.7 |

<FileCite ref="turn1file0"/>

注意这个指标是 pass@8，不是前面 Table 2 的 Avg@12，因此不能拿 84.1% 直接和 Table 2 中的 68.3% 作性能比较。

### 为什么作者选择 Full-vocabulary？

因为它保留了整个教师分布的信息。

举个例子：

\[
p_T=[0.8,0.1,0.1]
\]

而学生实际采样了 `8`。

Sampled-token 主要利用教师对 `8` 的评价；Full-vocabulary 则同时包含教师对 `7`、`8`、`9` 等所有候选的分布信息。

作者认为，这种更完整的软监督能够提供更丰富的学习信号。

但代价是：

**Full-vocabulary 需要处理每个生成位置上整个词表的 logits，因此会增加计算与峰值显存开销。**

这是非常典型的性能—资源权衡。

最终选择：**Full-vocabulary Logit Distillation**。

---

# 十一、附录 B：还有哪些实验值得看？

第 4 章正文之外，附录 B 还有一组重要结果：**完全关闭 Thinking Mode 的 OPSD 实验**。

它与主实验不同：

- 学生训练时 TM-off；
- 教师训练时 TM-off；
- 评估时也 TM-off。

作者希望看看 OPSD 是否必须依赖教师开启 Thinking Mode。

## Table 5：完全不使用 Thinking Mode 时的性能

下面直接展示相对基础模型的准确率变化，单位为百分点。

| 模型 | AIME24 | AIME25 | HMMT25 | 平均提升 |
|---|---:|---:|---:|---:|
| 1.7B | +3.1 | −3.0 | +0.8 | +0.3 |
| 4B | +8.0 | −0.3 | +5.6 | +4.4 |
| 8B | +23.3 | +15.3 | +7.5 | +15.4 |

这组数据的结论比较有意思：

**完全关闭 Thinking Mode，OPSD 仍然能够在部分模型和任务上取得明显收益。**

特别是 8B：

- AIME24：26.4% → 49.7%。
- AIME25：19.7% → 35.0%。
- HMMT25：10.8% → 18.3%。

但 1.7B 和 4B 的收益并不均衡，部分任务甚至下降。

因此，不能说“关闭 Thinking Mode 必然有效”，只能说 OPSD **不完全依赖于开启 Thinking Mode 才能产生学习效果**。

而且，这组实验是在关闭 Thinking 的评估模式下计算的，不能直接与正文开启 Thinking Mode 的 Table 2 相减比较。

## Table 6：完全关闭 Thinking Mode 时，训练步数有何影响？

Table 6 还给出了 Step 50、75、100 的完整数值：

| 模型 | 数据集 | Base | Step 50 | Step 75 | Step 100 |
|---|---|---:|---:|---:|---:|
| 1.7B | AIME24 | 11.9 | 15.0 | 13.9 | 12.5 |
| | AIME25 | 9.2 | 6.2 | 8.3 | 8.1 |
| | HMMT25 | 5.0 | 5.8 | 5.0 | 5.4 |
| 4B | AIME24 | 23.1 | 20.3 | 27.5 | 31.1 |
| | AIME25 | 21.4 | 21.4 | 20.8 | 21.1 |
| | HMMT25 | 10.8 | 11.1 | 13.1 | 16.4 |
| 8B | AIME24 | 26.4 | 49.7 | 45.3 | 38.3 |
| | AIME25 | 19.7 | 35.0 | 26.9 | 27.5 |
| | HMMT25 | 10.8 | 18.3 | 17.5 | 15.3 |

<FileCite ref="turn1file0"/>

最值得注意的是 Qwen3-8B：

它在第 50 步就取得非常明显的提升，但继续训练到第 100 步后，所有三项指标都下降。

这与正文里 OPSD 存在后期不稳定的观察是一致的。

### 我核对时还发现一个小问题

Table 5 声称报告各模型和基准的最佳 Checkpoint，但与 Table 6 并非完全对应。

例如：

- 1.7B / AIME25：Table 5 报告 OPSD 为 6.2，但 Table 6 的 Step 75 为 8.3。
- 4B / AIME25：Table 5 报告 OPSD 为 21.1，但 Table 6 的 Step 50 为 21.4。

这属于表格汇总和逐步结果之间的小不一致。对于论文精读，应该以原文记录这些差异，而不是自行替作者修改 Table 5。

---

# 十二、把整个第 4 章的实验结论串起来

<box border radius="xl" padding={3} gap={3}>
  <title size="lg">OPSD 实验逻辑总览</title>
  <list marker="number" connector="solid" gap={3}>
    <list-item>
      **Table 2：先证明有用**

      OPSD 在三个模型规模上总体优于 SFT，平均性能达到或超过 GRPO。
    </list-item>
    <list-item>
      **Figure 3：再证明采样效率**

      与 GRPO 相比，OPSD 使用更少学生生成 Token，在前 100 步获得更明显的准确率提升。
    </list-item>
    <list-item>
      **Table 3：确定散度**

      Forward KL 明显优于 Reverse KL 和 JSD。
    </list-item>
    <list-item>
      **Table 7：确定师生模式**

      TM-off 学生 / TM-on 教师产生更强的数学类分布差异，但同时发现风格类贡献很大。
    </list-item>
    <list-item>
      **Figure 4：解决训练不稳定**

      Pointwise Clipping 缓解大散度贡献，显著改善该实验的训练表现。
    </list-item>
    <list-item>
      **Figure 5：控制生成成本**

      4096 Token 没有带来一致的性能增益，因此默认使用 1024。
    </list-item>
    <list-item>
      **Table 4：确定训练目标**

      Full-vocabulary 的实验效果优于 Sampled-token，但显存成本较高。
    </list-item>
    <list-item>
      **Table 5、6：补充泛化设置**

      完全非 Thinking 模式也能产生收益，不过具有明显模型与任务差异，并存在训练后期退化。
    </list-item>
  </list>
</box>

# 十三、从科研角度，我认为这篇论文证明了什么，还没有证明什么？

| 论文主张 | 目前证据 | 我的判断 |
|---|---|---|
| 看过标准答案的同源教师能帮助学生学习 | Table 2 | 有正向证据 |
| 比 SFT 更好 | Table 2 | 当前数据及配置下成立 |
| 比 GRPO 的学生采样 Token 更高效 | Figure 3 | 有比较直接的证据 |
| Forward KL 更合适 | Table 3 | 当前配置下成立 |
| TM-off 学生 + TM-on 教师最好 | Table 7 和作者叙述 | 仍缺少完整下游消融表 |
| Pointwise Clipping 能稳定训练 | Figure 4 | 有较清楚的消融证据 |
| 更长生成没有必要 | Figure 5 | 只能说没有一致收益 |
| Full-vocabulary 优于 Sampled-token | Table 4 | 当前模型与两个基准下成立 |
| 能扩展到 32B、70B 等规模 | 无相关实验 | 尚未证明 |
| 总 GPU 训练成本低于 GRPO | 缺少统一算力预算比较 | 尚未严格证明 |

## 我认为最值得你记住的三个研究发现

**发现一：有标准答案，不代表必须直接 SFT。**

作者发现，参考答案可以不被当作硬标签，而是作为教师的特权信息，帮助构造学生自己轨迹上的软监督。

这是这篇论文真正的核心思想。

**发现二：最重要的挑战不是能否产生 KL，而是产生的 KL 有没有价值。**

不同 Thinking Mode 会产生不同的分布差异；风格 Token 可能产生非常大的 KL；一些分布差异可能并不对应推理能力的提升。

因此，作者还需要通过散度选择、教师提示词设计和 Pointwise Clipping 控制监督信号的质量。

**发现三：OPSD 已经显示出训练后期不稳定。**

Figure 4、Table 3、Table 6 都能看到这个问题。作者在附录 A 也明确承认：模型更大时是否更稳定、如何利用正确性验证信号，以及如何根据学生能力选择训练题目，都值得进一步研究。

尤其重要的是，**OPSD 当前的主要损失没有显式使用学生最终答案的正确性作为奖励**。它依赖的是教师在参考解答帮助下形成的分布。

这意味着，即使教师产生了较大 KL，也无法自动保证该方向会提高数学正确率。

---

## 最后，总结这篇论文的完整研究故事

这篇论文的实验不是在证明“KL 比强化学习高级”，而是在讲这样一个故事：

**传统 SFT** 只能模仿固定参考轨迹。

**传统 GRPO** 让模型自己探索，但最终奖励比较稀疏，而且容易出现采样组没有奖励差异的情况。

**OPSD** 则尝试结合两者的优点：让学生自己采样轨迹，再利用标准答案给同源教师提供特权上下文，从而获得每个位置上的概率分布监督。

不过，这种监督存在风格噪声、散度选择、生成长度和计算成本问题。

作者逐一做了选择：

\[
\boxed{
\begin{gathered}
\text{On-Policy Student Rollout}\\
\downarrow\\
\text{Privileged Teacher (TM-on)}\\
\downarrow\\
\text{Forward KL + Pointwise Clipping}\\
\downarrow\\
\text{Full-Vocabulary Distillation}\\
\downarrow\\
\text{Student Parameter Update}
\end{gathered}
}
\]

最终在 Qwen3-1.7B、4B 和 8B 的数学推理任务上取得了有竞争力的实验结果。

**如果你是为了学习如何从一篇成熟论文中寻找后续研究 Idea，我建议重点精读 Figure 3、Figure 4 和 Table 7。** 它们分别对应三个很有价值的问题：训练信号利用效率、噪声导致的训练不稳定，以及什么样的教师分布才真正值得学生学习。

---

## Tool
*2026-10-24 15:24*
<<ImageDisplayed>>

---

## Assistant
*2026-10-24 15:25*
> ❔ text

---

## User
*2026-10-24 17:10*
并且冻结初始教师。这个是啥意思，方法 B：Sampled-token
只利用学生实际采样 Token 的教师与学生对数概率差，构造策略梯度式损失。这个是啥嘞，我又忘了
然后请你带我讲解以下内容
5. Related Work  LLM Self-Training. Our work connects to a line of research showing that LLMs can improve by generating and exploiting their own supervision signals (Allen-Zhu & Li, 2020; Xu et al., 2024b; Chen et al., 2024; Wang et al., 2023; Sun et al., 2023; Yuan et al., 2024; Yang et al., 2024). Closest in spirit is context distillation (Snell et al., 2022), which uses the same underlying model as both teacher and student by providing the teacher with privileged context and then SFT the student on the teacher’s generated outputs without context. This can be viewed as off-policy, where the learning signal is a discrete token sequence. In the reasoning domain, ReST (Gulcehre et al., 2023) and STaR (Zelikman et al., 2022) similarly rely on iterative self-training loops—generate rationales conditioned on hints or answers, filter by rewards or ground-truth answers, and fine-tune on successful trajectories—again yielding hard distillation; Mitra & Ulukus (2025) extends this to soft distillation. Incontext editing (Qi et al., 2025) does on-policy sample from student and shows that context-induced knowledge can be internalized via soft distillation by minimizing divergences and demonstrates this in knowledge editing settings. OPSD differs from these approaches in that we perform on-policy, soft distillation on the student’s own rollouts for reasoning tasks: the teacher’s supervision is per-token distribution matching rather than generating a rationale for SFT. OPSD frames reasoning improvement as learning a conditional distribution induced jointly by the dataset’s ground-truth solutions and the model’s own reasoning ability. Concurrently, SDPO (H ̈ubotter et al., 2026) explored similar algorithm with environment feedbacks as privilledged information and SDFT (Shenfeld et al., 2026) explored on-policy selfdistillation on continual learning tasks.  On-Policy Distillation methods train a student model directly on trajectories sampled from its own policy, while a teacher model provides per-token guidance through KLbased regularization or related objectives (Agarwal et al., 2024; Xu et al., 2024a; Gu et al., 2024; Lu & Lab, 2025;  Xiaomi, 2026; Yang et al., 2025). These approaches mitigate distribution shift by optimizing directly on the student’s visitation distribution, but they typically rely on a distinct and often larger teacher model. In this work, we explore whether an LLM can teach itself by conditioning on more privileged answer information and leveraging its own reasoning capability to guide a weaker version of itself toward improved reasoning. On-policy training paradigms are also widely used in robotics and deep reinforcement learning, such as DAgger (Ross et al., 2011), where a human teacher provides corrective supervision on the states visited by the student policy.  Improving LLM Reasoning through SFT and RL. SFT and RL are two primary methods for improving LLM reasoning ability. SFT on high-quality reasoning traces has demonstrated strong performance (Yu et al., 2023; LI et al., 2024; Paster et al., 2023; Team, 2025a; Ye et al., 2025; Muennighoff et al., 2025; Zhou et al., 2023). However, prior work shows that SFT can rely on memorization rather than robust generalization (Chu et al., 2025). In contrast, RL optimizes directly for outcome-based objectives can exhibit better generalization (Huan et al., 2025). More recent algorithms such as GRPO (Guo et al., 2025; Shao et al., 2024) enable scalable RL by estimating advantages from group-level rewards without requiring an explicit critic as in PPO (Schulman et al., 2017). Building on this line of work, a growing body of research highlights the effectiveness of RLVR for reasoning tasks (Yu et al., 2025; Liu et al., 2025; Yue et al., 2025; An et al., 2025; Zheng et al., 2025). 6. Conclusion  We introduced On-Policy Self-Distillation (OPSD), a simple yet effective framework for post-training large language models on reasoning tasks. The intuition behind OPSD is that a sufficiently capable reasoning LLM can teach itself when it has access to privileged information about the answer to a reasoning problem, utilizing its own rationalization ability to grade its weaker self without access to the ground truth. We experimentally demonstrated that OPSD achieves better performance than off-policy distillation/SFT, and performs on par with or better than GRPO, while exhibiting significantly better sample efficiency than GRPO.
Impact Statement  This paper presents work whose goal is to advance the field of machine learning. Our method improves the efficiency of training language models for reasoning tasks, reducing computational costs compared to existing reinforcement learning approaches. We do not foresee specific negative societal consequences.  Acknowledgements  AG was supported by NSF CAREER Grant # 2341040 and a Schmidt AI 2050 Fellowship.

---

## Assistant
*2026-10-24 17:10*
我们先把你忘记的两个概念补回来，再逐段读第 5 章 Related Work 和第 6 章 Conclusion。这里最重要的，是理解 **OPSD 与此前研究究竟有什么区别，而不是只记住一串论文名字。**

# 一、先补回来：冻结初始教师是什么意思？

## 1. 教师和学生最开始是同一个模型，但训练中不再同步变化

假设你下载了一个预训练好的 Qwen3-4B-Instruct 模型，初始参数记为：

\[
\theta_0
\]

从这个模型出发，建立两个逻辑分支：

<box border radius="xl" padding={3} gap={3}>
  <box background="surface-secondary" radius="lg" padding={3} align="center" gap={1}>
    <title size="lg">初始模型 Qwen3-4B</title>
    <math value={String.raw`\theta_0`}/>
    <text color="secondary" size="sm">同一个初始检查点</text>
  </box>
  <grid columns={2} gap={3}>
    <grid-item>
      <box border radius="lg" padding={3} gap={2} height="100%">
        <badge color="info">Teacher</badge>
        **教师分支**
        <math value={String.raw`p_T=p_{\theta_0}`}/>
        - 输入：题目 + 标准答案
        - 参数：冻结
        - 输出：教师概率分布
      </box>
    </grid-item>
    <grid-item>
      <box border radius="lg" padding={3} gap={2} height="100%">
        <badge color="success">Student</badge>
        **学生分支**
        <math value={String.raw`p_S=p_{\theta_t}`}/>
        - 输入：只有题目
        - 参数：持续更新
        - 输出：学生轨迹及概率分布
      </box>
    </grid-item>
  </grid>
</box>

这里的「冻结」不是把模型的输出固定住，而是**不更新教师的模型参数**。

例如：

| 时刻 | 教师参数 | 学生参数 |
|---|---|---|
| 训练开始 | \(\theta_0\) | \(\theta_0\) |
| 第 1 次更新后 | \(\theta_0\) | \(\theta_1\) |
| 第 100 次更新后 | \(\theta_0\) | \(\theta_{100}\) |

因此，训练后期教师和学生虽然具有相同的模型架构、来自同一个初始检查点，但参数已经不同。

为什么要这么做？

因为学生每次更新之后，教师仍然提供相对稳定的监督目标。如果教师也跟着学生一起变化，监督目标就会不断移动，训练分析和稳定性控制都会更加复杂。

注意：冻结参数不等于教师完全不需要计算。教师仍然需要进行前向计算，得到下一 Token 的概率分布，只是不需要计算参数梯度，也不执行优化器更新。

## 2. 教师为什么有能力教学生？

这是 OPSD 最有意思的假设。

假设题目是：

`3 + 4 = ?`

学生只能看到题目，教师还可以看到标准答案 `7`。

即使它们来自同一个初始模型，额外的答案上下文也可能改变教师的条件概率分布。

\[
p_T(\cdot\mid x,y^\star)
\ne p_S(\cdot\mid x)
\]

例如，在预测答案的位置：

| Token | 教师概率 | 学生概率 |
|---|---:|---:|
| `7` | 80% | 20% |
| `8` | 10% | 70% |
| `9` | 10% | 10% |

教师通过额外上下文形成了一个不同的概率分布。学生随后通过蒸馏学习这个分布。

但必须强调：**看过答案不保证教师一定能够理解答案或形成更好的分布。** 这正是 OPSD 需要通过实验验证的核心假设之一。

---

# 二、再复习：Sampled-token 到底是什么？

你之前理解过全词表蒸馏，但容易忘记 Sampled-token。我们用一个例子重新建立直觉。

假设学生当前正在回答：

`3 + 4 =`

它最终采样出来的 Token 是 `8`。

此时，学生和教师对整个词表的预测如下：

| Token | 教师概率 | 学生概率 |
|---|---:|---:|
| `7` | 0.8 | 0.2 |
| `8` | 0.1 | 0.7 |
| `9` | 0.1 | 0.1 |

## 1. Full-vocabulary：比较整个词表

全词表蒸馏会比较：

- `7` 的教师概率与学生概率；
- `8` 的教师概率与学生概率；
- `9` 的教师概率与学生概率；
- 以及词表中其他所有 Token。

然后汇总成 KL 散度。

它关心的是**完整的概率分布应该如何改变**。

## 2. Sampled-token：只检查学生实际选中的 Token

Sampled-token 则只关注学生刚刚采样的 `8`。

定义：

\[
A_n=\log p_T(\hat y_n)-\log p_S(\hat y_n)
\]

这里省略了共同的题目和前缀条件。

代入：

\[
A_n=\log 0.1-\log 0.7
\]

\[
\boxed{A_n\approx-1.946}
\]

这个值是负数，意味着教师比学生更不支持刚才采样的 `8`。

接下来，算法使用这个值作为逐 Token 的策略梯度信号：

\[
L=-A_n\log p_S(\hat y_n)
\]

在计算梯度时，将 \(A_n\) 视为固定值，不让梯度通过它反向传播。

- 如果 \(A_n>0\)，就鼓励学生提高这个 Token 的概率。
- 如果 \(A_n<0\)，就鼓励学生降低这个 Token 的概率。

因此，对于 `8`，学生会收到降低其概率的学习信号。

但你可能会问：为什么不直接使用完整的 KL？

因为 Sampled-token 只需要查询实际采样 Token 的教师和学生对数概率，不必显式求和整个词表的散度。它采用的是一种**采样 Token 的策略梯度式优化目标**。

两者区别如下：

| 对比 | Full-vocabulary | Sampled-token |
|---|---|---|
| 检查什么 | 整个词表 | 实际采样的 Token |
| 训练信号 | 完整分布散度 | 教师与学生的对数概率差 |
| 优点 | 利用完整分布信息 | 监督目标更局部 |
| 代价 | 处理完整词表的 logits | 不显式计算全词表散度 |
| 论文实验结果 | 更好 | 相对较差 |

作者在 Table 4 中发现，全词表方法在 AIME25 和 HMMT25 上分别达到 84.1% 和 60.0% 的 pass@8，而 Sampled-token 为 82.1% 和 57.3%。

所以，**Sampled-token 是作者研究过的替代方法，不是论文最终采用的主要训练目标。**

还有一个细节值得记住：这里的 \(A_n\) 虽然叫 Advantage，但它不是 GRPO 的组相对优势值。GRPO 的 Advantage 来自最终奖励与组内平均奖励的差异；这里的 Advantage 来自教师与学生对一个 Token 的对数概率差。

---

# 三、第 5 章 Related Work：OPSD 与此前研究有什么区别？

这一章的目的不是再介绍一次算法，而是回答一个科研问题：

**既然自训练、知识蒸馏、SFT 和强化学习都已经存在，OPSD 到底新在哪里？**

作者把相关工作分成三个方向。

<box border radius="xl" padding={3} gap={3}>
  <title size="lg">Related Work 的三条研究线</title>
  <box background="surface-secondary" radius="lg" padding={3} gap={1}>
    **5.1 LLM Self-Training**

    模型自己生成训练数据，再利用这些数据改进自身。
  </box>
  <box background="surface-secondary" radius="lg" padding={3} gap={1}>
    **5.2 On-Policy Distillation**

    学生在自己的生成轨迹上训练，教师提供更细粒度的监督。
  </box>
  <box background="surface-secondary" radius="lg" padding={3} gap={1}>
    **5.3 Improving LLM Reasoning through SFT and RL**

    对比监督微调与强化学习在推理能力提升上的特点。
  </box>
</box>

## 5.1 第一条线：LLM Self-Training（大模型自训练）

自训练的基本思想是：

模型利用自身生成的结果、已有知识或外部反馈，构造新的监督信号，然后继续训练自己。

但不同自训练方法的关键差别是：**模型生成什么、如何筛选，以及最终用什么目标学习。**

### A. Context Distillation：上下文蒸馏

作者认为，最接近 OPSD 的早期思路之一是 Context Distillation。

它的流程可以这样理解：

<box border radius="lg" padding={3} gap={2}>
  <row align="center" gap={2}>
    <box background="surface-secondary" radius="md" padding={2} flex="1" align="center">
      **教师**
      <text size="sm">问题 + 特权上下文</text>
    </box>
    <icon name="arrow-right" color="secondary"/>
    <box background="surface-secondary" radius="md" padding={2} flex="1" align="center">
      **生成答案**
      <text size="sm">离散 Token 序列</text>
    </box>
  </row>
  <icon name="arrow-down" color="secondary"/>
  <box border radius="md" padding={3} gap={1}>
    **学生 SFT**

    学生不再看到特权上下文，而是学习教师生成的答案。
  </box>
</box>

这里的教师和学生来自同一个底层模型，但教师拥有额外的上下文。

举个例子：

- 教师看到问题和标准答案。
- 教师生成一段更好的解释。
- 学生只看到问题，然后通过 SFT 学习教师生成的解释。

为什么作者把它称为 Off-policy？

因为学生学习的是教师已经生成的离散答案序列，而不是直接在学生当前策略自己采样的轨迹上计算分布损失。

这里的关键是：**教师输出的是一个 Token 序列，学生模仿这个序列。**

作者把这种做法称为 Hard Distillation（硬蒸馏）。

### B. ReST 和 STaR：通过成功轨迹进行自训练

ReST 和 STaR 采用了另一种路线：

1. 模型生成多条推理轨迹。
2. 根据奖励、参考答案或其他标准筛选轨迹。
3. 保留成功的轨迹。
4. 对成功轨迹进行 SFT。
5. 继续生成新轨迹，进入下一轮。

例如，同一道题生成四个答案：

| 轨迹 | 最终答案 | 处理方式 |
|---|---|---|
| A | 正确 | 保留 |
| B | 错误 | 丢弃 |
| C | 错误 | 丢弃 |
| D | 正确 | 保留 |

随后模型只学习 A 和 D。

这与 OPSD 的一个关键区别是：

- STaR 主要从成功轨迹中学习。
- OPSD 即使遇到失败轨迹，也可以计算逐 Token 的教师—学生分布差异。

因此，OPSD 不需要先证明学生已经生成了正确答案，才能产生训练信号。

但要注意，这并不代表 OPSD 一定能从失败轨迹中学到正确的推理。教师的分布仍然可能不准确。

### C. Hard Distillation 与 Soft Distillation

这是读这篇论文必须掌握的术语。

| 方式 | 教师提供什么 | 学生学习什么 |
|---|---|---|
| Hard Distillation | 一个确定的 Token 序列 | 模仿该序列 |
| Soft Distillation | 每个位置的概率分布 | 匹配教师的概率分布 |

例如，教师在某个位置预测：

\[
p_T=[0.8,0.1,0.1]
\]

Hard Distillation 可能只提供概率最大的 Token `7`，学生就学习这个 Token。

Soft Distillation 则保留：

- `7` 的概率是 0.8；
- `8` 的概率是 0.1；
- `9` 的概率是 0.1。

因此，学生不只知道教师选了什么，还能学习教师对其他候选的判断。

论文提到 Mitra 和 Ulukus（2025）将相关自训练思路扩展到软蒸馏。这里作者是在说明软蒸馏并非 OPSD 首创，而是把它引入了不同的训练范式和推理场景。

### D. In-context Editing：上下文诱导的知识编辑

这项工作与 OPSD 有一个很有意思的联系。

它同样研究：

- 学生在自己的策略下采样。
- 利用上下文诱导出额外知识。
- 通过软蒸馏，将这种知识内化到模型中。

但论文强调，它的主要应用场景是 Knowledge Editing（知识编辑），而不是数学推理。

所以它与 OPSD 在方法思路上接近，但研究目标不同。

### E. 作者提到的同期工作：SDPO 和 SDFT

原文特别指出两项同期研究：

- **SDPO**：利用环境反馈作为教师可见的特权信息。
- **SDFT**：研究持续学习任务上的同策略自蒸馏。

这两项工作很值得注意，因为它们意味着：

**不能把 OPSD 的贡献概括为“第一个让模型自己教自己”或“第一个使用特权上下文做自蒸馏”。**

作者更具体的研究定位是：针对推理任务，在学生自己的生成轨迹上，让同源教师利用参考答案提供逐 Token 的完整分布监督，并研究这种方法的训练效果和采样效率。

这比笼统声称“自蒸馏是新方法”更准确。

---

## 5.2 第二条线：On-Policy Distillation（同策略蒸馏）

这一段是在进一步解释 OPSD 和传统蒸馏的区别。

### 先理解 On-policy 与 Off-policy

想象一个学生正在学习骑自行车。

- Off-policy：老师提前录制一段标准路线，学生反复观看录像学习。
- On-policy：学生自己骑车，老师观察学生实际走过的路线，并在这些位置给予纠正。

两者的差别不在于有没有老师，而在于**训练所依据的状态和轨迹从哪里来**。

在大模型中：

- Off-policy：训练轨迹来自固定参考答案或教师生成的答案。
- On-policy：训练轨迹来自学生自己的当前生成策略。

为什么这很重要？

因为学生可能生成错误答案，也可能走入教师标准答案从未经过的前缀。如果只训练标准轨迹，学生在自己实际生成的前缀上未必学得好。

On-policy Distillation 希望直接解决这个问题。

### 作者为什么提到 DAgger？

DAgger 是机器人和强化学习中的一种经典模仿学习算法。

它的核心思路是：让学生策略先执行任务，再让教师对学生实际访问的状态提供纠正监督，逐渐减少学生自身状态分布与专家示范分布之间的差异。

这与 OPSD 有相似的思想：

| DAgger | OPSD |
|---|---|
| 学生执行动作 | 学生生成 Token |
| 学生访问实际状态 | 学生形成实际生成前缀 |
| 教师提供纠正动作 | 教师提供下一 Token 概率分布 |
| 学生学习教师纠正 | 学生最小化逐 Token 分布差异 |

但两者并不是同一种算法。DAgger 的监督通常是教师给出的纠正动作标签；OPSD 则使用教师与学生的概率分布散度。

### OPSD 与常规 On-Policy Distillation 的区别

作者指出，很多已有 On-Policy Distillation 方法使用一个独立的教师模型，而且教师往往更大、更强。

OPSD 想回答的问题则是：

**如果没有额外的大模型教师，只使用同一个基础模型，但让教师分支多看到参考答案，能不能产生足够有用的指导？**

这才是 OPSD 的研究重点。

它希望减少对更大教师模型的依赖，但代价是需要额外的参考答案，并且教师提供的指导是否有效取决于模型的推理能力。

---

## 5.3 第三条线：SFT 和 RL 如何提升大模型推理能力？

这一段是作者将 OPSD 放到更大的后训练研究背景中。

### SFT：学习高质量推理轨迹

SFT 的优势是直接、稳定、容易实现。

只要有高质量推理数据，就能让模型学习正确的推理格式和解题步骤。

但作者引用的研究指出，SFT 有时会依赖训练样本的记忆，而不一定获得稳健的泛化能力。

例如，模型可能记住某类题的固定解题格式，却不能很好地应对稍微变化的问题。

### RL：直接优化结果

RL 则尝试让模型通过奖励学习如何完成任务。

对于数学推理，可以使用自动验证器：

- 答案正确：奖励 1。
- 答案错误：奖励 0。

这种方法直接优化任务结果，而不要求模型模仿某个固定答案。

作者认为，RL 在某些情况下能够获得更好的泛化表现。

### 为什么特别提 GRPO？

传统 PPO 通常需要一个 Critic 来估计状态价值，辅助计算 Advantage。

GRPO 则通过同一道题的一组采样回答，利用组内奖励估计相对优势，不需要单独训练一个 Critic。

这使 GRPO 更适合大规模语言模型的强化学习训练。

但它仍然面临我们前面讨论的两个问题：

1. 最终结果奖励无法直接告诉模型每一步应该如何调整。
2. 如果一组答案全部正确或全部错误，组内奖励没有差异，就无法获得有效的组相对奖励信号。

OPSD 希望通过逐 Token 的教师分布监督，减少对最终二元奖励的依赖。

### 三种范式的最终区别

| 方法 | 核心学习信号 | 是否需要成功答案 |
|---|---|---|
| SFT | 标准答案的 Token 标签 | 需要参考训练轨迹 |
| GRPO | 最终结果奖励构造的 Advantage | 不一定需要参考答案，但需要可验证奖励 |
| OPSD | 教师与学生在每个生成位置的分布差异 | 需要参考答案作为教师特权上下文 |

所以 OPSD 不是简单地把 SFT 和 GRPO 拼接在一起，而是提出了另一种监督方式：**让学生自己探索生成轨迹，再利用教师的软分布提供逐 Token 指导。**

---

# 四、第 6 章 Conclusion：作者最终想表达什么？

结论段其实是在重述整篇论文的核心假设。

作者认为，一个具有一定推理能力的大模型，在获得问题答案这一特权信息后，可以通过教师分支产生更有指导意义的概率分布，帮助不具备答案上下文的学生分支改善推理。

这里的“自己教自己”需要准确理解：

- 教师与学生来自同一个初始模型。
- 教师能够看到标准答案。
- 学生不能看到标准答案。
- 教师不一定比学生拥有更大的模型规模。
- 论文正式实验中，教师冻结在初始参数，学生持续更新。

因此，这不是说模型完全不需要外部知识，就能凭空提高推理能力。它使用了数据集中的参考答案，只是把参考答案从学生的直接学习目标，转变成教师的额外上下文。

作者总结的主要实验结果是：

- OPSD 优于本文设置下的 Off-policy Distillation / SFT。
- 在整体表现上与 GRPO 相当或更好。
- 在学生生成 Token 的利用效率上优于 GRPO。

但这些结论仍然受到实验范围限制：主要验证的是 Qwen3 的 1.7B、4B、8B 模型和数学推理任务，不能直接推广到所有模型和所有开放式任务。

---

# 五、把整篇论文的研究定位压缩成一张图

<box border radius="xl" padding={3} gap={3}>
  <box gap={1}>
    <title size="md">传统 SFT / Context Distillation</title>
    <text color="secondary" size="sm">教师生成离散答案 → 学生模仿固定 Token 序列</text>
  </box>
  <divider color="subtle"/>
  <box gap={1}>
    <title size="md">STaR / ReST</title>
    <text color="secondary" size="sm">生成多条轨迹 → 筛选成功答案 → SFT</text>
  </box>
  <divider color="subtle"/>
  <box gap={1}>
    <title size="md">GRPO</title>
    <text color="secondary" size="sm">学生生成多条轨迹 → 验证最终结果 → 组相对奖励 → 更新模型</text>
  </box>
  <divider color="subtle"/>
  <box background="surface-secondary" radius="lg" padding={3} gap={2}>
    <title size="lg">OPSD</title>
    <text>学生自己生成轨迹 → 教师额外看到参考答案 → 计算逐 Token 全词表散度 → 更新学生</text>
    <text color="secondary" size="sm">主要方案：Forward KL + Pointwise Clipping + Full-vocabulary Distillation。</text>
  </box>
</box>

**如果你要从这篇论文中学习科研方法，我建议最后记住两个问题。**

第一，作者没有发明新的 Transformer 架构，也没有发明 KL 散度。它的主要创新是重新设计了训练信号的来源：学生在自己的轨迹上学习，教师通过参考答案提供软监督。

第二，真正值得进一步研究的问题是：**教师与学生之间的分布差异，什么时候代表有价值的推理指导，什么时候只是表达风格或错误判断造成的噪声？**

论文的 Pointwise Clipping、Thinking Mode 组合和散度消融，实际上都在尝试回答第二个问题。这也是这篇论文最值得你带到后续研究中的思路。

---

## User
*2026-10-24 17:43*
可是不是初始冻结吗 按你这说法 成了一直冻结了呀
看到你关于 sample token 的解释，我又产生了一个很大的新疑惑。

1. 关于散度的计算位置：
简单来讲，就是我之前问你的：首先让学生模型生成一个轨迹，那么在计算散度时，它是能自动识别到只在最后一个生成结果的位置计算吗？还是在每个位置上都应该去计算？这个是怎么判断的？

2. 关于错误答案重新思考的合理性：
说实话，假如是出一些推理型或者开放性的题目，知道答案和不知道答案的差距那是天翻地覆的。你这直接从一个错误答案上去重新思考这个事情，我觉得就非常变态呀！当然，我需要确认一下它是怎么去重新思考的。

3. 关于新一轮输入的具体机制：
我的理解是，新一轮的输入和教师模型的输入肯定不一样。学生模型多了个标准答案，在新一轮输入时，就是把教师轨迹的 token 加进去，去算概率就可以了。你确定这样就可以吗？还有，在预测下一个位置时，是把上上个错误的 token 也都加上吗？

你只是举了个数学例子，我觉得太简单了，很不合理。或者你给我讲清楚。

---

## Assistant
*2026-10-24 17:43*
这次我会用一条“中途出错、后面继续推导”的完整轨迹，把教师的输入序列、每个位置的 logits 和下一轮参数更新分别展开。你指出的核心问题也确实存在：教师看到了正确答案，但仍被要求评估学生的错误前缀，这并不保证它能给出正确的纠偏信号。

---

## Assistant
*2026-10-24 17:43*
<details><summary>工具调用 · api_tool.call_tool</summary>

```python3
{"path":"/files/search","args":{"query":"zhao26be On-Policy Self-Distillation frozen initial policy teacher Figure 2 Algorithm 1 On-Policy Self-Distillation","scope":{"surfaces":["conversation"]}}}
```

</details>

---

## Tool
*2026-10-24 17:43*
```json
{"api_tool_source":"files/search","results":[{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451"},{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451"},{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451"},{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451"},{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451"},{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451"},{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451"},{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451"},{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451"},{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451"}]}
```

---

## Assistant
*2026-10-24 17:44*
<details><summary>工具调用 · api_tool.call_tool</summary>

```python3
{"path":"/files/read","args":{"read":[{"ref_id":"turn5file0","mode":"pages","start_page":4,"end_page":5,"include_images":false},{"ref_id":"turn5file0","mode":"pages","start_page":6,"end_page":7,"include_images":false},{"ref_id":"turn5file0","mode":"pages","start_page":13,"end_page":13,"include_images":false}]}}
```

</details>

---

## Tool
*2026-10-24 17:44*
```json
{"api_tool_source":"files/read","results":[{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451","api_tool_source":"files/read"},{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451","api_tool_source":"files/read"},{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451","api_tool_source":"files/read"}]}
```

---

## Assistant
*2026-10-24 17:44*
<details><summary>工具调用 · api_tool.call_tool</summary>

```python3
{"path":"/files/find","args":{"find":[{"ref_id":"turn5file0","pattern":"frozen"},{"ref_id":"turn5file0","pattern":"freeze"},{"ref_id":"turn5file0","pattern":"teacher policy"},{"ref_id":"turn5file0","pattern":"initial policy"},{"ref_id":"turn5file0","pattern":"fixed"}]}}
```

</details>

---

## Tool
*2026-10-24 17:44*
```json
{"api_tool_source":"files/find","results":[{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451","api_tool_source":"files/find","message":"No matches were found in the requested range. A zero-match find does not establish that the answer is absent. If the wording or location is uncertain, call `files.search` for ranked semantic retrieval; otherwise retry `files.find` with a broader or alternate exact pattern."},{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451","api_tool_source":"files/find","message":"No matches were found in the requested range. A zero-match find does not establish that the answer is absent. If the wording or location is uncertain, call `files.search` for ranked semantic retrieval; otherwise retry `files.find` with a broader or alternate exact pattern."},{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451","api_tool_source":"files/find"},{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451","api_tool_source":"files/find"},{"name":"zhao26be.zh-CN.dual.pdf","mime_type":"application/pdf","size_bytes":1711114,"library_file_id":"libfile_a8c4a1707ea88191a63ce65ba58c9f54","file_id":"file_00000000f8308230a3d0294f69770451","api_tool_source":"files/find"}]}
```

---

## Assistant
*2026-10-24 17:44*
你这次的三个问题非常关键，尤其是第二个问题，实际上已经碰到了 **OPSD 的一个核心局限：教师知道正确答案，并不代表它能在学生已经犯错的前缀上，给出正确的下一步指导。**

另外，你对“下一轮输入”的理解还有一处需要纠正：**学生始终不看标准答案，也不会把教师生成的 Token 加进自己的输入，因为教师根本不生成轨迹。**

我们先把这几个容易混淆的地方彻底分开。

## 一、“冻结初始教师”，究竟是冻结多久？

你的质疑是对的，我之前的表述不够明确。

我重新核对了论文第 4 章的 Implementation Details，原文明确说：

> We fix the teacher policy to be the initial policy

也就是说，**整个训练期间，教师都固定在初始模型参数上，而不仅仅是训练开始时暂时冻结。** <FileCite ref="turn5file0"/>

假设初始模型参数是 \(\theta_0\)。

| 训练时刻 | 教师参数 | 学生参数 |
|---|---|---|
| 初始化 | \(\theta_0\) | \(\theta_0\) |
| 第 1 次更新后 | \(\theta_0\) | \(\theta_1\) |
| 第 50 次更新后 | \(\theta_0\) | \(\theta_{50}\) |
| 第 100 次更新后 | \(\theta_0\) | \(\theta_{100}\) |

为什么还叫 Self-Distillation（自蒸馏）？

因为教师不是额外找来的更大模型，而是从**学生的初始模型**构造出来的。

但是到了训练后期，它们已经不是参数完全相同的两个策略。

论文的方法介绍使用了共享参数的抽象形式，而实际实验采用了固定初始教师的实现。你阅读时应该以实际实验为准。

---

## 二、第一个问题：散度到底在哪些位置计算？谁来判断？

答案非常明确：

**按照 OPSD 的公式，学生生成了多少个有效 Token，就沿这些生成位置逐个计算散度，而不是自动识别错误的位置，也不是只计算最后的答案。**

原文的核心公式：

\[
\boxed{
\ell(x,y^\star)
=
\frac{1}{|\hat y|}
\sum_{n=1}^{|\hat y|}
D\left(
p_T(\cdot\mid x,y^\star,\hat y_{<n}),
p_S(\cdot\mid x,\hat y_{<n})
\right)
}
\]

你看这个求和：

\[
\sum_{n=1}^{|\hat y|}
\]

它已经决定了比较范围：学生轨迹中的所有有效生成位置。

### 用一个例子

假设学生一共生成 100 个 Token：

<box border radius="xl" padding={3} gap={2}>
  <text color="secondary" size="xs">每个方格代表 10 个生成位置（仅为示意）</text>
  <grid columns={5} gap="4px">
    {#each Array.from({length:10},(_,i)=>i) as i}
      <grid-item>
        <box background="rgba(59,130,246,0.12)" padding={2} radius="sm" align="center">
          <text size="xs" tabularNums>{i*10+1}–{i*10+10}</text>
          <icon name="check" color="success" size="sm"/>
        </box>
      </grid-item>
    {/each}
  </grid>
  <text size="sm">以上 100 个位置都参与教师—学生分布比较，不需要先识别哪些位置正确、哪些位置错误。</text>
</box>

因此，计算出的是：

\[
D_1,D_2,\ldots,D_{100}
\]

再求平均：

\[
\ell=\frac{1}{100}\sum_{n=1}^{100}D_n
\]

对于实际程序，通常使用有效 Token mask 屏蔽 Prompt 和 Padding，保留学生回答中的有效预测位置。

这里有一个重要区别：

- **模型能计算第 37 个位置的散度。**
- **模型不一定知道第 37 个位置是推理错误。**

KL 只衡量教师和学生的分布差异，不直接判断“这一步数学上是否正确”。

这也是作者为什么要研究风格 Token 干扰、KL 裁剪等问题。

所以，OPSD 并没有一个自动识别关键错误步骤的机制。

---

## 三、第二个问题：教师明知道学生前面错了，为什么还要继续沿着错误轨迹算？

这才是你这次最值得追问的地方。

我们不再用 \(3+4\) 这种过于简单的例子，而是用一条**中途产生错误、后续所有推理都受到影响**的轨迹来分析。

### 1. 给模型一道稍复杂的概率题

> 一个袋子里有 5 个红球、3 个蓝球。连续不放回地抽出两个球，求两次都抽到红球的概率。

标准解答是：

\[
P=\frac58\times\frac47=\frac5{14}
\]

因为第一次抽出红球后，袋中只剩 4 个红球、总计 7 个球。

假设学生却生成了：

> 第一次抽到红球的概率为 \(5/8\)。第二次抽到红球的概率仍然为 \(5/8\)。因此两次都抽到红球的概率为 \((5/8)^2=25/64\)。

这里出现了典型的推理错误：

**学生没有考虑不放回抽样导致的条件概率变化。**

为了演示，我们把学生轨迹划分为五个片段。注意，这里是语义片段，不是真实 Token 边界。

<box border radius="xl" padding={3} gap={2}>
  <text color="secondary" size="xs">学生生成的完整轨迹</text>
  <box background="surface-secondary" radius="md" padding={3} gap={2}>
    <row align="start" gap={2}>
      <icon name="check-circle" color="success"/>
      <box flex="1">① 第一次抽到红球的概率为 5/8。</box>
    </row>
    <row align="start" gap={2}>
      <icon name="x-circle" color="danger"/>
      <box flex="1">② 第二次抽到红球的概率仍然为 5/8。</box>
    </row>
    <row align="start" gap={2}>
      <icon name="x-circle" color="danger"/>
      <box flex="1">③ 因此两次都抽到红球的概率为</box>
    </row>
    <row align="start" gap={2}>
      <icon name="x-circle" color="danger"/>
      <box flex="1">④ (5/8)²</box>
    </row>
    <row align="start" gap={2}>
      <icon name="x-circle" color="danger"/>
      <box flex="1">⑤ =25/64。</box>
    </row>
  </box>
</box>

现在学生已经生成了整条错误轨迹。

OPSD 会用教师分支评估这条轨迹的每一个 Token 预测位置。

### 2. 教师如何评估第一次出现错误的地方？

我们关注学生准备输出第二次抽球概率的位置。

学生分支看到：

> 袋中有 5 红 3 蓝，不放回抽两个……第一次抽到红球概率为 5/8，第二次抽到红球的概率为……

教师分支看到：

> 袋中有 5 红 3 蓝，不放回抽两个……  
> 参考解答：第一次概率为 5/8，第二次条件概率为 4/7，因此最终概率为 5/14。  
> 请理解参考解答并重新解题。  
> 答案：第一次抽到红球概率为 5/8，第二次抽到红球的概率为……

注意，两边共同的学生前缀是完全一样的。

但是教师前面多了完整的标准解答。

因此，在预测第二次抽球概率时，可能得到：

| 候选 | 学生概率 | 教师概率 |
|---|---:|---:|
| `4/7` | 0.20 | 0.75 |
| `5/8` | 0.65 | 0.10 |
| 其他 | 0.15 | 0.15 |

*以上概率均为假设，用于解释机制。*

如果教师真正理解了“不放回”的含义，它就可能给 `4/7` 更高的概率。

于是，OPSD 计算这两个概率分布的 KL，并更新学生，让它以后在类似上下文中，更倾向于产生教师支持的预测。

**这就是它有可能从失败轨迹中学习的原因。**

但问题还没有结束。

### 3. 最重要的难点：学生已经生成了错误的 `5/8`，之后怎么办？

你的怀疑在这里完全成立。

当我们来到学生轨迹的后一个位置时，学生前缀已经变成：

> 第一次抽到红球的概率为 5/8。第二次抽到红球的概率仍然为 5/8。因此……

此时教师也必须面对这个已经错误的前缀。

教师看到的是：

<box border radius="lg" padding={3} gap={2}>
  <text color="secondary" weight="medium" size="xs">教师的完整条件上下文（示意）</text>
  <box background="surface-secondary" padding={3} radius="md">
    **题目：** 不放回抽球的概率问题。

    **参考答案：** 第二次条件概率是 4/7，最终为 5/14。

    **待评估的学生前缀：** 第一次概率 5/8。第二次概率仍为 5/8。因此……
  </box>
  <row align="center" gap={2}>
    <icon name="arrow-down" color="secondary"/>
    <text color="secondary" size="sm">预测下一个 Token 的概率分布</text>
  </row>
</box>

你看，这里确实出现了矛盾：

- 标准解答告诉模型第二次概率为 4/7。
- 学生前缀却已经写成了 5/8。

教师接下来可能出现不同情况。

**情况 A：教师识别出矛盾。** 它可能更支持输出类似“但上述计算不对，因为是不放回抽样……”的纠正内容。

**情况 B：教师顺着错误前缀继续。** 它可能认为前文既然已经写了第二次概率为 5/8，那么后面应当继续输出 \((5/8)^2\)。

**情况 C：教师产生混乱的分布。** 正确解答与错误前缀互相干扰，教师提供的分布不一定比学生更有价值。

这三种情况在模型层面都可能发生。

而 OPSD 本身**没有一个显式机制来判断哪一种情况出现了，也没有自动把错误前缀修正后再评分的步骤**。

这就意味着：

> 教师获得正确答案，只保证它拥有更多信息，不保证它对每一条错误前缀都能产生正确的指导。

论文的方法是建立在一种假设之上的：模型有足够能力理解标准答案，并借此给自己较弱的学生策略提供有用监督。

但当问题太困难、错误前缀太具有误导性时，这种假设可能不成立。

事实上，作者在附录 A 明确承认：当问题超过模型理解能力，即使教师能够看到真实解答，也不一定能产生有意义的监督。<FileCite ref="turn5file0"/>

所以你说“直接沿着错误答案重新思考很不合理”，这个担忧是有根据的。

不过，更准确地说，OPSD **不是重新生成一条纠正后的完整推理过程，而是在错误前缀的每个位置评估下一个 Token 的概率分布**。

这两种操作有非常大的区别。

---

## 四、第三个问题：下一轮输入究竟是什么？会把以前错误的 Token 一直带进去吗？

这里必须区分两个不同的“下一轮”。

### 情况 A：同一条轨迹内，计算下一个位置

**是的，已经生成的错误 Token 也必须保留在前缀中。**

假设学生生成：

\[
\hat y=(a,b,c,d,e)
\]

其中 \(b\) 是错误 Token。

计算第 3 个位置时：

\[
p_T^{(3)}=p_T(\cdot\mid x,y^\star,a,b)
\]

计算第 4 个位置时：

\[
p_T^{(4)}=p_T(\cdot\mid x,y^\star,a,b,c)
\]

计算第 5 个位置时：

\[
p_T^{(5)}=p_T(\cdot\mid x,y^\star,a,b,c,d)
\]

发现没有？

**前面错误的 \(b\)，不仅会进入下一位置，还会进入后面所有位置的前缀。**

这是因为 OPSD 计算的是教师在学生实际访问过的上下文上的预测分布。

如果把错误 Token 擅自替换成正确 Token，就改变了原来的学生轨迹，训练目标也就变了。

所以不应该理解成“教师先把错误纠正，然后后面的散度都在正确轨迹上计算”。

论文没有做这件事。

### 情况 B：完成一次训练更新后，进入下一个 Training Step

**不会自动带入上一条错误轨迹，也不会把教师轨迹加进学生输入。**

假设现在是第 \(t\) 轮训练。

<box border radius="xl" padding={3} gap={2}>
  <title size="md">第 \(t\) 轮训练</title>
  <box background="surface-secondary" radius="md" padding={3} gap={1}>
    **学生模型：** \(\theta_t\)

    **学生输入：** 题目 \(x\)

    **学生生成：** \(\hat y^{(t)}\)，可能包含错误。
  </box>
  <icon name="arrow-down" color="secondary"/>
  <box border radius="md" padding={3} gap={1}>
    **教师评估：** 初始参数 \(\theta_0\)

    **教师输入：** 题目 + 标准答案 + 学生轨迹 \(\hat y^{(t)}\)
  </box>
  <icon name="arrow-down" color="secondary"/>
  <box background="surface-secondary" radius="md" padding={3} gap={1}>
    **计算 Loss → 更新学生**

    \[
    \theta_t\longrightarrow\theta_{t+1}
    \]
  </box>
  <divider color="subtle"/>
  <title size="md">第 \(t+1\) 轮训练</title>
  <box border radius="md" padding={3} gap={1}>
    **学生模型：** 更新后的 \(\theta_{t+1}\)

    **学生输入：** 新选取或重新采样的题目，不包含标准答案。

    **学生重新生成：** 新轨迹 \(\hat y^{(t+1)}\)
  </box>
</box>

所以，新一轮并不是这样：

~~旧学生轨迹 + 教师轨迹 + 标准答案 → 学生继续生成~~

而是：

\[
\boxed{
\text{题目}
\xrightarrow{\text{更新后的学生模型}}
\text{全新学生轨迹}
}
\]

标准答案始终只用于教师分支。

同一道题即使被再次采样到，也会由当前学生策略重新生成轨迹，而不是默认接着上一次错误答案继续写。

---

## 五、你说“学生模型多了标准答案”，这里正好理解反了

我们用最终的数学表达固定这个区别。

在训练第 \(t\) 轮，学生首先生成：

\[
\hat y^{(t)}
\sim
p_{\theta_t}(\cdot\mid x)
\]

然后，在该轨迹的第 \(n\) 个预测位置：

**学生：**

\[
\boxed{
p_S^{(n)}
=
p_{\theta_t}
(\cdot\mid x,\hat y_{<n}^{(t)})
}
\]

**教师：**

\[
\boxed{
p_T^{(n)}
=
p_{\theta_0}
(\cdot\mid x,y^\star,\hat y_{<n}^{(t)})
}
\]

两者的区别在于：

| | 学生 | 教师 |
|---|---|---|
| 题目 | 有 | 有 |
| 标准答案 | 没有 | 有 |
| 学生已经生成的前缀 | 有 | 有 |
| 教师自己生成的轨迹 | 没有 | 没有 |
| 模型参数 | 当前 \(\theta_t\) | 冻结 \(\theta_0\) |
| 参数更新 | 是 | 否 |

你可以看出，教师并没有将自己的推理结果插入学生序列。

它只是通过多出来的 \(y^\star\) 改变当前条件概率分布。

## 六、那为什么论文称教师在“重新思考”？

这是论文表述中很容易误导读者的地方。

作者在 Figure 2 的教师提示词中，确实写了类似：

> 理解参考解答之后，请尝试用自己的方法重新解题。

但同一张图的说明也明确指出：**教师不会真正生成 Token，所谓 rationalization 通过前向计算隐式发生。** <FileCite ref="turn5file0"/>

从 Transformer 的角度看：

1. 教师提示词包含完整参考解答。
2. 模型通过注意力机制处理这些上下文。
3. 参考解答可能改变各层隐藏状态。
4. 模型对学生前缀之后的下一个 Token 给出概率分布。

这就是所谓的“隐式理解”。

它并不等于：

- 教师先生成一份新的 CoT。
- 教师明确检查学生每一步推理。
- 教师找到第一个错误并进行修正。
- 教师再生成正确的新轨迹。

**这些步骤都不是本文 OPSD 算法所实现的。**

因此，论文中的“教师”更接近一个**拥有特权上下文的条件概率分布提供者**，而不是一个真正逐步审题、纠错的 Agent。

---

## 七、回到你之前问的 Sampled-token：它同样会受到这个问题影响

为了把之前的概念也连起来：

假设学生在错误位置采样了 `5/8`。

Sampled-token 会计算：

\[
A_n
=
\log p_T(\texttt{5/8}\mid\text{当前前缀})
-
\log p_S(\texttt{5/8}\mid\text{当前前缀})
\]

如果：

\[
p_T(\texttt{5/8})=0.1,\quad
p_S(\texttt{5/8})=0.7
\]

那么：

\[
A_n=\log(0.1/0.7)\approx-1.946
\]

负优势会抑制学生以后在类似上下文中选择这个 Token。

但如果教师受到错误前缀影响，反而认为 `5/8` 更合理，例如：

\[
p_T(\texttt{5/8})=0.8,\quad
p_S(\texttt{5/8})=0.7
\]

则：

\[
A_n=\log(0.8/0.7)>0
\]

此时它反而会鼓励这个错误 Token。

当然，这是针对 Sampled-token 替代目标的直观分析。论文主方案使用全词表蒸馏，不能直接把一个 Token 的优势值当作完整全词表 KL 的梯度。但两种方法都依赖教师分布是否有用。

**所以，无论 Full-vocabulary 还是 Sampled-token，只要教师的判断存在偏差，学生都可能学到不理想的东西。**

---

## 八、最后，从科研角度总结你这次发现的问题

你现在提出的其实是三个不同层次的问题：

| 问题 | OPSD 是否解决？ | 解释 |
|---|---|---|
| 如何在两个不同提示词之间对齐 Token？ | **解决了** | 两者始终评估相同学生前缀 |
| 如何在一条错误轨迹的所有位置产生训练信号？ | **实现了** | 每个位置计算教师与学生的概率分布差异 |
| 如何保证教师在错误前缀上仍提供正确指导？ | **没有保证** | 依赖教师理解参考答案的能力 |

其中第三个问题最值得关注。

OPSD 的方法假设是：

\[
\text{更多正确上下文}
\Longrightarrow
\text{更有价值的教师分布}
\]

但从逻辑上，这个箭头不是必然成立的。

特别是当学生早期犯错，后续推理全部沿着错误方向展开时，教师虽然知道最终正确答案，却仍需要在错误的条件前缀上预测下一 Token。这确实存在所谓的**错误前缀条件化（conditioning on erroneous prefixes）**风险。

论文通过实验展示了整体性能提升，但没有充分证明教师在错误传播的不同阶段，究竟提供了多少正确的纠偏信息。

因此，我认为你不应该把 OPSD 理解成“教师沿着学生错误轨迹进行完整纠错”。更准确的理解是：

**OPSD 是在学生真实生成的轨迹上，用一个拥有标准答案的固定教师，提供逐位置概率分布监督。它能够产生密集信号，但信号是否真正代表有效的推理纠正，仍然是一个值得研究的问题。**

这正是该论文机制和实际推理纠错之间的重要区别。

---

## Assistant
*2026-10-24 17:45*
> ❔ text
