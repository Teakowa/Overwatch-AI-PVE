# Hero balance reference coverage audit

本报告由 `tools/audit-hero-balance.ts` 从当前源码确定性生成，对应 GitHub Issue #78。它只记录现状，不修改任何玩法数值。完整逐项 inventory 在同目录的 JSON 文件中。

## 结论摘要

- 启用的 OW2_* reference 定义：61；注释掉的候选定义：0。
- Main 中直接使用 OW2_*：61 个字段；另有 0 个被消费的非命名空间重复基线事实（总记录 0 个）。
- Main 中通过 ratioPercent/ultGenPercent/relativePercent/relativeRatioPercent/relativeUltGenPercent 形成的基线相关 settings：99 条。
- ARAM settings 条目：386 条，其中直接数字：299 条。
- 英雄 runtime Workshop setting 工厂调用：186 条。
- 需要在迁移前人工确认的项目：299 条；缺失 reference：0 条。

## 分类口径

- **ow2_reference_value**：Upstream OW2 baseline/reference fact; it is not a PvE tuning decision.
- **absolute_pve_target**：An intended PvE value expressed as an absolute target and converted to a Workshop percentage.
- **relative_pve_modifier**：An intentional relationship to the selected OW2 reference; it must not be rewritten as an absolute target without review.
- **project_only_mechanic_constant**：A project mechanic without a meaningful vanilla baseline.
- **runtime_workshop_setting**：A user-configurable Workshop setting that must remain runtime-controlled.

## 文件覆盖

| 文件/范围 | 角色 | 相关条目 |
| --- | --- | ---: |
| `src/constants/ow2_hero_defaults.opy` | 当前 OW2 reference 常数文件 | 61 |
| `src/constants/player_constants.opy` | 项目常数、目标和重复 baseline 别名 | 0 |
| `src/constants/hero_balance_constants.opy` | Main/ARAM 最终 Workshop 百分比及项目机制常数 | 0 |
| `src/modules/prelude/settings.opy` | Main Workshop settings consumer | 99 |
| `src/aram_settings.opy` | ARAM Workshop settings consumer | 386 |
| `src/heroes/**/settings*.opy` | runtime Workshop setting acquisition | 186 |
| `src/heroes/**/init.opy` | hero init consumers inspected for reference usage | 0 |
| `src/heroes/**/rules.opy` | hero rule consumers inspected for reference usage | 0 |
| `src/heroes/**/aram.opy` | ARAM hero rule consumers inspected for reference usage | 0 |

## 重复基线事实

`player_constants.opy` 中以下名称与 `OW2_*` reference 同名但缺少命名空间；即使数值当前相同，也形成了可漂移的第二来源。

| legacy 名称 | canonical reference | 当前值 | 是否相同 | 消费位置 |
| --- | --- | ---: | :---: | --- |

## Main 基线相关 settings inventory

每一行代表一个当前 Main 的 `ratioPercent`、`ultGenPercent`、`relativePercent`、`relativeRatioPercent` 或 `relativeUltGenPercent` 消费；ARAM 对应条目、canonical reference、target 来源和迁移备注均在 JSON 的 `baselineFields` 中保留。

