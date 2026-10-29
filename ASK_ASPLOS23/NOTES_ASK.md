# ASK 论文笔记（问题导向版）

> **论文**: ASK: A Generic Service to Provide In-Network Aggregation for Key-Value Streams
> **作者**: Yongchao He (清华叉班), Wenfei Wu (北大, 通讯), Yanfang Le (Intel Barefoot), Ming Liu (UW-Madison), ChonLam Lao (Harvard)
> **Venue**: ASPLOS 2023 **Distinguished Paper Award** ｜ DOI: 10.1145/3575693.3575708
> **原文**: [ask-asplos23.pdf](./ask-asplos23.pdf) ｜ **双栏翻译**: `babeldoc-output-ask-asplos23/ask-asplos23.zh-CN.dual.pdf`
> **配套**: 我的 11 个提问原文+英译见 [QUESTIONS_ASK_bilingual.md](./QUESTIONS_ASK_bilingual.md)
>
> **本笔记的制作方式**：按我在 2026-10-28 精读对话中提出的 11 个问题组织，每个机制先给论文事实（公式/算法），再直接回答当时的困惑点。问题编号 Q1–Q11 与 QUESTIONS 文件一致。

---

## 1. 摘要（一分钟版）

Key-value 流聚合（reduce() / AllReduce() / SUM() 等的抽象）是分布式系统最常见也最耗资源的操作之一（梯度聚合可占训练时间 79%，WordCount 中 ReduceByKey 占 94.67%）。已有 INA（ATP、SwitchML、SHARP）只能做**同步的 value 流聚合**——那是 KV 流聚合的特例。ASK 是第一个**通用、端到端、正确且高性能的交换机内 KV 流聚合服务**：交换机 best-effort 聚合 + 主机 daemon 保障正确性。三个核心机制分别解决：① 多 key 包向量化（goodput）② 异步聚合的轻量可靠性（正确性）③ 热 key 无感知优先级（SRAM 利用率）。实测：纯 KV 聚合最高 **155×** 加速、大数据作业 3–5×、与 ATP/SwitchML 在分布式训练上打平（向后兼容）。

---

## 2. 故事逻辑（论文怎么立论的）

### 2.1 核心洞察：现有 INA 靠的是一种"特权"通信模式

![两种聚合模式](figures/fig_p02_image_9.png)
*Figure 1：(a) KV 流聚合——key 无序、不可预见、发送方不同步；(b) value 流聚合——"下标即 key"，所有流对齐同步。*

论文 §2.1 的比较分析是全文立论基础：

| | value 流（同步） | KV 流（异步） |
|---|---|---|
| key 形态 | 线性、连续、对齐（下标即 key） | 无序、不可预见 |
| 发送方 | 同步齐步走 | 各发各的，无同步 |
| 交换机知道"聚齐"吗 | **知道**（所有流同步到达，收齐即完成）| **永远不知道**（key 的最后一次出现不可预见） |
| aggregator 释放 | 立即释放、循环复用 | 无法释放，占到任务结束 |
| 现有可靠性机制 | 可用（1-bit 去重即可）| **全部失效**（状态无界） |

**关键推导**：可以把 value 流硬套进异步机制（性能损失换通用性），但**不可能**把 KV 流套进同步机制——所以通用系统必须解决异步，而异步的正确性机制此前无人做对。

### 2.2 Strawman 三假设逐步松绑 → 三机制

Strawman（单机 WordCount，已证明交换机聚合比 Spark 快 5×、16 核即可打满 100Gbps 线速）建立在不现实的三假设上，每个假设松绑各诞生一个机制：

```
假设① 一包一 key           → 网络有效吞吐只有 9.76Gbps（即使 100Gbps 线速）
                              机制 M1：多 key 包向量化（§3.2）
假设② 网络可靠无丢包        → 数据中心必然丢包，重传导致重复聚合
                              机制 M2：轻量可靠性（§3.3）
假设③ 所有 key 装得进交换机  → 真实负载 Zipf 偏斜，冷 key 先到先得占死槽位
                              机制 M3：Shadow Copy 热 key 优先（§3.4）
```

