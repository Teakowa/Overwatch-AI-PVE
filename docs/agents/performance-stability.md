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
