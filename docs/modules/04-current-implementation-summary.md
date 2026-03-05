# 04. 当前代码实现分析与总结（2026-03）

本文档基于当前仓库源码（`src/main.opy` + `src/constants/*` + `src/modules/*`）整理，聚焦“现在是如何工作的”。

## 1. 当前实现快照

- 入口文件：`src/main.opy`
- 常量层：`src/constants/player_constants.opy`
- 业务模块：`src/modules/*`（按 `_index.opy` 显式编排）
- 文档不再维护静态数量统计（`rule/globalvar/playervar/subroutine/def/@Disabled`），避免与源码漂移

## 2. 编排顺序（真实执行入口）

`src/main.opy` 当前顺序为：

1. `#!include "constants/player_constants.opy"`
2. `#!include "modules/prelude/00-settings.opy"`
3. `#!include "modules/prelude/01-global-vars.opy"`
4. `#!include "modules/prelude/02-player-vars.opy"`
5. `#!include "modules/prelude/03-subroutine-names.opy"`
6. `#!optimizeStrict`
7. `#!postCompileHook "post-compile-hook.js"`
8. `modules/bootstrap/*.opy`（在 `main.opy` 中显式逐条列举）
9. `utilities/*.opy`（在 `main.opy` 中显式逐条列举）
10. `modules/ai/*.opy`（在 `main.opy` 中显式逐条列举）
11. `modules/hero_rules/*.opy`（在 `main.opy` 中显式逐条列举）
12. `modules/hero_init/*.opy`（在 `main.opy` 中显式逐条列举）
13. `modules/debug/*.opy`（在 `main.opy` 中显式逐条列举）

其中：

- `src/main.opy` 不直接 include `*_index.opy`
- `_index.opy` 仍作为模块顺序源，用于契约脚本校验扁平入口顺序

## 3. 模块职责与体量

- `bootstrap`：启动、稳定性与准入层
- `ai`：目标选择、移动与技能控制层
- `hero_rules`：英雄行为增强与玩法改动主层
- `hero_init`：英雄 Detect/Initialize 与附加初始化逻辑
- `debug`：调试规则与 changelog 展示

## 4. 核心执行链路

### 4.1 Bootstrap（启动、稳定性、准入）

- 初始化协作者文案、模式开关和英雄技能设置项（`createWorkshopSetting*`）。
- Anti Crash 通过 `getAverageServerLoad()` 阈值触发慢动作，待负载恢复后退出。
- 黑名单、Hero BAN、可选英雄覆盖和 HUD 初始化都在该阶段完成。

### 4.2 Reset 工具链（生命周期）

核心在 `bootstrap/20-player-lifecycle-and-reset.opy`：

- `playerDied` 与回合切换逻辑会重置状态。
- `resetHero()` 统一执行：
  - 清 HUD / 清临时状态
  - `clearCustomHp()`
  - `resetStats()` / `resetStatuses()` / `resetFrenemies()`
  - 恢复可用按键
- `reset_pvar` 槽位承担跨规则协作语义（详见 `03-module-contracts.md`）。

### 4.3 AI 主逻辑

- `ai/core`：
  - 负责 dummy 生成、目标筛选与锁定（`botTarget`）、终极技能触发策略。
- `ai/movement`：
  - 负责移动、跳蹲、转向、速度恢复等基础行为。
- `ai/control`：
  - 按英雄/能力编排主控动作（开火、技能、终极、节流等待）。

### 4.4 Hero Rules（玩法增强）

- `hero_rules/player_shared.opy` 放置玩家通用规则（如 `status reset`）。
- `hero_rules/heroes/*.opy` 放置英雄片段规则。
- 该层是玩法变化最密集区域，也是回归风险最高区域。

### 4.5 Hero Init（初始化）

- 保留分隔规则：`Initialize Heroes` / `Initialize Heors End`。
- 主体遵循 Detect/Initialize 双规则模型：
  - Detect：命中英雄后置 `eventPlayer.reset_pvar[0] = true`
  - Initialize：执行 `resetHero()` 和英雄初始写入，最后将 `reset_pvar[0]` 复位
- `extras/*` 补充跨英雄初始化逻辑（如 Widow/Cassidy 衰减修正、Echo duplicate）。

### 4.6 Debug / Changelog

- `debug/10-debug-ultimate.opy` 提供 Debug 开关逻辑（默认 `@Disabled`）。
- `debug/20-changelog.opy` 通过 `changelogText()` 动态渲染不同英雄的更新说明 HUD。

## 5. 维护重点（结合当前实现）

1. 不改变 include 顺序和分隔规则名（尤其 `Initialize Heors End` 的现有拼写）。
2. 不重排变量索引；新增只追加空闲位。
3. `hero_rules` 与 `hero_init` 改动优先小步提交，避免跨分区大改。
4. 高频规则必须保留节流（`wait` / `waitUntil` / `WAIT_AI_THROTTLE_MIN`）。
5. 涉及 `reset_pvar` 槽位语义变更时，同步更新契约文档。
