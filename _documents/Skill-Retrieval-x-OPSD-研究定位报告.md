# Skill Retrieval × OPSD：从“刷检索榜”到真正有 Hard-Agent 故事的研究定位

## 先给结论：你师兄的担心是对的，但它否定的只是“纯 Skill Retrieval”，不是 Skill 这条线

我把你这次给出的两次讨论放在一起看，尤其是 Edwin 哥最初给你的任务边界：**他的工作动 Retriever/Ranker，你可以反过来固定 Retriever，训练 LLM 生成更好的 Query；而 Skill 与普通 RAG 文档的关键区别在于 Skill 是 functional object，Skills 之间可能存在并列、依赖、组合等关系。**

截至 **2026 年 10 月 28 日**，结合最近两三个月尤其是 EMNLP 2026 刚出现的一批工作，我的判断发生了一个很重要的收敛：

> **“给一个 Query，从大 Skill 库里把相关 Skill Top-K 检索出来”本身，确实越来越不像一个足够强的 Hard-Agent 问题。**
>
> **但是，“Agent 如何在实际任务中发现、判断、组合并真正利用 Skill”正在迅速变成一个很活跃、而且明显没有解决的问题。**

这里有三条非常关键的新证据。

第一，**SkillSeek** 在超过 23 万 Skill 的 marketplace-scale 环境中发现，在它测试的 SkillsBench 设置里，普通 BM25 在四组设置中的三组已经达到或超过 LLM-mediated retrieval loop；加一个小 cross-encoder 后可以覆盖剩下差距，而且总体花费从约 51.30 美元降到 27.54 美元。也就是说：

> **“库很大，所以一定需要复杂 LLM 检索”这个故事是不成立的。**

第二，清华 + 字节的 **SRA-Bench** 发现，问题并没有随着 Retriever 变好而消失。它把整个过程拆成 Retrieval → Incorporation → Application，最终发现 Agent 对 distractor 很敏感、不知道什么时候真的需要加载 Skill，而且即使召回了相关 Skill，也经常不能正确地把它转化成任务成功。项目主页甚至直接把“better retrieval does not guarantee better answers”概括成它的 surprising bottleneck。

第三，刚刚在 EMNLP 2026 Findings 出现的 **Skill Following** 给出了更尖锐的结果：17 个 LLM 上，很多模型从整体统计看“用了 Skill 以后准确率更高”，但如果在**同一个任务**上比较打开 Skill 与关闭 Skill，实际的 Retrieval-Invoked Actual-Use Effect（RAE）可以是负数；在 MBPP+ 上甚至存在“正好在模型决定检索 Skill 的那些任务上，Skill 反而害了它”的情况。

所以你们现在真正值得追的，不应该是：

> **How to retrieve relevant skills?**

而更应该逐渐升级成：

> **How can an LLM learn when, what, and how to search for skills that are actually useful for task completion, rather than merely relevant?**

这一步非常重要。

它把研究从一个容易被说成“IR 小问题”的东西，升级成了一个 **Agent Policy Learning 问题**。

而这恰好也是 OPSD 真正能够自然接上的地方。

---

## 最近的 Skill 论文实际上在告诉我们：问题已经从“相关性”转向“效用、结构和适用性”

我专门把近几个月比较值得看的工作重新按照“它究竟发现了什么 Hard Problem”整理了一遍。

你会发现一个非常明显的趋势：

**2026 年 5 月左右，大家还在问“Skill 怎么检索”；到 9–10 月，越来越多论文已经开始问“检索出来以后，这个 Skill 到底该不该用、有没有用、和别的 Skill 是什么关系”。**

### 纯 Retrieval 问题正在快速被填满

最典型的是 **SkillRet**。

它有 17,810 个公共 Agent Skills、63,259 条训练样本和 4,997 个评测 Query，并且训练、测试 Skill Pool 分离；作者发现专门针对 Skill Retrieval 微调后，NDCG@10 比最强 prior retriever 高 13.1 个点。它很好地证明了“Skill Retrieval 是一个可以被正规 benchmark 化的任务”。

但它解决问题的方式仍然基本是：

$$
q \rightarrow \text{Retriever} \rightarrow \operatorname{rank}(s_1,\ldots,s_n)
$$
也就是经典 IR。

R3-Skill 则进一步指出：Skill 不是 Document，因为 Top-K 是否正确不只取决于每个 Query–Skill 的独立相关性，还取决于这些 Skills 是否能够一起完成任务；它专门引入 Set-Compat，并把 compatibility signal 加进 retriever/reranker。

所以现在再做：

> “Skill 和 Document 不一样，我们训一个新的 Retriever。”

已经有人做。

再做：

> “Skills 之间还要看集合兼容性。”

也已经有人做。

甚至到了 2026 年 10 月 23 日，刚出来的 **SkillRep** 已经开始系统研究 Query–Skill representation gap：背景语义、Query 没说出口的 Skill 信息、把长 Skill 压成单向量造成的信息 dilution 等，并在 SRA-Bench 和超过 11 万 Skill 的 UniPool 上组合 Query-side expansion、Document-side expansion、fine-tuning、lexical channel 等方案。

所以**单纯从 Retriever representation 上继续卷，确实越来越像传统 IR。**

这与你师兄的判断是一致的。

### 但 Skill 的“结构问题”反而刚刚被真正打开

这里我认为 **Graph-of-Skills** 非常值得你认真看。

