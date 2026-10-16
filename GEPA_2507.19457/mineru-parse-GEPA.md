<!-- page 1 of 96 -->

Accepted at ICLR 2026 (Oral).

[arXiv:2507.19457v2 \[cs.CL\] 14 Feb 2026](https://arxiv.org/abs/2507.19457v2)

GEPA: REFLECTIVE PROMPT EVOLUTION CAN OUTPER-FORM REINFORCEMENT LEARNING

## Lakshya A Agrawal<sup>1</sup>, Shangyin Tan<sup>1</sup>, Dilara Soylu<sup>2</sup>, Noah Ziems<sup>4</sup>, Rishi Khare<sup>1</sup>, Krista Opsahl-Ong<sup>5</sup>, Arnav Singhvi<sup>2,5</sup>, Herumb Shandilya<sup>2</sup>, Michael J Ryan<sup>2</sup>, Meng Jiang<sup>4</sup>, Christopher Potts<sup>2</sup>, Koushik Sen<sup>1</sup>, Alexandros G. Dimakis<sup>1,3</sup>, Ion Stoica<sup>1</sup>, Dan Klein<sup>1</sup>, Matei Zaharia<sup>1,5</sup>, Omar Khattab<sup>6</sup>

<sup>1</sup>UC Berkeley <sup>2</sup>Stanford <sup>3</sup>BespokeLabs.ai <sup>4</sup>Notre Dame <sup>5</sup>Databricks <sup>6</sup>MIT

## ABSTRACT

Large language models (LLMs) are increasingly adapted to downstream tasks via reinforcement learning (RL) methods like Group Relative Policy Optimization (GRPO), which often require thousands of rollouts to learn new tasks. We argue that the interpretable nature of language often provides a much richer learning medium for LLMs, compared to policy gradients derived from sparse, scalar rewards. To test this, we introduce GEPA (**Ge**netic-**Pa**reto), a prompt optimizer that thoroughly incorporates natural language reflection to learn high-level rules from trial and error. Given any AI system containing one or more LLM prompts, GEPA samples trajectories (e.g., reasoning, tool calls, and tool outputs) and reflects on them in natural language to diagnose problems, propose and test prompt updates, and combine complementary lessons from the Pareto frontier of its own attempts. As a result of GEPA’s design, it can often turn even just a few rollouts into a large quality gain. Across six tasks, GEPA outperforms GRPO by 6% on average and by up to 20%, while using up to 35x fewer rollouts. GEPA also outperforms the leading prompt optimizer, MIPROv2, by over 10% (e.g., +12% accuracy on AIME-2025), and demonstrates promising results as an inference-time search strategy for code optimization. We release our code at [https://github.com/gepa-ai/gepa](https://github.com/gepa-ai/gepa).

![Image block](doc:ab3a513/tier:flash/page:1/block:8)

<details>
<summary>image content</summary>

IFBench, Qwen3 8B
HotpotQA, Qwen3 8B
62.5
Optimization Method
Optimization Method
38.5
Baseline
Baseline
80
60.0
MIPROv2
MIPROv2
GRPO
GRPO
38.0
57.5
GEPA
GEPA
75
Testset Score
Validation Performance
Validation Performance
55.0
37.5
Test-set Performance
Test-set Performance
Score
Score
70
52.5
37.0
50.0
65
47.5
36.5
60
45.0
36.0
42.5
0      5000    10000   15000   20000   25000
0      5000    10000   15000   20000   25000
Number of Rollouts
Number of Rollouts
(b) IFBench, Qwen3 8B
(a) HotpotQA, Qwen3 8B
</details>

Figure 1: A comparison of learning behavior of the GEPA prompt optimizer against a state-of-the-art prompt optimizer (MIPROv2) and GRPO (24,000 rollouts). As more rollouts are sampled, the prompt optimizers can learn much more quickly than GRPO. GEPA substantially outperforms both GRPO and MIPROv2 in final score. The Test-set star markers demonstrate the performance gap in a held-out set of questions.

1

<!-- page 2 of 96 -->

Accepted at ICLR 2026 (Oral).

## 1 INTRODUCTION

Large language models (LLMs) have enabled development of agents and systems that combine fuzzy natural-language specifications with tools like retrieval and code execution. This raises the question of how LLMs should be optimized for downstream performance. One popular approach is Reinforcement Learning with Verifiable Rewards (RLVR), e.g. with Group Relative Policy Optimization (GRPO) (Shao et al., 2024), which treats success metrics as end-of-rollout scalar rewards used to estimate policy gradients (Lambert, 2025). While these RL approaches are effective, they typically require tens of thousands of rollouts in practice to fit new tasks. For example, recent works leveraging GRPO typically use up to hundreds of thousands of rollouts for training (Chen et al., 2025b; Wu et al., 2025b; Zhang et al., 2025; Jin et al., 2025; Si et al., 2025; Wang et al., 2025a; Chen et al., 2025a; Sha et al., 2025; Lin et al., 2025a; Peng et al., 2025; Song et al., 2025). This sample inefficiency can quickly become a serious bottleneck: many downstream LLM applications invoke expensive tool calls, have limited inference budget for sampling from the LLM itself, or simply cannot finetune the weights of the largest or best-performing LLMs.

We observe that rollouts sampled from even highly sophisticated LLM systems can be serialized into traces of natural language: they contain nothing but the instructions of each LLM module, the resulting LLM reasoning chains, tool calls, and potentially the internal workings of the reward function (e.g., compiler error messages, before they are collapsed into scalar rewards). Because such serialized trajectories are readily understood by modern LLMs, we argue that algorithms that learn deliberately in natural language by reflecting on these trajectories can make more effective use of the strong language priors that LLMs have, compared with standard RL approaches.

We introduce GEPA (Genetic-Pareto), a reflective prompt optimizer for compound AI systems that merges textual reflection with multi-objective evolutionary search. GEPA iteratively mutates prompts using natural language feedback drawn from new rollouts. In each mutation, the candidate prompt is derived from an ancestor, accumulating high-level lessons derived from observations and LLM feedback. To avoid local optima that afflict greedy prompt optimization, GEPA maintains a Pareto front: instead of evolving only the global best prompt, it stochastically explores the top-performing prompts for each problem instance. This diversification enables robust generalization and mitigates getting stuck in local minima.

We evaluate GEPA across multi-hop reasoning (HotpotQA; Yang et al. 2018), Math (AIME, LiveBench-Math; Balunovic et al. (2025); White et al. (2025)), instruction following (IFBench; Pyatkin et al. 2025b), ´ privacy-aware delegation (PUPA; Li et al. 2025a), and retrieval-augmented verification (HoVer; Jiang et al. 2020), using both open (Qwen3 8B; Yang et al. 2025; Team 2025) and proprietary (GPT-4.1 Mini; OpenAI 2025) models. We find that GEPA generalizes well and is highly sample-efficient: on Qwen3 8B, it outperforms GRPO (24k rollouts) by up to 20% while using up to 35× fewer rollouts, with an average gain of +6% across six tasks. GEPA also surpasses the prior state-of-the-art, MIPROv2 (Opsahl-Ong et al., 2024), on all benchmarks and models, achieving +13% aggregate gains, over double MIPROv2’s +5.6%.

Qualitatively, GEPA-learned prompts are quite rich. Figure 2 shows excerpts from a prompt crafted for the query-creation module of a multi-hop question answering system used in HotpotQA, and Figure 5 shows that even a single reflective update often yields large gains. These results highlight that reflective prompt evolution with language feedback enables improved sample efficiency and robust generalization, offering a practical approach to optimizing complex AI workflows in data- or budget-constrained environments. We also demonstrate GEPA as an inference-time search strategy for code optimization on NPUEval (Kalade & Schelle, 2025) & KernelBench (Ouyang et al., 2025) in Sec 5.1, and for adversarial prompt search in Sec 5.2.

## 2 PROBLEM STATEMENT

We follow related work in defining a **compound AI system** as any modular system composed of one or more language model (LLM) invocations, potentially interleaved with external tool calls, orchestrated through ar-

2

<!-- page 3 of 96 -->

Accepted at ICLR 2026 (Oral).

![Image block](doc:ab3a513/tier:flash/page:3/block:2)

<details>
<summary>image content</summary>

Seed Prompt for Second-Hop of Multi-Hop QA System
Given the fields question, summary_1, produce the fields query.
GEPA’s Optimized Prompt for Second-Hop of Multi-Hop QA System, GPT-4.1 Mini
You will be given two input fields: question and summary_1. Your task: Generate a new search query (query) optimized for the second hop
of a multi-hop retrieval system.
• The original user question is typically complex and requires information from multiple documents to answer.
• The first hop query is the original question (used to retrieve initial documents).
• Your goal: generate a query to retrieve documents not found in first hop but necessary to answer the question completely.
Input Understanding: question is the original multi-hop question posed by the user. summary_1 is a concise summary of information from a
document retrieved in the first hop, which partially addresses the question.
Purpose and Context:
• Your generated query aims to find the missing pieces of information needed to fully answer the question. . . .
• The query must retrieve relevant documents NOT found in first hop . . . for final answer extraction.
Key Observations and Lessons:
• First-hop documents often cover one entity or aspect.
• Remaining relevant documents often involve connected or higher-level concepts mentioned in summary_1 but not explicitly asked in the
original question. The query should target these missing, but logically linked, documents.
• Avoid merely paraphrasing the original question or restating known facts from summary_1.
• Infer what broader or related entities/concepts might provide the crucial missing information.
• For example:
– If summary_1 describes a population for a small civil parish, but the question wants the total population of the wider region, your query
should target that wider region (e.g., “Madeira archipelago population in 2011”).
– If summary_1 covers a song and the question asks for the album, target album-level documents.
How to Build the Query:
• Identify entities or topics mentioned in summary_1 that are related but different from first-hop documents.
• Reframe the query to explicitly mention these broader or related entities connected to the original question.
• Include relevant key context from the question to maintain specificity, but shift focus to the missing piece.
• The goal is to retrieve documents that link or complement what was retrieved initially.
Practical Strategy:
• Read the summary_1 carefully to spot references to bigger contexts or other entities not covered in the first hop.
• Ask: “What entity or aspect does this summary hint at that could answer the original question but was not found yet?”
• Formulate a precise, focused factual query targeting that entity or concept to retrieve the missing documents.
Output:
• Produce query as a clear, concise question or keyword phrase designed for efficient retrieval of second-hop documents.
• Ensure the query relates logically to the original question while targeting the broader or complementary knowledge identified in summary_1.
. . . Do not include the original question or simply rephrase it. Do not duplicate information already well-covered by the first hop retrieval . . .
</details>

Figure 2: This figure shows an example prompt generated by GEPA for the second-hop document retrieval to be performed in a multi-hop question-answer system, along with the seed prompt it started with. Appendix L compares GEPA’s prompts for all tasks with prompts generated by MIPROv2.

bitrary control flow. This definition subsumes a broad class of real-world LLM-based AI systems, including agents, multi-agent systems, and general-purpose scaffolding techniques like ReAct (Yao et al., 2023), Ar-

3

<!-- page 4 of 96 -->

Accepted at ICLR 2026 (Oral).

chon (Saad-Falcon et al., 2025), etc. Following Soylu et al. (2024); Khattab et al. (2024); Opsahl-Ong et al. (2024); Tan et al. (2025), we formalize such a system as Φ = (M, C, X ,Y), where M = ⟨M<sub>1</sub>, . . . , M|M|⟩ denotes language modules, C specifies control flow logic, and X , Y are global input/output schemas. Each module M<sub>i</sub> = (π<sub>i</sub>, θ<sub>i</sub>, X<sub>i</sub>, Y<sub>i</sub>) is an LLM subcomponent: π<sub>i</sub> is its (system) prompt including instructions and few-shot demonstrations; θ<sub>i</sub> the underlying model weights; X<sub>i</sub>, Y<sub>i</sub> are input/output schemas. At runtime, C orchestrates the sequencing and invocation of modules—e.g., passing outputs from one module to another, invoking modules conditionally, or leveraging tool APIs. This way, C can invoke different modules in any order multiples of times.

Given Φ, let Π<sub>Φ</sub> = ⟨π<sub>1</sub>, . . . , <sup>π</sup>|M|⟩ denote the collection of all module prompts and Θ<sub>Φ</sub> = ⟨θ<sub>1</sub>, . . . , θ|M|⟩ the set of module weights. The learnable parameters are thus ⟨Π, Θ⟩<sub>Φ</sub>. For a task instance (x, m)—where x maps to the input schema X and m contains evaluator metadata (e.g., gold answers, evaluation rubrics, code unit tests)—the system induces an output y = Φ(x;⟨Π, Θ⟩<sub>Φ</sub>). A metric µ : Y × M → [0, 1] then measures the output quality of y with respect to metadata m (for example by calculating, exact match, F1, pass rate, etc.). The optimization problem is thus defined as follows, where T is a task distribution.:

![Formula block](doc:ab3a513/tier:flash/page:4/block:4)

We adopt this general problem formulation, allowing updates to both prompts and weights of language modules, to enable comparisons between optimization algorithms that operate in different parameter spaces (e.g., GEPA vs. GRPO).

**Sample-Efficient Optimization.** In many real-world scenarios, rollouts—concretely, invocations of Φ plus evaluation by µ—are often computationally, monetarily, or timewise expensive. The optimizer is thus limited to at most B rollouts on a dataset D<sub>train</sub> = {(x, m)i}N i=1 with full access to µ. The goal is to identify parameters ⟨Π∗, Θ∗⟩<sub>Φ</sub> that maximize held-out performance, subject to not exceeding the rollout budget B:

![Formula block](doc:ab3a513/tier:flash/page:4/block:7)

The core challenge, then, is: How do we extract maximal learning signal from every expensive rollout to enable effective adaptation of complex, modular AI systems in low-data or budget-constrained settings?

3 GEPA: REFLECTIVE PROMPT EVOLUTION

We introduce GEPA (Genetic-Pareto), a sample-efficient optimizer for compound AI systems motivated by three core principles: genetic prompt evolution (Section 3), reflection using natural language feedback (Section 3), and Pareto-based candidate selection (Section 3.1). Figure 3 gives an overview of GEPA and the full GEPA algorithm is formalized in Figure 4. GEPA receives the following inputs: A system Φ instantiated with simple prompts to be optimized, training dataset D<sub>train</sub> (consisting of task instances (x, m) as described in Section 2), the standard evaluation metric µ for the task, a feedback function µf (introduced in Section 3) and the total rollout budget B. Note that GEPA evolves only the set of prompts, denoted as Π<sub>Φ</sub>, whereas the underlying LLM weights, denoted by Θ<sub>Φ</sub> remains fixed.

**Genetic Optimization Loop:** Given an AI system Φ, the goal is to identify parameters Π<sub>Φ</sub> that maximize task performance. GEPA begins with a candidate pool P containing only the base system, where each candidate is a concrete instantiation of ⟨Π, Θ<sub>f</sub> rozen⟩Φ. It then enters an optimization loop, repeatedly proposing new candidates until the evaluation budget is exhausted. Candidates are derived from existing ones via reflective mutation or crossover, guided by feedback from rollouts, with each inheriting learning signals from its parents and its own rollout so that GEPA accumulates knowledge along the genetic tree. In each iteration, GEPA (i) selects promising candidates, (ii) proposes and evaluates a variant on a minibatch of tasks, and

4

<!-- page 5 of 96 -->

Accepted at ICLR 2026 (Oral).

![Image block](doc:ab3a513/tier:flash/page:5/block:2)

<details>
<summary>image content</summary>

Initialize
Perform
No        Performance
Discard Pnew
Pnew
Minibatch
improved?
Eval
While Budget > 0
Eval on all tasks
+
Yes
Propose New Candidate
Add Pnew to Pool
Reflective Prompt
System Aware
Mutation
Merge
Strategically select
Reflect and
prompt for each
Propose New
module, either
Prompt
Candidate Pool P
from P2
or P3
.
Obtain text
P0
If a module has
feedbacks using μf
evolved in P2
but
iii
not in P3
, select
P1        P2
Rollouts:
from P2 and vice-
Dtrain
Execute P2
on M
versa.
Sample
P3        P4
P2
P3       P2
Minibatch
Best candidate
M
Filtered Pool (Pareto Frontier)
per task
TPitle 13       Title 2        Title 3
P1     P4       Title 1        Title 2P2
P0
P0
Sample 1 candidate
Sample 2 candidates
P3
Task 1
for mutation
to merge
Assets
Assets
P1        P2
Task 2
P1     P2
P3        P4
P2
Choose Strategy to create new candidate
Task 3
Scores Matrix
...
Pareto-based Candidate Filtering
</details>

Figure 3: GEPA proposes a new candidate in every iteration by improving existing candidates using one of the two strategies (Reflective Prompt Mutation (Section 3) or System Aware Merge (Appendix D.1)), first evaluating them on a minibatch, and if improved, evaluating on a larger dataset. Instead of selecting the best performing candidate to mutate always, which can lead to a local-optimum, GEPA introduces Paretobased candidate sampling (Section 3.1), which filters and samples from the list of best candidates per task, ensuring sufficient diversity. Overall, these design decisions allow GEPA to be highly sample-efficient while demonstrating strong generalization.

(iii) if it outperforms its parent(s), adds it to P with ancestry records and evaluate on D<sub>pareto</sub>, the validation set used for selection. After the budget is exhausted, GEPA returns the candidate with the best aggregate performance on D<sub>pareto</sub>.

**Reflective Prompt Mutation:** Natural language traces generated during the execution of a compound AI system offer rich visibility into the behavior and responsibilities of each module, as they capture the intermediate inferences and underlying reasoning steps. When these traces are paired with the final outcome of the system (e.g., success or failure), they provide substantial diagnostic value, allowing practitioners to trace errors or successes back to specific decisions made at the module level. LLMs can leverage these traces via reflection to perform implicit credit assignment, attributing responsibility for the final outcome to the relevant modules. This process of reflection can then be used to make targeted updates to individual modules, making large and effective updates to the whole system’s behavior.

Given a candidate to mutate in the current iteration of the optimization loop (stochastically selected from the Pareto-frontier, see Section 3.1 below), GEPA executes the selected candidate on a stochastically sampled minibatch of input queries from the trainset, tracing the program’s execution. From the execution traces, GEPA extracts the module’s inputs, outputs, and reasoning, and calls the feedback function µf , which returns a numeric score and text feedback including details about the evaluation (like compiler error messages, failed rubrics, etc.). GEPA selects the module (among the |M| modules that the language program contains) to be updated based on a policy (round-robin), and a reflection LM is then shown the (current prompt, language program trajectory, score, feedback) with the task to reflectively attribute successes or failures to prompt

5

<!-- page 6 of 96 -->

Accepted at ICLR 2026 (Oral).

Algorithm 1 GEPA: Reflective Evolutionary Prompt Optimizer

```txt
Require: Inputs: System Φ, dataset Dtrain, eval metric µ, feed-
    back function µf , budget B
Require: Hyperparams: minibatch size b, Pareto set size npareto
 1: Split Dtrain into Dfeedback, Dpareto, s.t. |Dpareto| = npareto
 2: Initialize candidates P ← [Φ], parents A ← [None]
 3: for each (xi, mi) in Dpareto do
 4:     SΦ[i] ← µ(Φ(xi), mi)
 5: end for
 6: while budget B not exhausted do
 7:     k ← SELECTCANDIDATE(P, S)
 8:     j ← SELECTMODULE(Φk)
 9:     M ← minibatch of size b from Dfeedback
10:     Gather feedback, scores, traces for Φk[j] on M using µf
11:     π'j ← UPDATEPROMPT(πj , feedbacks, traces[j])
12:     Φ' ← Copy of Φk w/ module j updated by π'j
13:     σ, σ' ← avg score on M (before, after)
14:     if σ'improved then
15:        Add Φ'to P; Add k to A
16:        for each (xi, mi) in Dpareto do
17:            SΦ' [i] ← µ(Φ'(xi), mi)
18:        end for
19:     end if
20: end while
21: return Φ∗ maximizing average score on Dpareto
```

**Algorithm 2** Pareto-based candidate selection

1: **function** SELECTCANDIDATE(P, S) 2: // Build instance-wise Pareto sets

```txt
3:     for each i do
 4:        s∗[i] ← maxk SP[k][i]
 5:        P∗[i] ← {P[k] : SP[k][i] = s∗[i]}
 6:     end for
 7:     C ← unique candidates in Si P∗[i]
 8:     D ← ∅
 9:     while there exists Φ ∈ C \ D dominated by
    another in C \ D do
10:        D ← D ∪ {Φ}
11:     end while
12:     Remove D from each P∗[i] to get Pˆ∗[i]
13:     Let f[Φ] = number of i for which Φ ∈
    Pˆ∗[i]
14:     Sample Φk from Cˆwith probability ∝ f[Φk]
15:     return index k of Φk in P
16: end function
```

Figure 4: (**Left**) GEPA’s core algorithm for reflective prompt evolution. GEPA works iteratively, in each iteration, selecting some of the current candidates to evolve (line 7), executing the identified candidate on a minibatch of rollouts, while utilizing a special feedback function µf to gather module specific feedback when available (lines 9-10, described in detail in Section 3), using an LLM to reflectively update the prompt (line 11), and evaluating whether the system instantiated with the new prompt improved the performance on the minibatch (line 14). If improved, GEPA then proceeds to evaluate the new system candidate on the full D<sub>pareto</sub> set, adding it to the list of candidates tracked and marking the new system’s parent. (**Right**) The SelectCandidate subprocedure used by GEPA’s core algorithm is tasked with identifying the best candidate to evolve in the next optimization iteration. GEPA’s chief candidate selection strategy is to find non-dominated candidates in the Pareto frontier (of all task instances), and stochastically select one of them based on their appearance frequency in the Pareto front.

elements and propose revised instructions. The updated module, with the rest of the language program, is evaluated again on the minibatch, and if the score improves, then the new program is added to the candidate pool. The meta-prompt for reflective prompt updates is shown in Appendix C and the full algorithm is presented in Algorithm 1.

**Evaluation traces as diagnostic signals:** The text that LLMs produce is the execution trace of the AI system. The text that the environment produces to compute the reward (e.g. compiler error messages before giving reward 0) is the evaluation trace. Beyond reflection on execution traces, we identify a second valuable source of diagnostic information in the evaluation traces. Many evaluation metrics apply rich strategies (e.g., code evaluation may involve compilation, execution, and profiling), producing natural language traces before computing a scalar reward. We propose leveraging these evaluation traces for reflective credit assignment and targeted prompt updates. GEPA achieves this by extending rewards µ into a feedback function µf that

6

<!-- page 7 of 96 -->

Accepted at ICLR 2026 (Oral).

extracts textual traces during evaluation and returns them with the final score as feedback\_text. When available, such feedback can even be module-specific (e.g. in multi-hop systems the evaluator may provide feedback after each hop). In practice, there are domains where human-graders are able to rate the AI system’s responses, along with providing detailed feedback justifying their scalar ratings. When available, D<sub>train</sub> can be augmented with such human-written explanations for each instance; during reflection, and GEPA can consume these explanations as auxiliary feedback\_text to guide targeted prompt updates, even when natural-language feedback from rollouts is limited or unavailable.

![Image block](doc:ab3a513/tier:flash/page:7/block:3)

<details>
<summary>image content</summary>

Base Instruction.
0
Given a private user query, create a privacy-preserving request for a powerful
(82.26)
external LLM. The LLM may assist without learning private information about the user.
Expanded Privacy Strategies & Task Understanding
Adds detailed guidance on identifying and generalizing PII.
3
1
2
Stresses analyzing query intent and introduces
(90.99)
(87.76)
(85.74)
reasoning explanations for reformulation.
Structured Output & Domain Best-Practices
Formalizes split into Reasoning and Request.
6
4
Explicitly bans names/codes, describes abstraction & example use,
(94.44)
(91.7)
requires detailed privacy justi
fication and balance with task quality.
Detailed, Transparent Transformation Rationale
Enforces transparent privacy reasoning and careful abstraction.
7
8
9
5
Details location/name/general info removal, professional scenarios,
(94.67)
(91.85)
(90.02)
(93.83)
and
fictional character handling—always paired with an explanatory rationale.
Rigorous, Exhaustive Protocol
Strict, stepwise PII & proprietary info abstraction; bans partial redaction.
10
15
11
Full best-practices: always justify approach,
(97.6)
(93.67)
(94.33)
maximize utility while ensuring auditable privacy—zero leakage tolerated.
</details>

Figure 5: GEPA’s reflective prompt mutation systematically incorporates task-specific nuances, leading to substantial improvements in performance. This figure visualizes the optimization trajectory taken by GEPA, presenting an annotated subtree from Figure 25d (for the privacy-preserving delegation task PUPA) to demonstrate the iterative enhancements made to the prompts. The progression from the base prompt (candidate 0) to the best performing prompt (candidate 11) is highlighted with red arrows, and key prompt changes at each step are annotated beside the corresponding nodes. Full-length instructions for these iterations are provided in Appendix K.1. Each prompt refinement in this trajectory adds targeted nuances informed by ongoing optimization, illustrating how GEPA’s process accumulates lessons to continually boost task performance.

## 3.1 PARETO-BASED CANDIDATE SELECTION

GEPA is a highly modular algorithm that supports various strategies for candidate selection, with the choice of strategy governing the exploration–exploitation tradeoff. A naive approach is to always select the bestperforming candidate, but this often traps the optimizer in a local optimum: once a dominant strategy is found, it becomes difficult to surpass, and the optimizer exhausts its budget without learning new, potentially better strategies. Figure 6a illustrates this behavior: after finding one new strategy (the first child node), the search repeatedly attempts to refine it, fails to improve, and ultimately depletes the budget.

To address this, GEPA employs a Pareto-based “illumination" strategy (Mouret & Clune, 2015), shown in Algorithm 2. For each training instance, GEPA records the highest score across all candidates, forming a Pareto frontier. Candidates that achieve the best score on at least one task are retained, while strictly dominated ones are pruned. From this pruned set, GEPA stochastically samples a candidate, weighting

7

<!-- page 8 of 96 -->

Accepted at ICLR 2026 (Oral).

probabilities by how many tasks each candidate leads. This strategy helps GEPA escape local optima without inflating the search, efficiently balancing exploration and exploitation by focusing resources on candidates that embody “winning” strategies within the optimization budget.

4 EVALUATION

Table 1: Benchmark results for different optimizers with Qwen3 8B. GEPA and GEPA+Merge achieve better performance than GRPO with far fewer rollouts on all benchmarks except AIME. For example, for IFBench, GEPA found optimal prompts after just 678 rollouts achieving 38.61%, outperforming GRPO’s test set score of 35.88% with 24,000 rollouts.

```
Qwen3 8B          HotpotQA IFBench       Hover    PUPA AIME-2025 LiveBench-Math Aggregate              Improvement
Baseline            42.33       36.90     35.33   80.82      27.33            48.70          45.23          -
GRPO                43.33       35.88     38.67   86.66      38.00            51.26          48.91         +3.68
MIPROv2             55.33       36.22     47.33   81.55      20.00            46.60          47.84         +2.61
GEPA                62.33       38.61     52.33   91.85      32.00            51.95          54.85         +9.62
GEPA+Merge          64.33       28.23     51.67   86.26      32.00            51.95          52.40         +7.17
Total optimization budget (# rollouts)
GEPA (+Merge)       6871        3593      7051    2426       1839             1839           3936           -
GRPO                24000       24000    24000    24000      24000           24000           24000          -
```

Table 2: Benchmark results for different optimizers evaluated on GPT-4.1 Mini. As a prompt-optimization system, GEPA works off-the-shelf on closed-source models as well, outperforming state-of-the-art prompt optimizers including MIPROv2 (in 2 settings: Instruction-only optimization (“MIPROv2-No-Demos”) as well as joint instruction and few-shot optimization (“MIPROv2”)), Trace (with its OptoPrime optimizer), and TextGrad. Additionally, GEPA-optimized prompts demonstrate strong cross-model generalization: “GEPA-Qwen-Opt”—optimized entirely for (and using) the weaker Qwen3-8B—achieves a +9% gain when evaluated on GPT-4.1-Mini without modification, notably outperforming all baselines (MIPROv2, TextGrad, Trace) that optimized directly for (and using) GPT-4.1-Mini.

| GPT-4.1 Mini | HotpotQA | IFBench | Hover | PUPA | AIME-2025 | LiveBench-Math | Aggregate | Improvement |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Baseline | 38.00 | 47.79 | 46.33 | 78.57 | 49.33 | 58.20 | 53.03 | - |
| Trace (OptoPrime) | 60.33 | 51.19 | 46.00 | 74.18 | 45.33 | 60.74 | 56.30 | +3.27 |
| MIPROv2-No-Demos | 38.00 | 52.04 | 51.33 | 91.85 | 48.67 | 60.97 | 57.14 | +4.11 |
| MIPROv2 | 58.00 | 49.15 | 48.33 | 83.37 | 51.33 | 61.84 | 58.67 | +5.64 |
| TextGrad | 62.33 | 48.64 | 47.67 | 85.68 | 46.67 | 63.84 | 59.14 | +6.11 |
| GEPA | 69.00 | 52.72 | 51.67 | 94.47 | 59.33 | 64.13 | 65.22 | +12.19 |
| GEPA+Merge | 65.67 | 55.95 | 56.67 | 96.46 | 59.33 | 64.13 | 66.36 | +13.33 |

## Optimized with Qwen3-8B, evaluated on GPT-4.1-Mini

## 65.67 49.83

## 54.67 90.05

## 52.67

## 59.31

## 62.03

## +9.00

We adopt a standard train/validation/test split. Optimizers have full access to the train split, including text and labels, for program tuning. Although optimizers may monitor the performance of candidate parameters (like model checkpoints) by tracking scores on the validation set (to implement early stopping, for example), direct access to the content of validation instances is restricted. We evaluate on six benchmarks—AIME-2025 (Balunovic et al., 2025), LiveBench-Math (White et al., 2025), HotpotQA (Yang et al., 2018), IF-´ Bench (Pyatkin et al., 2025b), HoVer (Jiang et al., 2020), and PUPA (Li et al., 2025a)—each paired with existing compound AI systems and feedback functions. Experiments use Qwen3 8B (Yang et al., 2025) and GPT-4.1 Mini (OpenAI, 2025) with standardized inference settings, and compare against state-of-the-art optimizers MIPROv2 (Opsahl-Ong et al., 2024), Trace (with its OptoPrime optimizer) (Cheng et al., 2024),

<small><span class="docvortex-page-footnote" data-block-type="page_footnote" style="color:#6b7280">GEPA-Qwen-Opt</span></small>

8

<!-- page 9 of 96 -->

Accepted at ICLR 2026 (Oral).

TextGrad (Yuksekgonul et al., 2025), and GRPO<sup>1</sup> (Shao et al., 2024). Appendix E provides further details on benchmarks, systems, and feedback functions (Subsection E.1); models and inference settings (Subsection E.2); monetary cost to run the experiments (Subsection E.3); and optimizer configurations (Subsection E.4). Table 1, Table 2 and Figure 10 summarize our main results, from which we derive the following observations:

**Observation 1: Reflective Prompt Evolution is highly sample-efficient and can outperform weightspace reinforcement learning:** Across four benchmarks, GEPA adapts rapidly and generalizes robustly in compound AI systems—beating GRPO (24,000 rollouts) by up to 19% while using up to 35× fewer rollouts. It reaches optimal test performance with 4–35× fewer rollouts and exceeds GRPO on 5 out of 6 tasks by 19.0%, 2.73%, 13.66%, 5.19% and 0.7%. GEPA matches GRPO’s best validation after only 243, 402, 330, 1143, 1179, and 306 rollouts—up to 78× greater sample efficiency. GEPA+Merge widens the gap, outperforming GRPO by 21% at a comparable rollout budget to GEPA.

The majority of GEPA’s rollout budget is spent on validation, where scores are utilized solely for candidate selection and not for producing learning signals. If we restrict the analysis to train set rollouts, GEPA requires only 79 to 737 rollouts to reach optimal performance. To match GRPO’s best validation scores, GEPA achieves this with only 102, 32, 6, and 179 train rollouts for four tasks, respectively, underscoring the high sample efficiency of learning based on reflective prompt evolution.

Since tracking candidates’ validation performance accounts for majority of GEPA’s rollout budget, sample efficiency can be further improved by evaluating on a smaller validation set or by tracking scores on dynamically selected validation subsets instead of the full set—both of which we propose as directions for future work. Figures 1a, 1b, 14c and 15c show the full performance-vs-rollouts curve for all optimizers over benchmarks HotpotQA, IFBench, HoVer and PUPA, respectively.

**Observation 2: Reflective prompt evolution enables instruction-optimization alone to outperform joint instruction and few-shot optimization:** We compare GEPA with MIPROv2, a state-of-the-art instruction and few-shot optimizer, using two leading models across six diverse tasks, and observe that GEPA consistently outperforms MIPROv2 in all settings, achieving margins as high as 11.1% for GPT-4.1 mini and 10.3% for Qwen3 8B. Further, GEPA and GEPA+Merge more than double the aggregate gains over baseline seen with MIPROv2 across all benchmarks and models (+13.33% and +12.19% vs +5.64% for MIPROv2).

While prior works such as Opsahl-Ong et al. (2024) and Wan et al. (2024) have provided compelling evidence for the effectiveness of few-shot example optimization—often outperforming instruction-based approaches—our findings suggest an exciting shift in this trend. We attribute this primarily to recent advances in the instruction-following and self-reflective abilities of LLMs, as well as the design choices in GEPA that capitalize on these improved capabilities. To further contextualize our findings, we redo the study on generalization gap (the difference between validation and test set performance for optimized prompts) as proposed by Wan et al. (2024). The results presented in Figure 16 reinforce these observations: reflectively evolved instructions now demonstrate a lower generalization gap, underscoring both advancements in model capabilities and the benefits of GEPA’s design. We see this as a reflection of the continuous evolution of LLMs and GEPA’s ability to effectively leverage these improvements.

We provide the full-length optimized prompts produced by GEPA for all systems, benchmarks, and models in Appendix L, alongside MIPROv2 prompts. Notably, in contrast to prior findings where instruction optimization yielded improvements primarily through quasi-exemplars (Wan et al., 2024), GEPA’s prompts frequently contain detailed declarative instructions for completing the task, as illustrated in Figure 2.

<small><span class="docvortex-page-footnote" data-block-type="page_footnote" style="color:#6b7280"><sup>1</sup>We use LoRA for GRPO due to its low cost and succesful adoption with GRPO (Wang et al., 2025b; Xu et al., 2025b; Li et al., 2025b; Yue et al., 2025; Sun et al., 2025; Hayou et al., 2025; Zhao et al., 2025; Teknium et al., 2024; Zhao et al., 2024; Sidahmed et al., 2024). Additionally, we explore full-parameter finetuning. Figure 11 shows a similar result comparing GEPA to GRPO with full finetuning.</span></small>

9

<!-- page 10 of 96 -->

Accepted at ICLR 2026 (Oral).

## Observation 3: The next-candidate selection strategy strongly influences the optimization trajectory

**and final performance, with Pareto-based sampling providing a distinct advantage.**

Table 3: Comparing candidate selection strategies across different tasks with Qwen3 8B while keeping the evolution harness fixed. At each step, SelectBestCandidate (used by TextGrad Yuksekgonul et al. (2025)) evolves only from the top-scoring candidate. BeamSearch maintains a pool of the top-N candidates (used by APO Pryzant et al. (2023)), but is still prone to local optima. In comparison, GEPA’s Pareto-based selection yields a +12.44% improvement, significantly outperforming the +6.05% and +5.11% gains of greedy and beam-search strategies respectively.

| Qwen3 8B | HotpotQA | IFBench | Hover | PUPA | Aggregate | Improvement |
| --- | --- | --- | --- | --- | --- | --- |
| Baseline | 42.33 | 36.90 | 35.33 | 80.82 | 48.84 | - |
| SelectBestCandidate | 58.33 | 30.44 | 45.33 | 85.45 | 54.89 | +6.05 |
| BeamSearch | 57.33 | 36.39 | 41.00 | 81.08 | 53.95 | +5.11 |
| GEPA | 62.33 | 38.61 | 52.33 | 91.85 | 61.28 | +12.44 |

![Image block](doc:ab3a513/tier:flash/page:10/block:6)

<details>
<summary>image content</summary>

0
(81.56)
1
(92.67)
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
(91.09)
(92.44)
(92.0)
(91.99)
(91.97)
(90.28)
(91.4)
(87.99)
(92.44)
(90.09)
(88.14)
(90.17)
(91.09)
(88.03)
(90.39)
(89.04)
(92.87)
</details>

(a) SelectBestCandidate Strategy

![Image block](doc:ab3a513/tier:flash/page:10/block:8)

<details>
<summary>image content</summary>

0
(82.26)
1
2
3
6
13
(90.92)
(88.33)
(79.53)
(86.22)
(93.84)
8
9
5
7
4
14
(92.45)
(89.64)
(87.5)
(93.32)
(80.62)
(94.59)
12
10
11
15
18
(96.3)
(84.76)
(90.69)
(90.2)
(93.69)
16
17
(93.54)
(92.94)
</details>

(b) Pareto-based candidate sampling.

Figure 6: Comparing the impact of different candidate selection strategies. (Left) As can be seen, selecting the best-performing candidate in every iteration led to a local-optima after one iteration, leading to suboptimal search performance. (Right) On the other hand, using pareto-based candidate selection strategy, GEPA was able to generate a balanced search tree, finding a better performing program within the same budget.

GEPA refines prompts iteratively with rollout feedback; to test our Pareto-based selection, we compare against a baseline that always picks the best-performing candidate in the SelectBestCandidate strategy (which is similar to the strategy used by TextGrad Yuksekgonul et al. (2025)), and BeamSearch(N=4) (used by APO Pryzant et al. (2023)). As shown in Table 3, these baselines often yield suboptimal exploration of the prompt search space, leading to poor performance. GEPA with Pareto-based sampling outperforms the BeamSearch strategy by upto 11.33%, and SelectBestCandidate strategy by up to 8.17%, with an aggregate margin of +7.33% and +6.4% across all benchmarks, respectively. Figure 6 highlights the difference in optimization trajectories: always choosing the current best candidate gives immediate improvement but quickly stalls, wasting rollouts on a single candidate. In contrast, our Pareto-based method expands

10