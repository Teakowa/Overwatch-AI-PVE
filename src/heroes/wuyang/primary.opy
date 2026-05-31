#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, A or "", "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "[Wuyang]: primary dmg":
    @Event playerDealtKnockback
    @Hero wuyang
    @Condition eventAbility == null
    
    damage(victim, attacker, victim.getMaxHealth() * 0.08)
    wait(0.25)
