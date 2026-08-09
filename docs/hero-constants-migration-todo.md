# Hero Balance Constants Migration TODO (OW2 references -> PvE targets)

本文档用于指导后续在不改变玩法表现的前提下，按英雄逐步维护 OW2 reference、PvE target、relative modifier 与 project-only mechanic 的边界。

## 0. 目标与原则

- 目标：仅做可维护性重构，不主动调整平衡或玩法行为。
- 原则：
  - 等价重构优先（行为一致）。
  - 单次改动作用域可控（每次 1 个英雄，最多 2 个）。
  - 高收益优先（按常量密度与风险收益排序）。
  - vanilla baseline 只从 `data/ow2/reference-snapshot.json` 读取，并由生成的 `OW2_*` 文件提供给消费者。
  - `src/constants/player_constants.opy` 只拥有 PvE targets、relative modifiers 与 project-only mechanics，不重新定义 `OW2_*` baseline。
  - Main 与 ARAM 共用 reference 数据，但 target、modifier、机制和 runtime Workshop defaults 可以独立。

## 1. 约束与不变量

- 不能破坏现有主入口与 include 顺序：
  - `src/main.opy` 保持 `constants/player_constants.opy -> prelude 四文件 -> #!optimizeStrict -> bootstrap/utilities/ai/hero_rules/hero_init/debug 扁平 include`。
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
  - `data/ow2/reference-snapshot.json` 中项目实际消费的、带 provenance/ruleset 的 reference。
  - `src/modules/prelude/settings.opy` 与 `src/aram_settings.opy` 中审计标记为 baseline-derived/target-managed 的 settings。
  - `src/constants/player_constants.opy` 中表达绝对 PvE target 或显式 relative modifier 的常量。
  - `src/modules/hero_rules/heroes/*.opy` 中没有可靠 vanilla baseline 的 project-only mechanic 常量。
- Out of scope：
  - `src/modules/bootstrap/init-and-settings.opy` 的 `createWorkshopSetting*` 运行时配置（例如 `ReaperBuff/MaugaBuff/...`）。
  - ARAM 中没有可靠 reference 对应关系的直接数字；这些先保持 `runtime_workshop_setting`，不得仅凭数字猜测意图。
  - 索引重排、规则改名、include 顺序调整。

## 3. 命名与表达式规范（强约束）

### 3.1 Settings 常量命名

- canonical OW2 reference：只使用生成文件中的 `OW2_<HERO>_<FIELD>`，禁止在其他 `.opy` 文件重复定义或使用去掉 `OW2_` 的旧 alias。
- 绝对 PvE target（可由基准值计算）：
  - `SET_AI_<HERO>_<FIELD>_TARGET`
  - `SET_PLAYER_<HERO>_<FIELD>_TARGET`
  - ARAM 按实际作用域使用 `SET_ARAM_TEAM1_<HERO>_<FIELD>_TARGET`、`SET_ARAM_TEAM2_<HERO>_<FIELD>_TARGET` 或 `SET_ARAM_ALLTEAMS_<HERO>_<FIELD>_TARGET`。
- relative modifier：使用 `REL_<SCOPE>_<HERO>_<FIELD>_PERCENT`，并通过 `relativePercent(REL_..., OW2_...)` 保留其 reference provenance。
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
- relative modifier：`relativePercent(REL_..._PERCENT, OW2_...)`、`relativeRatioPercent(REL_..._PERCENT, OW2_...)` 或 `relativeUltGenPercent(REL_..._PERCENT, OW2_...)`；第二个参数用于审计和 provenance，宏展开后保持原有 Workshop 百分比计算。
- 无可靠基准值时：直接常量引用，不保留裸数字。

## 4. 迁移模式

### 4.1 Settings 五种替换模式

1. 基准值 + 目标值：
- Before: `"ability2Cooldown%": 67`
- After: `"ability2Cooldown%": ratioPercent(SET_AI_X_ABILITY2_COOLDOWN_TARGET, X_ABILITY2_COOLDOWN)`

