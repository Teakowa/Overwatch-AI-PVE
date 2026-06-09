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
