<!-- page 1 of 15 -->

# SiPipe: Bridging the CPU–GPU Utilization Gap for

![Image block](doc:0556421/tier:flash/page:1/block:2)

<details>
<summary>image content</summary>

Efficient Pipeline-Parallel LLM Inference
Bohan Zhao
Zheng Cao
ScitiX AI
ScitiX AI
vLLM (P2
vLLM (P1
SiPipe (P2
)
16)
)
8
8
vLLM (P4
SGLang (P1
SiPipe (P4
)
16)
)
4
4
10
Tokens/s
8
6
4
×103
2
0   DeepSeek V2.5      DeepSeek V3      Llama-3.1-405B
ScitiX AI
</details>

Figure 1. Throughput comparison of different engines under various parallel configurations on 16 H100 GPUs. Each configuration is denoted as 𝑃𝑖 , where the PP degree 𝑝 = 𝑖 and the 𝑗 TP degree 𝑡 = 𝑗. See §7.1 for detailed experimental settings.

[arXiv:2506.22033v1 \[cs.DC\] 27 Jun 2025](https://arxiv.org/abs/2506.22033v1)

Yongchao He

## Abstract

As inference workloads for large language models (LLMs) scale to meet growing user demand, pipeline parallelism (PP) has become a widely adopted strategy for multi-GPU deployment, particularly in cross-node setups, to improve key-value (KV) cache capacity and inference throughput. However, PP suffers from inherent inefficiencies caused by three types of execution bubbles—load-imbalance, intra-stage, and interstage—which limit pipeline saturation. We present SiPipe, a heterogeneous pipeline design that improves throughput by leveraging underutilized CPU resources to offload auxiliary computation and communication. SiPipe incorporates three key techniques—CPU sampling, a token-safe execution model, and structure-aware transmission—to mitigate pipeline bubbles and improve execution efficiency. Across diverse LLMs, SiPipe achieves up to 2.1× higher throughput, 42.7% lower per-token latency, and up to 23% higher average GPU utilization compared to the state-of-the-art vLLM under the same PP configuration, demonstrating its generality across LLMs and deployment scenarios.

## 1 Introduction

Large language models (LLMs), e.g., GPT [11, 35] and Llama [2, 14], have achieved remarkable success in inference tasks such as code generation and question answering, enabling widely used applications like ChatGPT [34]. However, this success has come with rapidly increasing model sizes—often reaching hundreds of billions of parameters—which far exceed the memory capacity of a single GPU—and with it, a growing user base that demands ever higher inference throughput [3].

Scaling LLMs across multiple GPUs is essential due to memory limits [8]. For example, while a 72B LLM’s weights may fit on two 80GB GPUs, the key-value (KV) [38] caches used to accelerate inference typically require 2–3× more memory, increasing the practical GPU requirement to eight or more [2, 6, 41]. To handle such large-scale deployments, tensor parallelism (TP) is commonly employed to distribute computation across GPUs. However, TP’s reliance on frequent all-reduce [36] communications creates a performance bottleneck beyond 4–8 GPUs, as inter-GPU communication during forward passes often dominates computation time [41].

To scale LLM inference, pipeline parallelism (PP) complements TP by dividing the model into sequential stages, each mapped to one or more GPUs. Within each stage, TP <sup>1</sup>

is used to further parallelize the forward of that stage—i.e., a portion of the model—across the assigned GPUs. This hybrid strategy reduces inter-GPU communication and enables efficient scaling across large GPU clusters. As discussed in prior works [9, 16, 41, 48], let 𝑝 and 𝑡 denote the degrees of PP and TP, respectively, and let 𝑁 = 𝑝 × 𝑡 be the total number of GPUs used. The overall inference throughput scales as 𝑇 (𝑝, 𝑡) ∝ 1 𝑘1 𝑝𝑡 + 𝑘2 <u>log 𝑡</u> , while the per-token latency +𝑏 𝑝 follows 𝐷(𝑝, 𝑡) ∝ 𝑘1 + 𝑘<sub>2</sub> log 𝑡 + 𝑘<sub>3</sub> (𝑝 − 1), where 𝑘<sub>𝑖</sub> and 𝑏 𝑡 are constants. A detailed derivation is provided in Appendix A. Therefore, given a user-facing inference service with a latency budget 𝐷<sub>𝑒</sub> (i.e., a service-level objective, or SLO), the inference engine must select an empirical configuration (𝑝<sub>𝑒</sub>, 𝑡<sub>𝑒</sub> ) such that 𝐷(𝑝<sub>𝑒</sub>, 𝑡<sub>𝑒</sub> ) ≤ 𝐷<sub>𝑒</sub> , subject to the constraint 𝑝<sub>𝑒</sub> ×𝑡<sub>𝑒</sub> = 𝑁, while maximizing throughput. This trade-off typically requires a carefully tuned PP degree 𝑝<sub>𝑒</sub>—large enough to exploit parallelism, yet small enough to satisfy the latency target. Figure 1 validates this conclusion. On a 16-GPU, 2- node deployment, recent LLMs achieve peak throughput with PP degrees 𝑝 = 2 or 4, using state-of-the-art (SOTA) inference engine vLLM [27]. For example, on DeepSeek V3 [31], the PP-based configuration vLLM (𝑃4 ) delivers up to 3.22×4 throughput of the pure TP configuration vLLM (𝑃1 16).

Despite recent progress, mainstream inference engines [27, 33, 47] offer limited support for PP, missing opportunities to scale LLM inference efficiently across multiple GPUs. Furthermore, their naïve PP designs [27, 33, 41] introduce several fundamental bottlenecks (§3.1): **Stage-wise compute load imbalance.** PP introduces a compute imbalance absent in pure TP: although LLM layers are

<small><span class="docvortex-page-footnote" data-block-type="page_footnote" style="color:#6b7280"><sup>1</sup>Data parallelism is treated as TP degree 𝑡 = 1.</span></small>

1

<!-- page 2 of 15 -->

Yongchao He, Bohan Zhao, and Zheng Cao

evenly divided across stages, the last stage incurs extra compute overhead from the sampling task (§2.1), resulting in uneven stage durations and pipeline bubbles. **Stage-wise input preparation overhead.** Before each forward pass, the CPU prepares input tensors and transfers them to GPU memory, incurring a preparation overhead 𝑡𝑝 , while the forward itself costs 𝑡<sub>𝑓</sub>. In PP, this preparation is redundantly repeated at every stage, even though each stage computes only a 1/𝑝 fraction of the forward. As a result, the preparation-to-computation ratio increases from 𝑡𝑝 to 𝑡𝑝 𝑡𝑓 /𝑝 , 𝑡𝑓 leading to greater GPU idle time as the PP degree 𝑝 increases. **Unpredictable cross-stage communication overhead.** In PP, strict data dependencies between adjacent stages—where the size of the transferred data vary with each iteration—require synchronized communication. This communication pattern exhibits unique characteristics of communication stalls and multi-round metadata exchanges, resulting in overheads that far exceed the cost of the data transfer itself.

Collectively, these factors highlight the growing imperative for pipeline-aware architecture in LLM serving systems. Although recent studies explore diverse pipelined strategies [12, 32, 42, 45], they leave core pipeline bottlenecks unresolved. Likewise, specialized designs for serverless inference [20] or Mixture-of-Expert (MoE) models [13, 49] address narrow scenarios but fall short of providing a generalpurpose, inference-oriented pipeline framework.

To tackle these bottlenecks, we identify a key inefficiency in LLM inference: while GPU computation is almost saturated and KV caching with inter-node communication imposes heavy memory and network pressure, CPUs on the same nodes are often underutilized (typically below 10%, see §7.4). SiPipe exploits this CPU slack by offloading parts of inter-stage communication and auxiliary tasks to underutilized CPUs, mitigating pipeline stalls and improving throughput. This insight motivates the design of SiPipe, a Saturated Inference **Pipe**line that rebalances computation across CPUs and GPUs for more efficient PP.

**SiPipe decouples sampling from GPU execution through**

**asynchronous, column-wise CPU sampling.** SiPipe performs

sampling on the CPU to mitigate GPU-side computation imbalance across stages. It adopts a column-wise layout for tensors and performs incremental updates, enabling in-place computation with minimal memory allocation. This design reduces CPU latency and eliminates sampling-induced stalls in PP, thereby improving overall inference efficiency. (§5.1) **SiPipe decouples and overlaps CPU and GPU execution**

**with the token-safe execution model (TSEM).** SiPipe introduces the TSEM to overlap CPU-side input preparation with GPU-side forward. For a given batch size, TSEM pre-captures two versions of the CUDA graph, which alternately bind to two shared buffers. This design allows the CPU to fill one buffer while the GPU reads the other, enabling seamless parallelism without modifying the execution graph. By decoupling

input preparation from forward, TSEM eliminates intra-stage GPU stalls and improves overall throughput. (§5.2)

**SiPipe introduces structure-aware transmission (SAT) for**

**efficient and decoupled stage communication.** Based on the insight that hidden states (i.e., the output tensors of each stage) exhibit structural stability across inference iterations, SAT infers tensor layouts in advance, enabling early memory allocation and eliminating the need to transmit metadata between stages. This significantly reduces communication rounds and removes the overhead of metadata serialization and deserialization. By allowing receivers to predict tensor layouts ahead of time, SAT eliminates synchronous metadata exchange, naturally enabling asynchronous communication and mitigating communication stalls. (§5.3) Our evaluation demonstrates that under the same PP configurations, SiPipe achieves a throughput improvement of 1.6×-2.1× and 1.4×-1.7× over vLLM [27] on the 8×H100 and 16×H100 testbeds, respectively, along with latency reductions of up to 30.5% and 42.7%. As shown in Figure 1, SiPipe delivers up to 4.5× throughput improvement over the pure TP approach in a cross-node setup with 16 H100 GPUs.

In summary, the contributions of this paper are: (1) We identify three types of PP bubbles caused by pipelineagnostic designs in existing LLM inference engines that significantly degrade performance. (§3.1) (2) We analyze PP characteristics and propose leveraging underutilized CPU resources to assist communication and computation, mitigating these bubbles. (§3.2) (3) We design and implement SiPipe based on these insights; the code will be open-sourced after publication. (§5) (4) We conduct extensive experiments on representative LLMs, demonstrating that SiPipe outperforms SOTA systems such as vLLM [27] and SGLang [47]. (§7)

## 2 Background

## 2.1 LLM Inference

Figure 2 illustrates the autoregressive generation process of LLM inference, where a pretrained LLM (e.g., DeepSeek-R1 [19]) generates **output** tokens conditioned on a **prompt**. A tokenizer [17, 25, 40] tokenizes the prompt into discrete **token IDs** using a fixed vocabulary table, which maintains the mapping between IDs and tokens. An inference engine [27, 47] maintains the generation state for each request as a **sequence**, which consists of the token IDs of both the input prompt and all output token IDs. Generation proceeds in discrete **iterations**, each producing one new token ID per scheduled sequence. To improve hardware efficiency, sequences at the same iteration are grouped into a **batch** for parallel inference on GPUs. Each decoding iteration consists of two parts<sup>2</sup>:

<small><span class="docvortex-page-footnote" data-block-type="page_footnote" style="color:#6b7280"><sup>2</sup>We focus on the decoding stage in this paper, where token generation proceeds one step at a time, in contrast to the initial prefill [38] stage that encodes the full prompt in a single pass.</span></small>

2

<!-- page 3 of 15 -->

SiPipe: Bridging the CPU–GPU Utilization Gap for Efficient Pipeline-Parallel LLM Inference

Outside the stages, the engine performs two key tasks. First, it selects a batch of active sequences (e.g., 𝑠𝑒𝑞<sub>0</sub> and 𝑠𝑒𝑞<sub>1</sub> at iteration 0) and generates a scheduling output, which is broadcast to all GPUs. Completed sequences are removed, and new ones are added to maintain batch occupancy and reduce queuing latency. Second, after the batch finishes traversing all stages, the engine appends the generated token IDs to each sequence, checks for completion, and detokenizes the outputs into human-readable text.

Inside each stage, three steps are applied in every iteration. ○1 Input preparation. Each GPU constructs a model input using the received scheduling output. This step encompasses tasks such as model and attention metadata computation, sequence caching and updates, tensor allocation, and CPU–GPU data transfers. The resulting model input is a collection of tensors that are subsequently transferred from CPU to GPU. ○2 Forward pass. In PP, each stage processes model inputs and returns an activation vector for each sequence. Non-final stages produce intermediate activations of shape 𝐵×𝐻, where 𝐵 is the microbatch size and 𝐻 the hidden dimension, and forward them to the next stage. Only the final stage transforms these into logits of shape 𝐵 × 𝑉 , where 𝑉 is the vocabulary size. Each row of the logits corresponds to a sequence, and each column to a vocabulary token. ○3 Sampling. A softmax in the final stage converts logits into probabilities. We denote the logits from the final layer of a LLM at time step 𝑠 as z𝑠 ∈ R𝐵×𝑉, where 𝐵 is the batch size and 𝑉 is the vocabulary size. For each request 𝑏 ∈ {1, . . . , 𝐵}, z(𝑏) 𝑠 ∈ R𝑉 represents the unnormalized log-probabilities over the vocabulary. Let y(𝑏) <𝑠 = (𝑦 1 , . . . , 𝑦𝑠−1 ) denote the se-(𝑏) (𝑏) quence of previously generated tokens for request 𝑏 up to step 𝑠−1. The sampling process can be defined as follows. (1) Logits adjustment. Modify logits using penalties [4, 26] (e.g., frequency) based on y<𝑠 <sup>to</sup> promote diversity. (𝑏) (2) Probability computation. Scale logits by temperature 𝜏 [7], apply softmax, and optionally restrict candidates using top𝑘 [15] or top-𝑝 [23] filtering:

## !

; 𝑘, 𝑝!

(𝑏)

(𝑏) )

