#!optimizeStrict

#!include "primary.opy"
#!include "ability1.opy"
#!include "ability2.opy"
#!include "ultimate.opy"

rule "[Wuyang]: ult dmg":
    @Event playerDealtKnockback
    @Hero wuyang
    @Condition eventAbility == Button.ULTIMATE
    
    damage(victim, attacker, victim.getMaxHealth() * WUYANG_ARAM_LINE_13_HEALTH_SCALAR)