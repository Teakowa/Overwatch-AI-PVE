#!optimizeStrict

# winston aram-only tesla alt fire

rule "[Winston]: Tesla Cannon Alt Fire":
    @Event playerDealtDamage
    @Hero winston
    @Condition eventAbility == Button.SECONDARY_FIRE

    damage(victim, attacker, victim.getMaxHealth().scaledBy(WINSTON_ARAM_HEALTH_SCALAR))