从 5×（strawman）到 155×（ASK）的跨越主要来自 M1 的 goodput 工程 + 三机制协同。

---

## 3. 算法逻辑（按我的提问逐个拆解）

### 3.1 M1 多 AA 向量化 —— 回答 Q3/Q4/Q9/Q10 的"分 AA 到底为什么"

#### 论文事实：PISA 硬件约束（§2.2.1, §3.2.1）

- 一个 packet 顺序穿过 pipeline 的所有 stage = **一次 pass**；
- 一个 register array（= aggregator 数组）**一次 pass 只能读一次、写一次**；
- 每个 stage 最多声明 **4 个** register array；
- SRAM 总量 ~15MB（Tofino：1280KB/stage × 16 stage × 4 pipeline）。

**这就是分 AA 的唯一原因**：一个包带 N 个 tuple，要让它们在**同一次 pass** 里各自完成"读 kPart → 比较 → 累加 → 写回"，而一个 array 只能读写一次，所以必须 N 个**物理独立**的 array 并行工作 = **二维聚合数组 AA**（第一维选 AA，第二维选 aggregator）。实现：每 pipeline 32 个 AA × 32768 aggregator，包载荷 32 个 slot，第 i 个 tuple 永远进第 i 个 AA。

> **【回答 Q10 后半】**"一个包有很多 key 是肯定的，与分 AA 有什么关系？"——分 AA **不是因为**包里 key 多，而是因为**硬件一次 pass 只允许每个 array 读写一次**。包内第 i 个 key 必须由第 i 个 AA 处理，这是把"包内并行度"映射到"硬件内存端口数"的设计。你的直觉"这不就是肯定的吗"恰恰说明应用层觉得自然，但 PISA 层面这是最硬的约束。

> **【回答 Q9 前半】**"AA 本质就是内存池，分它有啥意义？"——它不是逻辑分组的池，而是**硬件并行访问端口的具象化**。池化解决"容量管理"，AA 化解决"单 pass 多次访问"。若用一个大 pool，一个包的 32 个 tuple 需要对同一 array 读/写 32 次——硬件直接不允许。

#### 论文事实：两级 key 定位（§3.2.1–3.2.2）

**第一级（sender 侧，装包时）**：key 空间 K 划分为 N 个不重叠子空间，
$$i = F(key) \bmod N$$
key 属于子空间 $K_i$ → 装进包内第 i 个 slot → 交换机送进第 i 个 AA。**同一个 key 永远落在同一个 AA**（避免"单 key 多点"浪费 aggregator；聚合可交换，所以顺序无所谓）。

**第二级（switch 侧，运行时）**：AA 内用随机哈希定位，
$$index = hash(key) \bmod N_{agg}$$
读该 aggregator 的 kPart：若 blank 或等于 key → 累加 vPart；否则**冲突**，该 tuple 随包转发给 host。

> **【回答 Q4 前半】**"你是如何确定 AA 内的哈希位置的？"——就是上面第二级：`hash(key) % N_agg`（实现中 N_agg=32768）。论文 Figure 5 没画哈希值，所以当时看不出发 f 为什么撞 b。

> **【回答 Q3 的 c 疑问】**"c 为啥能站住？不是被 a=1 占着吗？"——**AA0 不是只有一个槽**。a 和 c 都在 AA0，但 `hash(a) ≠ hash(c)` → 索引不同 → c 找到的是**另一个空 aggregator**。a=1 只占住 `hash(a)` 那一格。只有 `hash(f) == hash(b)`（或撞上已被占格）才冲突——这正是示例里 (f,1) 回退 host 的原因。

#### 数学实例 ①：Figure 5 完整走查（含 bitmap 语义）

设 2 个 AA、每 AA 8 个 aggregator（示例用），包 = 2-bit bitmap + 2 个 tuple slot：

