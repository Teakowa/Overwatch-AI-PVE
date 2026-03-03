# AGENTS.md

本文件定义本仓库的人类与 AI 协作约定。目标是：
- 在不破坏玩法稳定性的前提下迭代 Workshop 逻辑
- 保持 `src/main.opy` 的结构和执行顺序可维护
- 降低服务器负载相关回归风险

## 1. Project Overview

- 项目类型：Overwatch 2 Workshop（OverPy 源码）
- 当前主入口：`src/main.opy`（单入口、单文件编排）
- 仓库根目录历史文件 `main.opy` 不再作为主编辑入口
- 输出工件：`workshop.ow`
- 参考说明：`README.md`

## 2. Directory Responsibilities

- `src/main.opy`
  - 核心玩法、AI、英雄改动、初始化、调试与 HUD 文案全部在此维护
  - 当前文件约 6k+ 行，属于“有分区的单体脚本”，改动要严格控制作用域
- `workshop.ow`
  - 导出的 Workshop 代码产物（通常不手改）
- `README.md`
  - 面向玩家的玩法说明，可能滞后于脚本细节

## 3. Current `src/main.opy` Structure (must keep order)

按当前文件顺序，顶层结构为：
1. `settings { ... }`
2. `#Global variables` + `globalvar ... <index>`
3. `#Player variables` + `playervar ... <index>`
4. `#Subroutine names` + `subroutine ... <index>`
5. `#!optimizeStrict`
6. 规则主体（按分区顺序）

主入口 include 顺序契约：
- `constants/player_constants.opy` -> `modules/prelude/_index.opy` -> `#!optimizeStrict` -> `modules/_index.opy`
- `settings` 若使用 constants 计算表达式，必须保证 constants 先于 prelude 被 include

规则主体建议保持以下分区边界和先后关系：
1. 引导与全局初始化（版权、全局设置、英雄能力设置）
2. 稳定性与管控（Anti Crash、Blacklist、英雄池 BAN）
3. 玩家生命周期与 reset 工具链（join/leave/died、`resetHero()` 等）
4. AI 主逻辑区（从 `Initialize AI Scripts` 到 `Initialize AI Scripts End`）
5. 英雄行为改动区（各英雄技能增强/限制）
6. 英雄初始化区（从 `Initialize Heroes` 到 `Initialize Heors End`）
7. 调试与变更展示（debug rule、`Changelog`/`changelogText()`）

## 4. Hard Constraints

1. 变量索引是协议，不要随意改号：
   - `globalvar Foo <index>`
   - `playervar Foo <index>`
   - `subroutine Foo <index>`
2. 尽量只追加，不重排：
   - 新增变量优先用未占用索引
   - 禁止“为美观”批量重排变量和规则
3. 保留关键分隔规则名：
   - `Initialize AI Scripts`
   - `Initialize AI Scripts End`
   - `Initialize Heroes`
   - `Initialize Heors End`（保持现有拼写，避免兼容风险）
4. 不要随意移除 `@Disabled` 规则。它们可能是灰度/调试开关。
5. 规则命名保持现有风格（`[module]: action`，中英混合可接受）。
6. 英雄通用数值调整优先放在 `settings`：
   - 伤害调整、减伤、治疗、受到治疗、技能冷却、终极技能充能等通用调整，不应单独创建 `rule`
   - 仅当效果依赖前置条件时使用 `rule`（例如“造成伤害降低技能冷却”“造成治疗时额外 XXX”“使用终极技能时 XXX”）

## 5. Hero Init Pattern (follow existing convention)

新增/改造英雄初始化逻辑时，遵循既有双规则模式：
1. Detect 规则：英雄命中时 `eventPlayer.reset_pvar[0] = true`
2. Initialize 规则：
   - 条件 `eventPlayer.reset_pvar[0] != false`
   - 调用 `resetHero()`
   - 写入自定义生命值/状态
   - 最后将 `eventPlayer.reset_pvar[0] = false`

避免在 Initialize 规则中遗漏“复位 false”，否则会导致重复初始化或循环执行。

## 6. Performance & Stability Guidelines

