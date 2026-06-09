#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Baptiste]: headshot damage":
    @Event playerDealtDamage
    @Hero baptiste
    @Condition BaptisteBuff[0] > 0
    @Condition eventWasCriticalHit == true
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, BaptisteBuff[0])

rule "[Baptiste]: Immortality Field":
    @Event eachPlayer
    @Condition eventPlayer.hasStatus(Status.UNKILLABLE) == true
    @Condition eventPlayer.reset_pvar[12].getAbilityCooldown(Button.ABILITY_2) > 0

    eventPlayer.setStatusEffect(eventPlayer.reset_pvar[12], Status.PHASED_OUT, BAPTISTE_RULES_PHASED_OUT_DURATION)
    #heal(eventPlayer, eventPlayer.reset_pvar[12], BAPTISTE_RULES_HEAL)
    heal(eventPlayer, eventPlayer.reset_pvar[12], BAPTISTE_RULES_HEAL_MAIN if eventPlayer.getTeam() == Team.1 else BAPTISTE_RULES_HEAL_ALT)
    wait(8)
