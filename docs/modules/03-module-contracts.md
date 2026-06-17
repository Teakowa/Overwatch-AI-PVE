# 03. 模块契约导览

本文档不再重复规则正文，只负责把“该去哪个 canonical 文档找哪类约束”讲清楚，并补充少量仓库内的阅读提示。

## 1. Canonical 入口

- 入口顺序与主入口边界：`docs/agents/main-contract.md`
- 变量索引、分隔规则名、`#!mainFile` 与 `@Disabled`：`docs/agents/protocol-constraints.md`
- Hero Init Detect / Initialize：`docs/agents/hero-init-contract.md`
- 高频规则、Anti Crash 与性能边界：`docs/agents/performance-stability.md`
- 提交门禁与检查顺序：`docs/agents/gates-and-commits.md`

## 2. 仓库内阅读提示

- `reset_pvar` 的稳定语义属于协议面，变更前先查 `docs/agents/protocol-constraints.md`，再回到 hero / reset 实现核对真实读写点
- Hero 初始化链路的代码阅读顺序通常是：`heroes/main.opy` -> 对应 hero init 文件 -> `resetHero()` 相关 utilities -> canonical Hero Init contract
- 如果一个问题同时涉及 include 顺序与模式拆分，优先把 `src/main.opy` / `src/aramMain.opy` 当成真实执行面，`_index.opy` 仅作为顺序源辅助理解

## 3. 何时同步文档

- 改了规则约束：更新 `docs/agents/*`
- 改了架构阅读路径：更新 `docs/modules/01-main-opy-architecture.md`
- 改了文件分布或聚合入口：更新 `docs/modules/appendix-src-file-index.md`