它是 **EMNLP 2026 Main Conference**，不是单纯 arXiv。

作者指出 flat semantic retrieval 有一个非常具体的失败：

> 用户问的东西可能直接匹配 Skill B，但 B 执行前实际上依赖 Skill A；语义检索能找到 B，却不会因为 A 是 B 的 prerequisite 就自然找到 A。

他们把这个问题叫 **prerequisite gap**，离线构建 executable Skill Graph，再通过 dependency-aware retrieval 恢复完整 bundle。GPT-5.2 Codex + SkillsBench 上，GoS 相对 full-skill loading 提升 7.0 个绝对 reward points，同时 Token 降低 56.7%；更有意思的是，把关键的 reverse dependency traversal 换掉之后，dependency-pair co-recovery 从 0.654 掉到 0.362。

这说明：

**Skill 之间确实存在 semantic relevance 无法充分描述的结构。**

再看 **SkillDAG**，EMNLP 2026 Findings。

它把关系说得更直接：

$$
\text{depends\_on},\quad
\text{conflicts\_with},\quad
\text{specializes},\quad
\text{duplicates},\quad
\text{composes\_with}
$$
也就是说，一对 Skills 即使“语义很像”，它们可能实际表达的是完全不同的功能关系。SkillDAG 甚至主张，与其让 Retriever 在后台消费这些关系，不如直接把 typed skill graph 暴露给 Agent，让 LLM 自己查询和更新 Skill 关系。其论文报告在两组 Benchmark 和三个模型族上超过 vector retrieval 和 Graph-of-Skills，并在 10× pool expansion 下保持较好的表现。

所以 Edwin 哥当时跟你说的：

> Chunk 是 evidence，是语义对象；Skill 是 functional object，需要考虑 A 和 B 是并列、依赖还是其他关系。

并不是随便找了一个故事。

**2026 年 10 月的主会论文已经在用实验说明这个差别是真实存在的。**

### 更大的问题其实是“相关 ≠ 有用”

我现在认为这是你最应该关注的转折。

SRA-Bench 的问题是：

> 找到了 Skill，Agent未必知道该不该 load，也未必真的会用。

Skill Following 的问题是：

> 甚至在发生 retrieval 的任务上，Skill 可能使结果变差。

最近的 **SkillMe** 又发现：

> 一个 Skill 可以在语义上非常 relevant，但因为当前 workspace 的工具、文件、格式和 failure mode 不一样，实际仍然不适合当前任务。其 71-task PinchBench 实验显示，把 Skill 针对 recurring workflow 进行 situated evolution 后，8 个 executor 的平均得分提升 25.7 个点。

**Skill-as-Pseudocode** 更直接地指出，即使 Skill 已经检索出来，自由文本 Markdown Skill 仍可能让 Agent 进入“理解错 → 再搜 → 还是理解错”的循环，因为 Agent 需要重新推断输入 schema 和具体 invocation syntax。

而 **STARS** 则把问题推进到安全性：同一个 Skill，在一个 runtime context 下可能正常，在另一个上下文下却可能产生危险调用；因此 static skill relevance 甚至不能决定这个 Skill 此时应不应该被激活。

把这些论文放在一起，一个非常明显的研究图景就出现了：

| 老问题 | 新问题 |
|---|---|
| 这个 Skill 跟 Query 像不像？ | **这个 Skill 在当前状态下有没有实际价值？** |
| Top-K 有没有 Gold Skill？ | **这组 Skills 是否完整、兼容、可执行？** |
| Retriever 排名准不准？ | **Agent 是否知道应该继续搜、换方向还是停止？** |
| 一个 Skill 是否相关？ | **是否应该使用？什么时候用？用了是否真能改善结果？** |
| 单 Skill relevance | **state-conditioned / set-level functional utility** |

这就是我认为现在最值得你利用的研究窗口。

---

## 你的论文故事不应该是“OPSD for Skill Retrieval”，而应该有几个可选的大故事

我现在不建议替你一锤定音，而是给你四条路线。它们的重要性、拥挤程度和 OPSD 适配程度不一样。

### 最推荐：从 Relevance 到 Utility

我暂时给它一个研究名：

**Execution-Grounded On-Policy Self-Distillation for Skill Search**

或者更有论文味一点：

> **Beyond Relevance: Learning Utility-Aware Skill Search through On-Policy Self-Distillation**

它的逻辑是：

#### 现状

传统 Skill Retrieval 优化的是：

$$
\operatorname{Rel}(q,s)
$$
即 Query 和 Skill 是否相关。

但最近的实验证据显示，相关 Skill 不一定产生实际收益；Skill Following 甚至发现 retrieved tasks 上的实际 effect 可以为负，而 SRA-Bench 发现大量错误发生在 incorporation/application 而非简单的召回阶段。

#### 核心矛盾

我们真正需要的是：

$$
U(s\mid x,h_t,S_t)
$$
即：

> 在当前任务 $x$、当前交互历史 $h_t$、已经获得的 Skills $S_t$ 下，这个 Skill **现在到底有没有边际效用**？

注意它和 relevance 不一样。

一个 Skill 可以高度 relevant：

$$
\operatorname{Rel}(q,s)\uparrow
$$
但：

$$
U(s\mid x,h_t,S_t)\leq 0
$$
例如：

