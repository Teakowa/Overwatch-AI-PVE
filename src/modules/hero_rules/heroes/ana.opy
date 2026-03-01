rule "[Mercy]: Flash Heal cd":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.getAbilityCooldown(Button.RELOAD) != 0
    
    eventPlayer.setAbilityCooldown(Button.RELOAD, 2)


rule "[Ana]: Headhunter":
    @Event playerDealtDamage
    @Team 2
    @Hero ana
    @Condition eventWasCriticalHit == true
    @Disabled
    
    if eventPlayer.getNormalizedHealth() != 1:
        eventPlayer.startHealingOverTime(eventPlayer, 0.625, ceil(eventDamage * 31.25 * 0.75))
    else:
        ([player for player in getLivingPlayers(eventPlayer.getTeam()) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) == true and player != eventPlayer]).startHealingOverTime(eventPlayer, 0.625, ceil(eventDamage * 31.25 * Ana_GrenadeDamage[1]) / (len([player for player in getLivingPlayers(eventPlayer.getTeam()) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) == true and player != eventPlayer])))
    wait(0.625)


rule "[Ana] Biotic Grenade Hit":
    @Event playerTookDamage
    @Condition eventAbility == Button.ABILITY_2
    @Condition attacker.getHero() == Hero.ANA == true
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false
    @Condition victim.has_nano != true
    
    if victim.zarya_buff[1] != null:
        goto lbl_0
    eventPlayer.setStatusEffect(attacker, Status.BURNING, 3)
    eventPlayer.startDamageOverTime(attacker, 3, ceil(Ana_GrenadeDamage[0] / 100 * victim.getMaxHealth()))
    wait(3)
    lbl_0:


rule "[Ana]: Damage Full Health Allies So Nano Can Heal":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.getUltCharge() == 100
    
    waitUntil(eventPlayer.getUltCharge() == 0, 99999)
    eventPlayer.nano_full_health = [i for i in eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam()) if i.getHealth() >= i.getMaxHealth()]
    damage(eventPlayer.nano_full_health, null, 0.05)
    wait(0.216)
    heal(eventPlayer.nano_full_health, null, 0.05)
    eventPlayer.nano_full_health = null


rule "Has Nano":
    @Event playerReceivedHealing
    #This checks that the ability used to deal the healing is the ultimate.
    @Condition eventAbility == Button.ULTIMATE
    #This checks if the player who dealt the healing is Ana or an Echo duplicating an Ana.
    @Condition healer.getHero() == Hero.ANA
    
    eventPlayer.has_nano = true
    waitUntil(eventPlayer.isDead(), 8)
    eventPlayer.has_nano = false


rule "[Ana] Nano Boost Healing":
    @Event playerDealtHealing
    @Hero ana
    @Condition eventAbility == Button.ULTIMATE
    @Condition healer.getHero() == Hero.ANA == true
    
    heal(healee, healer, 99999)


rule "【布丽吉塔】盾击伤害调整":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition attacker.isFiringSecondaryFire() == true
    @Condition attacker.isUsingUltimate() != true
    
    victim.setStatusEffect(attacker, Status.STUNNED, 1.2)
    if victim.zarya_buff[1] != null:
        goto lbl_0
    victim.brigitte_buff[0] = true
    lbl_0:
    victim.mov_speed_penalty += Brigitte[3]


rule "[Brigitte]: speed":
    @Event eachPlayer
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.unaffected != true
    @Condition eventPlayer.brigitte_buff[0] == true
    
    eventPlayer.setMoveSpeed(100 - eventPlayer.mov_speed_penalty + eventPlayer.mov_speed_buff)
    waitUntil(not eventPlayer.brigitte_buff[0] or eventPlayer.mov_speed_penalty == 0 or eventPlayer.unaffected or eventPlayer.hasStatus(Status.INVINCIBLE), 1.5)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.brigitte_buff[0] = false
    eventPlayer.mov_speed_penalty = 0


rule "【布丽吉塔】恢复包选中目标":
    @Event eachPlayer
    @Hero brigitte
    @Condition Brigitte[1] != 0
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition distance(eventPlayer, eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam())) <= 27.25
    
    sorted(getLivingPlayers(eventPlayer.getTeam()), lambda player: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getPosition(), player.getPosition())))[0].brig_repair_pack = true


rule "【布丽吉塔】恢复包提供护甲":
    @Event eachPlayer
    @Condition Brigitte[1] != 0
    @Condition eventPlayer.getHero() != Hero.BRIGITTE
    @Condition (eventPlayer.isAlive() and eventPlayer.brig_repair_pack) == true
    
    eventPlayer.brig_repair_pack = false
    if eventPlayer.brig_repair_pack_id == null:
        goto lbl_0
    removeHealthPool(eventPlayer.brig_repair_pack_id)
    lbl_0:
    eventPlayer.addHealthPool(Health.ARMOR, Brigitte[1], false, false)
    smallMessage(eventPlayer, "  {0} 获得来自 {1} 的护甲".format(abilityIconString(Hero.BRIGITTE, Button.ABILITY_2), eventPlayer.reset_pvar[1].getHero()))
    eventPlayer.brig_repair_pack_id = getLastCreatedHealthPool()


