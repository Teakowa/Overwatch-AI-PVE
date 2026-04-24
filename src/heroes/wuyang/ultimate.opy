#!optimizeStrict

rule "[Wuyang]: Tidal Blast mov_speed_penalty":
    @Event playerDealtKnockback
    @Hero wuyang
    @Condition eventAbility == Button.ULTIMATE

    if victim.wuyang_buff[4] == true:
        goto lbl_0
    victim.wuyang_buff[4] = true
    if abs(victim.mov_speed_buff) < WuyangBuff[4]:
        victim.mov_speed_buff = -WuyangBuff[4]
        victim.setMoveSpeed(min(max(100 + victim.mov_speed_buff, 20), 200))
    wait(3)
    if victim.wuyang_buff[4] != true:
        goto lbl_0
    if victim.mov_speed_buff == -WuyangBuff[4]:
        victim.mov_speed_buff = 0
        victim.setMoveSpeed(min(max(100 + victim.mov_speed_buff, 20), 200))
    victim.wuyang_buff[4] = false
    lbl_0:

rule "[Wuyang]: Tidal Blast Allies Target":
    @Event playerDealtHealing
    @Hero wuyang
    @Condition eventAbility == Button.ULTIMATE

    eventPlayer.startHealingOverTime(healee, 1.25, eventPlayer.getMaxHealth() * 0.5 / 1.25)
