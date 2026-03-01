# 01. `src/main.opy` 代码逻辑总览

本文档基于当前 `src/main.opy`（约 6191 行）整理，目标是帮助协作者快速理解执行链路、数据协议与维护边界。

## 1. 快速事实

- 主入口：`src/main.opy`
- 规则数：`361`
- `globalvar`：`41`
- `playervar`：`64`
- `subroutine` 声明：`14`
- `def` 子程序实现：`13`
- `@Disabled` 规则：`15`

## 2. 顶层结构（顺序约束）

按源码顺序，顶层结构如下：

1. `settings { ... }`（`src/main.opy:3`）
2. `#Global variables`（`src/main.opy:726`）
3. `#Player variables`（`src/main.opy:771`）
4. `#Subroutine names`（`src/main.opy:839`）
5. `#!optimizeStrict`（`src/main.opy:858`）
6. 规则主体（`src/main.opy:861` 开始）

关键分隔规则：

- `Initialize AI Scripts`（`src/main.opy:1352`）
- `Initialize AI Scripts End`（`src/main.opy:2517`）
- `Initialize Heroes`（`src/main.opy:4805`）
- `Initialize Heors End`（`src/main.opy:6024`，保留现有拼写）

## 3. 主执行链路（运行时）

### 3.1 启动阶段（全局初始化）

- `Copyright ...`：关闭 Inspector、初始化英雄池和 Anti-Crash 设置。
- `Initialize global variables`：构建 AI 参数表（`FalloffMin` / `ProjectileSpeed` / `BotHeroArray`）与模式设置。
- `Initialize Hero Ability Settings`：将大量英雄平衡参数映射到 Workshop Settings。

### 3.2 稳定性与准入

- `[Anti Crash]: Activate anti crash`：基于 `getServerLoad()` 触发慢动作熔断，再等待负载回落。
- `[Global]Setup Blacklist` + 玩家进出规则：黑名单踢出与离场提示。
- `[Player]Hero BAN`：按地图和职业池动态禁用英雄。
- `[Player]: Override allowed heroes list...`：按身份（作者/协作者/普通玩家）设置可选英雄。

### 3.3 玩家生命周期与重置

- `resetFrenemies()` 在 `eachPlayer` 持续刷新友敌引用缓存。
- 两条 `Default respawn time` 规则分别控制 Team1/Team2 复活时长。
- `playerDied` 规则执行状态清理：HUD、buff、DoT、位移/状态控制等。
- 回合切换 `Reinitialize hero on new round`：新回合后统一 `resetHero()`。

### 3.4 英雄切换初始化触发

核心触发变量是 `eventPlayer.reset_pvar[0]`：

- Detect 规则：英雄命中后置 `true`
- Initialize 规则：
  - 条件 `eventPlayer.reset_pvar[0] != false`
  - `resetHero()`
  - 写入自定义生命值/弹药/名称/联动引用
  - 末尾置回 `false`

统一入口规则：

- `[utilities/hero_setup.opy]: Reset and initialize hero on hero switch`

## 4. 子程序契约（关键）

- `resetHero()`：标准重置入口，内部串联 `clearCustomHp()`、`resetStats()`、`resetStatuses()`、`resetFrenemies()`、`enableAllAbilities()`。
- `applyCustomHp()` / `clearCustomHp()`：自定义生命池协议，处理 Normal/Armor/Shields。
- `resetStats()`：伤害、治疗、投射物、击退、移速等倍率回归基线。
- `resetStatuses()`：清理状态效果、DoT、受控动作、关键临时标记。
- `resetFrenemies()`：缓存友方关键英雄与敌方关键英雄引用（供跨规则快速访问）。
- `botAim2Target()`：AI 朝向目标眼位。
- `Knockback()`：禅雅塔踢击复用击退子程序。
- `changelogText()`：出生室说明文本构建。

## 5. `reset_pvar` 关键协议（抽样）

`reset_pvar` 在本工程中被当作“共享指针槽位数组”使用，以下槽位有稳定语义：

- `[0]`：英雄初始化触发开关
- `[1]`：己方 Brigitte
- `[3]`：己方 Kiriko
- `[4]`：己方 Sombra
- `[5]`：敌方 Ramattra
- `[6]`：敌方 Sombra
- `[7]`：敌方 Ana
- `[9]`：敌方 Hanzo
- `[11]`：敌方 Freja
- `[12]`：己方 Baptiste
- `[13]`：己方 Wuyang
- `[14]`：敌方 Wuyang
- `[15]`：本队 0 号位玩家
- `[16]`：本队 5 号位玩家

变更这些槽位前，应先做全局引用核对，避免跨模块读错位。

## 6. AI 主逻辑区（`1352` ~ `2517`）

AI 区的典型结构为：

1. 全局生成：自定义 AI dummy 的创建与回收
2. 通用战斗：自动治疗、反制大招、自动开大、95% 自动补满充能
3. 位移控制：跟随/拉扯/跳蹲/特殊机动（如 Widow 空战）
4. 目标选择：LoS 过滤、无敌/相位/关键技能免疫过滤、排序选主目标
5. 英雄控制：按英雄拆分 `PRIMARY/SECONDARY/ABILITY/ULT` 触发策略

维护要点：

- 高频规则必须有 `wait`/`waitUntil` 节流。
- 先廉价条件、后昂贵表达式（距离、LoS、排序）。
- Dummy 逻辑与真人逻辑严格区分（多用 `evalOnce(eventPlayer.isDummy())`）。

## 7. 英雄行为改动区（`2523` ~ `4804`）

该区是玩法增强核心，主要覆盖：

- 生存与减伤系统：Mauga、Ramattra、Reaper、Doomfist 等
- 控制链增强：眩晕、击倒、减速、沉默（Hack）
- 伤害公式改写：暴击倍率、处决阈值、额外生命值百分比伤害
- 资源回路：击杀返 CD、返弹药、返充能、叠层增益
- 团队联动：Juno 轨道射线、Kiriko 铃、Lifeweaver 握、Baptiste 立场等

## 8. 英雄初始化区（`4805` ~ `6024`）

此区包含 40+ 英雄 Detect/Initialize 对，职责是“切人后重置并写入英雄定制初值”。

常见初始化动作：

- `custom_hp_pvar` 三段生命池配置
- `applyCustomHp()`（部分英雄启用，部分注释保留）
- `startForcingName()` AI 名称池
- 写入跨规则引用（如 Sombra/Freja/Ana/Widow 的联动槽位）

已知例外：

- `[Sombra] Initialize` 未写 `@Condition eventPlayer.reset_pvar[0] != false`，属于当前实现特例，后续若调整需回归测试其联动链路。

## 9. 调试与展示尾部

- `[Global][Debug]Auto Ultimate Gain`：调试开关（默认 `@Disabled`）。
- `Changelog` + `changelogText()`：在出生室显示当前英雄改动说明，离开后销毁 HUD。

## 10. 维护建议（提交前检查）

1. 是否破坏顶层分区顺序或分隔规则名。
2. 是否修改了既有变量/子程序索引。
3. 是否引入无等待循环或高频昂贵计算。
4. 英雄改动是否覆盖初始化、重置、展示链路。
5. Team1（AI）与 Team2（玩家）职责是否仍清晰。

可配合附录阅读：

- [appendix-src-file-index.md](./appendix-src-file-index.md)
