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

rule "[Wuyang]: Tidal Blast mov_speed_penalty":
    @Event playerDealtKnockback
    @Hero wuyang
    @Condition eventAbility == Button.ULTIMATE

    victim.mov_speed_penalty += WuyangBuff[4]
    victim.setMoveSpeed(100 + victim.mov_speed_buff - victim.mov_speed_penalty)
    waitUntil(victim.mov_speed_penalty == 0 or victim.unaffected or victim.hasStatus(Status.INVINCIBLE), 3)
    victim.setMoveSpeed(100)
    victim.mov_speed_penalty -= WuyangBuff[4]
