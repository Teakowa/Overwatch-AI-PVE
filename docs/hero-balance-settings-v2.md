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

## 4. src 规则层特殊效果索引（已关联 v2）

### 4.1 读取范围

- `src/modules/hero_init/heroes/*.opy`
- `src/modules/hero_init/extras/*.opy`
- `src/modules/hero_rules/heroes/*.opy`
- `src/modules/hero_rules/shared.opy`

注：本节用于补足第 1-3 节仅基于 `settings` 的盲区。实际强度 = `settings` 基础数值 + `hero_init` 初始化覆盖 + `hero_rules` 事件规则叠加。

### 4.2 Hero Init 基线（生命池与初始化覆盖）

`custom_hp_pvar[0/1/2]` 对应 普通生命/护甲/护盾。`N/A` 表示该英雄初始化未在 `hero_init` 中显式覆盖生命池。

| 英雄 | custom_hp_pvar[0/1/2] | 初始化额外覆盖（影响平衡） |
|---|---|---|
| ana | 200/0/0 | - |
| ashe | 200/0/0 | - |
| baptiste | 200/0/0 | 主武器弹药上限 `45`，副武器弹药上限 `25` |
| bastion | 200/50/0 | - |
| brigitte | 200/75/0 | - |
| cassidy | 225/0/0 | - |
| doomfist | 300/100/0 | - |
| dva | N/A | - |
| echo | 200/0/0 | 另有 `echo-duplicate`：复制期间若大招 <50 则设为 `10` |
| freja | 225/0/0 | 初始化投射物速度设为 `500` |
| genji | 225/0/0 | - |
| hanzo | 200/0/0 | - |
| hazard | 200/250/0 | - |
| illari | 200/0/0 | - |
| junkerQueen | 375/0/0 | 初始化 `healingDealt`：Team1=`144.46`，Team2=`122.23` |
| junkrat | 200/0/0 | - |
| juno | 50/0/175 | - |
| kiriko | 225/0/0 | - |
| lifeweaver | 175/0/75 | - |
| lucio | 250/0/0 | - |
| mauga | 250/200/0 | - |
| mei | 275/0/0 | - |
| mercy | 250/0/0 | 主武器弹药上限 `20` |
| moira | 300/0/0 | - |
| orisa | 250/200/0 | - |
| pharah | 100/0/125 | - |
| ramattra | 275/100/0 | - |
| reaper | 275/0/0 | - |
| reinhardt | 250/250/0 | - |
| roadhog | 700/0/0 | 主武器弹药上限 `5` |
| sigma | 200/0/200 | - |
| sojourn | 250/0/0 | - |
| soldier | 200/0/0 | - |
| sombra | 200/0/0 | - |
| symmetra | 125/0/125 | - |
| torbjorn | 200/50/0 | - |
| tracer | 125/0/50 | 初始化 Recall 冷却设为 `8s` |
| vendetta | N/A | - |
| venture | 250/0/0 | - |
| widowmaker | 175/0/0 | 主武器弹药上限 `25` |
| winston | 300/200/0 | - |
| wreckingBall | 500/100/0 | - |
| wuyang | N/A | - |
| zarya | 200/0/200 | - |
| zenyatta | 50/0/175 | 主武器弹药上限 `20` |

### 4.3 规则层特殊效果（按英雄）

