#!mainFile "../../aramMain.opy"
#!optimizeStrict

# bastion aram-only artillery

#!include "ability1.opy"

rule "[Bastion]: Configuration: Artillery":
    @Event playerDealtDamage
    @Hero bastion
    @Condition eventAbility == Button.ULTIMATE

    damage(victim, attacker, victim.getHealth().percentOf(BASTION_ARAM_HEALTH_SCALAR))
    wait(0.25)