- 它与已经找到的 Skill 功能重复；
- 它缺少 prerequisite；
- 它适合另一个环境；
- 它与当前 Skill 冲突；
- 模型自己已经能完成，不需要 Skill；
- Skill 本身会把模型带偏。

这些问题已经分别被 SRA、Skill Following、GoS、SkillMe 等论文实验证明存在。

#### 我们做什么

不是重训 Retriever。

Retriever 保持：

$$
R(q_t)\rightarrow\{s_1,\ldots,s_k\}
$$
**真正训练的是执行任务的那个通用 LLM。**

它自己学会：

$$
\pi_\theta:
(x,h_t,S_t)
\rightarrow
\begin{cases}
\text{Search}(q_t)\\
\text{Continue Search}\\
\text{Change Search Intent}\\
\text{Stop}
\end{cases}
$$
这样你们优化的就不是一个“Skill Retrieval 小模型”。

而是：

> **让 Agent 本身获得 Skill-search competence。**

这和你一直想要的方向完全一致。

### 很强的第二条：从 Flat Retrieval 到 Relational Skill Search

故事可以叫：

**Internalizing Functional Skill Relations into LLM Search Policies**

这条线抓的是 Edwin 哥当时说的 functional relation。

现有 Graph-of-Skills / SkillDAG 的处理方式是：

$$
\text{把 Skill Relation 显式塞进检索系统}
$$
例如建图、PageRank、Graph API。

你们可以反过来问：

> **能不能训练 LLM 本身，使它学会理解 `depends_on / conflicts_with / specializes / composes_with`，而推理时仍然使用完全原封不动的 Retriever？**

这时结构知识可以只在训练时作为 PI：

$$
\text{Graph/Relations}
\overset{\text{training only}}{\longrightarrow}
Teacher
$$
而测试时：

$$
Student + Frozen Retriever
$$
就没有 Graph Retrieval 模块。

这是一个非常自然的 **AOPSD × Skill** 连接。

### 一个更简单但很扎实的故事：Need-aware Skill Search

问题变成：

> **Agent 到底什么时候应该搜索 Skill？什么时候应该继续搜索？什么时候应该停止？**

SRA-Bench 已经明确发现 Agent 缺乏 need-aware loading 能力。

Skill Following 又说明：

> “模型选择了 retrieval”本身不代表这个决定是对的。

于是你可以训练：

$$
a_t \in
\{\text{Search}(q_t),\text{Stop / Solve Directly}\}
$$
这条线非常干净，而且特别适合 OPSD，因为 Search/Stop 是长轨迹中的局部决策，最终 Reward 又很稀疏。

但我更倾向于把它作为前面 Utility-aware 故事的一个子模块，而不是单独撑整篇论文。

### 动态 Skill Library / 泛化路线：有潜力，但先别把它当第一选择

你之前提过：

> Skill 越来越多、不断新增和变化，现有方法可能不适应；OPSD 可以让模型学会适应。

这个方向现在确实有现实依据：SkillSeek 已经讨论超过 23 万 Skill 的公开聚合规模，SkillsVote 甚至分析 million-scale open-source skill corpus；SkillBrew 又明确指出 append-only Skill Bank 会积累 redundant、outdated、harmful skills。

但这条故事有一个很大的问题：

**SkillSeek 已经证明“规模大”本身未必要求复杂 LLM 搜索，廉价 IR 可能就够好。**

所以不要写：

> 库越来越大 → Retriever 不行 → OPSD。

更好的版本必须是：

> 随着库不断变化，出现越来越多**功能近似、版本不同、适用条件不同、相互冲突或相互依赖**的 Skills，而静态 relevance ranking 并不足以决定当前状态下的真实 utility。

这样它就又回到了前面的 Utility / Relation 故事。

### 我对四个选题的当前评分

| 路线 | 问题强度 | OPSD 天然适配 | 竞争拥挤 | 当前建议 |
|---|---:|---:|---:|---|
| **Execution-grounded Utility-aware Skill Search** | ★★★★★ | ★★★★★ | ★★★ | **首选** |
| **Relational / Compositional Skill Search** | ★★★★★ | ★★★★☆ | ★★★★ | **强备选，可和首选组合** |
| Need-aware Search / Stop | ★★★★☆ | ★★★★★ | ★★☆ | **适合作为首选的一个机制** |
| Dynamic / Marketplace Adaptation | ★★★★ | ★★★☆ | ★★★ | **先做诊断，再决定** |
| 单纯 Query Rewrite 刷 Recall/NDCG | ★★ | ★★★★ | ★★★★★ | **不建议作为最终故事** |

这是基于最近论文格局做出的研究判断，而不是已有论文的结论；支撑上述判断的关键事实是：简单 IR 在 SkillSeek 中已经很强，而 SRA-Bench、Skill Following、GoS 和 SkillRubricsRL 正在把问题推向真实 utility、结构和 credit assignment。

---

## 为什么这个问题恰好适合 OPSD，而不是为了火硬套 OPSD

这是这篇论文最终能不能讲好的核心。

假如最后你们的方法只是：

> 把 GRPO 换成 OPSD，然后 SkillRet Recall@10 高了三点。

我认为故事很弱。

因为 Search 场景本身已经有 **SD-Search、SSPO、IGSD** 这些 OPSD / hindsight self-distillation 工作。

真正应该说明的是：

> **Skill Search 本身恰好拥有 OPSD 最喜欢的监督结构。**

