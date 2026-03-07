rule "[Wuyang]: Tidal Blast Allies Healing":
    @Event eachPlayer
    @Condition eventPlayer.wuyang_buff == true
    @Disabled

    eventPlayer.startHealingOverTime(eventPlayer.reset_pvar[13], 3, eventPlayer.getMaxHealth() * WuyangBuff[5])
    wait(3)
    eventPlayer.wuyang_buff = false
