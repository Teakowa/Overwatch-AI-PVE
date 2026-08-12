# Performance & Stability (Canonical)

### R-PERF-THROTTLE-HIGH-FREQ

- 高频逻辑必须节流：使用 `wait(...)`/`waitUntil(...)`，避免无等待循环。

### R-PERF-CHEAP-FIRST-CONDITIONS

- `conditions` 首项优先低成本高筛选门控；避免把距离、大数组判断放首位。

### R-PERF-USE-PLAYER-FILTER

- 面向特定英雄/槽位时，优先用事件 `Player` 过滤器（Hero/Slot）。

### R-PERF-DEFER-STARTUP-BURST

- 避免开局首 tick 全量重条件/重动作；应延后触发并为多玩家去同步。

### R-PERF-LOW-FREQ-HEAVY-OPS

- 大遍历、字符串处理与高成本检测优先低频化/分批执行/缓存化。

### R-PERF-NO-RUNTIME-LOAD-SAMPLING

- 禁止在运行时调用 `getAverageServerLoad()` 或通过 Anti Crash 采样动态调整等待；使用固定节流、玩家槽位错峰和硬上限控制服务器压力。

### R-PERF-EXECUTION-MODEL

性能分析必须使用正确的 Workshop 执行模型假设：

- 同一规则/玩家上下文被 `wait`/`waitUntil` 阻塞时，不应建模为每次重复事件都会派生的无上限并行实例；不要仅凭 Wait 时长推断并发型性能问题。
- 普通子程序调用与调用方同步/顺序执行。
- 持久性 Workshop 动作（长时 HOT/DOT、facing/throttle/chase、按钮按住、健康池、加速度等）的生命周期独立于启动它们的规则：需要自身的持续时间或显式 stop/清理语义。Ongoing 规则条件变为 false 不会停止已启动的持久动作。

### R-PERF-PERSISTENT-ACTION-LIFECYCLE

- 从 Ongoing 规则启动长生命周期动作（如 `startHealingOverTime`/`startForcingButton`/`startAcceleration`）时，若规则带有可能反复 false→true 的相位/状态条件（如 `isMatchBetweenRounds`、`hasStatus`），必须保证该动作有明确的生命周期归属：要么在同一规则内配对 stop，要么存储句柄并显式清理，要么证明持续刷新就是预期生命周期。不要依赖条件变 false 来隐式停止动作。

### 扫描器模式（tools/perf-loop-scan.mjs）

`pnpm run perf:scan` 覆盖以下检查；`perf:scan:strict` 仅对 HIGH 置信度项失败退出：

- `EVENT_EXPENSIVE_CONDITION`：`playerTookDamage`/`playerDealtDamage`/`playerDealtKnockback` 条件中的空间/玩家查询；廉价门控已前置时为 LOW，否则为 MEDIUM。
- `REPEATED_QUERY`：同一规则内重复等价 producer/玩家集查询（advisory）。
- `PERSISTENT_ACTION_LIFECYCLE`：相位门控的 Ongoing 规则启动长生命周期动作且无配对 stop/句柄（advisory）。
- 自检：`pnpm run perf:scan:self-test`，fixture 位于 `tools/fixtures/perf/`。
