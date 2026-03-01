# Hero Balance Settings V2

- 生成时间：2026-03-02 (Asia/Shanghai)
- 数据来源：`src/modules/prelude/00-settings.opy`
- 覆盖范围：`heroes.team1`、`heroes.team2`、`heroes.allTeams`、`workshop`
- 差值定义：`Δ = Team1 - Team2`
- 判读规则：对于 `damageReceived%` / `*Cooldown%`，`Δ < 0` 代表 Team1 更强（更耐打或冷却更快）

## 1. 高优先级失衡清单（建议先调）

| 优先级 | 英雄 | 失衡热度(∑\|Δ\|) | 主要差值（节选） |
|---|---|---:|---|
| P0 | moira | 980 | `ability2MaxDamage% +400`, `ability2MaxHealing% +400`, `damageDealt% +45`, `damageReceived% -40` |
| P0 | illari | 325 | `damageDealt% +90`, `projectileSpeed% +100`, `damageReceived% -35`, `ability2Cooldown% -25` |
| P0 | symmetra | 212 | `ability1Cooldown% -70`, `ability2Cooldown% -67`, `damageReceived% -50`, `damageDealt% +25` |
| P0 | mercy | 199 | `damageReceived% -65`, `ability1Cooldown% -50`, `healingDealt% +58`, `ability2Cooldown% -26` |
| P0 | roadhog | 147 | `damageReceived% -80`, `ability2Cooldown% -67` |
| P1 | mauga | 255 | `ability2Healing% +200`, `ability2Cooldown% -25` |
| P1 | torbjorn | 228 | `ultGen% +56`（含 `combat/passive ultGen` 同步 +56） |
| P1 | ramattra | 225 | `ultDuration% +180`, `ultGen% +35` |
| P1 | mei | 204 | `damageReceived% -50`, `ability1Cooldown% -43`, `ability2Cooldown% -34` |
| P1 | kiriko | 171 | `healingDealt% +45`, `ultGen% +50` |
| P1 | pharah | 167 | `ability2Cooldown% -57`, `passiveExtraFuel% +75` |
| P1 | lucio | 153 | `healingDealt% +103`, `ability2Cooldown% -35` |

补充：反向（玩家侧更强）最明显的是 `tracer`（`damageDealt% -45`, `damageReceived% +15`）和部分 `genji`伤害项。

## 2. 全英雄核心指标差值表（Δ = Team1 - Team2）

| 英雄 | 伤害Δ | 承伤Δ | 治疗输出Δ | 受疗Δ | 生命Δ | 充能Δ | 技能1CDΔ | 技能2CDΔ | 次要CDΔ |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| ana | - | - | +40 | - | - | +48 | -14 | - | - |
| ashe | -25 | - | - | - | - | - | 0 | 0 | - |
| baptiste | -25 | - | +25 | - | - | - | 0 | 0 | - |
| brigitte | -10 | +7 | +20 | - | 0 | +18 | - | - | 0 |
| cassidy | -15 | -22 | - | - | - | - | - | 0 | - |
| doomfist | +5 | -25 | - | - | - | - | - | - | - |
| freja | +10 | -10 | - | - | - | - | -11 | -5 | 0 |
| genji | -40 | +10 | - | - | - | +40 | - | - | - |
| hanzo | -15 | - | - | - | - | +17 | - | - | - |
| hazard | -10 | -5 | - | - | - | - | - | - | - |
| illari | +90 | -35 | - | - | - | - | - | -25 | - |
| junkerQueen | -20 | 0 | - | - | - | - | -68 | 0 | 0 |
| junkrat | +30 | - | - | - | - | - | - | -50 | - |
| juno | - | - | 0 | - | - | 0 | - | 0 | 0 |
| kiriko | -15 | - | +45 | - | - | +50 | - | -4 | - |
| lucio | -15 | 0 | +103 | - | - | - | - | -35 | - |
| mauga | -15 | -15 | - | - | - | - | - | -25 | - |
| mei | +15 | -50 | - | - | - | - | -43 | -34 | - |
| mercy | - | -65 | +58 | - | - | - | -50 | -26 | - |
| moira | +45 | -40 | +40 | - | - | +30 | - | -25 | - |
| orisa | - | +5 | - | - | 0 | +30 | 0 | - | 0 |
| pharah | -10 | -10 | - | - | - | - | -15 | -57 | - |
| ramattra | -10 | 0 | - | - | - | +35 | 0 | 0 | 0 |
| reaper | -25 | -15 | +50 | - | - | - | - | - | - |
| reinhardt | - | -15 | - | - | 0 | - | -36 | - | - |
| roadhog | - | -80 | - | - | - | - | - | -67 | - |
| sigma | - | -15 | - | - | 0 | - | 0 | 0 | - |
| sojourn | - | - | - | - | - | - | - | 0 | - |
| soldier | -15 | - | - | - | - | - | - | -27 | - |
| sombra | -25 | -8 | - | - | - | - | - | - | -34 |
| symmetra | +25 | -50 | - | - | - | - | -70 | -67 | - |
| torbjorn | +10 | - | - | - | - | +56 | - | - | - |
| tracer | -45 | +15 | - | - | - | +35 | 0 | 0 | - |
| vendetta | 0 | -10 | - | - | - | 0 | - | - | - |
| venture | -15 | -15 | - | - | - | 0 | - | - | -12 |
| widowmaker | +30 | -45 | - | - | - | +70 | - | - | - |
| winston | +40 | -45 | - | - | - | - | - | -52 | - |
| zarya | -20 | -25 | - | - | - | +39 | -34 | -3 | - |
| zenyatta | -50 | - | - | - | - | +50 | - | - | - |

## 3. 使用建议（后续平衡调整）

1. 先从 P0 英雄做第一轮回归基础值（每轮只改 3-5 个字段）。
2. 每次只优先改一个维度（先 `damageReceived%/Cooldown%`，后 `damage/heal/ultGen`）。
3. 本文档仅覆盖 `settings` 层；最终体感仍受 `hero_init` 与 `hero_rules` 影响。
