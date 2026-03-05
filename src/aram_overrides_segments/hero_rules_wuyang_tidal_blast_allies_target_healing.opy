rule "[Wuyang]: Tidal Blast Allies Target":
    @Event playerDealtHealing
    @Hero wuyang
    @Condition eventAbility == Button.ULTIMATE
    
    eventPlayer.startHealingOverTime(healee, 1.25, eventPlayer.getMaxHealth() * 0.5 / 1.25)

rule "[Wuyang]: Tidal Blast Allies Healing":
    @Event eachPlayer
    @Condition eventPlayer.wuyang_buff == true
    @Disabled
    
    eventPlayer.startHealingOverTime(eventPlayer.reset_pvar[13], 3, eventPlayer.getMaxHealth() * WuyangBuff[5])
    wait(3)
    eventPlayer.wuyang_buff = false

