# AGENTS.md

本文件定义仓库协作约定，目标：玩法稳定、结构可维护、负载可控。

## 1. 项目范围

- 类型：Overwatch 2 Workshop（OverPy）。
- 主入口：`src/main.opy`（单入口编排）；根目录历史 `main.opy` 不再作为主编辑入口。
- 产物：`workshop.ow`；说明见 `README.md`。

## 2. `src/main.opy` 结构契约（必须保持顺序）

顶层顺序：
1. `settings { ... }`
2. `#Global variables` + `globalvar ... <index>`
3. `#Player variables` + `playervar ... <index>`
4. `#Subroutine names` + `subroutine ... <index>`
5. `#!optimizeStrict`
6. 规则主体（分区顺序保持）

主入口 include 顺序：
`constants/player_constants.opy` -> `modules/prelude/00-settings.opy` -> `modules/prelude/01-global-vars.opy` -> `modules/prelude/02-player-vars.opy` -> `modules/prelude/03-subroutine-names.opy` -> `#!optimizeStrict` -> `modules/bootstrap/*` -> `utilities/*` -> `modules/ai/*` -> `modules/hero_rules/*` -> `modules/hero_init/*` -> `modules/debug/*`

补充约束：
- `src/main.opy` 不直接 include `*_index.opy`（仅作为顺序源与契约校验）。
- `settings` 如依赖 constants 表达式，constants 必须先于 prelude include。
- 规则主体分区边界保持：引导初始化 -> 稳定性管控 -> 生命周期/reset -> `Initialize AI Scripts` 到 `Initialize AI Scripts End` -> 英雄行为 -> `Initialize Heroes` 到 `Initialize Heors End` -> debug/changelog。

## 3. 硬约束

1. 变量/子程序索引是协议：禁止改号（`globalvar/playervar/subroutine <index>`）。
2. 改动策略：优先追加，避免重排变量与规则。
3. 保留关键分隔规则名：`Initialize AI Scripts`、`Initialize AI Scripts End`、`Initialize Heroes`、`Initialize Heors End`（拼写保持现状）。
4. 不随意移除 `@Disabled` 规则。
5. 规则命名保持现有风格（`[module]: action`）。
6. 英雄通用数值优先放 `settings`；仅在依赖前置条件时使用 `rule`。

## 4. Hero Init 约定

新增/改造初始化遵循双规则：
1. Detect：命中时 `eventPlayer.reset_pvar[0] = true`。
2. Initialize：
   - 条件：`eventPlayer.reset_pvar[0] != false`
   - 调用：`resetHero()`
   - 写入：自定义生命值/状态
   - 结尾：`eventPlayer.reset_pvar[0] = false`

遗漏复位会导致重复初始化或循环执行。

## 5. 性能与稳定性

1. 高频逻辑必须节流：使用 `wait(...)`/`waitUntil(...)`，避免无等待循环。
2. `conditions` 首项优先低成本高筛选门控；避免把距离、大数组判断放首位。
3. 面向特定英雄/槽位时，优先用事件 `Player` 过滤器（Hero/Slot）。
4. 避免开局首 tick 全量重条件/重动作；应延后触发并为多玩家去同步。
5. 大遍历、字符串处理与高成本检测优先低频化/分批执行/缓存化。
6. Anti Crash（`getAverageServerLoad()`）是保底保护链路，不弱化。

## 6. 改动自检清单

1. 是否破坏顶层顺序、include 契约或关键分隔规则？
2. 是否改动已有变量/子程序索引？
3. 英雄改动是否覆盖 init Detect/Initialize、reset 清理与必要 changelog/HUD？
4. 是否引入无等待循环或高频昂贵表达式？
5. 是否误改 Team 1（AI）与 Team 2（玩家）职责边界？
6. 是否引入开局同 tick 峰值或高频条件直接读取频繁变化大数组？

## 7. 提交与门禁

- 小步提交，使用 Conventional Commits；跨分区改动优先拆分为可回滚提交。
- 玩法改动提交说明应标注：影响英雄/系统、负载影响、是否调整 init/reset 链路。

常用命令：
- `pnpm run build`
- `pnpm run build:release`
- `skills/ow-contract-guard/scripts/check_contracts.sh`
- `skills/ow-contract-guard/scripts/check_contracts.sh --strict-hero-init`
- `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --from-diff`
- `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --from-diff --build`
- `skills/ow-changelog-sync/scripts/changelog_sync.sh --from-diff`
- `skills/ow-changelog-sync/scripts/changelog_sync.sh --from-diff --strict-coverage --strict-language --strict-settings-sync`
- `skills/ow-module-metrics-sync/scripts/metrics_sync.sh`
- `skills/ow-module-metrics-sync/scripts/metrics_sync.sh --check`

建议门禁顺序：
1. `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --from-diff`
2. `skills/ow-contract-guard/scripts/check_contracts.sh --build`
3. `pnpm run build`