### OPSD 特性一：Skill Search 的真正监督大量存在于 hindsight

原始 OPSD 的基本结构是：

$$
\pi_S(y_t\mid h_t)
$$
Student 只看正常信息。

Teacher 与它是同一个模型，但是额外得到训练阶段的 PI：

$$
\pi_T(y_t\mid h_t,z)
$$
然后在 **Student 自己访问到的 on-policy prefixes** 上，利用 token-level distribution 对齐训练 Student。原始 Self-Distilled Reasoner 就是利用这种“同模型 + 不同上下文 + Student rollout”来避免普通 off-policy distillation 的状态分布失配。

Skill Search 天然有很多只有训练后才能知道的 hindsight：

任务跑完以后，我们才知道：

- 哪个 Skill 真被执行了；
- 哪个 Skill 根本没用；
- 哪个 Skill 提高了最终成功率；
- 哪一次 Query 找到的是重复能力；
- 哪一个 prerequisite 漏了；
- 某一步是否应该继续 Search；
- 当前 bundle 有没有冲突。

这比“Gold Skill Name”丰富得多。

而且这些信息多数**测试时不能给 Student**。

这就是非常漂亮的 PI。

### OPSD 特性二：Skill Search 是典型的长轨迹 credit assignment

假设：

$$
q_0\rightarrow s_1
\rightarrow q_1\rightarrow s_2
\rightarrow q_2\rightarrow s_3
\rightarrow \text{Task Success}
$$
最终 Task Reward = 1。

普通 GRPO 大体只能告诉整条轨迹：

> 你成功了。

却无法自然回答：

> q1 是不是多余的？

这正是 Edwin 哥跟你聊的：

> 删掉 q1，直接从 q0 到 q2，看结果的 advantage delta 是否变化，从而判断 q1 是否关键。

而这和当前 Search-Agent literature 的问题完全一致。

SD-Search 直接指出，在 trajectory-level RL 下，一个 rollout 中每一个 search query 都共享同一个 reward，因此 individual query 缺乏 step-specific credit；它用同模型 hindsight teacher 在 search-query token 上提供稠密 JSD supervision。

更巧的是，刚出的 **SkillRubricsRL** 也从 Skill 这一侧独立发现：

> 一个 Skill bundle 只有 trajectory reward 时，不知道每一个 Skill 是否真正被执行、是否真正帮助了任务。

因此它明确把问题定义成 **per-skill credit assignment**，并设计 fulfillment signal 和 counterfactual utility signal。

所以这里有一个非常漂亮的交叉：

**Search OPSD**

> 缺少 per-query credit

**Skill RL**

> 缺少 per-skill utility credit

**你们**

> 学习 Query → Skill → Execution 之间的真实 credit

这比“OPSD for Skill Retrieval”强得多。

### OPSD 特性三：Skill 的 Teacher 很容易被 Gold Information 骗坏

这反而是很好的创新机会。

最粗暴的做法是：

Student：

$$
Task + Current\ Retrieved\ Skills
$$
Teacher：

$$
Task + Current\ Retrieved\ Skills + Gold\ Skill\ Names
$$
但这实际上非常危险。

Teacher 可能直接利用：

> `excel-financial-report-analysis`

这种 Skill 名字重新组织 Query。

Student 测试时没有这个信息。

这就是典型 answer leakage。

AOPSD 最近在数学推理上给出的结果恰好说明，**Teacher Utility 高，不等于 Student Learnability 高**。如果 PI 太强，Teacher 会依赖 PI-conditioned shortcuts；因此 AOPSD 把正确解答表示为 reasoning DAG，只给 Teacher 当前 Student 能够承担的子图和 next frontier，而不是完整答案。

Skill Retrieval 中几乎存在一个天然对应物：

不要给 Teacher：

> 正确 Skill = `financial-report-analyzer-v3`

而给：

> 当前已覆盖 spreadsheet loading；尚缺少 financial-statement interpretation；report rendering 尚未完成。

甚至进一步给：

```text
Current frontier:
  loaded:
    spreadsheet parsing

  unresolved:
    financial analysis

  relation:
    parsing -> analysis

  conflict:
    generic-image-parser is not applicable
```

这就变成：

> **Functional / Relational PI，而不是 Gold Skill ID PI。**

这非常 Skill-specific。

### OPSD 特性四：Teacher 认为好的 Query，实际上可能并不好

这就是 IGSD 最值得借鉴的地方。

你的感觉完全正确：

**IGSD 本质上仍然更像 RAG / Search-Agent 优化。**

它研究的是 Document Retrieval，而不是 Agent Skill。

Teacher 在 Student 的失败状态上给出搜索建议；IGSD 分别执行 Teacher-induced 和 Student-induced Query，使用**同一个 Retriever、同一个 Student 状态**，看哪条 Query 真正带来了更好的 retrieved evidence，再把 executed paired information gain 作为正向蒸馏权重。

而且 IGSD 有一个非常重要的消融：

把 ground-truth answer 直接给 Teacher，反而平均表现最差；作者认为这种 leaky context 容易诱导 answer-conditioned behavior / reward hacking。

这和 AOPSD 的发现高度一致。

所以我们可以借 IGSD 的**训练原则**，但不应该照抄它的 metric。

IGSD 的核心 utility 是：

$$
\Delta IG_{\text{doc}}
$$
我们需要的是：

$$
\Delta U_{\text{skill}}
$$
而这个 $U$ 可以逐渐从弱到强设计：

