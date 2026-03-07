# Main Contract (Canonical)

### R-MAIN-TOP-ORDER

`src/main.opy` 顶层顺序必须保持：

1. `settings { ... }`
2. `#Global variables` + `globalvar ... <index>`
3. `#Player variables` + `playervar ... <index>`
4. `#Subroutine names` + `subroutine ... <index>`
5. `#!optimizeStrict`
6. 规则主体（分区顺序保持）

### R-MAIN-INCLUDE-ORDER

主入口 include 顺序必须保持：

`constants/player_constants.opy` -> `modules/prelude/00-settings.opy` -> `modules/prelude/01-global-vars.opy` -> `modules/prelude/02-player-vars.opy` -> `modules/prelude/03-subroutine-names.opy` -> `#!optimizeStrict` -> `modules/bootstrap/*` -> `utilities/*` -> `modules/ai/*` -> `modules/hero_rules/*` -> `modules/hero_init/*` -> `modules/debug/*`

### R-MAIN-NO-INDEX-INCLUDE

- `src/main.opy` 不直接 include `*_index.opy`（仅作为顺序源与契约校验）。

### R-MAIN-CONSTANTS-BEFORE-PRELUDE

- `settings` 如依赖 constants 表达式，constants 必须先于 prelude include。

### R-MAIN-SECTION-DELIMITERS

- 规则主体分区边界保持：引导初始化 -> 稳定性管控 -> 生命周期/reset -> `Initialize AI Scripts` 到 `Initialize AI Scripts End` -> 英雄行为 -> `Initialize Heroes` 到 `Initialize Heors End` -> debug/changelog。
