#!mainFile "../../main.opy"
#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, A or "", "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "[Wuyang]: primary dmg":
    @Event playerDealtKnockback
    @Hero wuyang
    @Condition eventAbility == null
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.getAbilityCooldown(Button.ABILITY_2) - 1)
    damage(victim, attacker, victim.getMaxHealth().scaledBy(WUYANG_PRIMARY_HEALTH_SCALAR))
    wait(0.25)