| 时刻 | 包内容 | bitmap 出 | AA0（hash→槽） | AA1 | bitmap 入 | 去向 |
|---|---|---|---|---|---|---|
| t1 | pkt1=[(a,1),(b,1)] | 11 | hash(a)=3 → 槽3：a=1 ✅ | hash(b)=6 → 槽6：b=1 ✅ | **00** | 全聚，交换机回 ACK |
| t2 | pkt2=[(c,1),(f,1)] | 11 | hash(c)=5 → 槽5：c=1 ✅ | hash(f)=6 → 槽6 已被 b 占，key′=b≠f ❌ | **01** | 部分：转发，host 只聚 (f,1)，回 ACK |
| t3 | pkt3=[(c,1),(b,1)] | 11 | 槽5：c=1+1=2 ✅ | 槽6：b=1+1=2 ✅ | **00** | 全聚，ACK |
| t4 | teardown | — | fetch: a=1, c=2 | fetch: b=2 | — | host 本地 f=1 + 交换机结果合并 |

注意 t2 之后 bitmap=01：**第 0 位（c）被清零表示"已被交换机消费"，第 1 位（f）保持 1 表示"还需要 host 处理"**。

> **【回答 Q3 的 bitmap 疑问】**"Bitmap 不是在表示一个 Key 是否已经全部聚合完成？"——对，它**从不**表示 key 聚合完成（交换机永远不知道这件事，见 3.2/M2）。它只表示**本包内每个 tuple 是否已被交换机消费**——一个纯"per-tuple 回执"位图。你当时的理解是对的，ChatGPT 早期表述混淆了"tuple 消费"与"key 完成"两层语义。

> **【回答 Q3 的包内聚合疑问】**"同一个包里边的能聚合吗？"——**不能也不需要**。包内是**不同的 key**（同子空间内每 slot 一个 key），它们各自进不同 aggregator。交换机聚合的对象是**跨包、跨流中相同 key 的 value**——与"来自不同 worker 的传统内网聚合"在数学上同一件事：$v' \leftarrow \sum_m \sum_i v_i^{(m)} \cdot \mathbb{I}(k_i^{(m)}=k')$（式 2）。区别只是触发方式：同步 INA 靠"齐步走"知道何时输出，ASK 靠 host 侧 teardown 知道何时输出。

> **【回答 Q2 的 Spark/BytePS】**"支持 Spark 与 BytePS 是什么意思"——通过插件做数据格式转换：Spark 插件（~1800 行 Java）把 map 输出的 KV 对送进 ASK daemon 的共享内存、把聚合结果交还 reduce；BytePS 插件（~500 行 C++）把梯度聚合接成参数服务器模式。ASK 本体对应用是透明的服务（daemon + 共享内存 IPC）。

#### 论文事实：变长 key 的聚合放置（§3.2.3）

medium key（长度超过单个 kPart）拆 k 段，占用**物理相邻 stage** 的 m 个 AA，但用**统一索引** `hash(整条key)`——避免"分段独立验证"导致的假阳性（论文例子：长 key X1X2、Y1Y2 各占两格后，X1Y2 会被误判为已存在）。短 key 的 subspace 不允许 medium 组的 AA 处理。实现取 m=2, k=8。

### 3.2 M2 轻量可靠性 —— 回答 Q5/Q6 的"异步怎么知道聚齐/丢包怎么办"

#### 先回答最核心的问题：交换机**根本不需要**知道聚齐

> **【回答 Q5】**"哪怕是异步，它是怎么知道一个板块需要几个聚合齐的？"——**它不知道，也不去知道**。设计哲学是把这个不可能知道的事情完全移出交换机：
> 1. aggregator 里的部分和**无限期保持**（直到 shadow copy 轮换或任务结束被 fetch）——key 的第 100 次出现和第 1 次出现一样直接累加；
> 2. "**何时算完**"由 **host 的任务边界**决定：每个 sender 发完且全部 ACK 后发 **FIN**；receiver 收齐**所有 sender 的 FIN** 后，才 fetch 交换机结果、与本地结果合并（§3.1 Task Teardown）。
> 3. 所以"聚合满了可以处理"这个事件在交换机侧**不存在**，只存在"任务结束了"这个 host 侧事件。

