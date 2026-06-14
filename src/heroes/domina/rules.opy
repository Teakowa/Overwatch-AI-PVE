#!mainFile "../../aramMain.opy"
#!optimizeStrict

rule "[Domina]: Primary File":
    @Event playerDealtDamage
    @Hero domina
    @Condition eventAbility == null
    
    damage(victim, attacker, victim.maxHealthPercent(DominaBuff[0]))
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) - 1)
    wait(1)


#!include "ultimate.opy"
