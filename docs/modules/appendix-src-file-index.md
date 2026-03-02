# 附录：`src/` 模块文件索引

## 1. 入口

- `src/main.opy`：模块清单入口（manifest）
- `src/modules/_index.opy`：玩法域聚合入口

## 2. Prelude

- `src/modules/prelude/_index.opy`
- `src/modules/prelude/00-settings.opy`
- `src/modules/prelude/01-global-vars.opy`
- `src/modules/prelude/02-player-vars.opy`
- `src/modules/prelude/03-subroutine-names.opy`

## 3. Bootstrap

- `src/modules/bootstrap/00-init-and-settings.opy`
- `src/modules/bootstrap/10-safety-blacklist-ban.opy`
- `src/modules/bootstrap/20-player-lifecycle-and-reset.opy`

## 4. AI

- `src/modules/ai/00-delimiter-begin.opy`
- `src/modules/ai/core/_index.opy`
- `src/modules/ai/core/10-core-global-and-targeting.opy`
- `src/modules/ai/movement/_index.opy`
- `src/modules/ai/movement/20-movement.opy`
- `src/modules/ai/control/_index.opy`
- `src/modules/ai/control/30-control-tracer-reaper-genji.opy`
- `src/modules/ai/control/31-control-supports.opy`
- `src/modules/ai/control/32-control-tanks.opy`
- `src/modules/ai/control/33-control-projectile-and-special.opy`
- `src/modules/ai/99-delimiter-end.opy`

## 5. Hero Rules

- `src/modules/hero_rules/shared.opy`
- `src/modules/hero_rules/heroes/_index.opy`
- `src/modules/hero_rules/heroes/*.opy`

说明：本区采用“连续片段拆分”以保留执行顺序，因此同一英雄可能出现在多个文件。

## 6. Hero Init

- `src/modules/hero_init/00-delimiter-begin.opy`
- `src/modules/hero_init/heroes/*.opy`
- `src/modules/hero_init/extras/*.opy`
- `src/modules/hero_init/99-delimiter-end.opy`

## 7. Debug

- `src/modules/debug/10-debug-ultimate.opy`
- `src/modules/debug/20-changelog.opy`

## 8. 关键不变量检查点

- `rule` 总数应保持 `375`
- 分隔规则名应保持不变：
  - `Initialize AI Scripts`
  - `Initialize AI Scripts End`
  - `Initialize Heroes`
  - `Initialize Heors End`
- `globalvar/playervar/subroutine` 索引不可重排
