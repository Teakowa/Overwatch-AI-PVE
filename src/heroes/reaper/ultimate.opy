#!optimizeStrict

rule "[Reaper]: ultimate Death Blossom":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.setDamageDealt(100 + eventPlayer.reaper_buff[0] * ReaperBuff[8])
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.setStatusEffect(eventPlayer, Status.UNKILLABLE, 2.5 if eventPlayer.reaper_buff[0] * 0.05 >= 2.5 else eventPlayer.reaper_buff[0] * 0.05)
    waitUntil(not eventPlayer.isUsingUltimate(), 3.016)
    eventPlayer.setDamageDealt(100)

rule "[Reaper]: Death Blossom remove Mov. speed penalty":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingUltimate() == true

    if abs(eventPlayer.mov_speed_buff) < abs(100):
        eventPlayer.mov_speed_buff = 100
        applySignedMoveSpeed()
    waitUntil(not eventPlayer.isUsingUltimate() or eventPlayer.isDead(), 3.5)
    if eventPlayer.isDead():
        goto lbl_0
    if eventPlayer.mov_speed_buff == 100:
        eventPlayer.mov_speed_buff = 0
        applySignedMoveSpeed()
    lbl_0:
