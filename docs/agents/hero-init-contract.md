# Hero Init Contract (Canonical)

新增/改造初始化遵循 Detect/Initialize 双规则。

### R-HINIT-DETECT-SET-RESET-FLAG

1. Detect：命中时 `eventPlayer.reset_pvar[0] = true`。

### R-HINIT-INIT-GUARD

2. Initialize 条件：`eventPlayer.reset_pvar[0] != false`。

### R-HINIT-CALL-RESET-HERO

3. Initialize 中必须调用：`resetHero()`。

### R-HINIT-APPLY-INITIAL-STATE

4. Initialize 中写入：英雄自定义生命值/状态。

### R-HINIT-CLEAR-RESET-FLAG

5. Initialize 结尾：`eventPlayer.reset_pvar[0] = false`。

遗漏复位会导致重复初始化或循环执行。
