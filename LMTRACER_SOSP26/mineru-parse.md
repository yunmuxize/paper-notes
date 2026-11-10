<!-- page 1 of 15 -->

# LMTracer: Fine-Grained and Real-Time Performance Profiling for Production LLM Systems

Wei Liu†‡, Yongchao He‡, Bohan Zhao‡, Hongyi Wang<sup>‡</sup>, Zhenhua Li<sup>‡∗</sup>, Junping Zhao<sup>†∗</sup> †Rank Computing ‡Tsinghua University

## Abstract

Training and serving large language models (LLMs) has become a core business for AI providers. To ensure a highquality user experience while optimizing infrastructure costs, providers need to closely monitor the performance of LLM executions in production. However, existing performance profiling tools fall short in this context, as they are either too coarse-grained to capture performance bottlenecks, or too intrusive to avoid significant performance degradation.

This paper presents LMTracer, a fine-grained and realtime performance profiling framework for production LLM services. We find that the inefficiency of existing techniques mainly stems from disruptions in highly asynchronous GPU execution flows. To address this, our key idea is to embed profiling logic into the execution through graph-embedded probing. This is achieved by compiling lightweight probe kernels that realize profiling logic as special trace nodes in GPU execution graphs, and streaming buffered profiling data to CPUs on demand to keep the execution of user kernels uninterrupted. LMTracer has been deployed in production for eight months. It incurs only 0.9% average overhead across various LLM workloads (e.g., training, serving, and fine-tuning), and has proactively uncovered 15 performance issues. After fixing these issues, we observed 21.2% latency reduction and 24.5% throughput improvement for LLM services.

CCS Concepts: • **Computing methodologies** →**Artificial intelligence**; • **General and reference** → **Performance**; • **Computer systems organization** → Parallel architectures; • **Hardware** → Hardware accelerators.

Keywords: Large Language Models; GPU Kernels; Real-time GPU Performance Profiling; Production Observability

## ACM Reference Format:

Wei Liu, Yongchao He, Bohan Zhao, Hongyi Wang, Zhenhua Li, Junping Zhao. 2026. LMTracer: Fine-Grained and Real-Time Performance Profiling for Production LLM Systems. In Symposium on Operating Systems Principles (SOSP ’26), September 29–October 2,

