# 03. 模块契约与稳定性协议

本文档定义模块化后的“不可随意变更”约定。

## 1. 变量索引协议（硬约束）

- `globalvar` 索引不可重排
- `playervar` 索引不可重排
- `subroutine` 索引不可重排

新增变量优先使用空闲索引，仅追加。

## 2. 分隔规则协议（硬约束）

以下规则名和相对顺序必须保留：

- `Initialize AI Scripts`
- `Initialize AI Scripts End`
- `Initialize Heroes`
- `Initialize Heors End`

## 3. `reset_pvar` 槽位协议（关键）

稳定语义槽位：

- `reset_pvar[0]`: 英雄初始化触发开关
- `reset_pvar[1]`: 己方 Brigitte
- `reset_pvar[3]`: 己方 Kiriko
- `reset_pvar[4]`: 己方 Sombra
- `reset_pvar[5]`: 敌方 Ramattra
- `reset_pvar[6]`: 敌方 Sombra
- `reset_pvar[7]`: 敌方 Ana
- `reset_pvar[9]`: 敌方 Hanzo
- `reset_pvar[11]`: 敌方 Freja
- `reset_pvar[12]`: 己方 Baptiste
- `reset_pvar[13]`: 己方 Wuyang
- `reset_pvar[14]`: 敌方 Wuyang
- `reset_pvar[15]`: 本队 0 号位
- `reset_pvar[16]`: 本队 5 号位

## 4. Hero Init 协议

遵循 Detect/Initialize 双规则模型：

1. Detect: 命中英雄后 `eventPlayer.reset_pvar[0] = true`
2. Initialize:
   - 条件 `eventPlayer.reset_pvar[0] != false`
   - 执行 `resetHero()`
   - 应用英雄初始状态
   - 最后写回 `eventPlayer.reset_pvar[0] = false`

## 5. 性能与稳定性协议

- 高频 `eachPlayer` 规则保持节流（`wait` / `waitUntil`）
- 先廉价条件后昂贵条件（LoS、排序、全局搜索）
- `Anti Crash` 链路不可弱化
- `@Disabled` 规则默认保留，不可因“清理”而移除

## 6. 构建协议

- 本地构建：`pnpm run build`
- 发行构建：`pnpm run build:release`
- OverPy 版本由 `package.json` 锁定
