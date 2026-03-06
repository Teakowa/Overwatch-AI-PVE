# genji aram-only dragonblade healing

rule "[Genji] Dragonblade Healing":
    @Event playerDealtDamage
    @Hero genji
    @Condition eventAbility == Button.ULTIMATE
    
    heal(eventPlayer, eventPlayer, eventDamage)
    damage(victim, attacker, eventPlayer.getMaxHealth() * 0.1)
    wait(0.16)