> **【回答 Q7 的"两种完成"矛盾】**"两种完全不同的完成是个很矛盾的描述"——不矛盾，是**两个不同层面**的完成：
> - **tuple 级消费**（bitmap 位清零）：这个 tuple 已被"交换机或 host 之一"处理，保证 exactly-once；
> - **任务级完成**（FIN 齐合 + 最终 fetch）：所有流的最后一块到齐，结果可交付。
> ChatGPT 当时把这两个概念混在"完成"一个词里讲，才显得自相矛盾。

#### 论文事实：为什么现有机制全部失效（§3.3）

同步 INA（ATP/SwitchML）在 aggregator 上放 1-bit 记录包出现即可去重，因为同步流的"包-槽位"关系有界。异步 KV 流中 key 的最后出现不可预见 → 该状态无界 → 1-bit 方案失效。TCP 端到端重传也不行：ASK 的流有**三个端点**（sender、switch、host receiver），"部分聚合包"重传时需要在 switch 和 host **分别**去重。

正确行为示例：包 [(a,1),(b,1)] 在交换机聚了 (a,1) 没聚 (b,1)，随后丢在 host 前的路上。重传时：交换机必须"丢掉"(a,1)（已算过）只带 (b,1) 转发；直接聚则 (a,1) 算两次，直接转发则 host 再聚一次 (a,1) 也算两次——两种都错。

#### 论文事实：滑动窗口 + seen + PktState 三件套

**Host sender**：窗口 W 包，ACK 推进，超时（**100μs**，不是 Linux 的 200ms）重传。不用乱序 ACK 触发重传——因为 ACK 可能来自交换机或 host 两个源，乱序会被误判为丢包。

**Switch receiver**：每 data channel 维护 2W-bit 循环数组 `seen`：
$$idx \leftarrow pkt.seq \bmod 2W,\quad observed \leftarrow seen[idx];\quad seen[idx] \leftarrow 1;\quad seen[(idx+W) \bmod 2W] \leftarrow 0$$
首见（observed=0）→ 参与聚合；重传（observed=1）→ 跳过聚合。同时用 `max_seq` 记录窗口上界，`seq ≤ max_seq − W` 的陈旧包直接丢弃（防老包污染新窗口位）。

**PktState**（处理部分聚合包的重传）：W 大小的循环数组存每个包的 bitmap。首见时存下聚合后的 bitmap（式 9），重传时写回包头（式 10）→ 重传包只携带未聚合的 tuple 去 host。

**Host receiver**：同样有接收窗口去重，重复包丢弃，两种情况都回 ACK。

**状态有界化**：所有流复用持久 data channel，per-channel 状态 = 256 + 256×32 bit ≈ **1056B**；TOR 交换机拿 264KB（~15MB 的 1.7%）就能支持 64 台服务器——这是可扩展性的关键设计。

#### 数学实例 ②：compact seen 的四情况（式 8，省一半内存）

W-bit 版本：序号按 W 分段，偶数段用 set_bit（1=已见），奇数段用 clr_bitc（0=已见）：

设 W=4，seq=0..3 为偶段、4..7 为奇段。seen 初始 [0,0,0,0]：
- seq=0（偶段，r=0）：bit=0 → set_bit 返回旧值 **0**（首见）✅，置 1
- seq=4（奇段，r=0）：bit=1 → clr_bitc 返回补码 **0**（首见）✅，清 0 —— 同时这格已为下个偶段备好"0=未见"
- seq=0 重传：bit=0 → set_bit 返回 **0**？！——错，此时 seq=0 已是陈旧包（0 ≤ max_seq−W 当 max_seq≥4），**在窗口检查层就被丢弃**，不会走到这里
- seq=4 重传：bit=0 → clr_bitc 返回补码 **1**（重传）✅

