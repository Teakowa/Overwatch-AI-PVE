#!optimizeStrict

rule "[Domina]: Primary File":
    @Event playerDealtDamage
    @Hero domina
    @Condition eventAbility == null
    
    damage(victim, attacker, victim.getMaxHealth().scaledBy(DOMINA_RULES_HEALTH_SCALAR))
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) - 1)
    wait(1)


#!include "ultimate.opy"
