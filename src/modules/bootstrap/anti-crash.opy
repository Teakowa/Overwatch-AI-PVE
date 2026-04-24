#!optimizeStrict

rule "[Anti Crash]: Setup settings":
    ANTI_CRASH_ACTIVATE_PERCENT = createWorkshopSettingInt("Anti Crash", "激活阈值", ANTI_CRASH_ACTIVATE_DEFAULT, ANTI_CRASH_ACTIVATE_MIN, ANTI_CRASH_ACTIVATE_MAX)
    ANTI_CRASH_HOLD_TIME = createWorkshopSettingFloat("Anti Crash", "激活持续时间", ANTI_CRASH_HOLD_DEFAULT, ANTI_CRASH_HOLD_MIN, ANTI_CRASH_HOLD_MAX, ANTI_CRASH_HOLD_ORDER)
    ANTI_CRASH_DEACTIVATE_PERCENT = createWorkshopSettingInt("Anti Crash", "停用阈值", ANTI_CRASH_DEACTIVATE_DEFAULT, ANTI_CRASH_DEACTIVATE_MIN, ANTI_CRASH_DEACTIVATE_MAX, ANTI_CRASH_DEACTIVATE_ORDER)


rule "[Anti Crash]: Activate anti crash":
    @Condition getAverageServerLoad() > ANTI_CRASH_ACTIVATE_PERCENT
    @Disabled
    
    wait(ANTI_CRASH_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    smallMessage(getAllPlayers(), "  服务器过载  ")
    setSlowMotion(ANTI_CRASH_SLOW_MOTION_ON)
    wait(ANTI_CRASH_RECOVERY_WAIT)
    waitUntil(getAverageServerLoad() < ANTI_CRASH_DEACTIVATE_PERCENT, Math.INFINITY)
    setSlowMotion(ANTI_CRASH_SLOW_MOTION_OFF)
