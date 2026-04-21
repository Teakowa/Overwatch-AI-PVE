rule "[Junkrat]: Steel Trap bleed":
    @Event playerDealtDamage
    @Hero junkrat
    @Condition eventAbility == Button.ABILITY_2

    victim.startDamageOverTime(attacker, 9999, 10)
    eventPlayer.junkrat_buff = getLastDamageOverTimeId()

rule "[Junkrat]: Steel Trap bleed":
    @Event playerReceivedHealing
    @Condition eventPlayer.junkrat_buff != null
    @Condition eventPlayer.isAlive() == true

    stopDamageOverTime(eventPlayer.junkrat_buff)
    eventPlayer.junkrat_buff = null
# junkrat aram-only arsonist

rule "[Junkrat]: arsonist":
    @Event playerDealtDamage
    @Hero junkrat
    #@Condition victim.hasStatus(Status.BURNING) == false
    @Condition eventAbility != Button.MELEE

    victim.setStatusEffect(attacker, Status.BURNING, 3)
    if victim.hasStatus(Status.BURNING) != true:
        goto lbl_0
    damage(victim, attacker, victim.getHealth() * 0.1)
    lbl_0:
    wait(1)
