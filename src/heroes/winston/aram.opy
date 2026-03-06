# winston aram-mode overlay

rule "[Winston]: Tesla Cannon Alt Fire":
    @Event playerTookDamage
    @Condition victim.unaffected != true
    @Condition attacker.getHero() == Hero.WINSTON
    @Condition (eventAbility == Button.SECONDARY_FIRE or eventAbility == null) == true
    
    wait(0.16)
    damage(victim, null, eventPlayer.getMaxHealth() * 0.1)
    wait(0.8)
