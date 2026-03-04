# 回合切换“脚本过多/服务器已关闭”代码逻辑排查报告（2026-03-04）

## 结论（高概率根因）

结合回合切换时机和当前脚本结构，最可疑的负载尖峰来源是：

1. **Hero Detect 规则持续将 `reset_pvar[0]` 置为 `true`，导致 Initialize 链路反复执行**。  
   现状是每个英雄都采用：
   - Detect：`@Event eachPlayer` + `@Hero xxx` + `eventPlayer.reset_pvar[0] = true`
   - Initialize：`@Condition eventPlayer.reset_pvar[0] != false` + `resetHero()` + 最后置 `false`

   由于 Detect 规则本身没有“只在切换瞬间触发”的门控，会在英雄不变时持续触发，造成 `reset_pvar[0]` 被反复拉高，Initialize 规则反复进入。该行为在回合切换时（大量玩家同时重生/重置）会放大并发。示例可见 Ana。  

2. **回合切换规则会对所有非 Sombra 玩家同时触发重置，形成同 tick 的重动作并发峰值**。  
   `Reinitialize hero on new round` 在 `isMatchBetweenRounds()==true` 时对 eachPlayer 生效，结束后统一 `wait(1)` 再 `resetHero()` 并置 `reset_pvar[0] = true`，这会让多个玩家几乎同时进入后续初始化链路。  

3. **`resetHero()` 本身动作链较重且包含多次状态/血量池重建，叠加调用时容易形成负载尖峰**。  
   该函数会销毁 HUD、清理状态、重建生命池、重置敌友缓存、恢复按键等，并至少跨多个 tick 执行（包含 `wait()`）。当多人在同一时间窗口重复进入，容易出现“脚本过多”。

## 关键证据

### 1) Detect/Initialize 双规则在当前写法下可能反复触发
- Ana Detect 每次 eachPlayer 执行都设置 `eventPlayer.reset_pvar[0] = true`。
- Ana Initialize 条件仅依赖 `reset_pvar[0] != false`，且内部再次 `resetHero()`，末尾才置回 `false`。

该模式在其它英雄文件同样存在（命名与结构一致）。

### 2) 回合切换集中触发重置
- `[reset.opy]: Reinitialize hero on new round`
  - 条件：`isMatchBetweenRounds() == true`
  - 动作：`waitUntil(not isMatchBetweenRounds()) -> wait(1) -> resetHero() -> reset_pvar[0]=true`

这会把大量玩家在回合切换后推入同一段初始化窗口。

### 3) 重置函数本体成本较高
- `resetHero()` 调用了：
  - `clearCustomHp()`（removeAllHealthPools + setMaxHealth + 多项缓存更新，含 wait）
  - `resetStats()`
  - `resetStatuses()`
  - `resetFrenemies()`（多次 `getPlayersOnHero(...)`）
  - `enableAllAbilities()`

## 为什么问题在“回合切换”更容易暴露

回合切换阶段通常具备以下叠加条件：
- 多玩家同步重生/状态迁移；
- 规则 `isMatchBetweenRounds()` 相关条件在一段时间内对多人同时成立；
- AI 与 Hero Initialize 规则并行评估，且部分规则缺少“开局/回合切换延后门控”；
- 若 Detect/Initialize 链路本身可重复进入，就会在该时段出现级联放大。

## 额外风险点（次要）

1. `Reset and initialize hero on hero switch` 也会在 `reset_pvar[0] != false` 时调用 `resetHero()`，与各英雄 Initialize 内的 `resetHero()` 形成重复重置路径。  
2. 部分 eachPlayer 规则存在较重条件（例如距离/LoS/数组查询）且未统一增加“回合阶段门控”，会在切换时共同参与评估，推高条件检查成本。

## 建议的修复方向（不改变玩法语义）

1. **先修 Detect 门控**（最高优先级）
   - 将 Detect 改为“仅在英雄发生切换时置 true”，避免每 tick 重置初始化标志。
   - 可采用：新增 `lastHero` player var；仅当 `eventPlayer.getHero() != lastHero` 时置 true 并更新 `lastHero`。

2. **回合切换去同步（de-sync）**
   - 在新回合重置链路按槽位偏移：`wait(Slot Of(Event Player) * small_offset)`。
   - 避免所有玩家同 tick 进入 `resetHero()`。

3. **合并重复 reset 调用路径**
   - 明确“公共 reset 只在一个入口执行”，Hero Initialize 只做该英雄增量初始化。

4. **给高成本 eachPlayer 规则加阶段门控**
   - 例如 `isGameInProgress()==true`、`not isMatchBetweenRounds()`、`hasSpawned()==true` 等低成本前置条件放在首项。

## 已执行验证

- 构建：`pnpm run build`（通过，存在若干非阻断 warning）。
- 协议/结构校验：`skills/ow-contract-guard/scripts/check_contracts.sh --build`（通过）。

