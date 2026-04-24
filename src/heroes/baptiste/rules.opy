#!optimizeStrict

rule "[Baptiste]: headshot damage":
    @Event playerDealtDamage
    @Hero baptiste
    @Condition HeadshotDamage[4] > 2
    @Condition eventWasCriticalHit == true
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, ceil((eventDamage * (HeadshotDamage[4] - 2)) / 2))

rule "[Baptiste]: Immortality Field":
    @Event eachPlayer
    @Condition eventPlayer.hasStatus(Status.UNKILLABLE) == true
    @Condition eventPlayer.reset_pvar[12].getAbilityCooldown(Button.ABILITY_2) > 0

    eventPlayer.setStatusEffect(eventPlayer.reset_pvar[12], Status.PHASED_OUT, 0.26)
    #heal(eventPlayer, eventPlayer.reset_pvar[12], 50)
    eventPlayer.startHealingOverTime(eventPlayer.reset_pvar[12], 5, 50 if eventPlayer.getTeam() == Team.1 else 25)
    wait(8)
