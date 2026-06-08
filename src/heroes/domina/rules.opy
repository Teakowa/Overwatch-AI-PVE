#!optimizeStrict

rule "[Domina]: Primary File":
    @Event playerDealtDamage
    @Hero domina
    @Condition eventAbility == null
    
    damage(victim, attacker, victim.getMaxHealth() * DOMINA_RULES_LINE_8_HEALTH_SCALAR)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) - 1)
    wait(1)


#!include "ultimate.opy"
