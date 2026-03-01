rule "[Tracer] Instant Respawn":
    @Event playerDied
    @Hero tracer
    
    wait(WAIT_SHORT_FRAME)
    eventPlayer.respawn()
    eventPlayer.setAbilityCharge(Button.ABILITY_1, 3)


rule "[Ramattra]: Pummel Knockback":
    @Event playerDealtDamage
    @Hero ramattra
    @Condition eventAbility == Button.ABILITY_1
    
    victim.applyImpulse(directionFromAngles(horizontalAngleOfDirection(victim.getPosition() - attacker.getPosition()), -20), 5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    victim.applyImpulse(Vector.UP, 2.5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    victim.setEnvironmentalKillCreditor(attacker)
    wait(0.5)


rule "[Ramattra] ult speed":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.mov_speed_buff += Ram_Annihilation[3]
    eventPlayer.setDamageDealt(100 + Ram_Annihilation[5])
    eventPlayer.setDamageReceived(100 - Ram_Annihilation[4])
    eventPlayer.setMoveSpeed(100 - eventPlayer.mov_speed_penalty + eventPlayer.mov_speed_buff)
    eventPlayer.setKnockbackReceived(30)
    waitUntil(not eventPlayer.isUsingUltimate(), WAIT_TIMEOUT_FOREVER)
    eventPlayer.mov_speed_buff = 0
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setDamageReceived(100)
    eventPlayer.setKnockbackReceived(100)
    eventPlayer.setDamageDealt(100)
    wait(WAIT_SHORT_FRAME)
    #removeTankPassive()


rule "[Ramattra] ult start":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) <= eventPlayer.custom_hp_pvar[0] + 50
    
    eventPlayer.ram_block_damage += 50
    eventPlayer.hudText = "{0}/{1}".format(floor(eventPlayer.ram_block_damage), Ram_Annihilation[0])
    wait(1.16)
    if ruleCondition:
        loop()


rule "[Ramattra] ult healing":
    @Event playerDealtDamage
    @Hero ramattra
    #@Condition attacker.getHero() == Hero.RAMATTRA == true
    @Condition attacker.isUsingUltimate() == true
    @Condition attacker.getHealth() < attacker.getMaxHealth()
    #@Condition eventAbility == Button.PRIMARY_FIRE == true
    
    #heal(eventPlayer, eventPlayer, Ram_Annihilation[2] * 15 * len(getPlayersInRadius(eventPlayer, 13, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES_AND_ENEMY_BARRIERS)))
    #wait(0.5)
    #playEffect(eventPlayer, DynamicEffect.GOOD_PICKUP_EFFECT, Color.YELLOW, eventPlayer, 200)
    heal(attacker, attacker, eventDamage * Ram_Annihilation[1])
    wait(0.0016)


rule "[Ramattra]: Pummel healing":
    @Event playerDealtDamage
    @Team 1
    @Hero ramattra
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventAbility == Button.ABILITY_1
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) <= eventPlayer.custom_hp_pvar[0] + 50
    
    eventPlayer.ram_block_damage += eventDamage * 2.5
    wait(0.3)


rule "[Ramattra]: Pummel healing":
    @Event playerDealtDamage
    @Team 2
    @Hero ramattra
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventAbility == Button.ABILITY_1
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) <= eventPlayer.custom_hp_pvar[0] + 50
    
    eventPlayer.ram_block_damage += eventDamage * 1.5
    eventPlayer.hudText = "{0}/{1}".format(floor(eventPlayer.ram_block_damage), Ram_Annihilation[0])
    wait(0.3)


rule "[Ramattra]: Pain endures":
    @Event playerDealtFinalBlow
    @Hero ramattra
    @Condition eventPlayer.getUltCharge() != 100
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition (eventAbility == Button.ULTIMATE or eventAbility == Button.ABILITY_1) == true
    
    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 25)
    wait(0.3)


rule "[Wrecking Ball] Grappling Claw cd reset":
    @Event eachPlayer
    @Hero wreckingBall
    @Condition eventPlayer.isInSpawnRoom() == true
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) != 0
    
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0)


rule "[Tracer] Pulse Bomb Damage":
    @Event playerDealtDamage
    @Hero tracer
    #@Condition attacker.getHero() == Hero.TRACER == true
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventDamage > 10
    
    damage(victim, attacker, ceil(eventDamage))


rule "[Sombra]: Apply OW1 hack on top of OW2 hack":
    @Event eachPlayer
    @Condition eventPlayer.hasStatus(Status.HACKED) == true
    @Condition eventPlayer.vendetta_hud != true
    
    stopChasingVariable(eventPlayer.hack_timer)
    eventPlayer.setStatusEffect(eventPlayer.reset_pvar[6], Status.HACKED, 4 if eventPlayer.getTeam() == Team.1 else 6)
    eventPlayer.hack_timer = 4 if eventPlayer.getTeam() == Team.1 else 6
    chaseAtRate(eventPlayer.hack_timer, 0, 1, ChaseRateReeval.NONE)


rule "[Sombra]: hack healing received":
    @Event eachPlayer
    @Condition eventPlayer.hasStatus(Status.HACKED) == true
    @Condition eventPlayer.mauga_berserker_soul != true
    
    eventPlayer.healing_decrease += SombraBuff[0]
    eventPlayer.setHealingReceived(100 - eventPlayer.healing_decrease + eventPlayer.healing_increase)
    #eventPlayer.sombra_buff = getLastCreatedEntity()
    waitUntil(not eventPlayer.hasStatus(Status.HACKED), 4 if eventPlayer.getTeam() == Team.1 else 6)
    eventPlayer.setHealingReceived(100)
    #destroyEffect(eventPlayer.sombra_buff)
    #eventPlayer.sombra_buff = null
    eventPlayer.healing_decrease = 0


rule "[Sombra]: kiil reset cooldown":
    @Event playerEarnedElimination
    @Hero sombra
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
    wait(0.5)


rule "[Tracer] Kill Heal":
    @Event playerEarnedElimination
    @Hero tracer
    @Condition Tracer_Ability[1] == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getHealth() < eventPlayer.getMaxHealth() == true
    
    heal(eventPlayer, null, 99999)


rule "[Tracer]: kiil reset cooldown":
    @Event playerEarnedElimination
    @Hero tracer
    @Condition Tracer_Ability[0] == true
    @Condition eventPlayer.isAlive() == true
    @Condition (eventPlayer.getAbilityCharge(Button.ABILITY_1) < 3 or eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0) == true
    
    eventPlayer.setAbilityCharge(Button.ABILITY_1, 3)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)


