#!optimizeStrict

rule "[Domina]: Ultimate":
    @Event playerDealtDamage
    @Hero domina
    @Condition eventAbility == Button.ULTIMATE
    #@Condition eventAbility != Button.PRIMARY_FIRE
    #@Condition eventAbility != Button.ABILITY_1

    #waitUntil(victim.hasStatus(Status.KNOCKED_DOWN), 0.5)
    waitUntil(victim.getHealth() <= victim.getMaxHealth() * 0.2, 5)
    if victim.getHealth() <= victim.getMaxHealth() * 0.2:
        damage(victim, attacker, 44444)
    wait(1)
