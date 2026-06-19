# Hero Init Contract (Canonical)

新增/改造初始化遵循 dispatcher + 英雄 init subroutine。

### R-HINIT-DETECT-SET-RESET-FLAG

1. detect/queue 链路命中时，设置：
   `eventPlayer.init_hero = eventPlayer.getCurrentHero()`
   `eventPlayer.call_init = true`
   `eventPlayer._reset_requested = true`

### R-HINIT-INIT-GUARD

2. dispatcher initialize 条件必须同时门控：
   `eventPlayer.call_init == true`
   `eventPlayer.hasSpawned() == true`
   `eventPlayer._reset_requested != false`
   `eventPlayer.getCurrentHero() == eventPlayer.init_hero`

### R-HINIT-CALL-RESET-HERO

3. dispatcher initialize 中必须调用：`resetHero()`。

### R-HINIT-APPLY-INITIAL-STATE

4. `src/modules/hero_init/dispatcher.opy` 是唯一共享 hero-init 入口，承载 subroutine 声明、dispatcher 和共享 initialize rule；每个 `src/heroes/*/init.opy` 只保留一个英雄 init subroutine 体，负责写入该英雄的初始生命值/状态/HUD/引用等初始化逻辑。

### R-HINIT-CLEAR-RESET-FLAG

5. dispatcher initialize 结尾必须：
   `eventPlayer._last_hero_played = eventPlayer.init_hero`
   `eventPlayer.call_init = false`
   `eventPlayer._reset_requested = false`

遗漏收尾会导致重复初始化、队列卡死或错误地复用旧英雄状态。