$$
U^{\text{retrieval}}
\rightarrow
U^{\text{functional}}
\rightarrow
U^{\text{execution}}
$$
分别对应：

**一级：检索收益**

新 Gold Skill 有没有被找到。

**二级：功能收益**

有没有补齐缺失功能、dependency，或者减少冲突和冗余。

**三级：执行收益**

得到这个 Skill 以后，实际任务成功概率有没有提升。

我认为**三级才真正能把你们和普通 OPSD-for-RAG 拉开。**

---

## DAG 到底要不要加：我的答案是“值得测，但要换一种加法”

你之前一直问：

> SkillRouter / Skill 层次本身不就有点 DAG 味道吗？那我们为什么不用 DAG？

这里现在可以给非常清楚的答案。

### 不建议：把 DAG 做成一个新的 Retriever

比如：

$$
q
\rightarrow \text{Semantic Retrieval}
\rightarrow \text{Skill Graph Expansion}
\rightarrow S
$$
这基本就是 Graph-of-Skills 的地盘。

它已经构造 executable skill graph，然后用 reverse-aware Personalized PageRank 和 dependency-aware hydration。

SkillDAG 又进一步把 typed graph 直接暴露给 Agent。

如果你也这么做，既违反 Edwin 哥“Retriever 不动”的研究分工，也会正面撞两篇 2026 年的新论文。

### 我反而很推荐：DAG 只存在于训练阶段

这就变得非常有意思：

```text
Training
────────────────────────────────────

Student:
Task + Retrieved Skills
        │
        ▼
     Search(q)

Teacher:
Task + Retrieved Skills
+ Functional DAG Frontier
+ Execution hindsight
        │
        ▼
   Better Search(q')

                 │
                 ▼
              Distill


Inference
────────────────────────────────────

Task
 │
 ▼
Trained LLM ──Search(q)──► Frozen Retriever
 │                            │
 └──────────── Skills ◄───────┘

No DAG
No extra graph retriever
No extra planner
```

这时候 DAG 做的事情和 AOPSD 非常类似：

> **控制 Teacher 能获得什么 PI。**

而不是：

> 帮 Student 在测试时作弊。

Skill DAG 的关系可以是：

$$
s_i \xrightarrow{\text{depends\_on}}s_j
s_i \xrightarrow{\text{specializes}}s_j
s_i \xleftrightarrow{\text{conflicts}}s_j
$$
Teacher 不需要看到全部 Graph，而只看当前 frontier：

$$
F_t =
\{ \text{当前 Skill bundle 尚未满足的邻接功能关系}\}
$$
于是 PI 就是：

$$
z_t = F_t
$$
Teacher：

$$
\pi_T(a_t\mid h_t,F_t)
$$
Student：

$$
\pi_S(a_t\mid h_t)
$$
我认为这是 DAG 最值得尝试的形式。

### 加 DAG 有三个潜在收益

**第一，避免 Gold Skill Name 泄露。**

Teacher 知道“缺的是哪类 functional prerequisite”，但不知道最终 Skill ID。

**第二，把 Skill-specific structure 真正放进 OPSD。**

否则审稿人很容易说：

> 你就是把 IGSD 的 document query 换成 Skill query。

有 Typed Relation PI 后，你就可以明确回答：

> 我们不是教 Agent 找“更多相关文本”，而是在教它学习可执行能力之间的结构。

**第三，推理阶段没有 Graph 的额外维护成本。**

如果实验能够证明：

$$
\text{Training with relation PI}
>
\text{Training without relation PI}
$$
而测试时两者都只有：

$$
LLM + Frozen Retriever
$$
这个结果会非常漂亮。

但我仍不建议把 DAG 写成必选机制。

**先做 relation-aware oracle diagnostic。**

如果加 dependency/frontier 信息对 Query generation 基本没有帮助，那就不要硬加 DAG。

---

## 一篇真正有故事的论文，可以这样从 Introduction 一路讲到方法

我建议你现在把整篇文章先脑补成下面这个逻辑，而不是先纠结公式。

### 开头不是“Skill Retrieval 很难”

这种开头已经不够强。

更好的开头是：

> **Agent Skills 正在成为扩展 LLM 能力的一种外部 capability layer。随着 Skill repositories 增长，将全部 Skills 塞进 context 已不可扩展，因此 retrieval 成为必需的入口。**

SRA-Bench 已经以 26,262 Skill 的库系统化定义 SRA，公开 Skill collections 也已经达到数万甚至二十多万规模。

### 然后立刻自我否定：“但检索本身不是全部问题”

这是整篇故事最漂亮的一步。

写成思想就是：

> Surprisingly, improving relevance retrieval alone may not solve skill augmentation.

证据非常硬：

- SkillSeek：传统 IR 已经是很强的 Skill Retrieval baseline。
- SRA-Bench：better retrieval 不一定带来 better answers；need-aware incorporation 是重要瓶颈。
- Skill Following：检索 Skill 的任务上可能出现负 RAE，即实际使用 Skill 反而损害结果。

于是问题从：

$$
\text{retrieve relevant skill}
$$
变成：

$$
**retrieve useful skill at the right state**
$$
这就已经不是普通 IR 了。

### 为什么现有方法不够？

一类工作：

$$
\text{Train Better Retriever}
$$
SkillRet、R3-Skill、SkillRep。

另一类：

