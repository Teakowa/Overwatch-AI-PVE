# 05. Macro / JS Macro 优化 TODO（实施指引）

本文档用于指导后续在不改变玩法表现的前提下，逐步引入 OverPy `macro` 与 JS macro，降低重复代码与维护成本。

## 0. 基线与约束

- 目标：仅做可维护性优化，不主动修改玩法行为。
- 保持硬约束不变：
  - 顶层编排顺序不变（`prelude -> optimizeStrict -> constants -> modules`）。
  - 关键分隔规则名不变：`Initialize AI Scripts`、`Initialize AI Scripts End`、`Initialize Heroes`、`Initialize Heors End`。
  - `globalvar/playervar/subroutine` 索引不重排。
  - `@Disabled` 规则不随意删除。

## 1. 实施清单

- [ ] 建立改造基线并记录构建结果。
  - `pnpm run build`
  - `pnpm run build:release`
- [ ] 新建宏入口文件（建议：`src/constants/macros.opy`），集中维护 `macro`。
- [ ] 将 `#!define` 中可安全迁移项逐步替换为 `macro`（优先常量表达式）。
- [ ] 先做 Hero Init 模板化试点（5 个英雄：Tracer / Reaper / Ana / Widowmaker / Baptiste）。
- [ ] 抽取 Hero Init 通用片段宏（Detect/Initialize骨架中的重复动作）。
- [ ] 修复 Hero Init 协议漂移项（如 Sombra 初始化条件缺失）。
- [ ] 扩展 Hero Init 宏化到全量英雄（保留特殊英雄例外逻辑）。
- [ ] 抽取 AI 控制层共通条件宏（`hasSpawned/isAlive/isDummy/botTarget/LoS`）。
- [ ] 抽取 AI 节流等待宏（统一 `wait(max(getServerLoad()/1000, ...))`）。
- [ ] 抽取通用公式宏（如 falloff/clamp 计算，减少重复数学表达式）。
- [ ] 引入第一个 JS macro（建议先做黑名单数据生成，低玩法风险）。
- [ ] 评估 Changelog 是否进入 JS macro（复杂度高，放第二阶段，可延期）。
- [ ] 增加契约自检脚本（分隔规则名、索引、Hero Init 协议、`@Disabled`）。
- [ ] 同步更新文档（`03-module-contracts.md`、`04-current-implementation-summary.md`）。

## 2. 推荐执行顺序

1. 基础设施阶段：基线、宏入口、`#!define -> macro` 安全迁移。
2. Hero Init 阶段：先试点再全量铺开。
3. AI 阶段：共通条件与节流宏收敛。
4. JS macro 阶段：先黑名单数据化，再评估 Changelog。
5. 收口阶段：自检脚本、文档与回归检查。

## 3. 提交建议（Conventional Commits）

- `docs(modules): add macro/js-macro implementation todo`
- `refactor(hero_init): extract shared init macros for pilot heroes`
- `refactor(ai): extract shared ai condition and throttle macros`
- `build(tooling): add contract regression checks for module invariants`

## 4. 每阶段验收标准

- 编译通过：`pnpm run build`、`pnpm run build:release`。
- 分区顺序与分隔规则名保持不变。
- 变量与子程序索引保持不变。
- 不引入无等待高频循环。
- 高负载场景下 Anti Crash 链路不弱化。