ApplyPenalty(z<sub>𝑠</sub>

, y<𝑠

(𝑏)

= Filter softmax

p<sub>𝑖</sub>

𝜏

(3) Sampling. Draw a token ID from the categorical distribution 𝑦𝑠 (𝑏) ∼ Categorical(p<sub>𝑠</sub> (𝑏) ), y<sub>𝑠</sub> ∈ N<sup>𝐵</sup>.

For example, at the 0<sub>th</sub> iteration, top-𝑘 sampling may select token IDs 8 and 14 for 𝑠𝑒𝑞<sub>0</sub> and 𝑠𝑒𝑞<sub>1</sub> respectively, yielding updated sequences 𝑠𝑒𝑞<sub>0</sub> = ⟨6, 7, 9, 11, 3, 8⟩ and 𝑠𝑒𝑞<sub>1</sub> = ⟨13, 7, 4, 5, 12, 3, 14⟩. The engine proceeds to the next iteration, repeating until an END-OF-SEQUENCE (EOS) token ID is generated or the maximum sequence length is reached.

## 2.2 Pipeline Parallelism in LLM Inference

LLMs typically consist of stacked transformer [44] layers, each performing attention and feed-forward computations. Pipeline parallelism (PP) partitions the model along its depth,

![Image block](doc:0556421/tier:flash/page:3/block:18)

<details>
<summary>image content</summary>

Vocabulary Table (Vocabulary size = 14)
Token: , . ? be cold is it No raining sunny today tomorrow will Yes
Token ID: 1 2 3 4   5  6 7 8   9    10   11     12    13 14
Prompt:
Output:
User 1
Is it raining today ?
No , it is sunny today .
tokenize        detokenize
Autoregressive
11
6 7 9     3        8 1 7 6 10 11 2
Generation
User 2   Will it be cold tomorrow ?       Yes , it will be cold tomorrow .
13 7 4 5 12 3        1 7 13 4 5 12 2
14
Prompt token IDs        Output token IDs
0th
6th
7th
Finished!
iter
iter
iter
scheduled
Engine
Engine
Engine
seq0 6 7 9 11 3
8
2
h
…
batc
14        12
seq1 13 7 4 5 12 3
2
Newly Generately Output Token ID
</details>

Figure 2. Example of iterative autoregressive generation in LLM serving. Note that the scheduled batch may changed from one iteration to the next—for instance, certain sequences may be preempted by others. The diagram omits these dynamics for clarity.

with each stage responsible for a subset of layers. During inference, unfinished sequences are grouped into microbatches and processed in a pipelined fashion. For example, with four sequences {𝑠𝑒𝑞<sub>0</sub>, 𝑠𝑒𝑞<sub>1</sub>, 𝑠𝑒𝑞<sub>2</sub>, 𝑠𝑒𝑞<sub>3</sub>} and pipeline degree 𝑝 = 2, one schedule assigns microbatch {𝑠𝑒𝑞<sub>0</sub>, 𝑠𝑒𝑞<sub>1</sub>} to iteration 2𝑘 and {𝑠𝑒𝑞<sub>2</sub>, 𝑠𝑒𝑞<sub>3</sub>} to 2𝑘 + 1, alternating until completion. Each stage sequentially performs input preparation and a forward pass, while only the final stage executes sampling.

PP enables inference of LLMs that do not fit on a single GPU and improves throughput. Unlike TP, whose allreduce operations scale poorly across nodes, PP restricts communication to adjacent stages and is more bandwidth-efficient —especially in cross-node deployments using Ethernet or InfiniBand. Let 𝑁, 𝐻, 𝐵, 𝑡, and 𝑝 denote the number of layers, hidden size, batch size, TP degree, and PP degree, respectively. The per-GPU communication volume is 𝐶(𝑝, 𝑡) = 𝐵𝐻 <u>4𝑁 (𝑡−1)</u> + 𝑝 − 1 . When 𝑝2 𝑡 < 4𝑁—a condition com𝑝𝑡 monly satisfied in LLM deployments that require 8 or more GPUs under PP (e.g., 𝑁 > 50, 𝑝𝑡 ≤ 16) [2, 31, 43]—we have 𝐶(𝑝, 𝑡) > 2 × 𝐶(2𝑝, 𝑡/2), suggesting that increasing 𝑝 and reducing 𝑡 can substantially lower communication. For small models<sup>3</sup> (e.g., 32B LLMs that require 𝑝𝑡 ≤ 4), PP brings limited benefit and may introduce pipeline bubbles. But for larger models (𝑝𝑡 ≥ 8), hybrid PP+TP (e.g., 𝑝 = 2, 𝑡 = 4) significantly reduces communication versus pure TP (𝑝 = 1, 𝑡 = 8). As shown in Figure 1, PP yields up to 4.5× throughput improvement for 16-GPU inference of DeepSeek V3.

<small><span class="docvortex-page-footnote" data-block-type="page_footnote" style="color:#6b7280"><sup>3</sup>Not in the scope of this paper.</span></small>

3

<!-- page 4 of 15 -->

Yongchao He, Bohan Zhao, and Zheng Cao

![Image block](doc:0556421/tier:flash/page:4/block:2)

<details>
<summary>image content</summary>

End-to-End Iteration        Forward on GPU
Stage 1
Stage 0
0        100        200        300        400
Time (milliseconds)
</details>

Figure 3. Per-iteration execution breakdown using vLLM on 8 H100 GPUs with Qwen-2.5-72B (𝑡 = 2, 𝑝 = 4). Bars denote iteration time; filled regions represent GPU forward time.

![Image block](doc:0556421/tier:flash/page:4/block:4)

<details>
<summary>image content</summary>

End-to-End Iteration        Forward on GPU
Stage 3
Stage 2
Stage 1
Stage 0
0        100       200       300       400       500       600
Time (milliseconds)
</details>

Figure 4. Per-iteration execution breakdown using vLLM on 16 H100 GPUs with DeepSeek V3 (𝑡 = 4, 𝑝 = 4).

## 3 Motivation

This section presents key observations on PP and identifies core challenges in achieving high throughput. These observations reveal fundamental inefficiencies in PP inference and motivate the design of SiPipe.

## 3.1 Observations of PP Inefficiencies in LLM Inference

Figure 3 and Figure 4 show the per-stage breakdown of each iteration during 8-GPU and 16-GPU PP inference with vLLM [27]. These results lead to the following observations: **Observation 1: Load-imbalance bubble.** The overall throughput of PP inference is limited by the slowest stage. Profiling across various LLMs and GPU counts consistently shows the final stage has a significantly higher computation load (22% − 40%)—mainly due to the extra cost of sampling. This imbalance causes earlier stages to idle: with PP degree 𝑝 = 𝑥, stage 0 at iteration 𝑛 +𝑥 must wait for stage 𝑥 − 1 to complete iteration 𝑛. Consequently, the overloaded final stage creates persistent pipeline bubbles, reducing overall efficiency.

**Observation 2: Intra-stage bubble.** In each iteration, we observe a gap (12% − 19%) at the beginning of every stage’s execution, caused by the CPU-side input preparation before launching the GPU-side forward. This delay arises from the use of CUDA graphs [18], which require inputs to reside at fixed GPU memory addresses. As a result, CPU-prepared tensors must be synchronously copied into pre-allocated buffers before each CUDA graph replay.

In frameworks like vLLM, input preparation is deferred until the previous forward completes to ensure correctness, avoiding race conditions in graph execution. This forces the GPU to wait for the CPU to finish preparation, creating intrastage bubbles. While more asynchronous designs are possible, they risk correctness issues (see Section 3.2).

**Observation 3: Inter-stage bubble.** inter-stage bubbles become non-negligible after an even 𝑝-stage partition, which consist of two components: synchronization overhead due to

data dependencies of adjacent stages (1.4–2.6 ms) and transmission overhead of activations (1–2 ms). Figures 3 and 4 reveal that even with an even 𝑝-stage partition, the forward execution time varies across stages with a standard deviation of 3% − 7%. This variation amplifies synchronization cost.

For example, suppose stage 0 takes 𝑡𝑛+1 to complete iter- 0 ation 𝑛 + 1, while stage 1 takes 𝑡𝑛 to complete iteration 𝑛,1 where 𝑡𝑛+1 0 < 𝑡𝑛 . If both begin at time 𝑡, stage 0 becomes idle 1 since 𝑡 + 𝑡𝑛+1, waiting to send hidden states to stage 1. The 0 interval [𝑡 + 𝑡<sup>𝑛+1</sup>, 𝑡 + 𝑡<sup>𝑛</sup>] is a communication stall induced solely by stage-wise synchronization on data dependencies.

## 0

## 1

## 3.2 Challenges and Solutions

Eliminating bubbles in PP requires addressing challenges in computation efficiency, dependency management, and overlapping communication. We next detail each challenge and show how underutilized CPUs are leveraged to mitigate them.

**Challenge 1: Decoupling sampling to preserve pipeline balance.** To eliminate load-imbalance bubbles, we first identify their root cause: The final pipeline stage performs an additional sampling step. In typical PP, sampling is naturally colocated with the final stage, as this stage produces the logits. However, this design introduces imbalance: while other stages proceed to the next microbatch after forward, the final stage is stalled by the additional, sequential sampling step. This creates a serialization point that degrades overall throughput.

A natural idea is to offload sampling to a dedicated GPU. However, in large-scale deployments where all GPUs are fully utilized (e.g., 𝑡 = 2, 𝑝 = 4 on an 8-GPU node), these options are impractical. Sampling is too light and sequential to warrant an exclusive GPU, and reshaping the pipeline to hide its latency (such as giving the final stage fewer layers) forces hardware-specific workload balancing, reducing portability. Because these strategies entangle sampling with model partitioning, they also impede modular scaling. Efficiently decoupling sampling thus remains a key challenge.

**Solution 1: SiPipe adopts a column-wise layout and incremental computation to accelerate CPU-based sampling.**

SiPipe offloads the sampling process to multiple CPUs to balance GPU workload in PP. To avoid the CPU becoming a straggler during high-throughput LLM inference, SiPipe introduces a column-wise data layout to enable efficient in-place updates. Built on this layout, SiPipe incrementally updates cross-iteration metadata, avoiding redundant computation and memory allocation. These optimizations exploit interbatch similarity, reduce CPU latency, and eliminate samplinginduced load-imbalance bubbles. (§5.1)

**Challenge 2: Cross-iteration input conflicts under static execution models.** A natural way to eliminate intra-stage bubbles is to decouple CPU and GPU execution—preparing inputs asynchronously on the CPU while the GPU performs the forward pass. However, to minimize runtime overhead, modern inference engines often adopt static execution models,

4

<!-- page 5 of 15 -->

SiPipe: Bridging the CPU–GPU Utilization Gap for Efficient Pipeline-Parallel LLM Inference

i.e., CUDA graphs [18], which fix input bindings and kernel sequences. While efficient, this approach leads to subtle write-after-read (WAR) hazards: when the CPU and GPU run asynchronously, inputs for iteration 𝑗 may overwrite buffers that the GPUs is still reading from iteration 𝑖 < 𝑗. These conflicts arise from temporal asymmetry between CPU and GPU, rigid memory bindings in CUDA graphs, and the evolving nature of model inputs in autoregressive generation.

A common workaround—staging model input tensors in temporary buffers and copying them into static regions before launch forward—avoids conflicts but incurs extra memory copies, reintroducing synchronization bottlenecks and offsetting the benefits of CUDA Graphs. These limitations call for a principled solution that enables safe decoupling without sacrificing the efficiency of static execution.

**Solution 2: SiPipe adopts token-safe execution model (TSEM) to decouple CPU and GPU execution.** To eliminate intrastage bubbles caused by GPU stalls during CPU-side input preparation, SiPipe introduces the TSEM, which safely decouples input preparation from forward while preserving static graph constraints. TSEM pre-captures two CUDA graphs per batch size, each bound to a distinct shared buffer. Iterations alternate between these graphs, allowing the CPU to prepare inputs in one buffer while the GPU reads the other. This shadow buffering-based scheme [22] ensures version isolation without requiring runtime graph modifications. By enabling asynchronous CPU-GPU execution, TSEM eliminates intra-stage bubbles. (§5.2)

**Challenge 3: Efficient transmission of dynamic hidden states across pipeline stages.** In PP, each stage transmits

a tensor dictionary of hidden states (activations and residuals [21]) to the next stage every iteration. Since tensor sizes vary dynamically and cannot be statically pre-allocated, packing and transmission must wait until forward passes complete, delaying communication. This uncertainty causes communication stall (§3.1) and requires multi-round metadata exchanges to determine tensor sizes, inflating inter-stage bubbles and reducing pipeline efficiency.

**Solution 3: SiPipe adopts a structure-aware transmission (SAT) strategy to enable asynchronous communication between stages.** Although hidden states change across iterations, their structure remains mostly stable. SiPipe exploits this property via SAT, which captures the invariant structure and infers per-iteration changes from scheduling output—eliminating the need to treat each tensor dictionary as fully dynamic. Once the structure is identified, an asynchronous CPU thread in the receiving process handles data pre-allocation, management, and transmission for each iteration. As a result, downstream stages can directly access the prepared data without waiting, eliminating transmission latency. SAT reduces multi-round metadata exchanges, avoids redundant metadata processing, shortens inter-stage bubbles, and removes communication stalls through its asynchronous design. (§5.3)

![Image block](doc:0556421/tier:flash/page:5/block:8)

<details>
<summary>image content</summary>

M Communicator G GPU Executor C CPU Executor S CPU Sampler
1
BIC-I
worker
worker
…2        S
3      4
0
BIC-L
scheduler
M
M
…
6
S
C   G
C   G
BIC-O
stage 0        stage p-1
5
</details>

Figure 5. Architecture and workflow of SiPipe.

## 4 Overview

## 4.1 System Architecture

Figure 5 shows the pipelined parallel inference architecture of SiPipe, comprising four key components: the scheduler, workers, CPU samplers, and the Buffered IPC Channel (BIC). In each iteration, the scheduler selects a microbatch from unfinished sequences and generates a scheduling output, which is broadcast to all workers. The pipeline consists of 𝑝 stages, each with 𝑡 workers executing TP inference over a model shard. The output of stage 𝑖 (i.e., the hidden states) becomes the input to stage 𝑖+1. Each worker includes three modules: (1) a communicator that handles inter-stage data transfer and internal coordination; (2) a CPU executor for input preparation and cached state management; (3) a GPU executor for the forward pass. After the final stage, a pool of CPU samplers receives the logits and performs parallel sampling. To enable low-latency communication between components, SiPipe introduces the BIC (detailed in §6), which serves as a message queue for different data types: BIC-I for scheduling outputs, BIC-L for logits, and BIC-O for sampling outputs.

## 4.2 Execution Flow

We illustrate the SiPipe workflow with an example. Suppose we process 4 sequences ({𝑠𝑒𝑞<sub>0</sub>, 𝑠𝑒𝑞<sub>1</sub>, 𝑠𝑒𝑞<sub>2</sub>, 𝑠𝑒𝑞<sub>3</sub>}) with a PP degree of 𝑝=2, resulting in a microbatch size of 4 = 2. At ini𝑝 tialization, the scheduler dispatches 𝑝 consecutive scheduling outputs to workers via BIC-I ( 0 ). Thereafter, upon receiving sampling output for iteration 𝑛, it immediately dispatches iteration 𝑛 + 𝑝. This pipelined approach keeps all workers busy, maximizing resource utilization. For example, the scheduler may assign microbatches {𝑠𝑒𝑞<sub>0</sub>, 𝑠𝑒𝑞<sub>1</sub>} and {𝑠𝑒𝑞<sub>2</sub>, 𝑠𝑒𝑞<sub>3</sub>} to iteration 2𝑘 and iteration 2𝑘 + 1, respectively.

Each worker handles sequences as follows: the CPU executor asynchronously updates the sequence cache, generates model input, and forwards it to the communicator. Concurrently, the GPU executor polls the communicator and launches forward passes upon receiving new model input. For stage-0 workers, execution triggers on model input availability alone (❶). Subsequent stages wait for both model input and hidden states from the previous stage. Intermediate stages forward hidden states downstream (❷), while the final stage sends logits to CPU samplers via BIC-L (❸❹).

Each CPU sampler then generates sampling metadata for the microbatch and performs sampling using the logits. Sampling outputs are sent back to the scheduler via BIC-O (❺), triggering the next iteration (❻).

5

<!-- page 6 of 15 -->

Yongchao He, Bohan Zhao, and Zheng Cao

## 5 Design

In this section, we present SiPipe’s core designs for eliminating pipeline inefficiencies, focusing on load-imbalance bubbles (§5.1), intra-stage bubbles (§5.2), and inter-stage bubbles (§5.3).

## 5.1 Column-Wise CPU Sampling via Metadata Reuse

Offloading sampling to the CPU reduces load-imbalance bubbles by balancing GPU workloads but introduces two main challenges. First, sampling relies on dynamic metadata (e.g., output token IDs) that change each iteration. Intermediate steps—such as penalty application, softmax, and filtering—produce many temporary tensors, causing frequent memory allocations and stressing CPU memory management. Second, sampling is compute-intensive and requires careful CPU-side optimization to maintain high throughput.

For instance, given logits Z ∈ R𝐵×𝑉 and previously output token IDs Y ∈ N<sup>𝐵</sup>× (𝑠−1) , we compute a penalty tensor f = CalcPenalty(Y), where each row f<sub>𝑖</sub>,: encodes token frequency, presence, or repetition in sequence 𝑖. The penalized logits are Z′ = Z − 𝛼 · f, with 𝛼 as a tunable hyperparameter. Then temperature scaling is applied: Z′′ = Z′ /𝜏, 𝜏 > 0, followed exp(Z<sub>𝑖</sub>, 𝑗 ) ′′ by a row-wise softmax P𝑖,𝑗 = Í𝑉 𝑣=1 exp(Z′′ 𝑖,𝑣 ) . Filtering methods such as top-𝑘 and top-𝑝 sampling optionally restrict candidate tokens before sampling. Since Y changes every iteration, these computations and memory allocations must be repeated.

Dynamic Y and Z impose significant overhead when batch size 𝐵 and vocabulary size 𝑉 are large—a common setting in LLM serving. For instance, Qwen-2.5-72B (𝑉 = 151,643, 𝐵 = 256) requires approximately 300 MB per penalty tensor (double precision). To sustain high inference throughput, sampling must finish within the decoding slack—typically 1–2 ms per sampling strategy—demanding over 150 GB/s memory bandwidth solely for penalty operations. While this falls below DDR5’s peak bandwidth, contention under high concurrency reduces effective utilization. Additionally, elementwise computations on large matrices further increase computational cost as 𝐵 and 𝑉 grow. Without memory reuse or incremental updates, penalty calculation becomes a critical CPU bottleneck, limiting overall throughput.

To mitigate memory allocation overhead and facilitate reuse across iterations, we propose a column-wise data layout that transposes the model logits Z ∈ R<sup>𝐵</sup>×𝑉 and Y ∈ N<sup>𝐵</sup>× (𝑠−1) into Z⊤ ∈ R<sup>𝑉</sup> ×𝐵 and Y⊤ ∈ N(𝑠−1)×𝐵 , respectively. This reordering forms the basis of a redesigned CPU sampling that directly improves both computational efficiency and memory access locality. Specifically, SiPipe reuses this transposed structure to incrementally construct penalties and optimize downstream sampling steps: (1) Memory reuse for output sequences. We preallocate a maximum-length output buffer Y ∈ N𝐿max×𝐵. In the transposed layout, new token IDs are appended as rows, enabling fast in-place update and avoiding tensor reshaping. This also

ensures that all subsequent metadata (e.g., frequency matrices) can be updated incrementally. (2) Incremental penalty construction. For penalties such as frequency, repetition, and presence, we maintain a shared buffer4 f ∈ R<sup>𝑉</sup> ×𝐵 aligned with the transposed logits Z⊤. At each iteration, only the 𝐵 elements of f that correspond to the newly generated token IDs are incrementally updated in-place across all sequences in the microbatch. This approach enables efficient computation of 𝛼 · f with minimal overhead, while being cache-friendly and avoiding reconstruction of the entire penalty tensor. Consequently, penalty adjustment reduces to a single vectorized subtraction Z⊤ := Z⊤ − 𝛼 · f, eliminating the need to regenerate f from scratch at every iteration. (3) Low-cost pipelined integration. In each stage, each worker typically generates a logits shard of shape 𝐵 × 𝑉 . By em- 𝑡 ploying a column-wise layout, these shards can be locally transposed to 𝑉 × 𝐵 and directly concatenated along the row 𝑡 dimension to form the global matrix Z⊤ ∈ R𝑉 ×𝐵. This approach avoids costly all-gather operations or row-wise tensor reconstructions.

By redesigning the sampling process to leverage the columnmajor layout, we unify key sampling operations into in-place transformations on the logits tensor Z⊤. This eliminates repeated intermediate tensor allocations and data copying. All operations run in a memory- and cache-efficient manner, enabling vectorized computation and high throughput. The resulting design forms a lean, scalable CPU-side sampling pipeline that is both elegant and efficient in practice.

SiPipe relies on the assumption that consecutively scheduled batches are identical or exhibit high similarity (i.e., the microbatch size 𝐵 remains constant across iterations), thereby permitting incremental updates through minor adjustments to Y. Although this assumption may appear restrictive, it is welljustified in large-scale LLM inference scenarios employing scheduling strategies such as contiguous batching or iteration batching [8, 16, 27, 46]. In particular, within TP, adjacent batches are highly likely to be identical. Similarly, in PP with parallelism degree 𝑝, batches indexed by 𝑛 and 𝑛 + 𝑝 are expected to be identical, while batches indexed by 𝑛 and 𝑛 + 𝑗 for 0 < 𝑗 < 𝑝 are orthogonal. Consequently, maintaining only 𝑝 distinct column-wise data replicas—corresponding to the pipeline stages—is sufficient to support efficient incremental computation without violating this assumption.

The memory overhead on the host for each replica is bounded by 𝑛 × 𝐵 ×𝑉 + 𝐵 × 𝐿<sub>max</sub>, where 𝐵 typically does not exceed 1024, and 𝑛 = 3 corresponds to the frequency, presence, and repetition penalty buffers. Moreover, 𝐿<sub>max</sub> and 𝑉 for most SOTA LLMs rarely exceed 128K and 200K, respectively. Consequently, the total memory consumption remains well within reasonable limits (≈ 3-4 GB), making this overhead acceptable for typical host memory capacities.

<small><span class="docvortex-page-footnote" data-block-type="page_footnote" style="color:#6b7280"><sup>4</sup>Each penalty type has its own buffer and follows a similar processing routine.</span></small>

6

<!-- page 7 of 15 -->

SiPipe: Bridging the CPU–GPU Utilization Gap for Efficient Pipeline-Parallel LLM Inference

## 5.2 Token-Safe Execution Model with CPU-Assist

To eliminate intra-stage bubbles, SiPipe decouples CPU and GPU executors for asynchronous execution. In PP, microbatches scheduled across successive iterations are non-overlapping sequence sets. Therefore, the CPU executor can safely pre-pare inputs for iteration 𝑖 +1 while the GPU executor performs forward on iteration 𝑖. Without data dependencies between adjacent microbatches, CPU-GPU concurrency is both safe and effective. This insight underpins our decoupled execution strategy, enabling full utilization of CPU and GPU resources without compromising correctness.

However, this asynchronous CPU-GPU execution conflicts with CUDA graphs, which rely on static buffer bindings that assume inputs remain unchanged across iterations. While CUDA graphs reduce launch overhead by capturing fixed kernel execution sequences and their memory bindings, this static model causes WAR hazards when the CPU overwrites data still in use by the GPU, threatening correctness (see Challenge 2, §3.2).

To address cross-iteration WAR hazards under static execution models, we propose the token-safe execution model (TSEM), a mechanism that ensures conflict-free pipeline inference. TSEM introduces an asynchronous CPU executor dedicated to input preparation, which operates in parallel with the GPU executor while maintaining compatibility with statically captured CUDA graphs. To coordinate these components without introducing blocking or direct dependencies, TSEM adopts a message-driven architecture (Figure 6), where a dedicated communicator orchestrates execution by dispatching events to the CPU and GPU executors. This design decouples input preparation from forward and eliminates idle time due to executor synchronization, allowing both components to make forward progress independently.

The GPU executor employs a versioned buffer mechanism, where each type of input tensor maintains two physical versions (𝑣<sub>0</sub> and 𝑣<sub>1</sub>). For each version, we capture a set of static CUDA graphs, each corresponding to a different batch size. A graph is selected based on a tuple <𝑣0/𝑣1, 𝑏𝑎𝑡𝑐ℎ\_𝑠𝑖𝑧𝑒>, enabling the executor to alternate between versions across iterations and avoid WAR hazards. The CPU executor maintains a SequenceCache that maps each sequence to its cached metadata, including prompt/output token IDs and KV-related state, minimizing redundant data transfer when sequences are repeatedly scheduled. It also prepares per-iteration Batch-Metadata, which includes preprocessed CPU tensors (e.g., attention inputs) for each microbatch. To reduce recomputation, 𝑝 versions of BatchMetadata are maintained (where 𝑝 is PP degree), leveraging the high similarity between microbatches in iteration 𝑖 and 𝑖+𝑝 (§5.1). The communicator coordinates execution by managing two message queues: one for scheduling outputs and one for model inputs. It buffers scheduling outputs from the scheduler and model inputs from

![Image block](doc:0556421/tier:flash/page:7/block:7)

<details>
<summary>image content</summary>

Scheduling Output Queue        Model Input Queue
Communicator
2        3        4
0
0    8
BatchMetadata 1
SequenceCache
1    8
BatchMetadata 2
……
1
BatchMetadata 3
0   512
Version-
1   512
ed Buffer
BatchMetadata 4
Graph Index CUDA Graph
CI       GI
CI==GI
CI>GI
CI==GI
CI==GI
CI>GI
CI>GI
FSM
W      R        FSM
W      R
CI>GI
CI==GI
CPU Executor
GPU Executor
</details>

Figure 6. Illustration of the token-safe execution model for conflict-free GPU execution.

the CPU executor, and asynchronously transmits GPU executor outputs to the next stage while receiving hidden states from the previous one. To drive progress, it maintains two indicators—the CPU indicator (CI) and GPU indicator (GI)—which track the latest completed iteration of each executor.

Each executor operates as a finite-state machine (FSM) with two states: wait (W) and running (R). Initially, both CI and GI are set to −1. The CPU executor transitions from W to R—or remains in R—whenever CI == GI, indicating that all previously generated model inputs have been consumed. In state R, it consumes a scheduling output from the communicator’s scheduling output queue ( 0 ), updates the SequenceCache and the corresponding BatchMetadata (indexed by 𝑖 mod 𝑝, where 𝑖 = CI), and writes the prepared input tensors into the versioned input buffer (version 𝑖 mod 2, ❶). It then enqueues a lightweight model input descriptor (e.g., batch size) into the model input queue and increments CI (❷). The GPU executor follows a similar FSM structure, with a key distinction: it increments GI immediately after entering or remaining in state R, thereby allowing the CPU executor to asynchronously prepare the next iteration’s input. Upon entering R, it fetches a model input from the model input queue (❸), locates the correct versioned buffer and CUDA graph using the index <(GI-1)mod2, batch\_size>, executes the graph, and forwards the output to the next stage via the communicator (❹). This FSM-driven design decouples CPU and GPU progress while maintaining strict correctness, enabling efficient overlap of input preparation and forward pass.

TSEM eliminates intra-stage bubbles by decoupling CPU input preparation from GPU execution, ensuring that each new iteration can immediately begin once the previous forward pass completes. This tight coordination maximizes pipeline utilization and sustains high throughput. The overhead of TSEM is modest, requiring only an additional static input buffer and a few CUDA graphs. This cost is effectively neutralized by offloading sampling to the CPU, which reclaims GPU memory previously allocated for sampling metadata, e.g., penalty tensor f.

7

<!-- page 8 of 15 -->

Yongchao He, Bohan Zhao, and Zheng Cao

## 5.3 Structure-Aware Hidden State Transmission

In PP, consecutive stages exhibit strict data dependencies: the output (i.e., hidden states) of stage 𝑖 serves as the input to stage 𝑖+1 for every microbatch. This mandates a data handoff between adjacent stages at each iteration. Cross-stage communication is inherently serialized. Stage 𝑖+1 must wait until it fully receives and deserializes the hidden states from stage 𝑖 before initiating forward pass. This strict dependency leads to inter-stage bubbles, where communication latency hinders overall pipeline utilization. Since tensor shapes and sizes of hidden states may vary across microbatches, the receiving stage cannot initiate partial forward and must wait for full transmission and deserialization.

Consider transmitting hidden states structured as {key1: tensor<sub>1</sub>, key2: tensor<sub>2</sub>}. As shown in Figure 7(a), state-of-the-art inference engines typically adopt a structure-unaware transmission strategy. In this approach, the receiver lacks prior knowledge of the dictionary layout or tensor sizes, preventing asynchronous communication and enforcing strict synchronization. The sender first serializes metadata containing the number of entries, the list of keys, and per-tensor attributes such as shape, dtype, and device ( 0 ). Because the receiver does not know the size of this metadata blob, it must first allocate a temporary buffer to receive the blob size (❶), then perform a communication round to obtain it (❷). Once the size is known, it allocates a full metadata buffer (❸) and receives the actual blob in a second communication round (❹). After deserialization (❺), the receiver sequentially allocates memory and receives each tensor one by one (❻–❽). Finally, it reconstructs the hidden state by pairing each key with its corresponding tensor (❾). This serialized, step-wise process requires multiple tightly coupled communication rounds and memory allocations, significantly delaying stage activation and exacerbating inter-stage bubbles.

For a running engine with the fixed model type and GPU assignment, the structure of the hidden state dictionary remains largely static across iterations. In typical models, this dictionary contains a small, fixed set of tensors, such as the output of the final feed-forward layer and the residual connection. As a result, both the number of entries and their string keys are predictable. Each tensor typically has a shape of 𝑥 × 𝑦, where 𝑦 (the hidden size) is model-dependent and fixed, whereas 𝑥 (the batch size) may vary across iterations. All other attributes, including data type and device, remain unchanged.

Figure 7(b) illustrates SiPipe’s structure-aware transmission mechanism, which avoids redundant metadata communication by separating static and dynamic components of the hidden states. The mechanism consists of two key components: static structure capture and dynamic batch size retrieval. In the first iteration, the receiver performs a full transmission using the structure-unaware transmission. During the reconstruction step, however, it additionally extracts and stores

![Image block](doc:0556421/tier:flash/page:8/block:7)

<details>
<summary>image content</summary>

sender        receiver
sender        receiver
serialization
serialization
0
0
alloc
alloc
1
1
2
2
iteration 0 (capture)
alloc
alloc
iteration 0
4        3
4        3
deseria-
deseria-
lization
lization
5
5
6
6
alloc
alloc
8        7
8        7
9
9
construction
construction and
structure capture
iteration n
iteration n
iteration n
……
(a) Structure-unaware Transmission       (b) Structure-aware Transmission
</details>

Figure 7. Effect of structure-aware vs. structure-unaware transmission when transferring variable-size tensors across multiple iterations.

the static structure of the dictionary (❾). Since the scheduler sends per-iteration scheduling output to each worker, the receiver can directly extract the only dynamic factor—the batch size—based on the number of sequences assigned to that stage.

With both static structure and batch size available, the receiver can pre-allocate memory and post asynchronous irecv operations before transmission begins, avoiding communication stalls caused by unfinished forward on GPU. The sender transmits hidden states using asynchronous isend, overlapping communication with ongoing computation. As shown in Figure 7(b), metadata-related serialization, deserialization, and synchronization are skipped entirely during steady-state iterations.

Our structure-aware mechanism provides two key advantages over the structure-unaware baseline. First, by removing synchronous metadata communication, it decouples adjacent pipeline stages. In the structure-unaware setting, stage 𝑖 may stall due to blocking communication. In contrast, our design enables pre-buffering and asynchronous receives to eliminate these communication stalls. Second, although hidden states are small—typically requiring only hundreds of microseconds to transfer over RDMA or NVLink—the overhead from metadata handling and control synchronization in the structure-unaware design dominates communication cost. By bypassing these steps, our approach brings inter-stage latency down from 2–5 ms to the pure data transfer overhead of less than 500𝜇s, which is further hidden by overlapping communication with computation asynchronously (reducing the effective inter-stage bubble to ∼100𝜇s).

8

<!-- page 9 of 15 -->

SiPipe: Bridging the CPU–GPU Utilization Gap for Efficient Pipeline-Parallel LLM Inference

## 6 Implementation

SiPipe is implemented in pure Python to maximize compatibility with existing inference frameworks. Specifically, it is implemented as a plugin for vLLM [27], inheriting from key Python classes and overriding selected methods to integrate seamlessly.

Unlike conventional frameworks where most computation is offloaded to GPUs, SiPipe performs sampling on the CPU. Due to Python’s Global Interpreter Lock (GIL), we adopt a multi-process architecture to fully exploit CPU parallelism.<sup>5</sup> This leads to substantial inter-process communication, which we categorize into two patterns: dispatch and combine.

For dispatch—broadcasting scheduling outputs from the scheduler to all worker and sampler processes, and broadcasting logits from the final-stage GPUs to all samplers—we design Buffered IPC Channels (BIC) using shared-memory ring buffers with a lock-ahead mechanism. We instantiate BIC-I for scheduling output and BIC-L for logits transfer. Each BIC maintains 𝑁 slots, each guarded by a mutex implemented using fcntl file locks, enabling lightweight, cross-process synchronization without busy-waiting. In iteration 𝑛, the producer pre-acquires an exclusive (write) lock on slot (𝑛 +1) mod 𝑁, writes data to slot 𝑛 mod 𝑁, and then releases the (𝑛 mod 𝑁)𝑡ℎ slot’s exclusive lock—ensuring lock-ahead progression without contention. Consumers poll slots sequentially, acquiring a shared (read) lock when a slot becomes available, which allows concurrent read access without blocking other consumers. For cross-host communication (e.g., between scheduler and remote workers), each host maintains a BIC replica, and a background daemon handles data synchronization across hosts.

For combine—aggregating sampling results from all samplers back to the scheduler—we design BIC-O, a TCP-based multi-producer ring buffer. Each slot in BIC-O contains multiple subslots, one per sampler. In iteration 𝑛, sampler 𝑖 writes its output to subslot 𝑖 of slot 𝑛 mod 𝑁. Once all subslots are filled, the scheduler detects that the microbatch is completed. Since each sampling result is typically just a token ID (i.e., an integer), this TCP-based approach is lightweight and avoids the complexity of emulating shared memory across hosts.

## 7 Evaluation

This section answers four key questions: (1) Does SiPipe deliver performance gains across diverse parallel inference configurations? (§7.2) (2) How does SiPipe impact end-to-end inference latency across diverse configurations? (§7.3) (3) How does SiPipe affect compute resource utilization across diverse configurations? (§7.4) (4) What is the contribution of each component in SiPipe’s design? (§7.5)

## 7.1 Experimental Setup

**Testbed.** Our evaluation is conducted on following testbeds: H100-NVL, A100-NVL, and A100-PCIe. Each server in H100-NVL and A100-NVL is equipped with 8 H100 or A100 GPUs connected via NVLink, respectively, while each A100- PCIe server contains 8 A100 GPUs connected via PCIe. All GPUs have 80 GB memory. Each server also features a 192- logical-core Intel(R) Xeon(R) Platinum 8468 CPU and 2 TB of host memory. Servers within the same testbed are connected via 400 Gbps ConnectX-7 NICs.

**Baseline.** We compare SiPipe against two of the most popular inference engines: vLLM [27] and SGLang [47]. Since SGLang does not support PP, we evaluate only its TP mode. For vLLM, we evaluate both TP and PP modes.

**Models.** We evaluate SiPipe using six LLMs, categorized into two groups: large LLMs—Llama-3.1-70B [37], Qwen-2.5-72B [43], and Mixtral-8×7B [24]; and ultra-large LLMs —DeepSeek V2.5 [30], DeepSeek V3 [31], and Llama-3.1-405B [37]. Based on deployment experience, large LLMs are typically served on 8 GPUs [1, 2], whereas the ultra-large models require 16 GPUs because their weights alone saturate the memory of 8 GPUs. We focus on LLMs of this scale because PP is primarily intended for multi-GPU deployments. In contrast, for smaller LLMs (e.g., 14B), pure TP is a more suitable choice. Optimizing TP performance for small LLMs is beyond the scope of this work. Data parallelism is also omitted: instances with fewer GPUs lack sufficient memory for both model weights and KV caches.

**Configuration.** The default batch size is 512 for 8-GPU and 1024 for 16-GPU experiments. In pure TP mode, PP is disabled (𝑝 = 1), and the TP degree 𝑡 equals the total number of GPUs. In PP mode, each stage forms a TP group assigned to a contiguous block of LLM layers, with 𝑝𝑡 equal to the GPU count. Empirically, setting 𝑡 = 4 per stage delivers nearoptimal intra-stage efficiency [6]. Samplers are colocated with the final stage. On this node, each worker occupies an isolated CPU core for input preparation (8 cores total), while the remaining cores are dedicated to sampling.

**Workload.** To ensure fair and reproducible comparison, we randomly select a fixed set of prompts from the ShareGPT dataset [5] and reuse them across all experiments. Decoding is performed using all common sampling strategies, including top-𝑝, top-𝑘, min-𝑝, temperature, and penalties for repetition, presence, and frequency.

**Metrics.** We report throughput, per-token latency, and resource utilization. Throughput is measured in tokens per second, and per-token latency reflects the average generation time per token. Utilization metrics reflect hardware efficiency.

## 7.2 Throughput Gains under Diverse Parallel Settings Throughput across LLMs and testbeds. Figure 8(a) shows

the throughput of large LLMs on the H100-NVL testbed using different inference engines and configurations. Compared

<small><span class="docvortex-page-footnote" data-block-type="page_footnote" style="color:#6b7280"><sup>5</sup>Future versions will explore Python 3.13’s free-threaded mode to simplify the implementation.</span></small>

9

<!-- page 10 of 15 -->

Yongchao He, Bohan Zhao, and Zheng Cao

![Image block](doc:0556421/tier:flash/page:10/block:2)

<details>
<summary>image content</summary>

vLLM (P2
)        vLLM (P4
)        vLLM (P1
)        SGLang (P1
)        SiPipe (P2
)        SiPipe (P4
)
4
2
8
8
4
2
12
20
10
Tokens/s
Tokens/s
Tokens/s
10
16
8
8
12
6
6
8
4
4
×103
×103
×103
4
2
2
0
0
0
Mixtral-8×7B
Mixtral-8×7B
Mixtral-8×7B
Llama-3.1-70B
Llama-3.1-70B
Llama-3.1-70B
Qwen-2.5-72B
Qwen-2.5-72B
Qwen-2.5-72B
(a) Using 8×H100 on the H100-NVL testbed
(b) Using 8×A100 on the A100-NVL testbed
(c) Using 8×A100 on the A100-PCIe testbed
</details>

![Image block](doc:0556421/tier:flash/page:10/block:3)

<details>
<summary>image content</summary>

Each configuration is denoted as 𝑃𝑖
𝑗
vLLM        SiPipe
10
10
Tokens/s
8
8
6
6
4
4
×103
2
2
0
0
64   128   256   512
128   256   512  1024
Batch Size
Batch Size
(a) Qwen-2.5-72B under P2
(b) DeepSeek V3 under P4
4
4
</details>

Figure 10. Effect of the number of pipeline stages (i.e., PP degree 𝑝) on throughput. In the first three subfigures, each stage uses a TP degree of 𝑡=2, while the last subfigure uses 𝑡=4. The dashed line denotes the performance of SiPipe under the default configuration.

Figure 9. Effect of batch size on inference throughput.

**Figure 8.** Throughput comparison of different engines under various parallel configurations, evaluated on multiple testbeds.

, where PP degree 𝑝 = 𝑖 and the TP degree 𝑡 = 𝑗. Specifically, 𝑃<sub>𝑡</sub> denotes the pure TP mode. 1

to vLLM (𝑃2 ), SiPipe achieves a performance gain of 1.6×4 to 2.1× by eliminating pipeline bubbles that degrade vLLM’s PP mode, especially as the number of stages increases (e.g., from 𝑃<sup>2</sup> <sub>4</sub> to 𝑃<sup>4</sup> <sub>2</sub> in vLLM). In this single-node scenario, we also observe that both vLLM and SGLang in pure TP mode outperform vLLM’s PP mode due to NVLink-enabled efficient GPU communication and better TP scalability. However, as each PP stage has a smaller TP degree (2 or 4) compared to the pure TP modes (𝑡 = 8), using PP cuts all-reduce overhead [10, 41] and is inherently more efficient. Building on this, SiPipe further addresses the inefficiencies of inter-stage coordination in prior PP implementation, enabling it to outperform pure TP modes in overall throughput.

Figure 8(b) and Figure 8(c) show results on the A100-NVL and A100-PCIe testbeds, respectively. SiPipe consistently outperforms existing frameworks across GPU architectures and interconnects, demonstrating strong generality and robustness in both NVLink- and PCIe-based environments. Notably, the speedup on A100 is smaller than on H100, as expected. H100’s 3× higher compute capability makes pipeline bubbles a more significant bottleneck relative to the forward pass. On the A100, by contrast, the forward pass dominates the runtime. This highlights an important trend—future accelerators will further reduce the relative cost of forward, making pipeline inefficiencies more pronounced. SiPipe aligns with this trend by minimizing stalls and maximizing pipeline efficiency.

Next, we revisit the 16-GPU inference results for ultralarge LLMs, previously shown in Figure 1. In this cross-node setting, SiPipe consistently outperforms all other inference engines, achieving 1.4×-1.7× improvement over the best baseline. The speedup is relatively lower than that observed for

![Image block](doc:0556421/tier:flash/page:10/block:11)

<details>
<summary>image content</summary>

vLLM        SiPipe
10
10
20
10
Tokens/s
8
8
16
8
6
6
12
6
4
4
8
4
×103
2
2
4
2
0
0
0
0
2     4
2     4
2     4
2     4
Number of Stage
Number of Stage
Number of Stage
Number of Stage
(c) Mixtral-8×7B
(a) Llama-3.1-70B
(b) Qwen-2.5-72B
(d) DeepSeek V2.5
</details>

large LLMs, primarily because the forward pass in ultra-large models takes longer to compute, which reduces the relative impact of pipeline bubbles. Notably, pure TP configurations perform worse than PP in this scenario. As confirmed in prior studies [41], the allreduce communication in TP scales poorly across machines, making them a major performance bottleneck.

**Impact of batch size on throughput.** Because production workloads rarely use a fixed batch size, we swept the batch size to gauge SiPipe’s robustness and scalability. Figure 9 presents throughput comparison for both large and ultra-large LLMs, each with a representative LLM. Under these batch sizes, SiPipe consistently delivers stable performance gains. Compared to vLLM, SiPipe achieves a speedup of 1.6-1.7× on Qwen-2.5-72B and 1.4-.17× on DeepSeek V3, demonstrating that the optimizations in SiPipe remain effective even under low-load scenarios (i.e., small batch sizes). **Scalability under multi-GPU settings.** Figure 10 demonstrates the scalability of SiPipe with varying number of GPUs. In LLM inference, it is typical to reserve KV cache memory amounting to 2–3× the LLM size [27, 41]. For example, deploying a 70B LLM generally requires > 4 GPUs [2, 6]. However, due to poor scalability in existing inference engines, adding GPUs to a single instance often yields less benefit than running multiple smaller ones–an approach that only works when all sequences are short, which is rarely the case in production.

10