# AGENTS.md

本文件仅作为规则路由目录，不承载规则正文。

## Golden Rule

- 遵循 [CLAUDE.md](CLAUDE.md)
- 规则 canonical 位置统一在 `docs/agents/*`
- 新增规则必须先登记 [docs/agents/rules-index.md](docs/agents/rules-index.md)

## How To Load Rules (Conditional)

先读 [docs/agents/rules-index.md](docs/agents/rules-index.md)，再按改动范围加载对应文档：

| 触发条件 | 必读文档 |
| --- | --- |
| 任意改动（建立上下文） | [docs/agents/project-scope.md](docs/agents/project-scope.md) |
| 改 `src/main.opy` 或 `src/modules/prelude/*` | [docs/agents/main-contract.md](docs/agents/main-contract.md), [docs/agents/protocol-constraints.md](docs/agents/protocol-constraints.md) |
| 改 `src/modules/hero_init/*` | [docs/agents/hero-init-contract.md](docs/agents/hero-init-contract.md), [docs/agents/protocol-constraints.md](docs/agents/protocol-constraints.md) |
| 改 `src/modules/hero_rules/*` 或 `src/modules/ai/*` 高频逻辑 | [docs/agents/performance-stability.md](docs/agents/performance-stability.md), [docs/agents/protocol-constraints.md](docs/agents/protocol-constraints.md) |
| 改 `src/aramMain.opy`、`src/aram_overrides*.opy` 或 `src/heroes/*/shared/*.opy`（ARAM 波次重构） | [docs/agents/performance-stability.md](docs/agents/performance-stability.md), [docs/agents/protocol-constraints.md](docs/agents/protocol-constraints.md), [docs/agents/gates-and-commits.md](docs/agents/gates-and-commits.md) |
| 提交前自检 | [docs/agents/self-checklist.md](docs/agents/self-checklist.md) |
| 执行门禁与提交规范 | [docs/agents/gates-and-commits.md](docs/agents/gates-and-commits.md) |

## Canonical Policy

- 每条规则只有一个 canonical 来源（见 `rules-index.md`）。
- `AGENTS.md`、`docs/modules/*` 只允许引用 canonical 规则，不重复定义正文。
- 若规则未登记 `Rule ID`，视为无效规则。
- Agent 规范文档文件名禁止使用数字前缀排序（例如 `01-*.md`、`10-*.md`）。