一条原子指令同时完成"记录本次 + 返回旧状态（奇段翻转）+ 为一个窗口后的未来包初始化"，省 50% 内存。

> **【回答 Q6 后半】**"真的丢包了怎么办"——完整链条：sender 100μs 超时重传 → 交换机 seen 判定重传 → 全聚过的包直接丢弃并补发 ACK；部分聚合的包用 PktState 写回旧 bitmap → 已聚 tuple 被剔除、剩余 tuple 转发 host → host receiver 再去重一层。三层配合保证**每个 tuple 恰好聚合一次**（exactly-once）。

### 3.3 M3 Shadow Copy —— 回答 Q6 前半/Q7 攻击点/Q9/Q10 前半/Q11

#### 论文事实：Algorithm 1 的精确语义

一个 AA 有 2N 个 aggregator，切成两半：前 N = copy 0，后 N = copy 1。交换机维护 1-bit `copy_indicator`：

```
Switch():   copy_indicator ← not(copy_indicator)          # receiver 触发的切换
Read(key):  read_part ← 1 - copy_indicator                # 读旧副本（host fetch 用）
            index ← hash(key) % N + read_part × N
Write(key): write_part ← copy_indicator                   # 写新副本（正常聚合用）
            index ← hash(key) % N + write_part × N
            if AA[index].key == key or blank → 聚合，return true
            else → 冲突，return false
```

触发条件：**receiver 统计"已到达包数"达到阈值** → receiver 发 swap 通知包给交换机 → indicator 翻转 → 之后所有新包进新副本；receiver 随后 fetch 旧副本的部分和并清理。PISA 每个 stage 同时只处理一个包，处理通知包时无并发读 indicator → Switch() 原子。Read/Write 物理不相交 → 无读写冲突。

> **【回答 Q9 的三个困惑】**
> 1. "达到一定位置强制切换——统计的是哈希数量还是冲突数量？"——都不是，是 **receiver 收到的包数**（到达流量计数）。它是个**时间维度**的触发器，与哈希/冲突统计无关。
> 2. "不就是抢占吗？"——是**全量时间片轮转式抢占**：所有 key 一起失去槽位、一起重新竞争。**不是**逐 key 的精准 LRU 驱逐。§7 Discussion 明说为什么不做 LRU：可靠地驱逐单个 key 需要交换机发 ARQ 直到 receiver 确认，P4 数据路径不支持重试/挂起；所以把"驱逐+可靠性"整体搬到 receiver 批量做。
> 3. "旧副本存在交换机这个没什么位置的地方？"——是的，两个 copy **都在交换机 SRAM 里**，就是同一个 AA 的前一半和后一半（物理相邻）。旧副本的空间不是额外申请的，是把原 AA 对半分出来的。

> **【回答 Q10 前半】**"为啥会有两个 copy？"——**为了读写分离消除竞态**，见下面 Q11 的分析。单副本下 host fetch+clear 和 switch 写入并发，要么丢更新要么重复计数；双副本让 Read() 和 Write() 永远操作物理不相交的区域，无需任何锁即可正确。

> **【回答 Q6 前半："取走"的前后矛盾】**——当时矛盾感的来源是把**两次不同的取走**混为一谈：
> - **任务结束的取走**（teardown fetch）：所有 FIN 到齐后，此时不会再有该任务的新包，取走即安全、取走即结束。
> - **任务中途的取走**（shadow copy swap）：取走的只是"上一轮的部分和"，**key 的后续出现会进新副本从零继续累加**，host 最终把"各轮部分和 + 本地结果"全部相加。由聚合的结合律，分轮累加与一次累加数学等价——**中途取走不等于任务完成，也不丢数据**。
> "槽位等所有 sender 到齐再维护"说的是 teardown 场景；"第二轮就取走"说的是 swap 场景——两句话各自正确，错的是把它们当成同一件事。

