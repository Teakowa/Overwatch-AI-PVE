rule "[Reaper]: ultimate Death Blossom":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.setDamageDealt(100 + eventPlayer.reaper_buff[0] * ReaperBuff[8])
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.setStatusEffect(eventPlayer, Status.INVINCIBLE, 2.5 if eventPlayer.reaper_buff[0] * 0.05 >= 2.5 else eventPlayer.reaper_buff[0] * 0.05)
    eventPlayer.setStatusEffect(eventPlayer, Status.PHASED_OUT, 2.5 if eventPlayer.reaper_buff[0] * 0.05 >= 2.5 else eventPlayer.reaper_buff[0] * 0.05)
    waitUntil(not eventPlayer.isUsingUltimate(), 3.016)
    eventPlayer.setDamageDealt(100)

rule "[Reaper]: Death Blossom remove Mov. speed penalty":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.mov_speed_buff += 100
    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff)
    waitUntil(not eventPlayer.isUsingUltimate(), 3.5)
    eventPlayer.mov_speed_buff = 0
    eventPlayer.setMoveSpeed(100)
