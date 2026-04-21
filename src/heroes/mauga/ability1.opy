rule "[Mauga] Overrun knockdown duration":
    @Event playerDealtDamage
    @Hero mauga
    @Condition eventAbility == Button.ABILITY_1

    victim.setStatusEffect(attacker, Status.BURNING, 2)
    if not victim.hasStatus(Status.KNOCKED_DOWN):
        goto lbl_0
    victim.setStatusEffect(attacker, Status.KNOCKED_DOWN, 2)
    if victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT) or victim.has_nano:
        goto lbl_1
    damage(victim, attacker, ceil(victim.getMaxHealth() * MaugaBuff[3]))
    lbl_0:
    lbl_1:

rule "[Mauga]: Fortify provides 100 temporary armor":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer.isUsingAbility1() == true

    eventPlayer.unaffected = true
    waitUntil(not eventPlayer.isUsingAbility1(), 3)
    eventPlayer.unaffected = false
