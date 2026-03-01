# `src/` 模块文档导航

本目录聚焦当前仓库的真实结构：`src/main.opy` 单入口 + `src/modules/*` 分层 `_index.opy` 显式编排。

## 推荐阅读顺序

1. [01-main-opy-architecture.md](./01-main-opy-architecture.md)
2. [02-modular-split-plan.md](./02-modular-split-plan.md)
3. [03-module-contracts.md](./03-module-contracts.md)
4. [appendix-src-file-index.md](./appendix-src-file-index.md)
5. [10-references-workshop-codes.md](./10-references-workshop-codes.md)

## 相关参考（同级 `docs/`）

- [Loops.md](../Loops.md)
- [improve-server-stability.md](../improve-server-stability.md)
- [Element-Count-Calculation.md](../Element-Count-Calculation.md)
- [overpy.md](../overpy.md)

## 维护约定

- 新增玩法逻辑时，优先在对应模块文件中追加。
- 涉及执行顺序、变量索引、分隔规则变更时，必须同步更新 `03-module-contracts.md` 与附录。
- `_index.opy` 仅用于显式顺序编排（含分层 `_index`），禁止为“美观”重排 include。
