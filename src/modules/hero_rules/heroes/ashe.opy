rule "[Cassdy] ammo restored by kills":
    @Event playerDealtFinalBlow
    @Team 1
    @Hero cassidy
    @Condition isGameInProgress() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAmmo() < eventPlayer.getMaxAmmo()
    
    eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())


rule "[Ashe]: headshot damage":
    @Event playerDealtDamage
    @Hero ashe
    @Condition HeadshotDamage[1] > 2
    @Condition eventWasCriticalHit == true
    @Condition eventAbility != Button.ABILITY_1
    @Condition eventAbility != Button.ABILITY_2
    @Condition eventAbility != Button.ULTIMATE
    
    damage(victim, attacker, ceil((eventDamage * (HeadshotDamage[1] - 2)) / 2))


rule "[Zenyatta]: headshot damage":
    @Event playerDealtDamage
    @Hero zenyatta
    @Condition HeadshotDamage[0] > 2
    @Condition eventWasCriticalHit == true
    @Condition eventAbility != Button.ABILITY_1
    @Condition eventAbility != Button.ABILITY_2
    @Condition eventAbility != Button.ULTIMATE
    
    damage(victim, attacker, ceil((eventDamage * (HeadshotDamage[0] - 2)) / 2))


rule "[Baptiste]: headshot damage":
    @Event playerDealtDamage
    @Hero baptiste
    @Condition HeadshotDamage[4] > 2
    @Condition eventWasCriticalHit == true
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    damage(victim, attacker, ceil((eventDamage * (HeadshotDamage[4] - 2)) / 2))


rule "[Hanzo]: headshot damage":
    @Event playerDealtDamage
    @Hero hanzo
    @Condition HeadshotDamage[3] > 2
    @Condition eventWasCriticalHit == true
    
    damage(victim, attacker, ceil((eventDamage * (HeadshotDamage[3] - 2)) / 2))


rule "[Kiriko]: headshot damage":
    @Event playerDealtDamage
    @Hero kiriko
    @Condition HeadshotDamage[2] > 2
    @Condition eventWasCriticalHit == true
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    damage(victim, attacker, ceil((eventDamage * (HeadshotDamage[2] - 2)) / 2))


