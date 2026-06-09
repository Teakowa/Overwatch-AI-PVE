#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Domina]: Ultimate":
    @Event playerDealtDamage
    @Hero domina
    @Condition eventAbility == Button.ULTIMATE
    #@Condition eventAbility != Button.PRIMARY_FIRE
    #@Condition eventAbility != Button.ABILITY_1

    #waitUntil(victim.hasStatus(Status.KNOCKED_DOWN), 0.5)
    waitUntil(victim.healthAtMostPercent(20), 5)
    if victim.healthAtMostPercent(20):
        damage(victim, attacker, DOMINA_ULTIMATE_EXECUTE_DAMAGE)
    wait(1)
