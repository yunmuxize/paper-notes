# Paper 论文库 · 文本材料处理工作区

本仓库按文章分文件夹整理，同时作为通用文本材料处理工作区（翻译 / 精读 / 笔记 / 存档）。

---

## 目录结构约定

```
Paper/
├── <论文名>_<arXiv ID>/     # 一篇论文一个文件夹（主流模式，保持顶 level）
│   ├── 原始 PDF
│   ├── babeldoc-output-*/   # 中英双栏翻译（主交付物 .zh-CN.dual.pdf）
│   ├── figures/             # MinerU 版面解析提取的图表
│   ├── NOTES_*.md           # 精读笔记（摘要/故事/算法+数学实例/实验/结论/文献）
│   └── QUESTIONS_*.md       # 精读提问存档（中英双语，可选）
├── INA/                     # 同主题论文合集
├── _archive/                # 原始档案（聊天记录 zip 等不可再生材料）
├── _documents/              # 独立文档（简历、研究报告等）
├── _projects/               # 非论文工作项目（LaTeX 工程、PPT 工程等）
├── babeldoc-translate.sh    # 通用翻译封装脚本（pdf-translate skill 引用，勿移动）
├── paper-notes.sh           # 图片提取 + 笔记生成脚本（skill 引用，勿移动）
└── README.md
```

**新论文处理流程**（使用 pdf-translate skill）：下载 PDF → `babeldoc-output-*/` 双栏翻译 → `figures/` 提图 → `NOTES_*.md` 写笔记 → git commit + push 同步 GitHub。

## 论文目录

| 文件夹 | 论文标题 | arXiv ID / DOI | 发表 Venue |
|---|---|---|---|
| `ASK_ASPLOS23/` | **ASK: A Generic Service to Provide In-Network Aggregation for Key-Value Streams**（通用 Key-Value 流内网聚合服务；Shadow Copy / Bitmap 部分聚合 / Hot-Key Agnostic Prioritization） | DOI: `10.1145/3575693.3575708` | ASPLOS 2023 (Distinguished Paper Award) |
| `ToolQP_2601.07782/` | **Beyond Single-Shot: Multi-step Tool Retrieval via Query Planning**（多步查询规划工具检索；SFT+RLVR 训练 1.7B 规划器） | `2601.07782` | — |
| `IGSD_2609.32694/` | **IGSD: Environment-Verified Hindsight Self-Distillation for Search Agents**（环境验证自蒸馏；执行配对信息增益 ΔIG 门控） | `2609.32694` | — |
| `SkillRL_2602.08234/` | **SkillRL: Evolving Agents via Recursive Skill-Augmented Reinforcement Learning** | `2602.08234` | — |
| `Agent0_2511.16043/` | **Agent0: Unleashing Self-Evolving Agents from Zero Data via Tool-Integrated Reasoning** | `2511.16043` | COLM 2026 |
| `AMEM_2502.12110/` | **A-Mem: Agentic Memory for LLM Agents** | `2502.12110` | — |
| `INA-BucketEffect_2026/` | **Breaking Bucket Effect in In-Network Aggregation via Memory-Bandwidth Coordination** | DOI: `10.1109/INFOCOM59046.2026.11571559` | IEEE INFOCOM 2026 |
| `INA/` | In-Network Aggregation 相关论文合集（7 篇） | — | — |
| `GEPA_2507.19457/` | **GEPA: Reflective Prompt Evolution Can Outperform Reinforcement Learning**（从执行轨迹中反思错误，搜索更好的 Prompt / 指令与策略） | `2507.19457` | ICLR 2026 Oral |
| `ACE_2510.04618/` | **Agentic Context Engineering: Evolving Contexts for Self-Improving Language Models**（不断积累、整理、修订经验 / Context-Playbook） | `2510.04618` | ICLR 2026 |
| `OPSD_zhao26be/` | **Self-Distilled Reasoner: On-Policy Self-Distillation for Large Language Models**（单模型双角色自蒸馏，教师以特权信息为条件、学生只看问题，逐 token 散度） | 待确认 | — |
| `OPSD-unsup_2608.06296v2/` | **On-Policy Self-Distillation without Any Supervision**（无监督版 OPD/OPSD，摆脱对外部真值/环境反馈的依赖） | `2608.06296` | — |

## 研究文档（`_documents/`）

- [`_documents/Skill-Retrieval-x-OPSD-研究定位报告.md`](_documents/Skill-Retrieval-x-OPSD-研究定位报告.md) — **Skill Retrieval × OPSD：从"刷检索榜"到真正有 Hard-Agent 故事的研究定位**（2026-10-28；Skill 检索近期论文格局调研、四条选题路线评估、六篇核心精读清单）

## 工具脚本

- `babeldoc-translate.sh` — 位于根目录的通用翻译脚本（pdf-translate skill 的 WRAPPER 常量引用此路径，**勿移动**）
- `paper-notes.sh` — 图片提取 + 笔记生成脚本（skill 的 NOTES_SCRIPT 常量引用此路径，**勿移动**）
