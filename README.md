# Paper 论文库

按文章分文件夹整理，每篇论文文件夹通常包含：原始 PDF、`babeldoc-output-*/`（中英对照翻译）、`chatgpt-archive/`（精读对话存档）、`mineru-figures/`（版面解析提取的图表）、精读笔记 Markdown。

---

## 目录

| 文件夹 | 论文标题 | arXiv ID / DOI | 发表 Venue |
|---|---|---|---|
| `SkillRL_2602.08234/` | **SkillRL: Evolving Agents via Recursive Skill-Augmented Reinforcement Learning** | `2602.08234` | — |
| `Agent0_2511.16043/` | **Agent0: Unleashing Self-Evolving Agents from Zero Data via Tool-Integrated Reasoning** | `2511.16043` | COLM 2026 |
| `AMEM_2502.12110/` | **A-Mem: Agentic Memory for LLM Agents** | `2502.12110` | — |
| `INA-BucketEffect_2026/` | **Breaking Bucket Effect in In-Network Aggregation via Memory-Bandwidth Coordination** | DOI: `10.1109/INFOCOM59046.2026.11571559` | IEEE INFOCOM 2026 |
| `INA/` | In-Network Aggregation 相关论文合集（7 篇） | — | — |
| `GEPA_2507.19457/` | **GEPA: Reflective Prompt Evolution Can Outperform Reinforcement Learning**（从执行轨迹中反思错误，搜索更好的 Prompt / 指令与策略） | `2507.19457` | ICLR 2026 Oral |
| `ACE_2510.04618/` | **Agentic Context Engineering: Evolving Contexts for Self-Improving Language Models**（不断积累、整理、修订经验 / Context-Playbook） | `2510.04618` | ICLR 2026 |
| `OPSD_zhao26be/` | **Self-Distilled Reasoner: On-Policy Self-Distillation for Large Language Models**（单模型双角色自蒸馏，教师以特权信息为条件、学生只看问题，逐 token 散度） | 待确认 | — |
| `OPSD-unsup_2608.06296v2/` | **On-Policy Self-Distillation without Any Supervision**（无监督版 OPD/OPSD，摆脱对外部真值/环境反馈的依赖） | `2608.06296` | — |

## 工具脚本

- `babeldoc-translate.sh` — 位于根目录的通用翻译脚本
- `paper-notes.sh` — 图片提取 + 笔记生成脚本
