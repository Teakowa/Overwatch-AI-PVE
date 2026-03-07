#!include "tidal-blast-allies-target-shared.opy"
#!include "tidal-blast-allies-healing-shared.opy"

rule "[Wuyang]: Tidal Blast mov_speed_penalty":
    @Event playerDealtKnockback
    @Hero wuyang
    @Condition eventAbility == Button.ULTIMATE

    victim.mov_speed_penalty += WuyangBuff[4]
    victim.setMoveSpeed(100 + victim.mov_speed_buff - victim.mov_speed_penalty)
    waitUntil(victim.mov_speed_penalty == 0 or victim.unaffected or victim.hasStatus(Status.INVINCIBLE), 3)
    victim.setMoveSpeed(100)
    victim.mov_speed_penalty -= WuyangBuff[4]
