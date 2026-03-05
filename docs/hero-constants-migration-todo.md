# Hero Constants Migration TODO (settings/rules -> player_constants)

本文档用于指导后续在不改变玩法表现的前提下，按英雄逐步将 `settings/rules` 中静态硬编码常量迁移到 `src/constants/player_constants.opy`，并在原位置替换为计算调用或常量引用。

## 0. 目标与原则

- 目标：仅做可维护性重构，不主动调整平衡或玩法行为。
- 原则：
  - 等价重构优先（行为一致）。
  - 单次改动作用域可控（每次 1 个英雄，最多 2 个）。
  - 高收益优先（按常量密度与风险收益排序）。

## 1. 约束与不变量

- 不能破坏现有主入口与 include 顺序：
  - `src/main.opy` 保持 `constants/player_constants.opy -> modules/prelude/_index.opy -> #!optimizeStrict -> modules/_index.opy`。
- 不能改动变量协议索引：
  - `globalvar/playervar/subroutine` 索引号不重排。
- 不能改动关键分隔规则名：
  - `Initialize AI Scripts`
  - `Initialize AI Scripts End`
  - `Initialize Heroes`
  - `Initialize Heors End`
- 不随意删除 `@Disabled` 规则。

## 2. 范围与边界

- In scope：
  - `src/modules/prelude/00-settings.opy` 中英雄相关裸数字（静态常量）。
  - `src/modules/hero_rules/heroes/*.opy` 中静态魔法数。
- Out of scope：
  - `src/modules/bootstrap/00-init-and-settings.opy` 的 `createWorkshopSetting*` 运行时配置（例如 `ReaperBuff/MaugaBuff/...`）。
  - 索引重排、规则改名、include 顺序调整。

## 3. 命名与表达式规范（强约束）

### 3.1 Settings 常量命名

- 目标值（可由基准值计算）：
  - `SET_AI_<HERO>_<FIELD>_TARGET`
  - `SET_PLAYER_<HERO>_<FIELD>_TARGET`
- 直接值（无可靠基准值）：
  - `SET_AI_<HERO>_<FIELD>`
  - `SET_PLAYER_<HERO>_<FIELD>`

### 3.2 Rules 常量命名

- 统一使用：`<HERO>_<MECHANIC>_<UNIT>`
- 示例：
  - `REAPER_SOUL_STACK_GAIN`
  - `WUYANG_SLOW_PERCENT`
  - `FREJA_EXECUTE_THRESHOLD`

### 3.3 Settings 表达式选择

- 冷却/比例优先：`ratioPercent(...)`
- 终极充能优先：`ultGenPercent(...)`
- 无可靠基准值时：直接常量引用，不保留裸数字。

## 4. 迁移模式

### 4.1 Settings 三种替换模式

1. 基准值 + 目标值：
- Before: `"ability2Cooldown%": 67`
- After: `"ability2Cooldown%": ratioPercent(SET_AI_X_ABILITY2_COOLDOWN_TARGET, X_ABILITY2_COOLDOWN)`

2. 终极充能：
- Before: `"ultGen%": 135`
- After: `"ultGen%": ultGenPercent(X_ULT_COST, SET_AI_X_ULT_COST_TARGET)`

3. 直接常量：
- Before: `"damageReceived%": 60`
- After: `"damageReceived%": SET_AI_X_DAMAGE_RECEIVED`

### 4.2 Rules 常量提取规则

- 提取对象：
  - 固定时长（如 `1.5`、`3`）
  - 固定阈值（如 `<= 75`）
  - 固定倍率/比例（如 `0.35`、`25`）
- 不提取对象：
  - 来自 `createWorkshopSetting*` 的运行时变量（`*Buff`、`HeadshotDamage` 等）
  - 与引擎 API 强绑定且语义固定的枚举常量

## 5. 英雄执行模板（每次提交可复制）

1. 盘点
- 扫描目标英雄在 `00-settings.opy` 与 `hero_rules` 的裸数字。
- 标注“可迁移静态值”与“运行时配置值”。

