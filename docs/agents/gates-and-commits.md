# Gates & Commits (Canonical)

### R-GATE-SMALL-ROLLBACKABLE-COMMITS

- 小步提交，使用 Conventional Commits；跨分区改动优先拆分为可回滚提交。

### R-GATE-GAMEPLAY-IMPACT-NOTES

- 玩法改动提交说明应标注：影响英雄/系统、负载影响、是否调整 init/reset 链路。

### R-GATE-REGISTER-RULE-FIRST

- 新增规则必须先更新 `docs/agents/rules-index.md`，未登记规则视为无效规则。

### 常用命令（语义保持不变）

- `pnpm install --frozen-lockfile`
- `pnpm run build`
- `pnpm run build:release`
- `pnpm run build:release:all`
- `pnpm run build:aram`
- `pnpm run perf:scan`
- `pnpm run perf:scan:strict`
- `pnpm run tool:bump-version`
- `tools/check-contracts.ts`
- `tools/check-contracts.ts --build`
- `tools/check-contracts.ts --strict-hero-init`
- `tools/check-aram-overrides-duplicates.ts`
- `tools/check-aram-overrides-duplicates.ts --check --emit-candidates build/reports/aram-delta-whitelist-candidates.tsv`
- `tools/hero-pipeline.ts --from-diff`
- `tools/hero-pipeline.ts --from-diff --build`
- `tools/changelog-sync.ts --from-diff`
- `tools/changelog-sync.ts --from-diff --strict-coverage --strict-language --strict-settings-sync`
- `tools/module-metrics-sync.ts`
- `tools/module-metrics-sync.ts --check`

### Workshop Settings 容量

- 自定义 Workshop setting（`createWorkshopSetting*`）总容量上限为 **128**，编译期超限即报错（`Cannot have more than 128 workshop settings`）。
- `tools/check-contracts.ts --build` 会报告 Main / ARAM 实际生成数量与 ARAM 剩余槽位：`workshop settings: main=N aram=M (limit 128, aram remaining K)`。
- 超限（remaining < 0）判定为失败；剩余不足 5 个槽位时给出警告。
- 新增 `createWorkshopSetting*` 时的容量原则：
  - 优先清理「已无规则读取的遗留 settings」「同一数值重复暴露」「Main/ARAM 都注册但只在单一模式有意义」的项，而不是删除正在使用的英雄调参。
  - 稳定参数（如斩杀 sentinel 值）在确有依据时可回退为编译期常量，但不能作为默认做法。
  - 新英雄的调参项只在其实际生效的模式注册；`settings.opy` / `settings.aram.opy` 互斥加载，默认值分别来自各自模式的常量。
  - 每次新增 setting 前先运行 `tools/check-contracts.ts --build` 确认 ARAM 剩余槽位。

### Release 语义

- 版本源：`src/version.opy`
- 版本格式：`YY.MMDD.N`
- Release 触发：push 到 `main`
- Release 跳过：commit message 包含 `[skip release]`
- Release 产物：`build/main.ow` 与 `build/aram.ow`

### 建议门禁顺序

### R-GATE-RUN-HERO-PIPELINE

1. `tools/hero-pipeline.ts --from-diff`

### R-GATE-RUN-CONTRACT-GUARD

2. `tools/check-contracts.ts --build`

### R-GATE-RUN-BUILD

3. `pnpm run perf:scan`
4. `pnpm run build`
