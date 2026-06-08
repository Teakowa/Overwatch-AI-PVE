#!optimizeStrict

rule "[Vendetta]: Sundering Blade":
    @Event playerDealtKnockback
    @Hero vendetta
    @Condition eventAbility == Button.ULTIMATE
    #@Condition eventAbility != Button.PRIMARY_FIRE
    #@Condition eventAbility != Button.ABILITY_1

    victim.setStatusEffect(attacker, Status.KNOCKED_DOWN, VendettaBuff[4])
    #waitUntil(victim.hasStatus(Status.KNOCKED_DOWN), 0.5)
    waitUntil(victim.getHealth().isAtMostPercentOf(VendettaBuff[5] * 100, victim.getMaxHealth()), VendettaBuff[4])
    if victim.getHealth().isAtMostPercentOf(VendettaBuff[5] * 100, victim.getMaxHealth()):
        damage(victim, attacker, VENDETTA_ULTIMATE_EXECUTE_DAMAGE)
    wait(1)
