#!optimizeStrict

rule "[Wuyang]: Tidal Blast Allies Target":
    @Event playerDealtHealing
    @Hero wuyang
    @Condition eventAbility == Button.ULTIMATE

    heal(eventPlayer, healee, eventPlayer.getMaxHealth())

rule "[Wuyang]: ult dmg":
    @Event playerDealtKnockback
    @Hero wuyang
    @Condition eventAbility == Button.ULTIMATE
    
    damage(victim, attacker, victim.getMaxHealth() * 0.75)
