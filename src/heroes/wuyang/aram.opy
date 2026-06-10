#!mainFile "../../aramMain.opy"
#!optimizeStrict

#!include "primary.opy"
#!include "ability1.opy"
#!include "ability2.opy"
#!include "ultimate.opy"

rule "[Wuyang]: ult dmg":
    @Event playerDealtKnockback
    @Hero wuyang
    @Condition eventAbility == Button.ULTIMATE
    
    damage(victim, attacker, victim.maxHealthPercent(WUYANG_ARAM_MAX_HEALTH_PERCENT))
