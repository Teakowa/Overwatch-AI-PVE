# 01. `src/main.opy` 代码逻辑总览

本文档基于当前模块化结构整理，目标是帮助协作者理解编排顺序、运行链路与维护边界。

## 1. 快速事实

- 主入口：`src/main.opy`（manifest）
- 规则数：`361`
- `globalvar`：`41`
- `playervar`：`64`
- `subroutine` 声明：`14`
- `def` 子程序实现：`13`
- `@Disabled` 规则：`15`

## 2. 顶层结构顺序（硬约束）

入口 `src/main.opy` 按以下顺序 include：

1. `modules/prelude/_index.opy`（内部顺序固定为 `00-settings -> 01-global-vars -> 02-player-vars -> 03-subroutine-names`）
2. `#!optimizeStrict`
3. `constants/player_constants.opy`（集中维护跨模块复用常量）
4. `modules/_index.opy`（内部顺序固定为 `bootstrap -> ai -> hero_rules -> hero_init -> debug`）

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