$$
\text{Redesign Skill Retrieval Structure}
$$
Graph-of-Skills、SkillDAG。

还有一类：

$$
\text{Train Agent via task-level RL}
$$
Skill1 甚至已经让一个统一 policy 生成 query、对候选 Skill 进行 rerank、使用 Skill 并从轨迹产生新 Skill，以 task outcome 统一训练。

所以不能写：

> 以前没人训练 LLM 自己选择 Skill。

这不成立。

### 真正的 gap

可以是：

> **现有方法要么改变 Skill Retrieval backend / graph，要么依赖粗粒度 task outcome 训练整个 skill lifecycle；它们并没有直接解决一个 frozen-retriever setting 下，LLM 如何从自身访问到的搜索状态中学习“哪一次 Skill search 真正增加了 downstream utility”的问题。**

这是目前我能够通过公开文献检索支持的、更安全的新颖性边界。

### 为什么普通 RL 不够？

因为：

$$
R(\tau)
$$
只告诉整条轨迹成功还是失败。

但是：

$$
q_1,\ q_2,\ q_3
$$
哪一个真正找到有用能力，无法直接知道。

SkillRubricsRL 从 Skill 侧已经明确把这个现象称作 per-skill credit assignment。

SD-Search 从 Query 侧又明确指出 trajectory reward 不能给 individual queries step-specific credit。

**你们刚好处在这两个问题的交叉点。**

### 为什么 OPSD 刚好合适？

因为训练时我们能够获得：

$$
\underbrace{\text{Execution Outcomes}}_{\text{hindsight}}
+
\underbrace{\text{Skill Utility / Relation}}_{\text{PI}}
$$
让 self-teacher 在 Student 真正访问到的状态上回答：

> 你现在下一步应该搜索什么？

而不是让一个离线 teacher 给一条与 Student 状态无关的标准轨迹。

这就是 OPSD 的 on-policy 优势。

最终故事可以压缩成：

> **Relevant skill retrieval is increasingly tractable, but useful skill search remains unresolved. We train the agent itself—rather than the retrieval backend—to recognize which capability is worth searching for from its own interaction states. Using execution-derived privileged hindsight, OPSD transforms sparse task outcomes into dense supervision over skill-search decisions.**

我目前认为，这是比“OPSD for Skill Retrieval”强一个层次的叙事。

---

## 方法上不要一口气堆五个模块，应该准备一个“机制候选池”逐个做诊断

我建议你现在先准备完整候选池，等 Benchmark 到手以后一个一个试，而不是提前宣布最终一定有三个模块。

### 基础版：Skill-Search OPSD

这是最小可行版本。

Student rollout：

$$
\tau =
(x,
q_1,S_1,
q_2,S_2,\ldots,
a_{\text{final}})
$$
Retriever 完全冻结。

Teacher 得到 hindsight，例如成功 sibling rollout：

$$
z=
\{\text{successful search queries},
\text{task outcome}\}
$$
在 Search Query Token 上蒸馏：

$$
\mathcal L_{\mathrm{SD}}
=
\sum_{t\in\mathcal Q}
D_{\mathrm{JS}}
\left(
\pi_T(\cdot\mid h_t,z)
\parallel
\pi_S(\cdot\mid h_t)
\right)
$$
这基本对应 SD-Search 的思路，所以**它只能作为 Base Method，不足以成为创新终点**。SD-Search 已经在 Search-Augmented Reasoning 上使用同模型 hindsight teacher，为 search-query positions 提供 dense supervision。

### 候选机制：Execution-Verified Skill Utility

这是目前我最看好的创新。

从同一个 Student State：

$$
h_t
$$
分别产生：

$$
q_t^S,\quad q_t^T
$$
都送给**完全相同的 Frozen Retriever**：

$$
S_t^S=R(q_t^S)
S_t^T=R(q_t^T)
$$
然后不要像 IGSD 那样只测 document information gain，而是计算 Skill-specific utility：

$$
\Delta U_t
=
U(S_t^T)-U(S_t^S)
$$
如果：

$$
\Delta U_t>0
$$
再加强 Teacher 的蒸馏。

IGSD 已经证明实际 executed retrieval gain 比 Teacher 自己的内部 confidence 更可靠；其实验中 executed gain 预测最终赢家的 ROC-AUC 点估计为 0.708，而比较的最强内部概率信号是 0.552。

你们真正的新问题是：

> **Skill 的 $U$ 应该如何定义？**

这反而可能是这篇论文的核心。

### 候选机制：Per-Skill / Per-Query Counterfactual Credit

这是 Edwin 哥最初提你的那个 idea。

例如：

$$
\tau=q_0,q_1,q_2
$$
构造：

$$
\tau^{-q_1}=q_0,q_2'
$$
重新从对应 state rollout，比较：

$$
C(q_1)
=
R(\tau)-R(\tau^{-q_1})
$$
如果几乎为零：

> q1 没有贡献。

如果大幅下降：

> q1 是关键 search decision。

注意这里不能机械删除 q1 后保留原 q2，因为 q2 可能依赖 q1 的 observation；需要从删除后的 state 重新生成 continuation，才更接近合理反事实。

SkillRubricsRL 已经说明 counterfactual utility 对 Skill 本身很有意义，而 IGSD 相关工作也将 counterfactual credit assignment 列为 Search Agent 的重要路线。

### 候选机制：Functional / DAG Frontier PI

