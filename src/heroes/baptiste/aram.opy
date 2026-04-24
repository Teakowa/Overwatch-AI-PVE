#!optimizeStrict

# baptiste aram-only headshot damage

rule "[Baptiste]: headshot damage":
    @Event playerDealtDamage
    @Hero baptiste
    @Condition HeadshotDamage[4] > 1
    @Condition eventWasCriticalHit == true
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, ceil((eventDamage * (HeadshotDamage[4] - 2)) / 2))
# baptiste aram-only immortality field

rule "[Baptiste]: Immortality Field":
    @Event eachPlayer
    @Condition eventPlayer.hasStatus(Status.UNKILLABLE) == true
    @Condition eventPlayer.reset_pvar[12].getAbilityCooldown(Button.ABILITY_2) > 0

    #heal(eventPlayer, eventPlayer.reset_pvar[12], 50)
    eventPlayer.startHealingOverTime(eventPlayer.reset_pvar[12], 5, 50 if eventPlayer.getTeam() == Team.1 else 25)
    wait(8)