> **【回答 Q11：单 copy 竞态 + 两级流水线 + SRAM 浪费】**
> - T1–T5 竞态分析**完全正确**：Host 读（T2/T5）与 Switch 写（T3/T4）并发 → 读到 6 或 10 不确定、清空可能吞掉新到的 4 或造成重复。双副本正是这个问题的解：T3–T4 写的是新副本，T2/T5 读清的是旧副本，时间上重叠但空间上不相交。
> - "两级流水线"直觉方向对，但要修正：**不是"发一块就传走"**——当前副本持续累加多个包，直到包数阈值才批量切换；传走的是"部分和"不是"逐块"。
> - "SRAM 浪费"的质疑成立且论文认账：有效写入槽位减半（2N→N）。但另一半并非闲置（保存待 fetch 的旧状态），且这笔账是否划算取决于 key 偏斜度——这正是下面实验部分要算的。

#### 数学实例 ③：Shadow copy 下的多轮部分和

设 key "apple" 在任务中总共出现 1000 次（每次 value=1），阈值导致 3 次切换：

| 轮次 | copy 状态 | apple 聚到的部分和 | fetch 后 host 累计 |
|---|---|---|---|
| R1（写 copy0） | copy0 = 0号区 | apple=300 | 300 |
| R2（写 copy1） | copy1 = N号区（从零） | apple=400 | 700 |
| R3（写 copy0，已清） | copy0 又从零 | apple=300 | 1000 |

若中途有 fallback（某轮 apple 的 tuple 撞槽去了 host），host 本地还另有若干 apple=…，teardown 时一相加——exactly-once 由 M2 保证，轮次拆分由结合律保证正确性。

#### 数学实例 ④：为什么必须 multi-key（goodput 账）

包开销 78 字节（12 IPG + 7 前导 + 1 SFD + 14 以太网头 + 20 IP 头 + 20 ASK 头 + 4 CRC），每 tuple 8 字节（4B key + 4B value）：

$$\text{goodput}(x) = \frac{8x}{8x+78} \times 100\text{Gbps}$$

| 每包 tuple 数 x | goodput 上限 |
|---|---|
| 1（strawman） | 9.76 Gbps |
| 8 | 45.0 Gbps |
| 32（单 pipeline 上限） | 76.6 Gbps |
| 64 | 86.8 Gbps |

strawman 的 5× 到 ASK 的 155× 之间，绝大部分差距来自这笔账 + 向量化后的 CPU 节省。

### 3.4 三机制整体运行（回答 Q8）

![ASK 总览](figures/fig_p05_image_2.png)
*Figure 4：receiver 发起任务 → controller 分配 AA 区 → 控制通道通知各 sender → 数据通道持续聚合。*

一个聚合任务的完整生命周期（三机制全程并行运行）：

1. **Task Setup**：receiver 向本地 daemon 提交任务（task ID）→ daemon 分配 host 共享内存 → 向 switch controller 申请 AA 区间 → 控制通道通知所有 sender daemon（含 task ID、AA 区间）→ sender 应用写共享内存。
2. **数据面循环**（M1+M2 常态）：sender 按 key 子空间装包（i=F(key)%N 进 slot i）→ 滑动窗口发送 → 交换机：seen 去重 → 第 i tuple 进第 i AA（hash 定位、blank/同 key 则聚合、冲突则留 bitmap=1）→ 全聚回 ACK / 部分聚转发 → host receiver 聚剩余 tuple、回 ACK、维护接收窗口去重。
3. **周期轮换**（M3 常态）：receiver 包数计数达阈值 → swap 通知 → indicator 翻转 → 新包写新副本 → fetch 旧副本部分和 → 清理旧副本 → 计数清零。**每 AA 独立周期进行**。
4. **Task Teardown**：各 sender 发完且全 ACK → FIN → receiver 收齐所有 FIN → **最终 fetch** 交换机当前副本 → 与本地结果 + 历次轮换的部分和合并 → 通知应用（共享内存地址）→ controller 释放 AA 区。

