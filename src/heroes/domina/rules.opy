#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Domina]: Primary File":
    @Event playerDealtDamage
    @Hero domina
    @Condition eventAbility == null
    
    damage(victim, attacker, victim.maxHealthPercent(DOMINA_RULES_MAX_HEALTH_PERCENT))
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) - 1)
    wait(1)


#!include "ultimate.opy"