2. 终极充能：
- Before: `"ultGen%": 135`
- After: `"ultGen%": ultGenPercent(X_ULT_COST, SET_AI_X_ULT_COST_TARGET)`

3. 直接常量：
- Before: `"damageReceived%": 60`
- After: `"damageReceived%": SET_AI_X_DAMAGE_RECEIVED`

4. relative modifier：
- Before: `"ability2Cooldown%": ratioPercent(SET_AI_X_ABILITY2_COOLDOWN_TARGET, OW2_X_ABILITY2_COOLDOWN)`
- After: `"ability2Cooldown%": relativeRatioPercent(REL_AI_X_ABILITY2_COOLDOWN_PERCENT, OW2_X_ABILITY2_COOLDOWN)`
- `REL_*_PERCENT` 是相对百分比，不得误读成绝对秒数 target。

5. ARAM 独立 relative modifier：
- Before: `"ultGen%": 175`
- After: `"ultGen%": relativeUltGenPercent(REL_ARAM_ALLTEAMS_JUNO_ULT_COST_PERCENT, OW2_JUNO_ULT_COST)`
- `REL_ARAM_*` 的数值必须保持 ARAM 自己的调优，不得为了复用 Main 而强行相同。

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
- 使用 `pnpm run tool:audit-hero-balance -- --check` 查看 baseline、target、relative 与 runtime 分类。
- 标注“可迁移 reference/target”与“不可从数字推断的 runtime 配置”。

2. Reference/target 定义
- reference 只修改 `data/ow2/reference-snapshot.json`，再运行 generator。
- PvE target 在 `src/constants/player_constants.opy` 对应英雄块新增；命名遵循第 3 节规范。

3. 替换引用
- `settings` 改为 `ratioPercent/ultGenPercent/relativePercent/relativeRatioPercent/relativeUltGenPercent/直接常量`。
- `rules` 改为命名的 project-only 或 relative modifier 常量。

4. 门禁执行
- `pnpm run tool:generate-ow2-reference -- --check`
- `pnpm run tool:audit-hero-balance -- --check`
- `pnpm run tool:check-hero-balance-architecture`
- `tools/check-contracts.ts --build`
- `pnpm run build:release:all`
- 若改动实质影响玩家数值，再运行 `tools/changelog-sync.ts --from-diff`。

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
| ramattra | P0 | both | 0 | - | in_progress | 避免触碰 `Ram_Annihilation` 运行时配置链 |

## 8. 测试场景与验收标准

### 场景 A：settings-only 英雄（如 `torbjorn` / `mei`）

- 仅发生 target/reference 引用替换。
- 不引入规则行为变化。

### 场景 B：rules-heavy 英雄（如 `reaper`）

- `rules` 静态数字替换为命名常量。
- `createWorkshopSetting*` 驱动的 Buff 链路不变。

### 场景 C：mixed 英雄（如 `mauga` / `ramattra`）

- 同时覆盖 `settings + rules`，门禁全绿。

### 统一验收

- 编译通过，契约检查通过。
- baseline-managed 英雄块不再引入新的裸数字；runtime Workshop 与 project-only 数字按审计分类保留。
- 生成 reference 无漂移、无重复 canonical definition、无 deprecated alias use。
- 无索引、分隔规则、include 顺序漂移。

## 9. 提交规范建议

- 推荐提交类型：`refactor(<hero>): migrate balance constants`
- 提交说明至少包含：
  - 影响英雄/系统
  - 是否影响服务器负载
  - 是否调整初始化或 reset 链路
- 若顺带平衡改动，必须拆分为独立提交并补 changelog 流程。

## 10. 假设与默认值

- Todo 文件路径固定：`docs/hero-constants-migration-todo.md`
- 覆盖范围：官方 + 自定义全部英雄；reference 只收录项目实际消费字段。
- 执行顺序：先完成 #78 audit、#79 generator，再按 reference -> target -> consumer -> guard 迁移；不按发布时间排序。
- 当前阶段目标：等价重构，不做平衡数值调优；provisional provenance 必须保持显式。
