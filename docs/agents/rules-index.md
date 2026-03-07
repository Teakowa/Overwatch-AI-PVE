# Rules Index (Canonical Registry)

本表是协作规则唯一注册表。字段固定：`Rule ID`、`Canonical Path`、`Anchor`、`Trigger`、`Owner`。

| Rule ID | Canonical Path | Anchor | Trigger | Owner |
| --- | --- | --- | --- | --- |
| R-SCOPE-ENTRY | docs/agents/project-scope.md | #r-scope-entry | 任意改动需建立项目上下文 | repo-maintainers |
| R-SCOPE-OUTPUT | docs/agents/project-scope.md | #r-scope-output | 涉及产物或构建输出说明 | repo-maintainers |
| R-MAIN-TOP-ORDER | docs/agents/main-contract.md | #r-main-top-order | 改 `src/main.opy` 或 prelude | repo-maintainers |
| R-MAIN-INCLUDE-ORDER | docs/agents/main-contract.md | #r-main-include-order | 改 include 编排 | repo-maintainers |
| R-MAIN-NO-INDEX-INCLUDE | docs/agents/main-contract.md | #r-main-no-index-include | 调整 main include | repo-maintainers |
| R-MAIN-CONSTANTS-BEFORE-PRELUDE | docs/agents/main-contract.md | #r-main-constants-before-prelude | 调整 constants/settings 依赖 | repo-maintainers |
| R-MAIN-SECTION-DELIMITERS | docs/agents/main-contract.md | #r-main-section-delimiters | 改初始化分段规则 | repo-maintainers |
| R-PROTO-INDEX-IMMUTABLE | docs/agents/protocol-constraints.md | #r-proto-index-immutable | 改变量/子程序声明 | repo-maintainers |
| R-PROTO-APPEND-NO-REORDER | docs/agents/protocol-constraints.md | #r-proto-append-no-reorder | 新增变量/规则 | repo-maintainers |
| R-PROTO-KEEP-DELIMITER-NAMES | docs/agents/protocol-constraints.md | #r-proto-keep-delimiter-names | 改关键分隔规则 | repo-maintainers |
| R-PROTO-KEEP-DISABLED | docs/agents/protocol-constraints.md | #r-proto-keep-disabled | 清理或启停规则 | repo-maintainers |
| R-PROTO-RULE-NAME-STYLE | docs/agents/protocol-constraints.md | #r-proto-rule-name-style | 新增/改名规则 | repo-maintainers |
| R-PROTO-SETTINGS-FIRST | docs/agents/protocol-constraints.md | #r-proto-settings-first | 改英雄通用数值策略 | repo-maintainers |
| R-PROTO-NO-FILENAME-ORDER-HACK | docs/agents/protocol-constraints.md | #r-proto-no-filename-order-hack | 变更模块文件命名 | repo-maintainers |
| R-HINIT-DETECT-SET-RESET-FLAG | docs/agents/hero-init-contract.md | #r-hinit-detect-set-reset-flag | 新增/改 hero init detect | repo-maintainers |
| R-HINIT-INIT-GUARD | docs/agents/hero-init-contract.md | #r-hinit-init-guard | 新增/改 hero init initialize | repo-maintainers |
| R-HINIT-CALL-RESET-HERO | docs/agents/hero-init-contract.md | #r-hinit-call-reset-hero | 初始化链路改动 | repo-maintainers |
| R-HINIT-APPLY-INITIAL-STATE | docs/agents/hero-init-contract.md | #r-hinit-apply-initial-state | 初始化属性写入 | repo-maintainers |
| R-HINIT-CLEAR-RESET-FLAG | docs/agents/hero-init-contract.md | #r-hinit-clear-reset-flag | 初始化收尾 | repo-maintainers |
| R-PERF-THROTTLE-HIGH-FREQ | docs/agents/performance-stability.md | #r-perf-throttle-high-freq | 高频规则改动 | repo-maintainers |
| R-PERF-CHEAP-FIRST-CONDITIONS | docs/agents/performance-stability.md | #r-perf-cheap-first-conditions | 条件链改动 | repo-maintainers |
| R-PERF-USE-PLAYER-FILTER | docs/agents/performance-stability.md | #r-perf-use-player-filter | 英雄/槽位筛选改动 | repo-maintainers |
| R-PERF-DEFER-STARTUP-BURST | docs/agents/performance-stability.md | #r-perf-defer-startup-burst | 开局初始化改动 | repo-maintainers |
| R-PERF-LOW-FREQ-HEAVY-OPS | docs/agents/performance-stability.md | #r-perf-low-freq-heavy-ops | 大数组/高成本检测改动 | repo-maintainers |
| R-PERF-KEEP-ANTI-CRASH | docs/agents/performance-stability.md | #r-perf-keep-anti-crash | Anti Crash 相关改动 | repo-maintainers |
| R-CHECK-MAIN-CONTRACT | docs/agents/self-checklist.md | #r-check-main-contract | 提交前自检 | repo-maintainers |
| R-CHECK-INDEX-PROTOCOL | docs/agents/self-checklist.md | #r-check-index-protocol | 提交前自检 | repo-maintainers |
| R-CHECK-HERO-INIT-CHAIN | docs/agents/self-checklist.md | #r-check-hero-init-chain | 提交前自检 | repo-maintainers |
| R-CHECK-NO-WAITLESS-LOOP | docs/agents/self-checklist.md | #r-check-no-waitless-loop | 提交前自检 | repo-maintainers |
| R-CHECK-TEAM-BOUNDARY | docs/agents/self-checklist.md | #r-check-team-boundary | 提交前自检 | repo-maintainers |
| R-CHECK-STARTUP-PEAK | docs/agents/self-checklist.md | #r-check-startup-peak | 提交前自检 | repo-maintainers |
| R-GATE-SMALL-ROLLBACKABLE-COMMITS | docs/agents/gates-and-commits.md | #r-gate-small-rollbackable-commits | 提交流程 | repo-maintainers |
| R-GATE-GAMEPLAY-IMPACT-NOTES | docs/agents/gates-and-commits.md | #r-gate-gameplay-impact-notes | 玩法改动提交说明 | repo-maintainers |
| R-GATE-REGISTER-RULE-FIRST | docs/agents/gates-and-commits.md | #r-gate-register-rule-first | 新规则引入 | repo-maintainers |
| R-GATE-RUN-HERO-PIPELINE | docs/agents/gates-and-commits.md | #r-gate-run-hero-pipeline | 提交门禁 | repo-maintainers |
| R-GATE-RUN-CONTRACT-GUARD | docs/agents/gates-and-commits.md | #r-gate-run-contract-guard | 提交门禁 | repo-maintainers |
| R-GATE-RUN-BUILD | docs/agents/gates-and-commits.md | #r-gate-run-build | 提交门禁 | repo-maintainers |
