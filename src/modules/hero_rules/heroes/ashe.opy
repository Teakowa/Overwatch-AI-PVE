rule "[Ash] ammo restored by kills":
    @Event playerDealtFinalBlow
    @Team 2
    @Hero ashe
    @Condition isGameInProgress() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAmmo() < eventPlayer.getMaxAmmo()
    
    eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())
rule "[Ash] ammo add by Coach Gun":
    @Event eachPlayer
    @Team 2
    @Hero ashe
    @Condition eventPlayer.isUsingAbility1() == true
    
    waitUntil(not eventPlayer.isUsingAbility1(), 0.55)
    eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo() if eventPlayer.getAmmo() + 5 > eventPlayer.getMaxAmmo() else eventPlayer.getAmmo() + 5)
rule "[Ashe]: headshot damage":
    @Event playerDealtDamage
    @Hero ashe
    @Condition HeadshotDamage[1] > 2
    @Condition eventWasCriticalHit == true
    @Condition eventAbility != Button.ABILITY_1
    @Condition eventAbility != Button.ABILITY_2
    @Condition eventAbility != Button.ULTIMATE
    
    damage(victim, attacker, ceil((eventDamage * (HeadshotDamage[1] - 2)) / 2))
