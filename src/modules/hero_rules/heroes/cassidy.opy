rule "[Venture] Burrow speed and healing":
    @Event eachPlayer
    @Hero venture
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.mov_speed_buff = 56
    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff)
    waitUntil(not eventPlayer.isUsingAbility1(), 99999)
    eventPlayer.mov_speed_buff = 0
    eventPlayer.setMoveSpeed(100)


rule "[Cassdy] Flashbang stun":
    @Event playerDealtDamage
    @Hero cassidy
    @Condition eventAbility == Button.ABILITY_2
    
    victim.setStatusEffect(attacker, Status.STUNNED, 0.8)


rule "[Cassdy] Peacekeeper Alt Fire":
    @Event eachPlayer
    @Hero cassidy
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    eventPlayer.setDamageDealt(135)
    waitUntil(not eventPlayer.isFiringSecondaryFire(), 0.75)
    eventPlayer.setDamageDealt(100)


rule "[Cassdy] Peacekeeper Alt Fire Reload":
    @Event eachPlayer
    @Hero cassidy
    @Condition eventPlayer.getAmmo() == 0
    
    wait(0.75, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())


rule "[Sojourn] Overclock Buff":
    @Event eachPlayer
    @Hero sojourn
    @Condition eventPlayer.isUsingUltimate() == true
    
    SojournBuff[0] = 0.2
    SojournBuff[3] = 30
    waitUntil(not eventPlayer.isUsingUltimate(), 10)
    SojournBuff[0] = 0.15
    SojournBuff[3] = 15


rule "[Sojourn] Execution players less 10% HP expectancy":
    @Event playerDealtDamage
    @Hero sojourn
    @Condition SojournBuff[0] != 0
    @Condition (eventAbility == Button.SECONDARY_FIRE or eventAbility == Button.ULTIMATE) == true
    @Condition victim.zarya_buff[1] == null
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false
    @Condition victim.has_nano != true
    @Condition victim.getHealth() <= SojournBuff[0] * victim.getMaxHealth()
    
    damage(victim, attacker, SojournBuff[1])
    wait(0.2)


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