2. 常量定义
- 在 `src/constants/player_constants.opy` 对应英雄块新增常量。
- 命名遵循第 3 节规范。

3. 替换引用
- `settings` 改为 `ratioPercent/ultGenPercent/直接常量`。
- `rules` 改为命名常量引用。

4. 门禁执行
- `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --from-diff`
- `skills/ow-contract-guard/scripts/check_contracts.sh --build`
- `pnpm run build`
- 若改动实质影响玩家数值：
  - `skills/ow-changelog-sync/scripts/changelog_sync.sh --from-diff`

5. 收口
- 更新本 Todo 进度表状态与备注。
- 提交信息注明：影响英雄、负载风险、是否触及 init/reset 链路。

## 6. 优先级路线图（高收益优先，含全部英雄）

### P0 首批

- `reaper`
- `wuyang`
- `freja`
- `mauga`
- `ramattra`

### P1 第二批

- `reinhardt`
- `brigitte`
- `doomfist`
- `kiriko`
- `sombra`
- `zarya`
- `vendetta`

### P2 第三批

- `sigma`
- `tracer`
- `zenyatta`
- `juno`
- `mizuki`
- `hazard`
- `orisa`
- `illari`

### Backlog（其余英雄，按字母序）

- `ana`
- `anran`
- `ashe`
- `baptiste`
- `bastion`
- `cassidy`
- `domina`
- `dva`
- `echo`
- `emre`
- `genji`
- `hanzo`
- `jetpackCat`
- `junkerQueen`
- `junkrat`
- `lifeweaver`
- `lucio`
- `mei`
- `mercy`
- `moira`
- `pharah`
- `roadhog`
- `sojourn`
- `soldier`
- `symmetra`
- `torbjorn`
- `venture`
- `widowmaker`
- `winston`
- `wreckingBall`

## 7. 进度表

| Hero | Priority | Scope (settings/rules/both) | Constants Added | Gate Result | Status (todo/in_progress/done) | Notes |
|---|---|---|---|---|---|---|
| reaper | P0 | both | 0 | - | todo | rules 密度高，优先抽取固定阈值/时长 |
| wuyang | P0 | both | 0 | - | todo | 规则分支多，先做低风险时长/百分比常量 |
| freja | P0 | both | 0 | - | todo | 先抽取执行阈值与持续时长 |
| mauga | P0 | both | 0 | - | todo | 避免触碰 `MaugaBuff` 运行时配置链 |
| ramattra | P0 | both | 0 | - | todo | 避免触碰 `Ram_Annihilation` 运行时配置链 |

## 8. 测试场景与验收标准

### 场景 A：settings-only 英雄（如 `torbjorn` / `mei`）

- 仅发生常量抽取和 `settings` 引用替换。
- 不引入规则行为变化。

### 场景 B：rules-heavy 英雄（如 `reaper`）

- `rules` 静态数字替换为命名常量。
- `createWorkshopSetting*` 驱动的 Buff 链路不变。

### 场景 C：mixed 英雄（如 `mauga` / `ramattra`）

- 同时覆盖 `settings + rules`，门禁全绿。

### 统一验收

- 编译通过，契约检查通过。
- 已完成英雄块不再引入新的裸数字。
- 无索引、分隔规则、include 顺序漂移。

## 9. 提交规范建议

- 推荐提交类型：`refactor(<hero>): migrate static constants to player_constants`
- 提交说明至少包含：
  - 影响英雄/系统
  - 是否影响服务器负载
  - 是否调整初始化或 reset 链路
- 若顺带平衡改动，必须拆分为独立提交并补 changelog 流程。

## 10. 假设与默认值

- Todo 文件路径固定：`docs/hero-constants-migration-todo.md`
- 覆盖范围：官方 + 自定义全部英雄。
- 执行顺序：按常量密度 + 风险收益优先，不按发布时间排序。
- 当前阶段目标：等价重构，不做平衡数值调优。