---

## 4. 实验部分（配置动机 + 它对我的 Q7 质疑的数据回应）

### 4.1 实验配置为什么这么设计

**集群**：1 台 Tofino（32 端口）+ 9 台服务器（56 核 / 100Gbps ConnectX-5）。

**四组 baseline 各隔离一个变量**：
| Baseline | 隔离的变量 | 想证明什么 |
|---|---|---|
| PreAggr（sender 本地预聚合） | 纯 host 计算方案 | 计算卸载的价值（CPU 是瓶颈） |
| Spark / SparkRDMA / SparkSHM | 网络 IO、磁盘 IO | 排除"快是因为网络/磁盘"的解释 |
| ATP / SwitchML | 同步 INA 系统 | 向后兼容：异步机制退化处理 value 流不吃亏 |
| NoAggr（纯 DPDK 传输） | 聚合本身的开销上限 | goodput 损失 + 可扩展性 |

**数据集**：生产 trace（yelp、20NG、BAC、LMDB）测真实收益；合成 Uniform/Zipf/Zipf(reverse) 测 M3——**Zipf(reverse)（冷 key 在前）是最刁钻的设定**，直接打击 FCFS 的最坏情况。

### 4.2 结果解读

**微基准（§5.2）**：同 CPU 用量下 ASK 最高 155×；1/2/4 data channel 只占 1.78%/3.57%/7.14% CPU，PreAggr 8 线程就要 14.3%、峰值打满 56 核。JCT：ASK(4dCh) 6s vs PreAggr 33–111s。**真实 trace 下交换机聚合 85.73%~94.32% 的 tuple、吸收 72.01%~90.36% 的包**（Table 1）——"交换机做了绝大部分聚合工作"有数据支撑。

**M1 验证（§5.3）**：goodput 随每包 tuple 数近线性上升，32 以后贴合理论值（受 host PPS 与 PCIe TLP 对齐的毛刺）；最差 trace（yelp）平均每包仍有 16.91 个非空 slot——key 子空间划分在偏斜负载下有槽位浪费，但没到抵消收益的程度。

**M3 验证（§5.4，直接回应我的 Q7 攻击点）**：
![有无优先级对比](figures/fig_p10_image_8.png)
*Figure 9：左（无优先级）：aggregator 数量不足时 INA 比例骤降，且 Zipf(reverse) 最惨；右（有优先级）：aggregator:distinct-key = 1:16 仍达 95.85%。*

- 无优先级：冷 key 占槽到任务结束，aggregator 不够时大量 tuple 回退 host；
- 有优先级：**1/16 的 aggregator 对 95.85% 的 on-switch 聚合率**——用 16 倍少的 SRAM 覆盖几乎全部聚合。
- **对我"没有完全利用内网聚合能力"质疑的正面回应**：INA Percentage 衡量的是 **tuple 被交换机聚合的比例**而非槽位占用率。周期轮换确实打断、确实牺牲一半写入槽位，但在偏斜负载下它换来的重竞争机会让 95%+ 的 tuple 留在交换机——**有效聚合比例**反而大幅上升。代价是否值得 = 负载偏斜度的函数；Uniform 负载下论文未给出轮换开销细账（这是它的一个薄弱点，可作为攻击面保留）。

**端到端（§5.5–5.6）**：WordCount JCT 降 67.3%~75.1%、CPU 降 88.7%；SparkRDMA/SparkSHM 对原版 Spark 几乎无提升（证明瓶颈在计算而非网络/磁盘，反衬卸载的价值）。训练场景与 ATP/SwitchML 打平（都能用交换机加速梯度），ASK 还略胜 SwitchML（后者包太小吃不满带宽）——**异步机制退化处理同步 value 流不吃亏**。

**开销与扩展（§5.7）**：goodput 73.96 vs NoAggr 91.75 Gbps（小包头的代价），4 核 vs 2 核；但 sender 数增加时 ASK 每服务器吞吐恒定（交换机吸收了大部分流量），NoAggr 每服务器吞吐反比下降（接收端链路成为瓶颈，8 机时 11.88Gbps）——**线性扩展**是这类系统最值钱的性质。