Teacher 不看 Gold Skill ID。

只看：

$$
PI_t =
\{\text{covered capabilities},
\text{missing frontier},
\text{dependency/conflict}\}
$$
然后 OPSD 给 Student。

这对应 AOPSD 的核心思想：

> PI 不是越多越好，而应该是 Student 当前可学的下一层信息。

如果实验有效，我认为这是最 Skill-specific 的机制。

### 候选机制：Need-Aware Search/Stop

把 LLM action space 扩成：

$$
a_t=
\begin{cases}
\text{Search}(q_t)\\
\text{Stop Search}\\
\text{Solve Directly}
\end{cases}
$$
PI 可以来自：

$$
U_{\text{with-skill}}-U_{\text{without-skill}}
$$
如果 Skill 反而使结果变差，那么 Teacher 应该教 Student：

> 不要继续搜 / 不要加载。

这是直接回应 SRA-Bench 和 Skill Following 的真实 empirical gap。

### 我会按照这个顺序试

**Vanilla OPSD → Execution Utility → Need-aware → Functional PI → Counterfactual Credit**
DAG 不是第一项。

DAG 应当在实验确认：

> **依赖 / specialization / conflict 真的是主要失败类别**

以后再加。

否则非常容易做成技术拼盘。

---

## 你现在最应该精读的论文：不是越多越好，而是每篇负责一个问题

我最后把阅读清单压缩成 **六篇核心 + 两篇选读**。

这里我同时考虑了你说的“最好是最近、大机构或正式好会、不要小作坊”，因此优先保留正式 ACL/EMNLP/ICML 论文，以及 Tsinghua/ByteDance、MIT 等明确有成熟研究背景的工作。

### 必读：SRA-Bench

**Skill Retrieval Augmentation for Agentic AI — EMNLP 2026 Findings**

清华大学 + ByteDance。官方项目明确列出单位。

**你不要主要看它怎么做 Retriever。**

重点看：

1. Introduction 怎么证明 Skill Retrieval Augmentation 是一个问题；
2. 为什么把它拆成 Retrieval / Incorporation / Application；
3. need-aware loading 的 failure analysis；
4. Retriever 提高以后，为什么 end-task 不一定跟着涨；
5. Benchmark 如何评价每一个 stage。

这是你理解：

> **“纯 Skill Retrieval 可能不够大，那真正的问题到底在哪里？”**

的第一篇论文。

### 必读：Graph-of-Skills

**Graph-of-Skills: Dependency-Aware Structural Retrieval for Massive Agent Skills — EMNLP 2026 Main**

这是我认为目前 Skill Retrieval 侧你最应该认真看的主会论文之一。

重点看：

1. 它为什么说 semantic retrieval 不够；
2. prerequisite gap 是怎么构造、怎么测；
3. dependency-pair co-recovery；
4. backward traversal 的 ablation；
5. 最终 reward 和 token cost 怎么一起报告。

你要学的不是它的 PageRank。

而是它是怎么证明：

> **“Skill is not merely a document.”**

这正好是 Edwin 哥最开始跟你说的 functional story。

### 必读：Skill Following

**Skill Following: Evaluating Actual Skill Use in Retrieval-Enabled LLM Agents — EMNLP 2026 Findings**

这篇机构没有前两篇那么“豪华”，但我仍然建议必须读，因为它提出的问题非常尖锐，而且是正式 EMNLP Findings。

重点只看两件事：

1. 为什么 aggregate retrieval lift 会骗人；
2. RAE 怎么通过 same-task counterfactual 比较，判断 Skill **实际上帮助还是伤害了 Agent**。

我认为这篇文章对你的价值甚至超过很多复杂 Skill Retrieval 算法。

因为它很可能提供你整篇论文最重要的一句话：

> **Retrieval relevance is not retrieval utility.**

### 必读：SkillRubricsRL

**SkillRubricsRL: Evolving Skill-Grounded Agents with Rubric-Guided Reinforcement Learning — EMNLP 2026 Findings**

重点看：

1. 为什么 trajectory reward 不能告诉模型每个 Skill 有什么贡献；
2. applicability-aware rubric；
3. fulfillment signal；
4. counterfactual utility；
5. 它怎么把 utility 用来改善 retrieval / skill-bank evolution。

它是你们 **Skill-specific credit assignment** 最重要的参考。

它不是 OPSD，但可能告诉你：

> OPSD Teacher 应该拿什么东西作为 PI。

### 必读：IGSD

**IGSD: Environment-Verified Hindsight Self-Distillation for Search Agents — 2026-09**

这篇就按照你之前的感觉理解：

**它就是 OPSD for Search / RAG 的非常近邻。**

重点精读：

1. teacher/student query candidate 怎么从同一个 Student State 产生；
2. 为什么 model confidence 不可靠；
3. executed paired information gain 怎么算；
4. 为什么只对 positive gain 做 distillation；
5. Ground-truth Answer 当 PI 为什么反而变差。

这篇不是拿来告诉你 Skill 有什么问题。

它是告诉你：

> **你的训练框架可以怎么搭。**

### 必读：AOPSD

**Learning from a Thoughtful Teacher: Adaptive On-Policy Self-Distillation for Mathematical Reasoning — 2026-09**

只看：

1. Teacher Utility vs Student Learnability；
2. PI leakage；
3. reasoning DAG；
4. affordable subgraph；
5. next frontier。

然后问自己：

