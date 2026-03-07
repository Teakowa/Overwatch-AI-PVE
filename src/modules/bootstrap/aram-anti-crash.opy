rule "[Anti Crash]: Activate anti crash":
    @Condition getServerLoad() > ANTI_CRASH_ACTIVATE_PERCENT
    
    wait(ANTI_CRASH_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    smallMessage(getAllPlayers(), "  服务器过载  ")
    setSlowMotion(1)
    wait(0.5)
    waitUntil(getServerLoad() < ANTI_CRASH_DEACTIVATE_PERCENT, 999999986991104)
    setSlowMotion(100)