| Team | Hero | Field | Category | Reference | Target | ARAM 表示 |
| --- | --- | --- | --- | --- | --- | --- |
| team1 | hanzo | `ultGen%` | relative_pve_modifier | `OW2_HANZO_ULT_COST` | `REL_AI_HANZO_ULT_COST_PERCENT` | 未配置 |
| team1 | cassidy | `ability2Cooldown%` | relative_pve_modifier | `OW2_MCCREE_FLASHBANG_COOLDOWN` | `REL_AI_CASSIDY_ABILITY2_COOLDOWN_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_CASSIDY_ABILITY2_COOLDOWN_PERCENT, OW2_MCCREE_FLASHBANG_COOLDOWN)` |
| team1 | lucio | `ultGen%` | relative_pve_modifier | `OW2_LUCIO_ULT_COST` | `REL_AI_LUCIO_ULT_COST_PERCENT` | 未配置 |
| team1 | soldier | `ability2Cooldown%` | relative_pve_modifier | `OW2_SOLDIER_BIOTIC_FIELD_COOLDOWN` | `REL_AI_SOLDIER_ABILITY2_COOLDOWN_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_SOLDIER_ABILITY2_COOLDOWN_PERCENT, OW2_SOLDIER_BIOTIC_FIELD_COOLDOWN)` |
| team1 | orisa | `ability1Cooldown%` | relative_pve_modifier | `OW2_ORISA_FORTIFY_COOLDOWN` | `REL_AI_ORISA_ABILITY1_COOLDOWN_PERCENT` | 未配置 |
| team1 | orisa | `ultGen%` | relative_pve_modifier | `OW2_ORISA_ULT_COST` | `REL_AI_ORISA_ULT_COST_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_ORISA_ULT_COST_PERCENT, OW2_ORISA_ULT_COST)`, `team2:relativePercent(REL_ARAM_TEAM2_ORISA_ULT_COST_PERCENT, OW2_ORISA_ULT_COST)` |
| team1 | ana | `ultGen%` | relative_pve_modifier | `OW2_ANA_ULT_COST` | `REL_AI_ANA_ULT_COST_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_ANA_ULT_COST_PERCENT, OW2_ANA_ULT_COST)` |
| team1 | ana | `ability1Cooldown%` | relative_pve_modifier | `OW2_ANA_SLEEP_DART_COOLDOWN_TIME` | `REL_AI_ANA_ABILITY1_COOLDOWN_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_ANA_ABILITY1_COOLDOWN_PERCENT, OW2_ANA_SLEEP_DART_COOLDOWN_TIME)`, `team2:relativePercent(REL_ARAM_TEAM2_ANA_ABILITY1_COOLDOWN_PERCENT, OW2_ANA_SLEEP_DART_COOLDOWN_TIME)` |
| team1 | baptiste | `ability1Cooldown%` | relative_pve_modifier | `OW2_BAPTISTE_REGEN_BURST_COOLDOWN` | `REL_AI_BAPTISTE_ABILITY1_COOLDOWN_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_BAPTISTE_ABILITY1_COOLDOWN_PERCENT, OW2_BAPTISTE_REGEN_BURST_COOLDOWN)`, `team2:relativePercent(REL_ARAM_TEAM2_BAPTISTE_ABILITY1_COOLDOWN_PERCENT, OW2_BAPTISTE_REGEN_BURST_COOLDOWN)` |
| team1 | baptiste | `ability2Cooldown%` | relative_pve_modifier | `OW2_BAPTISTE_LAMP_COOLDOWN_TIME` | `REL_AI_BAPTISTE_ABILITY2_COOLDOWN_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_BAPTISTE_ABILITY2_COOLDOWN_PERCENT, OW2_BAPTISTE_LAMP_COOLDOWN_TIME)`, `team2:relativePercent(REL_ARAM_TEAM2_BAPTISTE_ABILITY2_COOLDOWN_PERCENT, OW2_BAPTISTE_LAMP_COOLDOWN_TIME)` |
| team1 | brigitte | `ultGen%` | relative_pve_modifier | `OW2_BRIGITTE_ULT_COST` | `REL_AI_BRIGITTE_ULT_COST_PERCENT` | 未配置 |
| team1 | brigitte | `shieldBashKb%` | relative_pve_modifier | `OW2_BRIGITTE_SHIELD_BASH_KNOCKBACK` | `REL_AI_BRIGITTE_SHIELD_BASH_KB_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_BRIGITTE_SHIELD_BASH_KB_PERCENT, OW2_BRIGITTE_SHIELD_BASH_KNOCKBACK)`, `team2:relativePercent(REL_ARAM_TEAM2_BRIGITTE_SHIELD_BASH_KB_PERCENT, OW2_BRIGITTE_SHIELD_BASH_KNOCKBACK)` |
| team1 | torbjorn | `ultGen%` | relative_pve_modifier | `OW2_TORBJORN_ULT_COST` | `REL_AI_TORBJORN_ULT_COST_PERCENT` | 未配置 |
| team1 | ramattra | `ability2Cooldown%` | relative_pve_modifier | `OW2_RAMATTRA_VORTEX_COOLDOWN` | `REL_AI_RAMATTRA_ABILITY2_COOLDOWN_PERCENT` | 未配置 |
| team1 | ramattra | `ability1Cooldown%` | relative_pve_modifier | `OW2_RAMATTRA_NEMESIS_COOLDOWN` | `REL_AI_RAMATTRA_ABILITY1_COOLDOWN_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_RAMATTRA_ABILITY1_COOLDOWN_PERCENT, OW2_RAMATTRA_NEMESIS_COOLDOWN)` |
| team1 | ramattra | `ultGen%` | relative_pve_modifier | `OW2_RAMATTRA_ULT_COST` | `REL_AI_RAMATTRA_ULT_COST_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_RAMATTRA_ULT_COST_PERCENT, OW2_RAMATTRA_ULT_COST)` |
| team1 | ramattra | `secondaryFireCooldown%` | relative_pve_modifier | `OW2_RAMATTRA_VOID_BARRIER_COOLDOWN` | `REL_AI_RAMATTRA_SECONDARY_FIRE_COOLDOWN_PERCENT` | 未配置 |
| team1 | venture | `ultGen%` | relative_pve_modifier | `OW2_VENTURE_ULT_COST` | `REL_AI_VENTURE_ULT_COST_PERCENT` | 未配置 |
| team1 | illari | `ability2Cooldown%` | relative_pve_modifier | `OW2_ILLARI_PYLON_COOLDOWN` | `REL_AI_ILLARI_ABILITY2_COOLDOWN_PERCENT` | `allTeams:relativePercent(REL_ARAM_ALLTEAMS_ILLARI_ABILITY2_COOLDOWN_PERCENT, OW2_ILLARI_PYLON_COOLDOWN)` |
| team1 | juno | `ultGen%` | relative_pve_modifier | `OW2_JUNO_ULT_COST` | `REL_AI_JUNO_ULT_COST_PERCENT` | `allTeams:relativePercent(REL_ARAM_ALLTEAMS_JUNO_ULT_COST_PERCENT, OW2_JUNO_ULT_COST)` |
| team1 | doomfist | `ammoRegenerationTime%` | relative_pve_modifier | `OW2_DOOMFIST_AMMO_REGEN` | `REL_AI_DOOMFIST_AMMO_REGENERATION_TIME_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_DOOMFIST_AMMO_REGENERATION_TIME_PERCENT, OW2_DOOMFIST_AMMO_REGEN)`, `team2:relativePercent(REL_ARAM_TEAM2_DOOMFIST_AMMO_REGENERATION_TIME_PERCENT, OW2_DOOMFIST_AMMO_REGEN)` |
| team1 | zarya | `ultGen%` | relative_pve_modifier | `OW2_ZARYA_ULT_COST` | `REL_AI_ZARYA_ULT_COST_PERCENT` | 未配置 |
| team1 | pharah | `ability1Cooldown%` | relative_pve_modifier | `OW2_PHARAH_JUMP_JET_COOLDOWN` | `REL_AI_PHARAH_ABILITY1_COOLDOWN_PERCENT` | 未配置 |
| team1 | pharah | `ability2Cooldown%` | relative_pve_modifier | `OW2_PHARAH_CONCUSSIVE_BLAST_COOLDOWN` | `REL_AI_PHARAH_ABILITY2_COOLDOWN_PERCENT` | 未配置 |
| team1 | winston | `ability1Cooldown%` | relative_pve_modifier | `OW2_WINSTON_JUMP_PACK_COOLDOWN_TIME` | `REL_AI_WINSTON_ABILITY1_COOLDOWN_PERCENT` | 未配置 |
| team1 | winston | `ability2Cooldown%` | relative_pve_modifier | `OW2_WINSTON_BARRIER_COOLDOWN` | `REL_AI_WINSTON_ABILITY2_COOLDOWN_PERCENT` | 未配置 |
| team1 | genji | `ultGen%` | relative_pve_modifier | `OW2_GENJI_ULT_COST` | `REL_AI_GENJI_ULT_COST_PERCENT` | 未配置 |
| team1 | junkrat | `ability1Cooldown%` | relative_pve_modifier | `OW2_JUNKRAT_CONCUSSION_MINE_COOLDOWN` | `REL_AI_JUNKRAT_ABILITY1_COOLDOWN_PERCENT` | 未配置 |
| team1 | tracer | `ultGen%` | relative_pve_modifier | `OW2_TRACER_ULT_COST` | `REL_AI_TRACER_ULT_COST_PERCENT` | 未配置 |
| team1 | tracer | `ability2Cooldown%` | relative_pve_modifier | `OW2_TRACER_RECALL_COOLDOWN` | `REL_AI_TRACER_ABILITY2_COOLDOWN_PERCENT` | 未配置 |
| team1 | zenyatta | `ultGen%` | relative_pve_modifier | `OW2_ZENYATTA_ULT_COST` | `REL_AI_ZENYATTA_ULT_COST_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_ZENYATTA_ULT_COST_PERCENT, OW2_ZENYATTA_ULT_COST)` |
| team1 | moira | `ultGen%` | relative_pve_modifier | `OW2_MOIRA_ULT_COST` | `REL_AI_MOIRA_ULT_COST_PERCENT` | 未配置 |
| team1 | reinhardt | `ability1Cooldown%` | relative_pve_modifier | `OW2_REINHARDT_CHARGE_COOLDOWN_TIME` | `REL_AI_REINHARDT_ABILITY1_COOLDOWN_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_REINHARDT_ABILITY1_COOLDOWN_PERCENT, OW2_REINHARDT_CHARGE_COOLDOWN_TIME)`, `team2:relativePercent(REL_ARAM_TEAM2_REINHARDT_ABILITY1_COOLDOWN_PERCENT, OW2_REINHARDT_CHARGE_COOLDOWN_TIME)` |
| team1 | reinhardt | `secondaryFireRechargeRate%` | relative_pve_modifier | `OW2_REINHARDT_BARRIER_REGEN` | `REL_AI_REINHARDT_SECONDARY_FIRE_RECHARGE_RATE_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_REINHARDT_SECONDARY_FIRE_RECHARGE_RATE_PERCENT, OW2_REINHARDT_BARRIER_REGEN)`, `team2:relativePercent(REL_ARAM_TEAM2_REINHARDT_SECONDARY_FIRE_RECHARGE_RATE_PERCENT, OW2_REINHARDT_BARRIER_REGEN)` |
| team1 | reinhardt | `health%` | relative_pve_modifier | `OW2_REINHARDT_BARRIER_HEALTH` | `REL_AI_REINHARDT_HEALTH_PERCENT` | 未配置 |
| team1 | sigma | `health%` | relative_pve_modifier | `OW2_SIGMA_BARRIER_HEALTH` | `REL_AI_SIGMA_HEALTH_PERCENT` | 未配置 |
| team1 | kiriko | `ability2Cooldown%` | relative_pve_modifier | `OW2_KIRIKO_SUZU_COOLDOWN` | `REL_AI_KIRIKO_ABILITY2_COOLDOWN_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_KIRIKO_ABILITY2_COOLDOWN_PERCENT, OW2_KIRIKO_SUZU_COOLDOWN)`, `team2:relativePercent(REL_ARAM_TEAM2_KIRIKO_ABILITY2_COOLDOWN_PERCENT, OW2_KIRIKO_SUZU_COOLDOWN)` |
| team1 | kiriko | `ultGen%` | relative_pve_modifier | `OW2_KIRIKO_ULT_COST` | `REL_AI_KIRIKO_ULT_COST_PERCENT` | 未配置 |
| team1 | domina | `ability1Cooldown%` | absolute_pve_target | `OW2_DOMINA_SONIC_REPULSORS_COOLDOWN` | `SET_DOMINA_ABILITY1_COOLDOWN_TARGET` | 未配置 |
| team1 | domina | `ability2Cooldown%` | absolute_pve_target | `OW2_DOMINA_CRYSTAL_CHARGE_COOLDOWN` | `SET_DOMINA_ABILITY2_COOLDOWN_TARGET` | `allTeams:relativePercent(REL_ARAM_ALLTEAMS_DOMINA_ABILITY2_COOLDOWN_PERCENT, OW2_DOMINA_CRYSTAL_CHARGE_COOLDOWN)` |
| team1 | domina | `secondaryFireCooldown%` | absolute_pve_target | `OW2_DOMINA_BARRIER_ARRAY_COOLDOWN` | `SET_DOMINA_SECONDARY_FIRE_COOLDOWN_TARGET` | `allTeams:relativePercent(REL_ARAM_ALLTEAMS_DOMINA_SECONDARY_FIRE_COOLDOWN_PERCENT, OW2_DOMINA_BARRIER_ARRAY_COOLDOWN)` |
| team1 | sombra | `secondaryFireCooldown%` | relative_pve_modifier | `OW2_SOMBRA_HACK_COOLDOWN_TIME` | `REL_AI_SOMBRA_SECONDARY_FIRE_COOLDOWN_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_SOMBRA_SECONDARY_FIRE_COOLDOWN_PERCENT, OW2_SOMBRA_HACK_COOLDOWN_TIME)`, `team2:relativePercent(REL_ARAM_TEAM2_SOMBRA_SECONDARY_FIRE_COOLDOWN_PERCENT, OW2_SOMBRA_HACK_COOLDOWN_TIME)` |
| team1 | widowmaker | `ultGen%` | relative_pve_modifier | `OW2_WIDOWMAKER_ULT_COST` | `REL_AI_WIDOWMAKER_ULT_COST_PERCENT` | 未配置 |
| team2 | hanzo | `ability2Cooldown%` | relative_pve_modifier | `OW2_HANZO_STORM_COOLDOWN` | `REL_PLAYER_HANZO_ABILITY2_COOLDOWN_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_HANZO_ABILITY2_COOLDOWN_PERCENT, OW2_HANZO_STORM_COOLDOWN)`, `team2:relativePercent(REL_ARAM_TEAM2_HANZO_ABILITY2_COOLDOWN_PERCENT, OW2_HANZO_STORM_COOLDOWN)` |
| team2 | hanzo | `ultGen%` | relative_pve_modifier | `OW2_HANZO_ULT_COST` | `REL_PLAYER_HANZO_ULT_COST_PERCENT` | 未配置 |
| team2 | cassidy | `ultGen%` | relative_pve_modifier | `OW2_MCCREE_ULT_COST` | `REL_PLAYER_CASSIDY_ULT_COST_PERCENT` | 未配置 |
| team2 | cassidy | `ability2Cooldown%` | relative_pve_modifier | `OW2_MCCREE_FLASHBANG_COOLDOWN` | `REL_PLAYER_CASSIDY_ABILITY2_COOLDOWN_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_CASSIDY_ABILITY2_COOLDOWN_PERCENT, OW2_MCCREE_FLASHBANG_COOLDOWN)` |
| team2 | bastion | `ability1Cooldown%` | relative_pve_modifier | `OW2_BASTION_RECONFIGURE_COOLDOWN` | `REL_PLAYER_BASTION_ABILITY1_COOLDOWN_PERCENT` | `team2:relativePercent(REL_ARAM_TEAM2_BASTION_ABILITY1_COOLDOWN_PERCENT, OW2_BASTION_RECONFIGURE_COOLDOWN)` |
| team2 | soldier | `ability2Cooldown%` | relative_pve_modifier | `OW2_SOLDIER_BIOTIC_FIELD_COOLDOWN` | `REL_PLAYER_SOLDIER_ABILITY2_COOLDOWN_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_SOLDIER_ABILITY2_COOLDOWN_PERCENT, OW2_SOLDIER_BIOTIC_FIELD_COOLDOWN)` |
| team2 | orisa | `ability1Cooldown%` | relative_pve_modifier | `OW2_ORISA_FORTIFY_COOLDOWN` | `REL_PLAYER_ORISA_ABILITY1_COOLDOWN_PERCENT` | 未配置 |
| team2 | orisa | `ultGen%` | relative_pve_modifier | `OW2_ORISA_ULT_COST` | `REL_PLAYER_ORISA_ULT_COST_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_ORISA_ULT_COST_PERCENT, OW2_ORISA_ULT_COST)`, `team2:relativePercent(REL_ARAM_TEAM2_ORISA_ULT_COST_PERCENT, OW2_ORISA_ULT_COST)` |
| team2 | ana | `ability2Cooldown%` | relative_pve_modifier | `OW2_ANA_BIOTIC_GRENADE_COOLDOWN` | `REL_PLAYER_ANA_ABILITY2_COOLDOWN_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_ANA_ABILITY2_COOLDOWN_PERCENT, OW2_ANA_BIOTIC_GRENADE_COOLDOWN)`, `team2:relativePercent(REL_ARAM_TEAM2_ANA_ABILITY2_COOLDOWN_PERCENT, OW2_ANA_BIOTIC_GRENADE_COOLDOWN)` |
| team2 | ana | `ultGen%` | relative_pve_modifier | `OW2_ANA_ULT_COST` | `REL_PLAYER_ANA_ULT_COST_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_ANA_ULT_COST_PERCENT, OW2_ANA_ULT_COST)` |
| team2 | ana | `ability1Cooldown%` | relative_pve_modifier | `OW2_ANA_SLEEP_DART_COOLDOWN_TIME` | `REL_PLAYER_ANA_ABILITY1_COOLDOWN_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_ANA_ABILITY1_COOLDOWN_PERCENT, OW2_ANA_SLEEP_DART_COOLDOWN_TIME)`, `team2:relativePercent(REL_ARAM_TEAM2_ANA_ABILITY1_COOLDOWN_PERCENT, OW2_ANA_SLEEP_DART_COOLDOWN_TIME)` |
| team2 | baptiste | `ability1Cooldown%` | relative_pve_modifier | `OW2_BAPTISTE_REGEN_BURST_COOLDOWN` | `REL_PLAYER_BAPTISTE_ABILITY1_COOLDOWN_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_BAPTISTE_ABILITY1_COOLDOWN_PERCENT, OW2_BAPTISTE_REGEN_BURST_COOLDOWN)`, `team2:relativePercent(REL_ARAM_TEAM2_BAPTISTE_ABILITY1_COOLDOWN_PERCENT, OW2_BAPTISTE_REGEN_BURST_COOLDOWN)` |
| team2 | baptiste | `ability2Cooldown%` | relative_pve_modifier | `OW2_BAPTISTE_LAMP_COOLDOWN_TIME` | `REL_PLAYER_BAPTISTE_ABILITY2_COOLDOWN_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_BAPTISTE_ABILITY2_COOLDOWN_PERCENT, OW2_BAPTISTE_LAMP_COOLDOWN_TIME)`, `team2:relativePercent(REL_ARAM_TEAM2_BAPTISTE_ABILITY2_COOLDOWN_PERCENT, OW2_BAPTISTE_LAMP_COOLDOWN_TIME)` |
| team2 | brigitte | `ability2Cooldown%` | relative_pve_modifier | `OW2_BRIGITTE_REPAIR_PACK_COOLDOWN` | `REL_PLAYER_BRIGITTE_ABILITY2_COOLDOWN_PERCENT` | 未配置 |
| team2 | brigitte | `ultGen%` | relative_pve_modifier | `OW2_BRIGITTE_ULT_COST` | `REL_PLAYER_BRIGITTE_ULT_COST_PERCENT` | 未配置 |
| team2 | brigitte | `shieldBashCooldown%` | relative_pve_modifier | `OW2_BRIGITTE_SHIELD_BASH_COOLDOWN` | `REL_PLAYER_BRIGITTE_SHIELD_BASH_COOLDOWN_PERCENT` | 未配置 |
| team2 | brigitte | `shieldBashKb%` | relative_pve_modifier | `OW2_BRIGITTE_SHIELD_BASH_KNOCKBACK` | `REL_PLAYER_BRIGITTE_SHIELD_BASH_KB_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_BRIGITTE_SHIELD_BASH_KB_PERCENT, OW2_BRIGITTE_SHIELD_BASH_KNOCKBACK)`, `team2:relativePercent(REL_ARAM_TEAM2_BRIGITTE_SHIELD_BASH_KB_PERCENT, OW2_BRIGITTE_SHIELD_BASH_KNOCKBACK)` |
| team2 | torbjorn | `ultGen%` | relative_pve_modifier | `OW2_TORBJORN_ULT_COST` | `REL_PLAYER_TORBJORN_ULT_COST_PERCENT` | 未配置 |
| team2 | ramattra | `ability2Cooldown%` | relative_pve_modifier | `OW2_RAMATTRA_VORTEX_COOLDOWN` | `REL_PLAYER_RAMATTRA_ABILITY2_COOLDOWN_PERCENT` | 未配置 |
| team2 | ramattra | `ability1Cooldown%` | relative_pve_modifier | `OW2_RAMATTRA_NEMESIS_COOLDOWN` | `REL_PLAYER_RAMATTRA_ABILITY1_COOLDOWN_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_RAMATTRA_ABILITY1_COOLDOWN_PERCENT, OW2_RAMATTRA_NEMESIS_COOLDOWN)` |
| team2 | ramattra | `ultGen%` | relative_pve_modifier | `OW2_RAMATTRA_ULT_COST` | `REL_PLAYER_RAMATTRA_ULT_COST_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_RAMATTRA_ULT_COST_PERCENT, OW2_RAMATTRA_ULT_COST)` |
| team2 | ramattra | `secondaryFireCooldown%` | relative_pve_modifier | `OW2_RAMATTRA_VOID_BARRIER_COOLDOWN` | `REL_PLAYER_RAMATTRA_SECONDARY_FIRE_COOLDOWN_PERCENT` | 未配置 |
| team2 | venture | `ultGen%` | relative_pve_modifier | `OW2_VENTURE_ULT_COST` | `REL_PLAYER_VENTURE_ULT_COST_PERCENT` | 未配置 |
| team2 | illari | `ability2Cooldown%` | relative_pve_modifier | `OW2_ILLARI_PYLON_COOLDOWN` | `REL_PLAYER_ILLARI_ABILITY2_COOLDOWN_PERCENT` | `allTeams:relativePercent(REL_ARAM_ALLTEAMS_ILLARI_ABILITY2_COOLDOWN_PERCENT, OW2_ILLARI_PYLON_COOLDOWN)` |
| team2 | juno | `ultGen%` | relative_pve_modifier | `OW2_JUNO_ULT_COST` | `REL_PLAYER_JUNO_ULT_COST_PERCENT` | `allTeams:relativePercent(REL_ARAM_ALLTEAMS_JUNO_ULT_COST_PERCENT, OW2_JUNO_ULT_COST)` |
| team2 | doomfist | `ammoRegenerationTime%` | relative_pve_modifier | `OW2_DOOMFIST_AMMO_REGEN` | `REL_PLAYER_DOOMFIST_AMMO_REGENERATION_TIME_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_DOOMFIST_AMMO_REGENERATION_TIME_PERCENT, OW2_DOOMFIST_AMMO_REGEN)`, `team2:relativePercent(REL_ARAM_TEAM2_DOOMFIST_AMMO_REGENERATION_TIME_PERCENT, OW2_DOOMFIST_AMMO_REGEN)` |
| team2 | doomfist | `ability1Cooldown%` | relative_pve_modifier | `OW2_DOOMFIST_POWER_BLOCK_COOLDOWN` | `REL_PLAYER_DOOMFIST_ABILITY1_COOLDOWN_PERCENT` | 未配置 |
| team2 | doomfist | `ability2Cooldown%` | relative_pve_modifier | `OW2_DOOMFIST_SEISMIC_SLAM_COOLDOWN` | `REL_PLAYER_DOOMFIST_ABILITY2_COOLDOWN_PERCENT` | 未配置 |
| team2 | zarya | `ultGen%` | relative_pve_modifier | `OW2_ZARYA_ULT_COST` | `REL_PLAYER_ZARYA_ULT_COST_PERCENT` | 未配置 |
| team2 | pharah | `ability1Cooldown%` | relative_pve_modifier | `OW2_PHARAH_JUMP_JET_COOLDOWN` | `REL_PLAYER_PHARAH_ABILITY1_COOLDOWN_PERCENT` | 未配置 |
| team2 | pharah | `ability2Cooldown%` | relative_pve_modifier | `OW2_PHARAH_CONCUSSIVE_BLAST_COOLDOWN` | `REL_PLAYER_PHARAH_ABILITY2_COOLDOWN_PERCENT` | 未配置 |
| team2 | winston | `ability2Cooldown%` | relative_pve_modifier | `OW2_WINSTON_BARRIER_COOLDOWN` | `REL_PLAYER_WINSTON_ABILITY2_COOLDOWN_PERCENT` | 未配置 |
| team2 | genji | `ultGen%` | relative_pve_modifier | `OW2_GENJI_ULT_COST` | `REL_PLAYER_GENJI_ULT_COST_PERCENT` | 未配置 |
| team2 | genji | `ability2Cooldown%` | relative_pve_modifier | `OW2_GENJI_DEFLECT_COOLDOWN` | `REL_PLAYER_GENJI_ABILITY2_COOLDOWN_PERCENT` | 未配置 |
| team2 | junkrat | `ultGen%` | relative_pve_modifier | `OW2_JUNKRAT_ULT_COST` | `REL_PLAYER_JUNKRAT_ULT_COST_PERCENT` | `team2:relativePercent(REL_ARAM_TEAM2_JUNKRAT_ULT_COST_PERCENT, OW2_JUNKRAT_ULT_COST)` |
| team2 | tracer | `ultGen%` | relative_pve_modifier | `OW2_TRACER_ULT_COST` | `REL_PLAYER_TRACER_ULT_COST_PERCENT` | 未配置 |
| team2 | tracer | `ability2Cooldown%` | relative_pve_modifier | `OW2_TRACER_RECALL_COOLDOWN` | `REL_PLAYER_TRACER_ABILITY2_COOLDOWN_PERCENT` | 未配置 |
| team2 | zenyatta | `ultGen%` | relative_pve_modifier | `OW2_ZENYATTA_ULT_COST` | `REL_PLAYER_ZENYATTA_ULT_COST_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_ZENYATTA_ULT_COST_PERCENT, OW2_ZENYATTA_ULT_COST)` |
| team2 | moira | `ultGen%` | relative_pve_modifier | `OW2_MOIRA_ULT_COST` | `REL_PLAYER_MOIRA_ULT_COST_PERCENT` | 未配置 |
| team2 | reinhardt | `ability1Cooldown%` | relative_pve_modifier | `OW2_REINHARDT_CHARGE_COOLDOWN_TIME` | `REL_PLAYER_REINHARDT_ABILITY1_COOLDOWN_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_REINHARDT_ABILITY1_COOLDOWN_PERCENT, OW2_REINHARDT_CHARGE_COOLDOWN_TIME)`, `team2:relativePercent(REL_ARAM_TEAM2_REINHARDT_ABILITY1_COOLDOWN_PERCENT, OW2_REINHARDT_CHARGE_COOLDOWN_TIME)` |
| team2 | reinhardt | `secondaryFireRechargeRate%` | relative_pve_modifier | `OW2_REINHARDT_BARRIER_REGEN` | `REL_PLAYER_REINHARDT_SECONDARY_FIRE_RECHARGE_RATE_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_REINHARDT_SECONDARY_FIRE_RECHARGE_RATE_PERCENT, OW2_REINHARDT_BARRIER_REGEN)`, `team2:relativePercent(REL_ARAM_TEAM2_REINHARDT_SECONDARY_FIRE_RECHARGE_RATE_PERCENT, OW2_REINHARDT_BARRIER_REGEN)` |
| team2 | reinhardt | `health%` | relative_pve_modifier | `OW2_REINHARDT_BARRIER_HEALTH` | `REL_PLAYER_REINHARDT_HEALTH_PERCENT` | 未配置 |
| team2 | reinhardt | `ultGen%` | relative_pve_modifier | `OW2_REINHARDT_ULT_COST` | `REL_PLAYER_REINHARDT_ULT_COST_PERCENT` | 未配置 |
| team2 | sigma | `health%` | relative_pve_modifier | `OW2_SIGMA_BARRIER_HEALTH` | `REL_PLAYER_SIGMA_HEALTH_PERCENT` | 未配置 |
| team2 | sigma | `ultGen%` | relative_pve_modifier | `OW2_SIGMA_ULT_COST` | `REL_PLAYER_SIGMA_ULT_COST_PERCENT` | 未配置 |
| team2 | roadhog | `ability1Cooldown%` | relative_pve_modifier | `OW2_ROADHOG_HOOK_COOLDOWN_TIME` | `REL_PLAYER_ROADHOG_ABILITY1_COOLDOWN_PERCENT` | 未配置 |
| team2 | kiriko | `ability2Cooldown%` | relative_pve_modifier | `OW2_KIRIKO_SUZU_COOLDOWN` | `REL_PLAYER_KIRIKO_ABILITY2_COOLDOWN_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_KIRIKO_ABILITY2_COOLDOWN_PERCENT, OW2_KIRIKO_SUZU_COOLDOWN)`, `team2:relativePercent(REL_ARAM_TEAM2_KIRIKO_ABILITY2_COOLDOWN_PERCENT, OW2_KIRIKO_SUZU_COOLDOWN)` |
| team2 | kiriko | `ultGen%` | relative_pve_modifier | `OW2_KIRIKO_ULT_COST` | `REL_PLAYER_KIRIKO_ULT_COST_PERCENT` | 未配置 |
| team2 | domina | `ability1Cooldown%` | absolute_pve_target | `OW2_DOMINA_SONIC_REPULSORS_COOLDOWN` | `SET_DOMINA_ABILITY1_COOLDOWN_TARGET` | 未配置 |
| team2 | domina | `ability2Cooldown%` | absolute_pve_target | `OW2_DOMINA_CRYSTAL_CHARGE_COOLDOWN` | `SET_DOMINA_ABILITY2_COOLDOWN_TARGET` | `allTeams:relativePercent(REL_ARAM_ALLTEAMS_DOMINA_ABILITY2_COOLDOWN_PERCENT, OW2_DOMINA_CRYSTAL_CHARGE_COOLDOWN)` |
| team2 | domina | `secondaryFireCooldown%` | absolute_pve_target | `OW2_DOMINA_BARRIER_ARRAY_COOLDOWN` | `SET_DOMINA_SECONDARY_FIRE_COOLDOWN_TARGET` | `allTeams:relativePercent(REL_ARAM_ALLTEAMS_DOMINA_SECONDARY_FIRE_COOLDOWN_PERCENT, OW2_DOMINA_BARRIER_ARRAY_COOLDOWN)` |
| team2 | sombra | `secondaryFireCooldown%` | relative_pve_modifier | `OW2_SOMBRA_HACK_COOLDOWN_TIME` | `REL_PLAYER_SOMBRA_SECONDARY_FIRE_COOLDOWN_PERCENT` | `team1:relativePercent(REL_ARAM_TEAM1_SOMBRA_SECONDARY_FIRE_COOLDOWN_PERCENT, OW2_SOMBRA_HACK_COOLDOWN_TIME)`, `team2:relativePercent(REL_ARAM_TEAM2_SOMBRA_SECONDARY_FIRE_COOLDOWN_PERCENT, OW2_SOMBRA_HACK_COOLDOWN_TIME)` |
| team2 | widowmaker | `ultGen%` | relative_pve_modifier | `OW2_WIDOWMAKER_ULT_COST` | `REL_PLAYER_WIDOWMAKER_ULT_COST_PERCENT` | 未配置 |
| allTeams | dva | `ability1Cooldown%` | relative_pve_modifier | `OW2_DVA_BOOSTER_COOLDOWN_TIME` | `REL_DVA_ABILITY1_COOLDOWN_PERCENT` | 未配置 |
| allTeams | dva | `ability2Cooldown%` | relative_pve_modifier | `OW2_DVA_MICRO_MISSILES_COOLDOWN_TIME` | `REL_DVA_ABILITY2_COOLDOWN_PERCENT` | 未配置 |
| allTeams | dva | `secondaryFireMaximumTime%` | relative_pve_modifier | `OW2_DVA_MATRIX_DURATION` | `REL_DVA_SECONDARY_FIRE_MAXIMUM_TIME_PERCENT` | `allTeams:relativePercent(REL_ARAM_ALLTEAMS_DVA_SECONDARY_FIRE_MAXIMUM_TIME_PERCENT, OW2_DVA_MATRIX_DURATION)` |

