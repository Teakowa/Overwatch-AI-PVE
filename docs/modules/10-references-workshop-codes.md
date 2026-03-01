# 10. Workshop.Codes 参考映射

本文档将 Workshop.Codes 的通用实践映射到本仓库当前的 `src/main.opy` 实现，便于在维护时快速定位“理论 -> 实战”关系。

## 1) Loops 教程

- 分类页：[Tutorials](https://workshop.codes/wiki/categories/tutorials)
- 文章：[How to use loops](https://workshop.codes/wiki/articles/how-to-use-loops)

对应到项目：

- `[AI/Movement]: Movement`（`src/main.opy:1449`）
- `[AI/Movement]: Strafing`（`src/main.opy:1469`）
- `[AI/control]: Pharah Jump`（`src/main.opy:1972`）
- `[Freja]: HUD & Reset`（`src/main.opy:4406`）

实践原则：

- 循环体必须有 `wait` 或可中断的 `waitUntil`。
- 使用 `Wait.ABORT_WHEN_FALSE` / `Wait.RESTART_WHEN_TRUE` 控制重入与中断。

## 2) 服务器稳定性实践

- 文章：[Improve your code's server stability](https://workshop.codes/wiki/articles/improve-your-codes-server-stability)

对应到项目：

- `disableInspector()`：`src/main.opy:862`
- Anti-Crash 链路：`src/main.opy:976`
- 条件前置短路（如 AI 规则先过滤 `isAlive/hasSpawned`）
- 大量 `eachPlayer` 规则显式节流（`wait(...)`）

## 3) C-Style / OverPy 风格参考

- 文章：[C-Style Syntax in Workshop](https://workshop.codes/wiki/articles/c-style-syntax-in-workshop)

对应到项目：

- OverPy `rule/def/@Condition` 风格贯穿全文件。
- 复用子程序（`resetHero()`, `applyCustomHp()`, `botAim2Target()`）减少重复逻辑。
- 大量列表推导、`sorted`、`random.choice`、`evalOnce` 用于 AI 决策表达。

## 4) OW2 Workshop 差异

- 文章：[All Workshop changes from Overwatch 1 to Overwatch 2](https://workshop.codes/wiki/articles/all-workshop-changes-from-overwatch-1-to-overwatch-2)

对应到项目：

- Widow/Cassidy 远距离伤害衰减回退逻辑：
  - `[widowmaker.opy]: Revert sniper damage falloff`（`src/main.opy:5163`）
  - `[Cassidy.opy]: Revert sniper damage falloff`（`src/main.opy:5341`）
- 状态系统叠加与覆盖（Hack/Invincible/Phased Out/Unkillable）在多个英雄规则中统一处理。

## 5) 元素数与复杂度控制

- 文章：[Element Count Calculation](https://workshop.codes/wiki/articles/element-count-calculation)

对应到项目：

- 大型逻辑按“分隔规则 + 子程序”组织，避免单规则过载。
- 同类行为拆分为多个窄规则（如英雄初始化 Detect/Initialize 双规则），有利于定位与回滚。

## 6) 本仓库落地建议

- 新规则先过三关：
  1. 是否破坏分区顺序或分隔规则名。
  2. 是否引入无 `wait` 高频循环。
  3. 是否影响 `resetHero()` 链路与 `reset_pvar` 槽位语义。
- 高负载功能优先复用现有状态变量与子程序，不重复造轮子。
