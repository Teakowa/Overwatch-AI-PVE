# 01. `src/main.opy` 代码逻辑总览

本文档基于当前模块化结构整理，目标是帮助协作者理解编排顺序、运行链路与维护边界。

## 规范来源迁移说明（Canonical）

- 本文档用于架构理解与背景说明，不再作为规则 canonical 来源。
- `src/main.opy` 结构与分隔规则以 `docs/agents/main-contract.md` 为准：
  - `R-MAIN-TOP-ORDER`
  - `R-MAIN-INCLUDE-ORDER`
  - `R-MAIN-NO-INDEX-INCLUDE`
  - `R-MAIN-CONSTANTS-BEFORE-PRELUDE`
  - `R-MAIN-SECTION-DELIMITERS`
- 变量与命名等通用约束以 `docs/agents/protocol-constraints.md` 为准。

## 1. 快速事实

- 主入口：`src/main.opy`（manifest）
- 文档不再维护静态数量统计（`rule/globalvar/playervar/subroutine/def/@Disabled`），避免与源码漂移

## 2. 顶层结构顺序（硬约束）

入口 `src/main.opy` 按以下顺序 include：

1. `constants/player_constants.opy`（集中维护跨模块复用常量）
2. `modules/prelude/00-settings.opy`
3. `modules/prelude/01-global-vars.opy`
4. `modules/prelude/02-player-vars.opy`
5. `modules/prelude/03-subroutine-names.opy`
6. `#!optimizeStrict`
7. `#!postCompileHook "post-compile-hook.js"`
8. `modules/bootstrap/*`
9. `utilities/*`
10. `modules/ai/*`
11. `modules/hero_rules/*`
12. `modules/hero_init/*`
13. `modules/debug/*`

说明：`src/main.opy` 不直接 include `*_index.opy`，但模块目录中的 `_index.opy` 仍作为顺序源用于契约校验。

## 3. 关键分隔规则（保留）

- `Initialize AI Scripts`
- `Initialize AI Scripts End`
- `Initialize Heroes`
- `Initialize Heors End`（保留现有拼写）

## 4. 运行链路

### 4.1 启动与全局设置（bootstrap）

- 版权/协作者文案初始化
- Anti Crash 设置项
- 全局模式与 AI 参数数组初始化
- 英雄设置项（Workshop Settings）初始化

### 4.2 稳定性与准入（bootstrap）

- Anti Crash 触发与恢复
- Blacklist 初始化与踢出
- Hero BAN 与可选英雄列表覆盖

### 4.3 玩家生命周期与 reset 工具链（bootstrap）

- 默认复活时间
- 死亡重置
- 回合切换重置
- 核心子程序：
  - `resetHero()`
  - `resetStats()`
  - `resetStatuses()`
  - `resetFrenemies()`
  - `applyCustomHp()` / `clearCustomHp()`

### 4.4 AI 主逻辑（ai）

- dummy 生成与全局 AI 参数
- 目标选择与朝向
- 移动（走位、跳蹲、速度恢复）
- 按英雄分组的控制规则（PRIMARY/SECONDARY/ABILITY/ULT）
- 当前以 `ai/core`、`ai/movement`、`ai/control` 分层编排，便于按职责扩展。

### 4.5 英雄行为改动（hero_rules）

- 主玩法增强区，包含伤害、状态、CD、HUD、联动逻辑
- 当前按连续片段拆到 `hero_rules/heroes/*.opy`，以保持原执行顺序

### 4.6 英雄初始化（hero_init）

- Detect/Initialize 双规则模式
- 额外规则（如 widow/cassidy falloff、echo duplicate、disabled health table）放入 `hero_init/extras/`

### 4.7 调试与展示（debug）

- `[Global][Debug]Auto Ultimate Gain`
- `Changelog` 与 `changelogText()`

## 5. 维护建议

1. 默认不调整规则顺序。
2. 不改变量索引协议。
3. `@Disabled` 规则仅在确认需要时启用。
4. 影响 `reset_pvar` 槽位语义时必须同步更新契约文档。
