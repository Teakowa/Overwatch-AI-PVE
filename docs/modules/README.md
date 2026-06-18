# `src/` 模块文档导航

本目录聚焦当前仓库的真实结构：`src/main.opy`（常规赛）与 `src/aramMain.opy`（大乱斗）双执行面，加上 `src/modules/*` 分层 `_index.opy`（顺序源）。

## 推荐阅读顺序

1. [01-main-opy-architecture.md](./01-main-opy-architecture.md)
2. [03-module-contracts.md](./03-module-contracts.md)
3. [appendix-src-file-index.md](./appendix-src-file-index.md)
4. [02-modular-split-plan.md](./02-modular-split-plan.md)
5. [05-macro-js-macro-todo.md](./05-macro-js-macro-todo.md)
6. [10-references-workshop-codes.md](./10-references-workshop-codes.md)

## 相关参考（同级 `docs/`）

- ARAM 入口与共享验证：[`../reports/aram-vs-main-verification.md`](../reports/aram-vs-main-verification.md)
- [Loops.md](../Loops.md)
- [improve-server-stability.md](../improve-server-stability.md)
- [Element-Count-Calculation.md](../Element-Count-Calculation.md)
- [overpy.md](../overpy.md)

## 维护约定

- 新增玩法逻辑时，优先在对应模块文件中追加。
- 涉及执行顺序、变量索引、分隔规则等规则面变更时，必须同步更新 `docs/agents/*`；涉及阅读路径或文件分布变化时，再同步本目录文档。
- `_index.opy` 用于维护模块顺序源并供契约校验使用；`src/main.opy` 不直接 include `*_index.opy`。
- 阅读常规赛执行面时优先看 `01-main-opy-architecture.md`；阅读大乱斗执行面时优先对照 `src/aramMain.opy` 与 ARAM 验证报告。
