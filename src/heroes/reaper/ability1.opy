#!optimizeStrict

rule "[Reaper]: Ability 1 Wraith Form cd":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingAbility1() == true

    waitUntil(not eventPlayer.isUsingAbility1(), 3.016)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, eventPlayer.getAbilityCooldown(Button.ABILITY_1) - (50 * ReaperBuff[1] if eventPlayer.reaper_buff[0] > 50 else eventPlayer.reaper_buff[0] * ReaperBuff[1]))
    eventPlayer.dmg_amplification += 150 if ReaperBuff[2] + eventPlayer.reaper_buff[0] * ReaperBuff[3] >= 150 else ReaperBuff[2] + eventPlayer.reaper_buff[0] * ReaperBuff[3]
    wait(3)
    #chaseOverTime(eventPlayer.dmg_amplification, 0, 3, ChaseTimeReeval.NONE)
    eventPlayer.dmg_amplification = 0