> 数学里的 Reasoning Frontier 能不能对应 Skill 里的 Functional Frontier？

如果可以，你才加 DAG。

### 选读：ToolQP

**Beyond Single-Shot: Multi-step Tool Retrieval via Query Planning — ACL 2026 Findings，MIT**

MIT CSAIL 作者主页也列出了这篇工作。

你之前担心它训练了 lightweight planner，这个担心对。

所以我现在不建议你照它的 architecture。

**只看三件事：**

1. 它怎么把 single-shot retrieval 描述成问题；
2. iterative query planning 如何设计；
3. 如何证明 multi-step Query 比一次性 Query 更好。

换句话说：

> 学它“怎么研究 Query”，不要学它“再挂一个小模型”。

### 选读：Skill1

**Skill1: Unified Evolution of Skill-Augmented Agents via Reinforcement Learning — 2026-05**

这篇一定要知道，因为它是直接查新威胁。

它已经训练**一个统一 Policy**：

$$
Task
\rightarrow Query
\rightarrow Retrieve
\rightarrow Re-rank
\rightarrow Use Skill
\rightarrow Distill Skill
$$
所有阶段用同一个 task-outcome objective 联合进化。

所以你不能写：

> “以前都是训练 Retriever，没有人训练 LLM 自己具备 Skill Retrieval 能力。”

这句话已经不成立。

但 Skill1 同时训练 selection / reranking / utilization / distillation，而你们可以聚焦：

> **在 Retriever 完全冻结的环境下，利用 execution-grounded OPSD 学习 state-dependent skill search policy。**

这仍然是明显不同的研究边界。

### 阅读顺序我建议就这样

**第一轮，只读问题：**

SRA-Bench → Skill Following → Graph-of-Skills

读完你应该回答：

> **Skill Retrieval 真正难在哪里？**

**第二轮，只读方法：**

IGSD → AOPSD → SkillRubricsRL

读完你应该回答：

> **为什么恰好值得用 OPSD？Teacher 应该多知道什么？又不能知道什么？**

**最后查竞争：**

Skill1 → ToolQP

读完回答：

> **别人已经做到哪里，我们还有什么不能被一句“方法迁移”打掉的东西？**

---

## 最终判断：我现在会怎么和你师兄重新描述这个项目

我不会再跟他说：

> “我想做 OPSD for Skill Retrieval，把 Multi-Hop RAG 搬过来刷你们的榜。”

这句话确实容易让人觉得不是 Hard Problem。

我会说：

> **最近 Skill Retrieval 的研究已经出现一个很明显的变化：单纯 relevance retrieval 未必是最核心的问题。SkillSeek 甚至显示标准 IR 在大规模 Skill 库上可以非常有竞争力；但 SRA-Bench、Skill Following、Graph-of-Skills、SkillRubricsRL 同时表明，Agent 仍然不知道什么时候需要 Skill、找到的 Skill 是否真正有用、多个 Skill 是否满足依赖/兼容关系，以及长轨迹中到底哪次检索真正贡献了最终任务成功。**
>
> **所以我想把你们已有 Retriever 完全 freeze，研究的不是 retriever model，而是让通用 Agent LLM 本身学会 execution-grounded skill search。训练时我们恰好有大量 inference 时不可见的 hindsight：哪些 Skill 真被执行、哪些有增量 utility、缺了什么 prerequisite、哪一步 Query 是冗余的。这些本身就是非常自然的 privileged information，因此比普通 RL 更适合 OPSD。**
>
> **最基础版本可以沿 SD-Search/IGSD 做 query-level self-distillation，但 Skill 特有的部分应该从 document information gain 升级到 functional/execution utility；如果 dependency 确实是主要 bottleneck，再借 AOPSD 的思路把 Skill relation DAG 只作为 teacher training-time frontier PI，而不是改 Retriever。**

我认为这个版本，已经明显比：

> “Skill Retrieval 很难，所以我们 OPSD 一下。”

强得多。

而且它和 Edwin 哥最早给你的分工没有冲突：**他的 Benchmark/Ranker 负责告诉系统“给定 Query 后如何找 Skill”；你的工作负责让 Agent 学会“什么时候搜、应该搜什么、搜到以后还缺什么、什么时候停止”。**

更重要的是，它也正面回应了你另一个师兄昨天的批评：

> **纯 Skill Retrieval 也许不够 Hard。**

那就不要把“Retrieval”本身当终点。

把它重新定义成：

**Execution-Grounded Skill Search Policy Learning**
也就是：

> **Agent 怎样从一个固定的外部能力库中，学习发现真正有用的能力。**

这是我目前调研后认为最有希望既保留你们现成 Benchmark 和 Retriever 资产、又能真正讲出一个 AI/Agent + OPSD 故事的方向。

而在真正投入八卡训练之前，最关键的实验甚至不是 OPSD：先拿 Edwin 哥的数据做一个 **Relevance–Utility Gap Diagnostic**——分别统计“Gold Skill 被召回”“Skill 被实际使用”“使用 Skill 后任务是否变好”“Multi-Skill 是否完整/兼容”。如果这四个指标之间存在明显断层，你们就拿到了这篇论文最有价值的第一张图；反过来，如果 Gold Recall 一高，任务成功就同步接近饱和，那么这个数据集更适合刷 Skill Retrieval 榜，而不一定足以支撑上面这条更大的 Hard-Agent 故事。