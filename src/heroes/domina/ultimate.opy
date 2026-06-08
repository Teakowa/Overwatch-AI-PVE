#!optimizeStrict

rule "[Domina]: Ultimate":
    @Event playerDealtDamage
    @Hero domina
    @Condition eventAbility == Button.ULTIMATE
    #@Condition eventAbility != Button.PRIMARY_FIRE
    #@Condition eventAbility != Button.ABILITY_1

    #waitUntil(victim.hasStatus(Status.KNOCKED_DOWN), 0.5)
    waitUntil(victim.getHealth().isAtMostPercentOf(20, victim.getMaxHealth()), 5)
    if victim.getHealth().isAtMostPercentOf(20, victim.getMaxHealth()):
        damage(victim, attacker, DOMINA_ULTIMATE_EXECUTE_DAMAGE)
    wait(1)