- `通用`：`shared.opy` 中存在“状态重置”规则，会周期性清理 `INVINCIBLE/PHASED_OUT/unaffected`（`mauga_berserker_soul` 例外），会影响多英雄效果持续时间。
- `ana`：生物手雷可附加燃烧+最大生命值比例 DOT；Nano 使用了“满血队友先微伤再治疗”逻辑，确保吃到抬血；睡眠命中坦克改为更长倒地控制。
- `ashe`：存在额外爆头伤害规则；Team2 击杀回满弹，Coach Gun 可加弹。
- `baptiste`：不朽领域期间会给受保目标短暂 `PHASED_OUT` + 持续治疗；存在额外爆头伤害规则。
- `bastion`：未发现独立规则层特效（主要由 settings 与 init 决定）。
- `brigitte`：盾击附带眩晕与减速链路；维修包可转化为护甲池；Rally 期间含加速与叠层护甲/减伤（含 shared 链路）。
- `cassidy`：闪光弹眩晕；副射期间伤害上调并带自动回弹；Team1 击杀补弹；额外文件恢复远距离伤害衰减曲线（OW1 风格）。
- `doomfist`：Power Block 累计增伤值并由副武器一次性结算；“最佳防守”提供临时护甲池；大招期间伤害倍率单独覆盖。
- `dva`：未发现独立规则层特效（且 init 未覆盖生命池）。
- `echo`：聚焦光束期间有额外伤害覆盖；复制体有快速起步大招充能规则。
- `freja`：主攻/大招叠“印记”，副射按印记结算额外伤害；存在斩杀逻辑；空中减伤与 Team1 自疗；大招期间投射物速度改写。
- `genji`：格挡期间无敌+伤害提高；龙刃带吸血与单独伤害/承伤修正。
- `hanzo`：存在额外爆头伤害规则。
- `hazard`：突进击杀重置 CD；蓄力可得临时生命池；防御姿态可回大招并按受伤回复生命；副射伤害带额外倍率。
- `illari`：Captive Sun 存在按附近友军数扩增的“最大生命值比例”伤害，并有对应 HUD 提示。
- `junkerQueen`：Commanding Shout 带嘲讽链路并按嘲讽人数提供临时生命池。
- `junkrat`：攻击可施加燃烧，并触发按当前生命值百分比的追加伤害。
- `juno`：Ability2 调整投射速度；大招圈内队友获得减伤；副武器治疗可短时提高受疗。
- `kiriko`：存在额外爆头伤害规则；Suzu/瞬移均会清异常并提供短暂无敌+虚化；瞬移后可给附近友军临时生命池。
- `lifeweaver`：Life Grip 触发时会清理目标身上的异常状态。
- `lucio`：Soundwave 触发团队治疗逻辑。
- `mauga`：低血触发“狂战士之魂”（无敌/不可击杀/虚化、伤害与减伤重写、禁疗、临时生命池与持续掉血）；击杀回命；期间技能 CD 被压短；Overrun/心脏过载/斗兽场有额外效果。
- `mei`：未发现独立规则层特效（主要由 settings 与 init 决定）。
- `mercy`：Flash Heal 冷却被强制压低；女武神期间有全队 HOT、伤害/承伤重写，并刷新复活冷却。
- `moira`：开大期间禁用 Shift；在特定技能阶段会触发自疗 HOT。
- `orisa`：Fortify/大招受击可反伤；大招击飞可附眩晕；存在速度惩罚与冲刺位移；shared 中 Fortify 还会附加临时护甲与 `unaffected`。
- `pharah`：未发现独立规则层特效（主要由 settings 与 init 决定）。
- `ramattra`：格挡与大招链路可累积“格挡值”并转换为临时生命池；大招期间独立移速/伤害/承伤/击退抗性；普攻和大招具备自疗与续大逻辑。
- `reaper`：灵魂层数体系（击杀叠层）驱动 CD 返还、增伤、减伤、DOT；死神形态/大招允许上下飞行；大招期间可获得不可击杀与移速修正。
- `reinhardt`：火焰打击附加燃烧并可回生命；裂地击杀可回满大招；存在“十字军坚定”（抗击退+临时生命池）；冲锋/盾击有独立修正与额外控制。
- `roadhog`：吸气期间可转为 Team1 团队治疗，并维持副资源下限。
- `sigma`：屏障冷却下限压缩；大招有追加伤害；石头可延长击倒；主武器有“叠层第4发”额外伤害机制。
- `sojourn`：Overclock 开启后参数上调；对低血目标有斩杀补伤逻辑。
- `soldier`：螺旋飞弹附加燃烧与 DOT。
- `sombra`：Team1 自动位移支援逻辑；Hack 叠加 OW1 风格时长并降低受疗；击杀可重置 Translocator 冷却。
- `symmetra`：未发现独立规则层特效（主要由 settings 与 init 决定）。
- `torbjorn`：未发现独立规则层特效（主要由 settings 与 init 决定）。
- `tracer`：死亡瞬间复活并回闪现层数；脉冲炸弹有追加伤害；击杀触发回血与 Recall/Blink 重置；Recall 存在额外治疗链路。
- `vendetta`：普攻命中可减双技能 CD、按目标血量结构追加伤害并自疗；位移技能提供虚化/免控；大招有倒地后阈值斩杀。
- `venture`：遁地阶段移速显著提升（规则名含 healing，但当前实现主要为移速）。
- `widowmaker`：Infra-Sight 期间狙击爆头倍率提升至 x3；狙击距离衰减曲线回退为 OW1 风格。
- `winston`：未发现独立规则层特效（主要由 settings 与 init 决定）。
- `wreckingBall`：抓钩在出生室重置冷却；特定击飞事件可附带短眩晕。
- `wuyang`：完整控制链路（减速、冻结、强制位移）；可给队友提供护盾池与治疗；技能命中可返还 CD；大招同时带减速与团队治疗。
- `zarya`：投射屏障目标选择+临时生命池；低血“胜利意志”触发无敌/虚化/回能与 HOT。
- `zenyatta`：存在额外爆头伤害规则；踢击有额外位移与补伤；开大期间有移速与治疗输出重写。

### 4.4 与 v2 高优先级清单的关联结论

- `moira`：不仅 `settings` 差值极大，规则层还叠加“技能阶段自疗”和“开大禁 Shift”这类节奏控制，调参应先动 `settings` 再看规则链。
- `illari`：`settings` 的高伤高弹速叠加 Captive Sun 比例伤害机制，实战爆发会高于纯面板预期。
- `symmetra`：虽无额外规则层特效，但 `settings` 已给出高减伤+低冷却，属于“纯面板强势型”。
- `mercy`：除 `settings` 外还有女武神全队 HOT 与复活刷 CD，属于“面板+机制双强化”。
- `roadhog`：`settings` 高生存叠加团队治疗规则，耐打与续航都偏高。
- `mauga`：`settings` 与“狂战士之魂”机制强耦合，建议把机制窗口（触发阈值、持续、禁疗）和基础数值分两轮调。
- `ramattra`：`ultDuration` 差值之外还有“续大+减伤+临时生命池”链路，建议优先限制叠层来源或触发频率。
- `pharah`：当前主要由 `settings` 决定（规则层无额外强化），可直接按面板法调参。
- `kiriko`：高治疗/高充能同时叠加无敌+虚化与临时生命池，建议先削减其中一个维度，避免双重保命。
- `lucio`：高治疗面板叠加 Soundwave 团疗，建议关注团战峰值治疗而非平均治疗。
- `torbjorn`：目前主要是面板驱动（规则层无明显额外强化），适合直接按 v2 差值回调。
- `mei`：规则层影响弱，优先按 `damageReceived%` 与技能 CD 差值回调即可。
