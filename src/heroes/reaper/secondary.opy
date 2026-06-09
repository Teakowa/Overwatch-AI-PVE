#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Reaper]: Ability Dire Triggers":
    @Event eachPlayer
    @Hero reaper
    #@Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) > 1.5
    @Condition eventPlayer.isFiringSecondaryFire() == true

    waitUntil(not eventPlayer.isFiringSecondaryFire(), 0.6)
    eventPlayer.setAmmo(0, eventPlayer.getAmmo() + 1)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, ReaperBuff[6])

rule "[Reaper]: Ability Dire Triggers dot":
    @Event playerDealtDamage
    @Hero reaper
    @Condition eventAbility == Button.SECONDARY_FIRE

    #wait(WAIT_SHORT_FRAME)
    damage(victim, attacker, victim.maxHealthPercent(10) + eventPlayer.reaper_soul_count * ReaperBuff[7])
    #victim.reaper_buff = getLastDamageOverTimeId()
    wait(1)
    #victim.reaper_buff = 0
