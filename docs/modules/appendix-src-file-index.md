# 附录：`src/main.opy` 索引（按行号）

## 1. 顶层结构索引

| 区块 | 起始行 | 说明 |
| --- | ---: | --- |
| `settings { ... }` | 3 | 模式、地图、队伍、英雄基础倍率 |
| `#Global variables` | 726 | 全局变量索引协议 |
| `#Player variables` | 771 | 玩家变量索引协议 |
| `#Subroutine names` | 839 | 子程序索引协议 |
| `#!optimizeStrict` | 858 | OverPy 严格优化指令 |

## 2. 规则主体分区索引

| 分区 | 行号范围 | 规则数（约） | 说明 |
| --- | --- | ---: | --- |
| 启动/全局/重置基础 | 861-1351 | 17 | 版权、全局设置、Blacklist、Hero BAN、reset 工具链 |
| AI 主逻辑区 | 1352-2517 | 66 | 生成 dummy、目标选择、位移控制、英雄 AI 控制 |
| 英雄行为改动区 | 2523-4804 | 177 | 技能增强/限制、伤害与状态逻辑、跨英雄联动 |
| 英雄初始化区 | 4805-6024 | 95 | Detect + Initialize 双规则模式 |
| 调试/展示尾部 | 6030-6191 | 2 | 调试开关、Changelog HUD |

## 3. 关键分隔规则

| 规则名 | 行号 | 用途 |
| --- | ---: | --- |
| `Initialize AI Scripts` | 1352 | AI 区块起始分隔 |
| `Initialize AI Scripts End` | 2517 | AI 区块结束分隔 |
| `Initialize Heroes` | 4805 | 英雄初始化区起始分隔 |
| `Initialize Heors End` | 6024 | 英雄初始化区结束分隔（保留现拼写） |

## 4. 关键子程序索引

| 子程序 | 行号 | 作用 |
| --- | ---: | --- |
| `storeOverhealth()` | 1120 | 记录临时生命池变化基线 |
| `enableAllAbilities()` | 1126 | 恢复按键与技能可用状态 |
| `disableAllAbilities()` | 1150 | 禁用主要技能按键 |
| `resetStats()` | 1174 | 回归倍率与移动参数 |
| `resetStatuses()` | 1189 | 清理状态效果与临时标记 |
| `resetFrenemies()` | 1213 | 刷新友敌关键引用缓存 |
| `clearCustomHp()` | 1283 | 清空并重建生命池基线 |
| `applyCustomHp()` | 1301 | 应用自定义生命池到当前英雄 |
| `resetHero()` | 1320 | 标准英雄重置入口 |
| `removeTankPassive()` | 1345 | 坦克被动移除（当前禁用） |
| `botAim2Target()` | 1358 | AI 朝向当前目标 |
| `Knockback()` | 3231 | 禅雅塔踢击复用击退 |
| `changelogText()` | 6053 | 出生室改动文案 |

## 5. 规则事件分布（统计）

| 事件 | 数量 |
| --- | ---: |
| `eachPlayer` | 248 |
| `playerTookDamage` | 24 |
| `playerDealtDamage` | 34 |
| `playerEarnedElimination` | 7 |
| `playerDealtKnockback` | 12 |
| 其他事件（Join/Left/Died/Healing 等） | 36 |

备注：事件分布可用于评估高频规则压力；高负载时优先审查 `eachPlayer` 规则中的条件顺序与 `wait` 节流。