1. `eachPlayer` 与循环逻辑必须谨慎增加，优先复用现有状态变量与 helper。
2. 大部分高频逻辑需带 `wait(...)`/`waitUntil(...)` 节流，避免无等待循环。
3. 持续时间效果默认使用 `wait(...)` 实现；仅当需求明确要求“重复命中刷新时长/窗口重置”时，才使用 `getMatchTime()` 等时间戳方案。
4. 涉及全局遍历和字符串处理时，尽量放在初始化时机，而不是常驻帧逻辑。
5. Anti Crash 相关规则（基于 `getAverageServerLoad()`）是保底保护，不要弱化触发链路。
6. 任何新增特效、HUD、dot、强控逻辑，都应评估 Team 1 AI 满员场景下的负载。
7. Workshop `conditions` 按顺序短路评估：首条件优先放“低成本且高筛选率”的门控条件，避免将 `Distance Between`、`Is True For Any(...)`（尤其大数组）等昂贵表达式置顶。
8. 避免多个互斥规则共享同一个首条件导致重复评估；在可维护性可接受时，优先合并为单规则并在 `actions` 内用分支处理。
9. 规则只针对特定英雄/槽位时，优先使用事件 `Player` 过滤器（Hero/Slot），不要仅依赖 `Hero Of(Event Player)` 条件筛选。
10. 开局阶段禁止让重条件/重动作在首 tick 全量激活；应通过 `Total Time Elapsed`、`Number Of Living Players`、玩家 spawn 状态或启动 `Wait` 延后触发。
11. 对可降采样的高成本检测，优先采用 `Wait + If + Loop` 的稀疏评估模式；仅在确需高精度时保留高频条件。
12. 多玩家重初始化或重动作链应做去同步（例如按 `Slot Of(Event Player)` 偏移 `Wait`），降低同 tick 峰值。
13. 单规则长动作链应分批执行并插入短 `Wait`，避免同帧堆叠造成瞬时负载尖峰。
14. 避免在高频条件中直接引用频繁变化的大数组；优先改为低频计算、局部缓存或分段变量后再判定。
15. 社区经验（如时段负载波动、回放系统周期峰值）可作为背景参考，但不应作为硬门禁或固定阈值依据。

## 7. Change Checklist

对 `src/main.opy` 做功能改动时，至少自检以下项：
1. 是否破坏了顶层分区顺序或分隔规则？
2. 是否改动了已有变量/子程序索引？
3. 新增英雄逻辑是否同时覆盖：
   - 初始化 Detect/Initialize
   - reset 清理路径
   - 必要的 HUD/changelog 文案
4. 是否引入了无等待循环或高频昂贵表达式？
5. 是否误改 `Team 1`（AI）与 `Team 2`（玩家）的职责边界？
6. 条件首项是否为低成本门控，而非距离/大数组等昂贵计算？
7. 英雄/槽位限定规则是否优先使用了事件 `Player` 过滤器，而非仅靠 `Hero Of(...)` 条件？
8. 是否引入了开局同 tick 的重动作/重条件峰值（未延后、未去同步）？
9. 是否把频繁变化的大数组直接放入高频 `conditions`？

## 8. Commit & Review Expectations

- 小步提交，提交信息使用 Conventional Commits。
- 涉及玩法改动时，在提交说明中标注：
  - 影响英雄/系统
  - 是否影响服务器负载
  - 是否调整初始化或 reset 链路
- 如改动跨越多个分区，优先拆分为可回滚的小提交。

## 9. Repo Workflows & Commands

- 基础构建（本地）：`pnpm run build`
- 发行构建（输出到 `build/main.ow`）：`pnpm run build:release`
- 结构与协议契约校验：`skills/ow-contract-guard/scripts/check_contracts.sh`
- 英雄改动回归流水线（按 diff 自动识别英雄）：`skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --from-diff`
- Changelog 同步检查（按 diff）：`skills/ow-changelog-sync/scripts/changelog_sync.sh --from-diff`
- 模块文档指标同步：`skills/ow-module-metrics-sync/scripts/metrics_sync.sh`

建议门禁顺序（玩法/结构改动）：
1. `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --from-diff`
2. `skills/ow-contract-guard/scripts/check_contracts.sh --build`
3. `pnpm run build`