2026, Prague, Czech Republic. ACM, New York, NY, USA, 15 pages. [https://doi.org/10.1145/3830418.3843871](https://doi.org/10.1145/3830418.3843871)

## 1 Introduction

Large language models (LLMs) have been emerging as a cornerstone of today’s AI applications, powering a variety of services from chatbots to general problem solving and beyond [38, 51]. In the meantime, training and serving these models at scale becomes an important business and a primary source of revenue for mainstream AI providers [61, 68]. For example, OpenAI reported an 82% revenue increase from its serving business in 2025 [4], and AWS saw a 24% quarterly revenue increase in its training services [43].

However, training and serving LLMs is oftentimes resourceintensive and performance-sensitive. Training a single LLM can cost millions of dollars and require thousands of GPUs over weeks or months [50, 69], while serving these models to a large and concurrent user base demands substantial scheduling and optimizing capabilities on the infrastructure and computational resources [65]. Even a small performance degradation of a GPU (e.g., 20%) during distributed training can lead to significant training cost increases (e.g., 38%) [41], and a small latency increase (e.g., 1 s) in the serving phase can lead to a large number of user requests being dropped and thus cause significant revenue loss [3, 73].

In such a context, AI providers need to closely monitor the performance of their LLM training and serving systems in production, so as to ensure the optimal utilization of resources and a smooth user experience. To this end, LLM profiling tools [16, 21, 42] are a common practice that help identify inefficiencies and validate the optimizations. Unfortunately, our two-year experience in operating LLM systems at scale reveals that existing tools struggle to meet the needs of fine-grained and real-time profiling in practice. They are either too coarse-grained to capture performance insights, or too heavyweight to obtain accurate profiling data without significantly affecting the performance in production<sup>1</sup>.

• **Telemetry-based monitoring.** Telemetry-based monitoring is achieved by aggregating high-level performance metrics such as token throughput, iteration time, and endto-end latency of user requests. These metrics are often available in LLM frameworks like vLLM [46], SGLang [71],

<small><span class="docvortex-page-footnote" data-block-type="page_footnote" style="color:#6b7280"><sup>∗</sup>Corresponding authors.</span></small>

<small><span class="docvortex-page-footnote" data-block-type="page_footnote" style="color:#6b7280">[This work is licensed under a Creative Commons Attribution 4.0 International License.](https://creativecommons.org/licenses/by/4.0)</span></small>

<small><span class="docvortex-page-footnote" data-block-type="page_footnote" style="color:#6b7280">SOSP ’26, Prague, Czech Republic</span></small>

<small><span class="docvortex-page-footnote" data-block-type="page_footnote" style="color:#6b7280">© 2026 Copyright held by the owner/author(s).</span></small>

<small><span class="docvortex-page-footnote" data-block-type="page_footnote" style="color:#6b7280">ACM ISBN 979-8-4007-2585-2/26/09</span></small>

<small><span class="docvortex-page-footnote" data-block-type="page_footnote" style="color:#6b7280">[https://doi.org/10.1145/3830418.3843871](https://doi.org/10.1145/3830418.3843871)</span></small>

<small><span class="docvortex-page-footnote" data-block-type="page_footnote" style="color:#6b7280"><sup>1</sup>Although offline profiling imposes less stringent overhead constraints, it may fail to accurately reflect real-world performance, as execution patterns can differ substantially between offline and production environments.</span></small>

550

<!-- page 2 of 15 -->

SOSP ’26, September 29–October 2, 2026, Prague, Czech Republic

Wei Liu et al.

and Megatron-LM [60]. They can also be measured by tools like eBPF [30], which record data mostly over CPUs.

While these methods are lightweight and easy to use, they typically provide limited performance insights, especially regarding the GPU execution time of LLM components.

• **Kernel-level profiling.** To overcome the limitations of telemetry-based monitoring, kernel-level profiling tools such as NVIDIA CUPTI [15], Nsight Systems [16], AMD ROCm Systems Profiler [19], and PyTorch Profiler [21] can be used to capture fine-grained performance traces at GPU kernels. However, these tools are too intrusive in practice, and sometimes hardware-dependent, incurring significant overheads and leading to inaccurate performance measurements [42]. Consequently, they are restricted to offline profiling or debugging, and are not suitable for monitoring real-time performance in production LLM systems.

To understand the essential challenges behind real-time profiling in production, we conduct a comprehensive study on the existing tools, finding that the highly asynchronous yet streamlined nature of GPU executions forms the root cause. Specifically, to minimize the idle time during LLM executions, almost all GPU architectures employ an asynchronous execution model [2], where CPUs issue tasks (e.g., computing and communication kernels) to GPUs in a non-blocking manner, and the GPUs execute these enqueued kernels concurrently without being blocked by the operations from CPUs. These kernels are oftentimes fused together in a streamlined manner as a single execution graph (e.g., through PyTorch Inductor [1] and CUDA/HIP Graph [8, 11]) to reduce the GPU idle time on launching different kernels.

When profiling tools collect profiling data, however, they often interrupt the streamlined GPU executions with intrusive barriers to make the timeline data accurate. For example, they may insert CUDA/HIP Events [7, 12] to record the wall time of GPU kernel executions. This process not only disrupts the streamlined execution (since only kernels rather than runtime events can be fused together [1]), but also introduces significant synchronization overheads.

This paper presents LMTracer, a fine-grained and realtime performance profiling framework for production LLM systems. Our key idea is to embed profiling logic into GPU execution through graph-embedded probing, so as to eliminate disruptions on asynchronous GPU executions. To this end, LMTracer employs special probe kernels, which are lightweight GPU kernels that enclose original LLM kernels, allowing users to specify profiling logic (e.g., record timestamps). They are compiled to GPU execution graphs and executed in order with LLM kernels, while asynchronously collecting and streaming profiling data without introducing barriers.

To realize the above idea, we need to address several challenges. Specifically, if we insert probe kernels at arbitrary locations in the execution graphs captured by GPUs, we may break kernel fusion and cause performance degradation. To

overcome this, LMTracer employs stack-aware compilation, which recursively tracks compile-time operator call hierarchies and their source-level code regions during kernel fusion. Using this information, LMTracer determines the optimal locations in execution graphs to insert probe kernels, and thus keeps a streamlined execution graph without interfering with the fused operators or affecting the performance.

At runtime, profiling data should be collected in real time without introducing barriers. Existing profilers fail to achieve this as they depend on barriers to ensure data alignments. To address this, we devise doorbell-assisted shadow buffering. It does not directly write the profiling data to the CPU memory (which is slower and introduces barriers), but instead writes the data together with the GPU clock value to two faster shadow GPU buffers, and proactively streams the buffer data to the CPU based on a “doorbell” signaling protocol when a shadow buffer is full. LMTracer then calibrates the collected data with GPU clock offsets (recorded once before the execution) on CPUs. In the meantime, probe kernels continue to write the data into the other shadow GPU buffer and thus avoid CPU-GPU synchronizations.

After collecting profiling data, LMTracer provides actionable insights for developers to optimize LLM systems through its profiling interfaces. In particular, LMTracer automatically analyzes the LLM execution graph by replaying the collected data, and quickly identifies potential performance bottlenecks or inefficiencies with the execution dependency information among different kernels and GPUs.

LMTracer has been deployed on a variety of LLM systems in our production environment for eight months, including vLLM, SGLang, and Megatron-LM, for both training and serving, with model sizes ranging from 7B to 671B parameters and GPUs of O(1k). On average, it only incurs 0.9% overhead while providing kernel-level profiling granularity, such as measuring the execution time of attention, multi-layer perceptron (MLP), and layer normalization, etc. Compared to the existing profilers like NVIDIA Nsight Systems [16] and PyTorch Profiler [21], LMTracer reduces profiling overheads by 11.6× with comparable accuracy.

LMTracer has proactively uncovered 15 latent performance issues, such as imbalanced GPU utilization and straggler GPUs. After fixing these issues, we improve the training throughput by 24.5% and reduce the serving latency by 21.2%.

This work makes the following contributions.

• We identify the challenges of performance profiling in production LLM systems, i.e., the disruptions of the asynchronous yet streamlined GPU executions.

• We propose LMTracer, a lightweight and real-time profiler that embeds probe kernels into GPU execution graphs to eliminate disruptions on asynchronous executions.

• We show our experience in applying LMTracer to production LLM systems. It identifies many performance issues, leading to significant resource utilization improvements.

551

<!-- page 3 of 15 -->

LMTracer: Fine-Grained and Real-Time Performance Profiling for Production LLM Systems

SOSP ’26, September 29–October 2, 2026, Prague, Czech Republic

![Image block](doc:6257f5c/tier:flash/page:3/block:3)

<details>
<summary>image content</summary>

Serving: Autoregressive Generation
Training: Forward Propagation
Output Tokens
User Requests
or Loss
or Datasets
Training: Backward Propagation
</details>

Figure 1. General workflow of LLM training and serving.

Code and data are publicly available at [https://llm-profiling.github.io](https://llm-profiling.github.io). This paper does not raise any ethical issues.

## 2 Background

Large language models (LLMs) are widely used in many real-world scenarios, such as chatbots [56], content generation [45], industrial control [34], and fundamental research [27, 53, 72]. Training and serving LLMs is currently the core business of AI providers like OpenAI [17], Google [10], and Meta [13]. However, such a business is extremely resourceintensive, requiring massive GPU infrastructure and computational power [35]. For example, training Llama3 requires thousands of GPUs running for weeks to months [31], and serving LLMs on the market demands hundreds of GPUs to handle user requests in real time [68].

**LLM training and serving workflows.** From the system perspective, the general workflows of LLM training and serving are illustrated in Figure 1. A single LLM training/serving task can be split across multiple GPUs by various parallelism techniques like data parallelism (DP), pipeline parallelism (PP), and tensor parallelism (TP) [50], so as to handle the increasing model size and massive data. DP replicates the entire model as shown in the different color planes in Figure 1, while PP partitions the model layers horizontally into different stages. In each PP stage, model layers are further partitioned vertically across the GPUs through TP.

With these parallelism techniques, when training starts, the forward and backward passes are performed iteratively until the training loss converges. Different GPUs are assigned different data batches, and different GPUs cooperate to complete the forward and backward passes. Any inefficiency in this workflow, such as suboptimal parallelism strategies [40], straggler GPUs [48, 67, 69], or network bottlenecks [49, 50], can lead to significant slowdowns and increased costs [58].

For LLM serving, the end-to-end serving process starts with user requests (i.e., user prompts) and ends with output tokens. Each user request is first processed by a scheduler that routes and enqueues it to the appropriate DP replica based on the service level agreement (SLA) and the current load of the LLM system. The DP replica then performs the prefill phase, which generates the initial KV cache [51, 59] for the prompt, and enters the decode phase to generate output

tokens in an autoregressive manner (i.e., generating one token at a time based on the previously generated tokens).

**Kernel fusion.** Almost all of today’s GPUs employ an asynchronous execution model to maximize hardware utilization, where the CPU enqueues kernels for computation or data transfer to the GPU, and the GPU launches and executes them in order [2] without mutual blocking on the CPU side. To fully take advantage of this asynchronous execution model, existing LLM frameworks typically use various kernel fusion techniques to combine multiple operators into a single large kernel, so as to reduce the kernel launch overhead and improve both CPU and GPU utilizations [1].

Figure 2 exemplifies the kernel fusion process of the layer normalization of a mainstream model, where the original implementation consists of four separate steps to compute the final output (i.e., the operators including power, addition, reciprocal square root, and multiplication), while the fused implementation combines these steps into a single kernel. In this way, LLM frameworks only launch one fused kernel instead of launching multiple kernels for each of the operators, thus significantly reducing the kernel launch overhead and improving the LLM performance.

**Graph execution.** Different fused kernels can be further organized together to form an execution graph on GPUs, so that these fused kernels are launched together without introducing idle time between two adjacent kernels. Such a graph execution scheme especially benefits the LLM training and serving workflows, since their computation often consists of a sequence of kernels that are executed iteratively. According to previous reports, graph execution schemes, such as CUDA graphs on NVIDIA GPUs, can improve LLM performance by up to 3× [55]. Thus, using graph execution and kernel fusion is a common practice for LLM frameworks to optimize the performance of LLM training and serving.

## 3 Motivation

To ensure efficient and reliable execution of LLM training and serving workloads, AI providers need to closely monitor the real-time performance of their systems in production, so as to guide resource allocation and anomaly detection. Unfortunately, our two years of experience in operating LLM training and serving workloads in production has revealed that existing profiling solutions are inadequate for the challenges posed by LLM workloads. Table 1 summarizes the concrete limitations of the mainstream profiling tools.

Specifically, simple profiling solutions based on the aggregation of LLM framework-level metrics or telemetry (e.g., CPU, GPU, and memory usage) are insufficient for capturing the complex interactions between different components of LLM workloads, and often fail to provide actionable insights for performance optimization. They cannot even distinguish which GPU kernels or user code causes the inefficiency. For example, a low token throughput can be caused by many

552

<!-- page 4 of 15 -->

SOSP ’26, September 29–October 2, 2026, Prague, Czech Republic

Wei Liu et al.

![Image block](doc:6257f5c/tier:flash/page:4/block:3)

<details>
<summary>image content</summary>

Input
Initial        Result 1
1e-6
pow
add
Result 2
rsqrt
Fused
Result 3
Kernel
mul
Result 4
Output
</details>

Figure 2. Example of kernel fusion on layer normalization.

![Image block](doc:6257f5c/tier:flash/page:4/block:5)

<details>
<summary>image content</summary>

Training-70B
Perf. Degradation (%)
64
Serving-32B
Serving-671B
16
4
CUPTI   Nsight
Runtime
PyTorch
Events
Profiler
Systems
</details>

Figure 3. Performance degradation incurred by different profiling tools.

![Image block](doc:6257f5c/tier:flash/page:4/block:7)

<details>
<summary>image content</summary>

Instrumentation Overhead (us)
16
Low-end GPU
Mid-range GPU
High-end GPU
12
8
4
0
CUPTI   Nsight
Runtime
Embedded
Events
Kernel
Systems
</details>

Figure 4. Instrumentation overhead incurred by different mechanisms.

Table 1. Comparing existing profiling tools for LLM systems, where Kernel Profiling stands for kernel-level profiling, Kernel Fusion represents the ability to distinguish fused kernels, Stack Trace is the ability to capture stack traces, Transparent is the ability to avoid user code modification, and Real-Time stands for the ability to capture performance data in real time.

| Tool | Kernel Profiling | Kernel Fusion | Stack Trace | Transparent | Real-Time |
| --- | --- | --- | --- | --- | --- |
| Framework Metrics | % | % | % | ! | ! |
| CUPTI | ! | % | % | % | % |
| Nsight Systems | ! | % | % | ! | % |
| Runtime Events | ! | % | % | % | ! |
| PyTorch Profiler | ! | % | ! | ! | % |
| LMTracer | ! | ! | ! | ! | ! |

factors like inefficient GPU kernel, suboptimal scheduling, or network bottlenecks, but the framework-level telemetry may not be able to pinpoint the root cause. As a result, they are often used for coarse-grained monitoring and alerting, rather than fine-grained performance tuning or optimization.

To overcome the above issue, there have been a number of fine-grained profilers on top of LLM frameworks, such as CUPTI [15], Nsight Systems [16], and PyTorch Profiler [21]. These tools expose fine-grained, kernel-level performance traces on GPUs. However, they are primarily designed for offline performance analysis. When applied to production workloads, we observed that they have significant limitations, especially in terms of their overhead and debugging capabilities. Note that although offline performance analysis can also be used for performance optimization, it is often not sufficient for production workloads, since the performance of LLM systems is highly sensitive to real-time input data.

**Vendor-specific profilers.** The official profiling tools provided by GPU vendors, such as CUPTI [15], Nsight Systems [16], and ROCm Systems Profiler [19], only capture kernel-level performance, and cannot capture user code. This makes it difficult to correlate and optimize the performance with the concrete implementation of LLM workloads. In addition, these tools are originally designed for offline performance analysis, and typically introduce significant overhead when applied to production. As shown in Figure 3, when training a 70B LLM, profilers like CUPTI and Nsight Systems

introduce 5.2% and 7.2% performance degradation in terms of the iteration time, respectively. When applied to LLM serving, the degradation rises to 9.1% and 10.2%.

Moreover, when we examine their trace data, we find that these tools cannot distinguish the fused kernels. This is because the fused kernels are generated before the graph execution on GPUs (cf. § 2), and thus the vendor-specific profiling tools have no visibility into their internal operations.

**Runtime events.** Commodity GPUs also provide a set of APIs for users to insert runtime events (e.g., CUDA/HIP Event [7, 12]), so as to record the corresponding event timestamp for performance tracing. However, these events require users to modify their code base, which is a barrier for adoption in production as well as for future maintenance. Runtime events also incur over 12% performance degradation when capturing crucial LLM execution phases like attention and MLP (as shown in Figure 3). Worse still, they are incompatible with kernel fusion and graph optimizations.

**Framework-oriented profiler.** Some LLM frameworks provide their own profilers (e.g., PyTorch Profiler [21]) to capture both kernel performance data and user stack traces. Unfortunately, they are not designed for real-time performance profiling either, and introduce significant overhead when applied to production workloads. As shown in Figure 3, when training a 70B LLM, PyTorch Profiler introduces 74.8% performance degradation on iteration time, and 83.4% decrease in token throughput when applied to LLM serving.

553

<!-- page 5 of 15 -->

LMTracer: Fine-Grained and Real-Time Performance Profiling for Production LLM Systems

SOSP ’26, September 29–October 2, 2026, Prague, Czech Republic

![Image block](doc:6257f5c/tier:flash/page:5/block:3)

<details>
<summary>image content</summary>

Executor Binding
Async Copy to CPU
Call Stack        Exporter
Critical
Anomaly
Code Region
Profiling
Performance
Profiling
GPU
Reasoning        Probe Kernel
Shadow        Data
Dependency
Detection
Mapping
Configuration
Insights
Exec.
Buffers
Embedding
Stack-Aware Compilation        Trace Data Shadow Buffering
Bottleneck Analysis
</details>

Figure 5. Architectural overview of LMTracer.

**Limitations and implications.** In summary, existing LLM profiling tools cannot meet the requirements of real-time performance profiling in our production environments. Vendorspecific and runtime event APIs cannot capture user-level stack traces, thus omitting the semantic mapping between the performance and the implementation. Profilers in LLM frameworks can capture a part of the user-level stack trace, but they cannot handle the kernel fusion and graph optimizations that are widely used in LLM workloads.

Runtime overheads of all the existing tools are significant, since they introduce additional barriers or instrumentation instructions. We performed a detailed analysis on the overheads of the barriers or instrumentation instructions introduced by the existing tools. As shown in Figure 4, vendor-specific profilers introduce at least 13 µs for a single instrumentation point. On the other hand, if we directly embed GPU kernels to record crucial timestamps over GPUs for performance tracing, we can reduce the overhead to only 0.7–0.9 µs for each trace point (as shown in Figure 4), which is significantly lower than the existing tools. This is easy to understand because GPU kernels are the basic execution units on GPUs. As a result, using kernels to record timestamps is naturally compatible with the other user kernels, and will not break the graph executions, thus mitigating the overheads of the profiling process. If we further design a set of lightweight GPU kernels to fully utilize the asynchronous execution of GPUs, we can reduce the overhead and enable real-time performance profiling.

## 4 System Overview

Building on the above insight, LMTracer enables fine-grained, real-time performance profiling of production LLM systems through graph-embedded probing. As shown in Figure 5, the core of LMTracer is to embed special probe kernels into the original GPU execution graph of LLM workload. These probe kernels capture in-situ performance traces, and stream them to CPUs asynchronously without affecting original execution flows. LMTracer also provides a set of interfaces that allows developers to profile at different granularity levels with a simple configuration (which is independent of the user’s code base), and a dependency-guided trace analysis engine that reconstructs the execution graph to attribute the performance bottlenecks to different system components.

Specifically, LMTracer takes the user configuration for profiling as the input, and performs the following steps to generate performance traces at the production scale.

• Stack-Aware Compilation (§5.1). Since the user can specify any modules, functions, or even code regions to be profiled, LMTracer needs to ensure that the probe kernels are correctly inserted into the execution graph without breaking the original execution and kernel fusion. To achieve this, LMTracer performs stack-aware compilation that recursively analyzes the static function call stacks of code regions on kernel fusion. During the compilation of the fused kernel, LMTracer inserts the probes that bound user operators in their corresponding call hierarchies based on the profiling configuration. In this way, LMTracer locates the probe kernels at the right positions for later graph capturing and execution of LLM frameworks.

• Doorbell-Assisted Shadow Buffering (§5.2). When LLM systems execute the model, the inserted probe kernels are launched with the original kernels to record the timestamps and other profiling data on GPUs. Existing profilers usually require the CPU to synchronize with the GPU to retrieve the performance data, causing significant performance perturbation to LLM execution. To address this, we devise a buffering mechanism that allows the probe kernels to write the data into one of the two shadow GPU buffers, while the CPU reads from the other buffer asynchronously based on a “doorbell” signal without waiting for the GPU. Thus, we eliminate the need for barriers.

• Bottleneck Analysis (§5.3). After collecting the performance traces from GPUs through the probe kernels, LMTracer automatically reconstructs the dependencies in the execution graph of the LLM system. It then performs bottleneck analysis to identify the straggler nodes, GPUs, or RDMA NICs (RNICs) that stagnate the execution flows. LMTracer also maps the bottlenecks back to the user-specified code lines if the bottlenecks are relevant to CPU or GPU execution, which allows developers to quickly locate the issues and optimize the implementation accordingly.

## 5 Design

## 5.1 Stack-Aware Compilation Profiling configuration.

LMTracer provides users with a set of profiling configuration interfaces. It enables users

554

<!-- page 6 of 15 -->

SOSP ’26, September 29–October 2, 2026, Prague, Czech Republic

Wei Liu et al.

to specify code regions or LLM modules to be profiled and the relevant profiling data to be collected or aggregated. As shown in Listing 1, users can define probes at module, function, and code region levels. The initial profiling configuration can be derived from the model structure, i.e., the LLM’s high-level components and execution stages such as attention, MLP, and communication. Such a coarse-grained execution view is sufficient for LMTracer to localize performance issues to specific components or stages. Without this execution view, instrumenting every detailed step of model execution would introduce unnecessary complexity and is impractical for production environments.

Users can specify different LLM frameworks, and LM-Tracer automatically adapts the instrumentation process to the corresponding framework (cf. §5.2). The configuration also supports multiple exporters to save collected trace data for offline analysis or export metrics to analytics systems such as Prometheus [18] and Flink [29] for real-time performance tracking. The configuration effort is a one-time setup, and the same configuration can be reused across subsequent runs without additional overhead.

**Probe kernel.** With user-defined profiling configurations, LMTracer instruments the LLM execution by inserting lightweight probe kernels at the specified code regions or module boundaries. These probe kernels are designed to collect critical runtime data on GPUs, in particular GPU kernel execution time. This is achieved by leveraging raw GPU assembly instructions in the probe kernel to read the GPU clock cycle register (e.g., read the globaltimer register for NVIDIA GPUs [36, 42] or invoke the s\_memtime instruction for AMD GPUs [37]) before (or after) the execution of the target kernels and code regions defined in the profiling configuration (as exemplified in Listing 1), and calculating the execution time by differentiating the two clock values.

Unlike existing fine-grained profiling approaches that are intrusive to user kernels by altering kernel instructions [42], LMTracer does not modify the original user kernels so that the data collected by probe kernels preserve high fidelity and accuracy. Also, probe kernels do not modify the runtime states of the user kernels (e.g., registers, shared memory, and local memory [66]), which effectively avoids the state restoration overhead and performance degradation. Users can also customize probe kernels to collect additional traces such as the intermediate output between kernels [47].

**Stack-aware compilation.** To support flexible profiling over widely used GPU kernel fusion techniques [63], LM-Tracer needs to overcome a key challenge—the loss of visibility into the internal execution of the user kernels after the kernel fusion. Specifically, a single fused kernel can contain multiple logical operations from different code regions defined by the users (cf. §3). A single code region to be profiled can be fused into different kernels as well. After kernel fusion, the resulting kernels can be captured by CUDA/HIP

Listing 1. Example instrumentation configurations of LM-Tracer for SGLang runtime probing and data exporting.

![Image block](doc:6257f5c/tier:flash/page:6/block:9)

<details>
<summary>image content</summary>

llm_engine: sglang
probes:
# LLM modules
- phase: attention
module: sglang.srt.models.gpt_oss.GptOssAttention
# Functions or even code lines
- phase: norm
function: sglang.srt.layers.layernorm.RMSNorm.
forward_cuda
# Optional: Flexibility for code-line profiling
line_start: 109
line_end: 126
exporters:
# Exporter 1: Save binary trace data to files
- module: lmtracer.core.exporter.
FileByteDataExporter
params:
output_dir: /tmp/lmtracer_exports
# Exporter 2: Export metrics to Prometheus
- module: lmtracer.core.exporter.
SGLangMetricPrometheusExporter
params: {}
</details>

Graphs [8, 11], allowing the captured execution graph to be launched with a single CPU-side API call, thereby reducing kernel launch overhead. If we simply insert probe kernels at the boundaries of the user-defined code regions, we may break kernel fusion results and significantly degrade the performance. This is because probe kernels are not the basic operators (e.g., arithmetic operators such as addition and multiplication) that can be fused into one kernel.

To address this, we design stack-aware compilation that inserts probe kernels according to operator call stacks during compilation. This mechanism performs a compile-time static analysis on the user code. Specifically, when LLM frameworks compile user operators into kernels (e.g., through PyTorch Inductor [1]), it needs to symbolically execute the user code to collect tensor operations involved in kernel generation [9]. During this process, function calls into and out of different code regions of LLM execution can be tracked, forming a static call stack that records the source-code locations associated with each operator. LMTracer uses this call stack information to track the origin of each operator.

After recursively backtracking all call stacks that lead to the operator in each kernel, LMTracer checks whether the call stacks intersect with user-defined profiling regions. If so, LMTracer records the corresponding kernel, thereby establishing a mapping between compiled (potentially fused) kernels and user-defined code regions. Finally, probe kernels are inserted at the boundaries of compiled kernels (rather than between arbitrary user operators) that cover the target

555

<!-- page 7 of 15 -->

LMTracer: Fine-Grained and Real-Time Performance Profiling for Production LLM Systems

SOSP ’26, September 29–October 2, 2026, Prague, Czech Republic

![Image block](doc:6257f5c/tier:flash/page:7/block:3)

<details>
<summary>image content</summary>

Graph Execution
qwen3.py
Direct Operator Stack
Forward Enter
# attn_start
linear.py
Attn Enter
QKVParallelLinear
Parent Stacks
RowParallelLinear
Ops for Kernel A
Fused Kernel A
get_rope
Ops for Kernel A
qwen2.py
Attention
# forward_start
QNorm
Attn Exit
hidden_states=
KNorm
Norm Enter
layernorm.py
self.self_attn
# attn_end
# norm_start
Op1 of layernorm for Kernel A
Fused Kernel B
attention_norm
Op1 of layernorm for Kernel B
Op2 of layernorm for Kernel A
# norm_end
Op2 of layernorm for Kernel B
Op3 of layernorm for Kernel B
Norm Exit
# forward_end
Op4 of layernorm for Kernel B
Forward Exit
…
Fused Kernel C
</details>

Figure 6. Stack-aware compilation to identify operator fusion and probe kernel insertion points in execution graphs, where colored arrows indicate the mappings from source code through operator call stacks to the fused kernels.

code regions, so that execution time is measured at runtime without disrupting kernel fusion.

As exemplified in Figure 6, suppose the user defines three code regions (i.e., forward, attn, and norm) in the configuration file for profiling, where the forward region contains the entire forward pass of the model in the qwen2.py source file, attn is the attention module in a single decoder layer in qwen3.py, and norm is the normalization process after all the decoder layers in qwen2.py. LMTracer hooks into the compilation process and first finds that the operators in Fused Kernel A directly originate from the code regions in both linear.py and layernorm.py (i.e., the code lines shown in blue in the two source files). Nevertheless, these two files have no user-defined code regions for profiling.

LMTracer then backtracks the call stacks of these operators, and discovers that the operators in the linear part of Fused Kernel A are derived from the user-defined attn code region in qwen3.py, whose stack frame is delimited by attn\_start and attn\_end. By further tracing upward, LMTracer confirms that this attn region is itself nested inside the outer forward region in qwen2.py, bounded by forward\_start and forward\_end, which is defined by the user in the profiling configurations. Therefore, Fused Kernel A is simultaneously associated with two user-defined regions, i.e., attn and forward. Since it is the first time that the call stack activates the attn region<sup>2</sup>, LMTracer inserts an Attn Enter probe at the beginning of Fused Kernel A, so that the probe kernel can record the entry time of attn.

For the operators in Fused Kernel B, they are directly derived from layernorm.py when they are compiled (i.e., the code lines shown in yellow in layernorm.py), and eventually from the norm region in qwen2.py. Thus, they are inside the user-defined norm\_start and norm\_end regions, nested inside the outer forward region. However, they are

<small><span class="docvortex-page-footnote" data-block-type="page_footnote" style="color:#6b7280"><sup>2</sup>The forward region is not the first time that the call stack enters, as we omit some other operations before attention regions for simplicity.</span></small>

not intersected with the previous attn region in qwen3.py, which was activated when Fused Kernel A was compiled. We therefore determine that the attention region is deactivated when Fused Kernel B is sequentially compiled after Fused Kernel A<sup>3</sup>, so we insert an Attn Exit probe at the beginning of Fused Kernel B, and a Norm Enter probe at the same time to indicate that the call stack has left the attn region and the norm region is now activated. Note that the forward region is still active during the compilation of Fused Kernel B.

Finally, when the compiler fuses the operators in Fused Kernel C, LMTracer finds that the fused operators have no call stack intersection with the user-defined code regions, which means that we need to deactivate all the active regions (i.e., norm and forward) before Fused Kernel C is executed. Thus, we insert a Norm Exit and a Forward Exit probe before Fused Kernel C to record the corresponding timestamps.

Based on this stack-aware recursive analysis, LMTracer determines the kernel boundaries that correspond to userdefined profiling regions and inserts probe kernels accordingly. The profiling granularity is defined by user-specified regions rather than individual kernels, as a single region may span one or multiple compiled kernels due to kernel fusion. Therefore, LMTracer automatically identifies the boundary kernels covering the target regions and inserts probes without requiring any user intervention or modifications to the original codebase. Such a probe kernel incurs at most 0.9 µs overhead as we have reported in Figure 4. Also, even if multiple operators from different source files are fused into GPU kernels (e.g., Fused Kernel A–C in the figure), LMTracer can still faithfully reconstruct the logical execution boundaries.

**Kernel-level granularity.** During the above stack-aware compilation, LMTracer can encounter the case where the user-defined trace point is inside a fused kernel, although this is rare (<2% of the trace points in production since in most cases profiling targets are aligned with operator or kernel boundaries). To address this, LMTracer supports two modes of probe kernel insertion. The first is inserting probes at the nearest fused kernel boundaries, and the second is splitting the kernel for exact probe placement. By default, LMTracer adopts the first mode to avoid perturbing execution behavior. If finer granularity is required, LMTracer can switch to the second mode to split the kernel and place probes at the exact location. Nevertheless, this mode is primarily intended for offline investigation because it modifies the generated code and may perturb the original performance characteristics.

**Code line hashing and probe merging.** The above probe insertion point information is used as the input parameter for the probe kernels, so that they can generate the trace data with the mapping information between the GPU kernel execution and the user-defined code regions.

<small><span class="docvortex-page-footnote" data-block-type="page_footnote" style="color:#6b7280"><sup>3</sup>These fused kernels are also sequentially executed at runtime.</span></small>

556

<!-- page 8 of 15 -->

SOSP ’26, September 29–October 2, 2026, Prague, Czech Republic

Wei Liu et al.

To parameterize this information, LMTracer hashes the source file and code lines to generate a unique integer identifier. This integer identifier will be translated back to the source file when LMTracer processes the trace data. To further reduce the number of inserted kernels and reduce the profiling overhead, LMTracer merges the probes that are inserted at the same kernel boundary. In the above example, the Attn Exit and Norm Enter probes are merged at the beginning of Fused Kernel B. The Norm Exit and Forward Exit probes are merged at the beginning of Fused Kernel C for the same reason. These merged probes are assigned a new hash value for later identification.

**CUDA/HIP graph compatibility.** Probe kernels are compatible with the CUDA/HIP graph execution, which is especially important for profiling LLM executions in production environments. As we have discussed above (cf. §2), to reduce the intermittent kernel launch overhead, today’s LLM frameworks widely take advantage of the graph execution mechanism provided by the GPU vendors (e.g., CUDA graph [8] and HIP graph [11]). Specifically, before the actual training or inference process, the LLM framework first captures a sequence of GPU kernel executions of the LLM workload into a CUDA/HIP Graph during a warm-up iteration [55]. The captured graph can then be replayed in subsequent iterations with a single CPU-side launch call, thereby reducing the overhead of launching individual kernels.

The probe kernels inserted by LMTracer are treated as normal GPU kernels by the GPU driver and can therefore be captured into the CUDA/HIP graph together with user kernels during the warm-up iteration. For non-linear CU-DA/HIP graphs, LMTracer remains compatible because the kernel-to-region mapping established during compilation is independent of the graph topology, rather than relying on a linear kernel ordering. When the graph is replayed for subsequent iterations, the inserted probe kernels are seamlessly executed together with the user kernels in the graph. Such a process does not break graph-based execution, while still allowing LMTracer to collect trace data.

## 5.2 Doorbell-Assisted Shadow Buffering

The probe kernels inserted by the stack-aware compilation mechanism collect the trace data and export it to the exporters defined by the users. During this process, we need to efficiently manage the data transfer between the GPU and CPU to avoid barriers and minimize the performance overhead. Some approaches defer the data transfer until the end of LLM executions to avoid the barriers, but this leads to large memory usage, and is not suitable for our real-time performance monitoring. Some other approaches perform data transfer after each kernel execution, but this causes significant perturbation to the original execution flows.

To enable zero-barrier profiling in real time, LMTracer employs a doorbell-assisted shadow buffering mechanism. As

![Image block](doc:6257f5c/tier:flash/page:8/block:9)

<details>
<summary>image content</summary>

Current Buffer Pointer        GPU
Shadow Buffer A        Shadow Buffer B
Buffer Full
Write
Doorbell Signal
Pointer
GPU-CPU Mapped Memory
Async
Trigger
_threadfence_system
Copy
CPU
Trace Buffer        Poller Thread
</details>

Figure 7. Doorbell-assisted shadow buffering mechanism to mitigate barriers on profiling LLM executions.

shown in Figure 7, LMTracer allocates two GPU-side shadow buffers (i.e., Buffer A and Buffer B) for storing profiling data (e.g., GPU clock values and trace point information) collected by probe kernels. The probe kernels write data into the current shadow buffer and switch to the other buffer when it becomes full. Meanwhile, LMTracer writes a doorbell signal to CPU-GPU mapped memory [22, 23, 44] to notify the CPU that the full buffer is ready for transfer. A background CPU poller monitors the doorbell signal and asynchronously transfers the full buffer in a separate GPU stream, while probe kernels continue writing to the other buffer. This design allows GPU execution and data transfer to proceed concurrently without synchronization overhead. LMTracer exports the collected trace data through user-defined exporters for further analysis (cf. §5.3).

**Buffer management and consistency guarantee.** To ensure correctness and robustness under high profiling rates, LMTracer uses a lightweight backpressure-free policy. When both shadow buffers become full, newly collected traces overwrite old traces rather than blocking LLM execution. Nevertheless, in long-term practice till now, we have not observed both buffers being full at the same time. A 1 MB shadow buffer is sufficient to store profiling data for over 200 iterations of a 671B-parameter LLM, and the occupancy of the inactive buffer remains below 5% in our production workloads. Moreover, the buffer size can be easily scaled with the number of probes, as the required memory grows approximately linearly with profiling granularity. To guarantee consistency between GPU writes and CPU reads, LM-Tracer enforces release-acquire ordering [25]. Probe kernels invoke \_\_threadfence\_system() calls [6] before updating the doorbell, ensuring that all prior buffer writes are visible to the CPU. The CPU poller checks this doorbell to ensure that buffer contents are consistent before transfer.

**Process bindings.** The runtime execution of probe kernels depends on sharing the user processes, so that they are executed with the user kernels for collecting corresponding trace data. This is because almost all GPU programming models are based on the runtime context of the user processes. GPU kernels can only be launched by the user process that owns the context and has initialized these kernels [26].

557

<!-- page 9 of 15 -->

LMTracer: Fine-Grained and Real-Time Performance Profiling for Production LLM Systems

SOSP ’26, September 29–October 2, 2026, Prague, Czech Republic

However, different LLM frameworks may have different process management and GPU context initialization mechanisms, which makes it challenging to insert the probe kernels into the user processes in a transparent way. Fortunately, by carefully inspecting the implementation of mainstream LLM frameworks, we find that they all follow a schedulerexecutor architecture, where the scheduler schedules GPU executions, and the executor strictly binds to one GPU for executing the scheduled tasks. This is easy to understand since today’s LLM systems are designed to run on distributed GPU clusters, and the scheduler-executor architecture effectively manages the GPU resources by scheduling the tasks across different GPUs and architectures.

Based on the above observation, we design an executorbinder abstraction layer to automatically find the executor component in the target LLM framework and bind the probe kernels to it. LMTracer locates the executor component of LLM frameworks by leveraging Python<sup>4</sup> site-specific configuration hooks [20]. With the deployed hooks, LMTracer monitors Python package importing events at runtime, and matches the imported packages that involve GPU executors (e.g., the Worker class in vLLM and the ModelRunner class in SGLang). Once an executor component is detected, LM-Tracer patches the executor code before it is initialized, so that the probe kernels share the same process context after the executor is initialized. Users can also manually specify the concrete executor in the configuration if they know the implementation details of the target LLM framework.

**Synchronizing clocks among GPUs and CPUs.** As we mentioned in §5.1, probe kernels collect GPU kernel execution time by reading GPU clock registers. However, in realworld data centers, although CPU times on different hosts are mostly synchronized through the network time protocol [52] or the precision time protocol [57], GPU clocks are usually not synchronized with CPU clocks or the clocks of other GPUs. This is because GPUs are used for high-performance computing, and deviations in GPU clocks have limited impact on performance. However, this inconsistency will lead to inaccurate analysis in performance profiling.

To address this issue, LMTracer records the initial time offsets between GPU and CPU devices instead of continuously synchronizing their clocks, which is more efficient and practical in real-world data centers. After binding to the process of a GPU, LMTracer launches AllGather operations [28, 50] among all GPUs to exchange their initial clock values. For the master GPU of the AllGather operation, LMTracer records its CPU clock value at the same time. LMTracer then calculates the timestamps across all GPUs and CPUs based on their initial offsets to the master GPU. No further synchronization is performed during profiling,

<small><span class="docvortex-page-footnote" data-block-type="page_footnote" style="color:#6b7280"><sup>4</sup>We focus on Python-based LLM frameworks since they are the most widely used. For frameworks implemented in other programming languages, similar techniques like eBPF [30] can be used to hook the executors.</span></small>

![Image block](doc:6257f5c/tier:flash/page:9/block:8)

<details>
<summary>image content</summary>

Bubble
L L L L
L        L        L        L
GPU 0
A M A M A M A M
A M A M A M A M
Network
L L L L
L        L        L        L
GPU 1
A M A M A M A M
A M A M A M A M
GPU 2        Network
L L L L
S
Straggler
A M A M A M A M
GPU 3        Bubble        Bubble
L        L      L      L
S
A       M A M A M A M
</details>

Figure 8. Example inference pipeline profiled by LMTracer, where A denotes attention, M denotes multi-layer perceptron, L denotes decode layers, and S denotes sampling. since a one-time calibration provides sufficiently accurate relative timing for our performance analysis. This is because distributed LLM workloads mainly rely on relative timing across GPUs rather than precise CPU wall-clock time, and relative GPU clock drift is typically small in practice (e.g., at most 2 ms over a month); otherwise, significant clock drift itself may indicate an underlying GPU issue.

## 5.3 Bottleneck Analysis

LMTracer is designed to be an end-to-end performance profiling framework, which not only collects the trace data through probe kernels, but also provides a suite of interfaces for analyzing the collected data to identify performance issues. To achieve this goal, LMTracer enables users to define data exporters in the profiling configuration (as exemplified in Listing 1). For each exporter, LMTracer exports the collected trace data to the corresponding backend system (e.g., file system, Prometheus, Flink) for the analysis.

**Training and inference pipelines.** By analyzing trace data and their dependency collected by probe kernels, LM-Tracer reconstructs the training/serving pipelines, based on which it helps developers identify performance bottlenecks and optimize LLM executions. Specifically, LMTracer first reconstructs kernels’ wait-for relationships [64] from their execution timelines and dependency information, and then groups counterpart operations across GPUs within each parallelism group. Bottlenecks are identified by analyzing stragglers and their dependencies. Figure 8 shows an example inference pipeline generated by LMTracer. The inference is configured with TP=2 and PP=2, where GPU 0 and GPU 1 are in the same TP group of the first PP stage. GPU 2 and GPU 3 are in another TP group of the second PP stage.

**GPU bubble fraction.** By default, LMTracer calculates the GPU bubble fraction to notify the user of resource underutilization. We define the GPU bubble fraction as the time ratio where the GPU is idle and waiting for data or barriers from other GPUs (as shown in Figure 8). It is calculated as

![Formula block](doc:6257f5c/tier:flash/page:9/block:14)

where 𝑁 denotes the number of GPU execution records within the monitoring window, 𝑡<sub>𝑖</sub> represents the timestamp

558

<!-- page 10 of 15 -->

SOSP ’26, September 29–October 2, 2026, Prague, Czech Republic

Wei Liu et al.

when the 𝑖-th GPU kernel is launched, and 𝑑<sub>𝑖</sub> denotes its execution duration. The Í<sub>𝑁</sub> 𝑖=1 <sup>𝑑</sup><sub>𝑖</sub> term represents the total active GPU computation time, while 𝑡<sub>𝑁</sub> −𝑡<sub>1</sub>+𝑑<sub>𝑁</sub> denotes the overall time span from the start of the first kernel to the completion of the last kernel. A higher bubble fraction indicates a larger fraction of idle GPU time caused by communication delays, suboptimal scheduling, or input data stalls.

**GPU straggling fraction.** LMTracer also quantifies the GPU straggling fraction to detect execution skew across distributed GPUs. In parallelized LLM executions, GPUs are expected to start kernels simultaneously. However, due to workload imbalance or hardware defects, some GPUs may finish later than others, resulting in straggling behavior. The GPU straggling fraction is defined as the normalized starttime skew across GPUs, which can be calculated as

![Formula block](doc:6257f5c/tier:flash/page:10/block:5)

where 𝐺 denotes the set of GPUs participating in the parallel execution (e.g., performing an AllReduce), 𝑠<sub>𝑔</sub> represents the start timestamp of the kernel executed on GPU 𝑔, and 𝑒<sub>𝑔</sub> denotes the end timestamp of the kernel executed on GPU 𝑔. The max<sub>𝑔</sub>∈𝐺 𝑠<sub>𝑔</sub> − min<sub>𝑔</sub>∈𝐺 𝑠<sub>𝑔</sub> term captures the start-time skew among GPUs, while the max<sub>𝑔</sub>∈𝐺 𝑒<sub>𝑔</sub> − min<sub>𝑔</sub>∈𝐺 𝑠<sub>𝑔</sub> term represents the overall execution span across all GPUs. A higher straggling fraction indicates more severe performance inconsistency among GPUs caused by abnormal devices.

**Network observability.** Since LMTracer allows users to insert probe kernels between adjacent kernels, it can also be leveraged to analyze network performance in distributed LLM executions. In modern LLM systems, communication operations are typically encapsulated into dedicated kernels and compiled together with computation kernels into a unified execution graph (e.g., the AllReduce and AllGather kernels in vLLM [46]). By placing probe kernels around these communication kernels, LMTracer accurately measures their execution time and helps developers identify potential network bottlenecks during distributed execution.

## 6 Implementation

We implement LMTracer in 4,915 lines of Python code and 230 lines of C++ code. We designed a suite of interfaces for different LLM frameworks to load LMTracer’s probe kernels, as well as different exporters to export the collected profiling data for various downstream analysis and visualization tools. Currently, LMTracer supports vLLM [46], SGLang [71], and Megatron-LM [60] for both training and serving. It also supports exporting the profiling data to different formats, including Prometheus [18], binary files, databases, real-time dashboards, and Perfetto trace [54].

Developers or users simply install LMTracer as a Python package, after which LMTracer detects the target framework and loads the corresponding hooks. LMTracer allows users

to configure the profiling settings through a configuration file specified by an environment variable. LMTracer also provides basic preset profiling configurations for different models like Qwen3, DeepSeek-V3, GPT-OSS, and Llama3.

## 7 Evaluation

## 7.1 Evaluation Setups

LMTracer has been deployed in production for eight months, covering training and serving of various LLMs (e.g., Qwen3, DeepSeek-V3, etc.) and frameworks (e.g., vLLM, SGLang, Megatron-LM, etc.) on different GPU models. In our experiments in §7.2 and §7.3, we evaluate LMTracer with the same hardware and software configurations as in production. We also compare LMTracer with other commonly used profilers (i.e., Nsight Systems, runtime events, and PyTorch Profiler) to show the advantages of LMTracer in overhead and fidelity.

For LLM serving, we measure the token throughput and time to first token (TTFT) of Qwen3-32B inference over eight low-end GPUs, DeepSeek-V3 inference over eight as well as 16 mid-range GPUs, and GPT-OSS-120B inference over eight mid-range GPUs. These models are representative of the LLMs we have in production, and we use real-world user requests during peak hours for evaluation. For LLM training, we measure the throughput of DeepSeek-V3 supervised fine-tuning (SFT) over 256 high-end GPUs, which is also a common training configuration in production. We use the preset profiling configurations (cf. §6) for evaluation. They track the duration of the attention and MLP operations in each of the LLM layers, as well as the total layer duration and model forward duration. We set the buffer flush interval to 1k records for all experiments.

## 7.2 Performance

We evaluate the profiling overhead of LMTracer by measuring the token throughput and latency of LLM training as well as LLM inference with and without LMTracer enabled.

**Profiling overhead.** Figure 9 shows the token throughput of Qwen3-32B inference on low-end GPUs with different profiling tools. LMTracer achieves negligible performance degradation of 0.9% (from 3,157 to 3,128 tokens/s) with TP=8, and 0.6% (from 3,743 to 3,721 tokens/s) with TP=4 and PP=2 on vLLM. On SGLang, LMTracer only causes 0.4% throughput degradation (from 3,103 to 3,090 tokens/s) with TP=8, and 0.3% throughput degradation (from 4,145 to 4,132 tokens/s) with TP=4 and PP=2.

In contrast, other profilers all cause greater throughput degradation. This is specifically for PyTorch Profiler, which causes 87.9%, 91.7%, 82.4%, and 86.5% degradation for the four configurations, respectively. This is because PyTorch Profiler breaks the graph executions on profiling, and introduces barriers when mapping GPU-side kernels to CPU-side call stacks with extensive Python-runtime instrumentation.

559