# Minimal Dependency Boundary (Canonical)

### R-MODULE-MINIMAL-DEPENDENCY-BOUNDARY

本规则约束可抽取、可复用或需要跨 Main/ARAM 复用的模块边界。它描述模块的最小依赖集合，不绑定任何具体英雄或技能。

## 规则

1. 先沿 expanded Main/ARAM include graph 追踪目标模块的所有读取、写入、reset、lifecycle 和运行时消费者，再确定依赖边界。
2. 模块只能依赖完成其职责所需的声明、常量、Workshop 内建能力和语义策略；不得为了方便复制完整的 `global-vars.opy`、`player-vars.opy` 或其他全局注册表。
3. 跨模块状态必须通过明确的语义接口或责任模块暴露；直接读取另一个模块的私有存储不构成可复用边界。
4. 模块本地声明必须放在其责任所有者中，带有正确的 `#!mainFile`，从实际使用它的 entry 可达，并在 expanded include graph 中保持逻辑名称唯一。跨 Main/ARAM 的共享声明保留相同逻辑名称，模式差异只体现在明确的配置值或入口。
5. 当改动声称模块可以独立复用或缩小依赖边界时，必须建立最小 fixture：只包含目标片段、所需语义策略、常量、声明和运行时表面，不包含完整 prelude 注册表；fixture 必须能够编译。
6. 如果最小 fixture 无法编译，应记录真实依赖并扩大边界，或先调整模块接口；不能通过静默复制全局注册表来伪造可移植性。

## 验证

- 依赖边界变更至少检查 Main/ARAM include graph、声明唯一性、contract 和对应的 Main/ARAM build。
- 具体 fixture 或工具属于任务/模块的验证实现，不是每个英雄技能都必须拥有同名 portability 规则。
- 参考 fixture：`docs/workflows/ow-ana-portability.md`。它验证安娜生物手雷这一具体实例，但不改变本规则的通用范围。
