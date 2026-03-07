# Self Checklist (Canonical)

### R-CHECK-MAIN-CONTRACT

1. 是否破坏顶层顺序、include 契约或关键分隔规则？

### R-CHECK-INDEX-PROTOCOL

2. 是否改动已有变量/子程序索引？

### R-CHECK-HERO-INIT-CHAIN

3. 英雄改动是否覆盖 init Detect/Initialize、reset 清理与必要 changelog/HUD？

### R-CHECK-NO-WAITLESS-LOOP

4. 是否引入无等待循环或高频昂贵表达式？

### R-CHECK-TEAM-BOUNDARY

5. 是否误改 Team 1（AI）与 Team 2（玩家）职责边界？

### R-CHECK-STARTUP-PEAK

6. 是否引入开局同 tick 峰值或高频条件直接读取频繁变化大数组？
