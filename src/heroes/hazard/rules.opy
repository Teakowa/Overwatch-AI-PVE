#!optimizeStrict

#!mainFile "../../main.opy"

playervar hazard_hp_id

#!include "ability1.opy"

rule "[Hazard]: Spike Guard cd":
    @Event playerDealtDamage
    @Hero hazard
    @Condition attacker.getHero() == Hero.HAZARD
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition HazardBuff[0] != 0

    damage(victim, attacker, HazardBuff[0] * eventDamage - eventDamage)

rule "[Hazard]: Spike Guard get Ultimate and heal":
    @Event playerTookDamage
    @Hero hazard
    @Condition eventPlayer.hazard_using_ability_sec == true

    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + (HazardBuff[1] if eventPlayer.getTeam() == Team.2 else HazardBuff[1] * 1.15))
    heal(eventPlayer, eventPlayer, eventDamage / 0.35 * (HazardBuff[2] if eventPlayer.getTeam() == Team.2 else 0.5))
    wait(max(0.5, getAverageServerLoad() / 100))

rule "[Hazard]: Spike Guard using tracking":
    @Event eachPlayer
    @Hero hazard
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true

    eventPlayer.hazard_using_ability_sec = true
    waitUntil(not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), 12)
    eventPlayer.hazard_using_ability_sec = false
#!include "ultimate.opy"
