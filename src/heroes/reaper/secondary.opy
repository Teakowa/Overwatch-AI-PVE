#!optimizeStrict

rule "[Reaper]: Ability Dire Triggers dot":
    @Event playerDealtDamage
    @Hero reaper
    @Condition eventAbility == Button.SECONDARY_FIRE

    #wait(WAIT_SHORT_FRAME)
    damage(victim, attacker, victim.getMaxHealth() * 0.1 + eventPlayer.reaper_buff[0] * ReaperBuff[7])
    #victim.reaper_buff = getLastDamageOverTimeId()
    wait(1)
    #victim.reaper_buff = 0