## 缺失 reference 与人工设计审查

这些项目不能仅凭现有代码安全地归入新的 reference/target/modifier 层，#80 迁移前必须显式决定。

| 类别 | Hero | Field | 来源 | 当前值 | 原因 |
| --- | --- | --- | --- | --- | --- |
| aram_direct_literal | hanzo | `ability2Quantity%` | `src/aram_settings.opy:31` | `6` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | hanzo | `ability3Cooldown%` | `src/aram_settings.opy:32` | `0` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | hanzo | `ability1Cooldown%` | `src/aram_settings.opy:34` | `0` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | hanzo | `projectileSpeed%` | `src/aram_settings.opy:35` | `135` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | hanzo | `movementSpeed%` | `src/aram_settings.opy:36` | `120` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | hanzo | `projectileGravity%` | `src/aram_settings.opy:37` | `0` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | cassidy | `damageDealt%` | `src/aram_settings.opy:40` | `110` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | cassidy | `damageReceived%` | `src/aram_settings.opy:41` | `80` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | lucio | `damageDealt%` | `src/aram_settings.opy:46` | `105` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | lucio | `damageReceived%` | `src/aram_settings.opy:47` | `75` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | lucio | `healingReceived%` | `src/aram_settings.opy:48` | `120` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | lucio | `ability2Cooldown%` | `src/aram_settings.opy:49` | `50` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | lucio | `healingDealt%` | `src/aram_settings.opy:50` | `210` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | soldier | `damageDealt%` | `src/aram_settings.opy:53` | `115` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | soldier | `movementSpeed%` | `src/aram_settings.opy:54` | `110` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | soldier | `ultDuration%` | `src/aram_settings.opy:56` | `134` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mercy | `damageDealt%` | `src/aram_settings.opy:60` | `200` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mercy | `damageReceived%` | `src/aram_settings.opy:61` | `70` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mercy | `projectileSpeed%` | `src/aram_settings.opy:62` | `150` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mercy | `ability1Cooldown%` | `src/aram_settings.opy:63` | `0` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mercy | `healingDealt%` | `src/aram_settings.opy:65` | `150` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mercy | `ability2Cooldown%` | `src/aram_settings.opy:66` | `0` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | orisa | `damageReceived%` | `src/aram_settings.opy:69` | `70` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | orisa | `projectileSpeed%` | `src/aram_settings.opy:70` | `130` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | orisa | `projectileGravity%` | `src/aram_settings.opy:71` | `0` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | orisa | `health%` | `src/aram_settings.opy:73` | `500` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | orisa | `movementSpeed%` | `src/aram_settings.opy:74` | `105` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | ana | `healingDealt%` | `src/aram_settings.opy:79` | `122` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | baptiste | `damageDealt%` | `src/aram_settings.opy:86` | `115` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | baptiste | `healingDealt%` | `src/aram_settings.opy:89` | `125` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | baptiste | `ultDuration%` | `src/aram_settings.opy:90` | `200` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | brigitte | `damageDealt%` | `src/aram_settings.opy:94` | `115` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | brigitte | `damageReceived%` | `src/aram_settings.opy:95` | `70` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | brigitte | `healingReceived%` | `src/aram_settings.opy:96` | `110` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | brigitte | `secondaryFireRechargeRate%` | `src/aram_settings.opy:98` | `118` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | brigitte | `secondaryFireCooldown%` | `src/aram_settings.opy:99` | `80` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | brigitte | `healingDealt%` | `src/aram_settings.opy:100` | `125` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | torbjorn | `damageDealt%` | `src/aram_settings.opy:104` | `115` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | torbjorn | `damageReceived%` | `src/aram_settings.opy:105` | `75` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | torbjorn | `ability2Cooldown%` | `src/aram_settings.opy:106` | `50` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | torbjorn | `ability2Duration%` | `src/aram_settings.opy:107` | `150` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | torbjorn | `ultDuration%` | `src/aram_settings.opy:108` | `150` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | ramattra | `damageDealt%` | `src/aram_settings.opy:111` | `105` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | ramattra | `damageReceived%` | `src/aram_settings.opy:112` | `70` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | ramattra | `ultDuration%` | `src/aram_settings.opy:116` | `500` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | doomfist | `damageDealt%` | `src/aram_settings.opy:120` | `115` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | doomfist | `damageReceived%` | `src/aram_settings.opy:121` | `70` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | zarya | `damageDealt%` | `src/aram_settings.opy:126` | `115` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | zarya | `damageReceived%` | `src/aram_settings.opy:127` | `70` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | zarya | `ability2Cooldown%` | `src/aram_settings.opy:128` | `50` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | reaper | `damageDealt%` | `src/aram_settings.opy:132` | `110` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | reaper | `damageReceived%` | `src/aram_settings.opy:133` | `80` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | reaper | `healingDealt%` | `src/aram_settings.opy:135` | `350` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mauga | `damageDealt%` | `src/aram_settings.opy:138` | `110` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mauga | `damageReceived%` | `src/aram_settings.opy:139` | `70` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mauga | `ability2Cooldown%` | `src/aram_settings.opy:140` | `33` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mauga | `ability2Healing%` | `src/aram_settings.opy:141` | `400` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mauga | `ultDuration%` | `src/aram_settings.opy:143` | `188` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | junkerQueen | `damageDealt%` | `src/aram_settings.opy:148` | `110` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | junkerQueen | `damageReceived%` | `src/aram_settings.opy:149` | `70` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | junkerQueen | `ability1Cooldown%` | `src/aram_settings.opy:150` | `57` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | junkerQueen | `ability2Cooldown%` | `src/aram_settings.opy:151` | `75` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | junkerQueen | `secondaryFireCooldown%` | `src/aram_settings.opy:152` | `67` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | winston | `damageDealt%` | `src/aram_settings.opy:155` | `120` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | winston | `damageReceived%` | `src/aram_settings.opy:156` | `70` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | genji | `damageDealt%` | `src/aram_settings.opy:160` | `105` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | genji | `damageReceived%` | `src/aram_settings.opy:161` | `80` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | genji | `healingReceived%` | `src/aram_settings.opy:162` | `150` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | genji | `ultDuration%` | `src/aram_settings.opy:164` | `134` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | junkrat | `damageDealt%` | `src/aram_settings.opy:167` | `125` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | junkrat | `ability2Cooldown%` | `src/aram_settings.opy:168` | `50` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | junkrat | `projectileSpeed%` | `src/aram_settings.opy:169` | `200` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | tracer | `damageDealt%` | `src/aram_settings.opy:173` | `105` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | tracer | `damageReceived%` | `src/aram_settings.opy:174` | `80` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | tracer | `ability1Cooldown%` | `src/aram_settings.opy:175` | `60` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | zenyatta | `damageDealt%` | `src/aram_settings.opy:178` | `110` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | zenyatta | `healingReceived%` | `src/aram_settings.opy:179` | `150` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | zenyatta | `projectileSpeed%` | `src/aram_settings.opy:181` | `150` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | zenyatta | `healingDealt%` | `src/aram_settings.opy:183` | `200` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | symmetra | `health%` | `src/aram_settings.opy:186` | `100` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | symmetra | `damageDealt%` | `src/aram_settings.opy:187` | `115` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | symmetra | `damageReceived%` | `src/aram_settings.opy:188` | `80` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | symmetra | `ability1Cooldown%` | `src/aram_settings.opy:189` | `50` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | sojourn | `secondaryFireEnergyChargeRate%` | `src/aram_settings.opy:193` | `200` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | sojourn | `damageReceived%` | `src/aram_settings.opy:194` | `80` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | sojourn | `ability2Cooldown%` | `src/aram_settings.opy:195` | `54` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | sojourn | `projectileSpeed%` | `src/aram_settings.opy:196` | `130` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mei | `damageDealt%` | `src/aram_settings.opy:199` | `115` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mei | `ability2Cooldown%` | `src/aram_settings.opy:200` | `57` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mei | `primaryFireFreezeDuration%` | `src/aram_settings.opy:201` | `138` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mei | `damageReceived%` | `src/aram_settings.opy:202` | `75` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mei | `ability1Cooldown%` | `src/aram_settings.opy:203` | `57` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mei | `healingDealt%` | `src/aram_settings.opy:205` | `150` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | ashe | `damageDealt%` | `src/aram_settings.opy:208` | `110` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | ashe | `ability2Cooldown%` | `src/aram_settings.opy:209` | `50` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | ashe | `ultDuration%` | `src/aram_settings.opy:212` | `200` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | moira | `damageDealt%` | `src/aram_settings.opy:215` | `135` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | moira | `damageReceived%` | `src/aram_settings.opy:216` | `85` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | moira | `healingReceived%` | `src/aram_settings.opy:217` | `180` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | moira | `healingDealt%` | `src/aram_settings.opy:218` | `292` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | moira | `ability2MaxDamage%` | `src/aram_settings.opy:219` | `500` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | moira | `ability2MaxHealing%` | `src/aram_settings.opy:220` | `500` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | moira | `primaryFireRechargeRate%` | `src/aram_settings.opy:221` | `500` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | reinhardt | `damageReceived%` | `src/aram_settings.opy:225` | `70` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | reinhardt | `combatUltGen%` | `src/aram_settings.opy:227` | `150` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | sigma | `damageReceived%` | `src/aram_settings.opy:230` | `70` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | sigma | `secondaryFireRechargeRate%` | `src/aram_settings.opy:231` | `350` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | roadhog | `damageReceived%` | `src/aram_settings.opy:234` | `70` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | roadhog | `secondaryFireRechargeRate%` | `src/aram_settings.opy:235` | `150` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | roadhog | `healingDealt%` | `src/aram_settings.opy:237` | `150` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | roadhog | `movementSpeed%` | `src/aram_settings.opy:238` | `105` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | kiriko | `ability1Cooldown%` | `src/aram_settings.opy:241` | `50` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | kiriko | `damageDealt%` | `src/aram_settings.opy:243` | `120` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | kiriko | `projectileSpeed%` | `src/aram_settings.opy:244` | `115` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | kiriko | `healingDealt%` | `src/aram_settings.opy:245` | `250` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | sombra | `damageDealt%` | `src/aram_settings.opy:249` | `110` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | sombra | `damageReceived%` | `src/aram_settings.opy:250` | `80` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | sombra | `healingReceived%` | `src/aram_settings.opy:251` | `115` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | sombra | `passiveUltGen%` | `src/aram_settings.opy:253` | `134` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | sombra | `ammoClipSize%` | `src/aram_settings.opy:255` | `125` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | widowmaker | `damageDealt%` | `src/aram_settings.opy:258` | `165` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | widowmaker | `damageReceived%` | `src/aram_settings.opy:259` | `80` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | widowmaker | `movementSpeed%` | `src/aram_settings.opy:261` | `102` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | widowmaker | `ultDuration%` | `src/aram_settings.opy:262` | `134` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | general | `damageReceived%` | `src/aram_settings.opy:265` | `90` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | general | `abilityCooldown%` | `src/aram_settings.opy:266` | `60` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | general | `ultGen%` | `src/aram_settings.opy:267` | `150` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | general | `health%` | `src/aram_settings.opy:269` | `200` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | hanzo | `damageDealt%` | `src/aram_settings.opy:274` | `110` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | hanzo | `projectileSpeed%` | `src/aram_settings.opy:276` | `135` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | hanzo | `ability1Cooldown%` | `src/aram_settings.opy:277` | `0` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | cassidy | `damageDealt%` | `src/aram_settings.opy:280` | `110` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | cassidy | `damageReceived%` | `src/aram_settings.opy:281` | `94` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | lucio | `damageDealt%` | `src/aram_settings.opy:285` | `120` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | lucio | `healingDealt%` | `src/aram_settings.opy:286` | `120` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | lucio | `damageReceived%` | `src/aram_settings.opy:287` | `75` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | lucio | `ability2Cooldown%` | `src/aram_settings.opy:288` | `50` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | echo | `damageDealt%` | `src/aram_settings.opy:291` | `115` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | echo | `damageReceived%` | `src/aram_settings.opy:292` | `80` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | bastion | `damageDealt%` | `src/aram_settings.opy:295` | `125` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | bastion | `damageReceived%` | `src/aram_settings.opy:297` | `70` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | soldier | `damageDealt%` | `src/aram_settings.opy:300` | `130` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | soldier | `ultDuration%` | `src/aram_settings.opy:301` | `134` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mercy | `damageReceived%` | `src/aram_settings.opy:306` | `100` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mercy | `healingDealt%` | `src/aram_settings.opy:307` | `117` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mercy | `ability1Cooldown%` | `src/aram_settings.opy:309` | `50` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mercy | `ability2Cooldown%` | `src/aram_settings.opy:310` | `13` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | orisa | `damageReceived%` | `src/aram_settings.opy:313` | `70` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | orisa | `projectileSpeed%` | `src/aram_settings.opy:314` | `130` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | orisa | `health%` | `src/aram_settings.opy:316` | `500` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | orisa | `movementSpeed%` | `src/aram_settings.opy:317` | `105` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | ana | `damageDealt%` | `src/aram_settings.opy:321` | `115` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | ana | `healingDealt%` | `src/aram_settings.opy:322` | `130` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | baptiste | `damageDealt%` | `src/aram_settings.opy:327` | `120` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | baptiste | `ammoClipSize%` | `src/aram_settings.opy:328` | `100` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | baptiste | `healingDealt%` | `src/aram_settings.opy:330` | `120` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | baptiste | `ultDuration%` | `src/aram_settings.opy:331` | `150` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | brigitte | `damageDealt%` | `src/aram_settings.opy:335` | `115` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | brigitte | `damageReceived%` | `src/aram_settings.opy:336` | `43` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | brigitte | `secondaryFireRechargeRate%` | `src/aram_settings.opy:338` | `118` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | brigitte | `secondaryFireCooldown%` | `src/aram_settings.opy:339` | `80` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | brigitte | `healingDealt%` | `src/aram_settings.opy:340` | `110` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | torbjorn | `damageDealt%` | `src/aram_settings.opy:344` | `105` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | torbjorn | `ammoClipSize%` | `src/aram_settings.opy:345` | `100` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | torbjorn | `damageReceived%` | `src/aram_settings.opy:346` | `85` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | torbjorn | `ability2Cooldown%` | `src/aram_settings.opy:347` | `50` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | torbjorn | `ability2Duration%` | `src/aram_settings.opy:348` | `150` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | torbjorn | `ultDuration%` | `src/aram_settings.opy:349` | `100` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | ramattra | `damageDealt%` | `src/aram_settings.opy:352` | `115` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | ramattra | `damageReceived%` | `src/aram_settings.opy:353` | `65` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | ramattra | `ultDuration%` | `src/aram_settings.opy:354` | `500` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | doomfist | `damageDealt%` | `src/aram_settings.opy:357` | `110` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | doomfist | `damageReceived%` | `src/aram_settings.opy:358` | `70` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | zarya | `damageDealt%` | `src/aram_settings.opy:362` | `110` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | zarya | `damageReceived%` | `src/aram_settings.opy:363` | `75` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | zarya | `ammoClipSize%` | `src/aram_settings.opy:364` | `150` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | zarya | `ability2Cooldown%` | `src/aram_settings.opy:365` | `67` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | zarya | `ability1Cooldown%` | `src/aram_settings.opy:366` | `55` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | reaper | `damageDealt%` | `src/aram_settings.opy:369` | `115` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | reaper | `damageReceived%` | `src/aram_settings.opy:370` | `80` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | reaper | `healingDealt%` | `src/aram_settings.opy:371` | `300` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mauga | `damageDealt%` | `src/aram_settings.opy:374` | `115` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mauga | `damageReceived%` | `src/aram_settings.opy:375` | `70` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mauga | `ability2Cooldown%` | `src/aram_settings.opy:376` | `33` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mauga | `ability2Healing%` | `src/aram_settings.opy:377` | `250` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mauga | `ultDuration%` | `src/aram_settings.opy:378` | `188` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | junkerQueen | `damageDealt%` | `src/aram_settings.opy:381` | `130` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | junkerQueen | `damageReceived%` | `src/aram_settings.opy:382` | `50` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | junkerQueen | `ability1Cooldown%` | `src/aram_settings.opy:383` | `117` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | junkerQueen | `secondaryFireCooldown%` | `src/aram_settings.opy:384` | `100` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | winston | `damageDealt%` | `src/aram_settings.opy:387` | `110` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | winston | `damageReceived%` | `src/aram_settings.opy:388` | `70` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | winston | `ammoClipSize%` | `src/aram_settings.opy:389` | `100` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | genji | `damageDealt%` | `src/aram_settings.opy:392` | `125` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | genji | `damageReceived%` | `src/aram_settings.opy:393` | `80` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | genji | `ultDuration%` | `src/aram_settings.opy:395` | `134` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | junkrat | `damageDealt%` | `src/aram_settings.opy:398` | `100` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | junkrat | `damageReceived%` | `src/aram_settings.opy:399` | `130` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | junkrat | `combatUltGen%` | `src/aram_settings.opy:400` | `95` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | junkrat | `projectileSpeed%` | `src/aram_settings.opy:401` | `200` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | junkrat | `ability2Cooldown%` | `src/aram_settings.opy:403` | `100` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | junkrat | `ultDuration%` | `src/aram_settings.opy:405` | `40` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | junkrat | `passiveUltGen%` | `src/aram_settings.opy:406` | `95` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | tracer | `damageDealt%` | `src/aram_settings.opy:410` | `125` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | tracer | `damageReceived%` | `src/aram_settings.opy:411` | `70` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | zenyatta | `damageDealt%` | `src/aram_settings.opy:415` | `160` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | zenyatta | `damageReceived%` | `src/aram_settings.opy:416` | `100` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | zenyatta | `projectileSpeed%` | `src/aram_settings.opy:417` | `125` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | symmetra | `ability2Cooldown%` | `src/aram_settings.opy:420` | `100` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | symmetra | `damageDealt%` | `src/aram_settings.opy:421` | `60` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | symmetra | `damageReceived%` | `src/aram_settings.opy:422` | `120` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | symmetra | `ability1Cooldown%` | `src/aram_settings.opy:423` | `100` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | symmetra | `ammoClipSize%` | `src/aram_settings.opy:424` | `100` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | sojourn | `damageDealt%` | `src/aram_settings.opy:428` | `115` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | sojourn | `secondaryFireEnergyChargeRate%` | `src/aram_settings.opy:429` | `125` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | sojourn | `ability2Cooldown%` | `src/aram_settings.opy:430` | `54` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mei | `damageDealt%` | `src/aram_settings.opy:433` | `100` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mei | `ability2Cooldown%` | `src/aram_settings.opy:434` | `100` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mei | `primaryFireFreezeDuration%` | `src/aram_settings.opy:435` | `138` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mei | `damageReceived%` | `src/aram_settings.opy:436` | `85` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mei | `ammoClipSize%` | `src/aram_settings.opy:437` | `100` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mei | `ability1Cooldown%` | `src/aram_settings.opy:438` | `100` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | ashe | `damageDealt%` | `src/aram_settings.opy:441` | `140` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | ashe | `ammoClipSize%` | `src/aram_settings.opy:442` | `125` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | ashe | `ultDuration%` | `src/aram_settings.opy:443` | `150` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | moira | `damageDealt%` | `src/aram_settings.opy:446` | `100` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | moira | `damageReceived%` | `src/aram_settings.opy:447` | `90` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | moira | `healingDealt%` | `src/aram_settings.opy:448` | `110` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | moira | `ability2MaxDamage%` | `src/aram_settings.opy:449` | `100` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | moira | `ability2MaxHealing%` | `src/aram_settings.opy:450` | `100` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | moira | `primaryFireRechargeRate%` | `src/aram_settings.opy:452` | `150` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | reinhardt | `damageDealt%` | `src/aram_settings.opy:455` | `110` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | reinhardt | `damageReceived%` | `src/aram_settings.opy:457` | `75` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | sigma | `damageDealt%` | `src/aram_settings.opy:461` | `115` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | sigma | `damageReceived%` | `src/aram_settings.opy:462` | `75` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | sigma | `secondaryFireRechargeRate%` | `src/aram_settings.opy:463` | `300` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | roadhog | `damageDealt%` | `src/aram_settings.opy:466` | `100` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | roadhog | `damageReceived%` | `src/aram_settings.opy:467` | `100` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | kiriko | `damageDealt%` | `src/aram_settings.opy:472` | `120` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | kiriko | `healingDealt%` | `src/aram_settings.opy:473` | `110` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | sombra | `damageDealt%` | `src/aram_settings.opy:477` | `110` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | sombra | `damageReceived%` | `src/aram_settings.opy:478` | `80` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | widowmaker | `damageDealt%` | `src/aram_settings.opy:482` | `115` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | widowmaker | `damageReceived%` | `src/aram_settings.opy:483` | `115` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | widowmaker | `ammoClipSize%` | `src/aram_settings.opy:484` | `86` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | widowmaker | `ultDuration%` | `src/aram_settings.opy:485` | `134` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | general | `health%` | `src/aram_settings.opy:488` | `200` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | general | `abilityCooldown%` | `src/aram_settings.opy:489` | `60` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | general | `ultGen%` | `src/aram_settings.opy:490` | `150` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | dva | `damageDealt%` | `src/aram_settings.opy:496` | `105` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | dva | `damageReceived%` | `src/aram_settings.opy:497` | `75` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | dva | `secondaryFireRechargeRate%` | `src/aram_settings.opy:498` | `200` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | illari | `damageDealt%` | `src/aram_settings.opy:503` | `120` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | illari | `damageReceived%` | `src/aram_settings.opy:504` | `95` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | illari | `projectileSpeed%` | `src/aram_settings.opy:506` | `500` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | freja | `damageDealt%` | `src/aram_settings.opy:510` | `110` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | freja | `damageReceived%` | `src/aram_settings.opy:511` | `90` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | freja | `projectileSpeed%` | `src/aram_settings.opy:512` | `100` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | venture | `damageDealt%` | `src/aram_settings.opy:515` | `115` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | venture | `damageReceived%` | `src/aram_settings.opy:516` | `80` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | venture | `ability1Duration%` | `src/aram_settings.opy:517` | `250` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | juno | `damageDealt%` | `src/aram_settings.opy:520` | `115` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | juno | `healingDealt%` | `src/aram_settings.opy:521` | `125` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | pharah | `damageDealt%` | `src/aram_settings.opy:525` | `110` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | pharah | `damageReceived%` | `src/aram_settings.opy:526` | `80` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | lifeweaver | `healingDealt%` | `src/aram_settings.opy:531` | `135` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | lifeweaver | `ability2Cooldown%` | `src/aram_settings.opy:533` | `50` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | lifeweaver | `primaryFireRange%` | `src/aram_settings.opy:534` | `200` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | lifeweaver | `secondaryFireCooldown%` | `src/aram_settings.opy:535` | `150` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | wreckingBall | `damageDealt%` | `src/aram_settings.opy:538` | `105` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | wreckingBall | `damageReceived%` | `src/aram_settings.opy:539` | `75` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | hazard | `damageDealt%` | `src/aram_settings.opy:542` | `105` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | hazard | `damageReceived%` | `src/aram_settings.opy:543` | `80` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | hazard | `ability2Health%` | `src/aram_settings.opy:544` | `400` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | hazard | `secondaryFireCost%` | `src/aram_settings.opy:545` | `50` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | hazard | `combatUltGen%` | `src/aram_settings.opy:546` | `0` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | hazard | `passiveUltGen%` | `src/aram_settings.opy:547` | `0` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | domina | `damageDealt%` | `src/aram_settings.opy:550` | `125` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | domina | `damageReceived%` | `src/aram_settings.opy:551` | `80` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mizuki | `damageDealt%` | `src/aram_settings.opy:556` | `125` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mizuki | `damageReceived%` | `src/aram_settings.opy:557` | `80` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mizuki | `secondaryFireCooldown%` | `src/aram_settings.opy:558` | `50` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mizuki | `ability1Cooldown%` | `src/aram_settings.opy:559` | `42` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | mizuki | `ability2Cooldown%` | `src/aram_settings.opy:560` | `42` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | anran | `damageDealt%` | `src/aram_settings.opy:563` | `135` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | anran | `damageReceived%` | `src/aram_settings.opy:564` | `70` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | anran | `ability1Cooldown%` | `src/aram_settings.opy:565` | `50` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | anran | `ability2Cooldown%` | `src/aram_settings.opy:566` | `50` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | emre | `damageDealt%` | `src/aram_settings.opy:569` | `125` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | emre | `damageReceived%` | `src/aram_settings.opy:570` | `90` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | emre | `ability1Duration%` | `src/aram_settings.opy:571` | `160` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | emre | `ability2Cooldown%` | `src/aram_settings.opy:573` | `40` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | jetpackCat | `health%` | `src/aram_settings.opy:576` | `250` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | jetpackCat | `damageDealt%` | `src/aram_settings.opy:577` | `135` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | jetpackCat | `damageReceived%` | `src/aram_settings.opy:578` | `60` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | jetpackCat | `healingDealt%` | `src/aram_settings.opy:579` | `150` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | jetpackCat | `ability1Cooldown%` | `src/aram_settings.opy:580` | `0` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | jetpackCat | `ability2Cooldown%` | `src/aram_settings.opy:581` | `34` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |
| aram_direct_literal | general | `health%` | `src/aram_settings.opy:584` | `200` | ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone |

## 未使用 reference

`unusedOw2ReferenceDefinitions` 是当前既没有直接消费、也没有通过重复 alias 消费的启用定义；#79 应只把项目实际消费的子集纳入 canonical snapshot，避免把未使用字段误当作项目契约。完整列表见 JSON。

共 0 个。

## 迁移边界

- 保留 Main/ARAM 的独立 tuning；审计不把 ARAM 的直接百分比自动解释为绝对 target。
- `src/heroes/**/settings*.opy` 的 `createWorkshopSetting*` 属于 runtime Workshop setting，不能折叠进 OW2 reference。
- 只有在 #79 reference schema 和本报告的人工审查项明确后，#80 才能删除重复常数并迁移消费者。