---

## 5. 最终结论

- ASK 是第一个**通用、正确、高性能**的交换机内 KV 流聚合端到端系统：把 INA 从分布式训练的专用优化（同步 value 流）推广为服务多应用的通用原语（异步 KV 流）。
- 三机制各守一关：M1 向量化（goodput，155× 的主要来源）、M2 滑窗+seen+PktState（异步 exactly-once，此前无人做对）、M3 Shadow Copy（时间维度轮换，让热 key 定期重获 SRAM）。
- **设计上最值得学习的取舍**：把"不可能知道的事"（key 何时结束）彻底移出交换机，交给 host 任务边界（FIN）和批量轮换（swap）——用 host 的可编程性换交换机的简洁性。
- **局限（§7 自述 + 我补充）**：多机架层级部署会状态爆炸 → 只能部署在 TOR（跨 rack 流量绕过交换机）；swap 阈值是静态经验值；Uniform 负载下双副本的容量代价缺乏分析；1/2 SRAM 换重竞争在低偏斜负载可能不划算。

---

## 6. 相关文献地图

| 文献 | 关系 |
|---|---|
| ATP (Lao et al., NSDI'21) | 同步 INA 代表（多租户训练）；ASK 的 §2 对比锚点 + §5.6 基线；作者 Lao 也在本文作者列表 |
| SwitchML (Sapio et al.) | 同步 INA；固定线性 slot 分配 |
| SHARP / NetReduce / iSwitch / PANAMA | 其它同步 INA 变体（IB 硬件 / RDMA 兼容 / 强化学习 / 拥塞控制） |
| P4COM (2021) | KV 聚合 showcase：证明了可行性但无可靠性/接口/性能系统设计——ASK 论文里的"另一类前身" |
| OmniReduce / SparkRDMA | 网络加速路线（稀疏压缩 / RDMA），与 ASK 互补 |
| NetCache / NetChain / Cheetah | 交换机加速其它操作（缓存/复制/过滤），可组合 |
| Trio (Cisco) | run-to-completion 新硬件，SRAM 提升到 O(1GB)——论文指出 ASK 的 shadow copy 与变长 key 在其上可进一步改进 |
| BytePS / Spark | 被接入的应用系统（参数服务器 / 大数据） |
| DCTCP / ECN | 数据中心丢包/拥塞背景；ASK 兼容 ECN 拥塞控制但窗口不得超过可靠性窗口 |

---

## 7. 对我的研究的启示（Global ATP / 空间维度共享）

- **维度差异要讲清楚**：ASK 的 Shadow Copy 是**单交换机内的时间维度轮换**（同一块 SRAM 按时间片重新竞争）；Global ATP 关注**多交换机间的空间资源共享**（跨机的槽位再分配）。两者正交，可组合——这是定位声明时最干净的切割线。
- **可迁移的设计思想**：
  1. **"receiver 主导驱逐 + 批量可靠性"**：把逐 key 的精准替换（需要 ARQ，交换机做不了）退化为 host 发起的批量轮换（ARQ 在 host 可行）——任何"交换机资源再分配"设计都会撞上同一堵墙，这个降级思路直接可用；
  2. **状态有界化**：per-channel 1056B / 64 服务器 264KB——把可靠性状态锚在持久 data channel 而非 per-flow，是可扩展性的关键；跨机设计更需要这层抽象；
  3. **"完成"语义分层**（tuple 消费 vs 任务边界）：跨机场景下任务边界判定会更复杂（多交换机各自的 fetch 时序），ASK 的"FIN 齐合→fetch"只解决单机版本。
- **可攻击面**：静态 swap 阈值、Uniform 负载下的双副本代价、跨 rack 流量完全绕过交换机（层级聚合缺位）——这三点在"空间共享"框架下都有对应的机会。
