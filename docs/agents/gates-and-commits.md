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
- `pnpm run build:aram`
- `pnpm run perf:scan`
- `pnpm run perf:scan:strict`
- `skills/ow-contract-guard/scripts/check_contracts.sh`
- `skills/ow-contract-guard/scripts/check_contracts.sh --build`
- `skills/ow-contract-guard/scripts/check_contracts.sh --strict-hero-init`
- `skills/ow-contract-guard/scripts/check_aram_overrides_duplicates.sh`
- `skills/ow-contract-guard/scripts/check_aram_overrides_duplicates.sh --check --emit-candidates build/reports/aram-delta-whitelist-candidates.tsv`
- `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --from-diff`
- `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --from-diff --build`
- `skills/ow-changelog-sync/scripts/changelog_sync.sh --from-diff`
- `skills/ow-changelog-sync/scripts/changelog_sync.sh --from-diff --strict-coverage --strict-language --strict-settings-sync`
- `skills/ow-module-metrics-sync/scripts/metrics_sync.sh`
- `skills/ow-module-metrics-sync/scripts/metrics_sync.sh --check`

### 建议门禁顺序

### R-GATE-RUN-HERO-PIPELINE

1. `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --from-diff`

### R-GATE-RUN-CONTRACT-GUARD

2. `skills/ow-contract-guard/scripts/check_contracts.sh --build`

### R-GATE-RUN-BUILD

3. `pnpm run perf:scan`
4. `pnpm run build`
