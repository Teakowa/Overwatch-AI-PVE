rule "[Juno]: Orbial Ray Damage":
    @Event eachPlayer
    @Condition eventPlayer.juno_buff[0] == true
    
    smallMessage(eventPlayer, "   {0} 轨道射线： 伤害减免 {1}%".format(abilityIconString(Hero.JUNO, Button.ULTIMATE), 100 - JunoBuff))
    eventPlayer.setDamageReceived(100 - JunoBuff)
    waitUntil(not eventPlayer.juno_buff[0], 10)
    eventPlayer.setDamageReceived(100)
    smallMessage(eventPlayer, "   {0} 轨道射线： 伤害减免已结束".format(abilityIconString(Hero.JUNO, Button.ULTIMATE)))
rule "[Juno]: Pulsar Torpedoes Healing":
    @Event playerReceivedHealing
    @Condition healer.getHero() == Hero.JUNO
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition eventPlayer.mauga_berserker_soul != true
    
    eventPlayer.healing_increase += 50
    eventPlayer.setHealingReceived(100 - eventPlayer.healing_decrease + eventPlayer.healing_increase)
    waitUntil(eventPlayer.isDead(), 4)
    eventPlayer.setHealingReceived(100)
    eventPlayer.healing_increase = 0
    wait(2.6)
rule "[Freja]: Revdraw Crossbow Stack":
    @Event playerDealtDamage
    @Hero freja
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition eventPlayer.hasStatus(Status.INVINCIBLE) != true
    
    victim.freja_buff[0]++
rule "[Freja]: Revdraw Crossbow Stack":
    @Event playerDealtKnockback
    @Hero freja
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventPlayer.hasStatus(Status.INVINCIBLE) != true
    
    victim.freja_buff[0] += 15
    wait(5)
rule "[Freja]: Take Aim Damage":
    @Event playerDealtDamage
    @Hero freja
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false
    @Condition victim.has_nano != true
    @Condition victim.freja_buff[0] > 0
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.BLUE, victim, 0.8)
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.BLUE, victim, 10)
    damage(victim, attacker, FrejaBuff[0] * victim.freja_buff[0])
    victim.freja_buff[0] = 0
    victim.freja_buff[1] = 0
rule "[Freja]: HUD & Reset":
    @Event eachPlayer
    @Condition eventPlayer.freja_buff[0] > 0
    
    if eventPlayer.freja_buff[3] != 0:
        goto lbl_0
    hudText(eventPlayer.reset_pvar[11], null, " \r\n\r\n\n", "  {0} 狩猎印记： {1}".format(heroIcon(eventPlayer.getHero()), eventPlayer.freja_buff[0]), HudPosition.LEFT, 1, null, null, rgb(255, 255, 255, 200), HudReeval.STRING)
    eventPlayer.freja_buff[3] = getLastCreatedText()
    lbl_0:
    if eventPlayer.freja_buff[4] != 0:
        goto lbl_1
    hudText(eventPlayer, null, " \r\n\r\n\n", " {0} 印记： {1}".format(heroIcon(Hero.FREJA), eventPlayer.freja_buff[0]), HudPosition.LEFT, 2, null, null, rgb(255, 255, 255, 200), HudReeval.STRING)
    eventPlayer.freja_buff[4] = getLastCreatedText()
    lbl_1:
    eventPlayer.freja_buff[1] = eventPlayer.freja_buff[0]
    wait(5)
    if eventPlayer.freja_buff[0] > eventPlayer.freja_buff[1]:
        loop()
    eventPlayer.freja_buff[0] = 0
    eventPlayer.freja_buff[1] = 0
    destroyHudText(eventPlayer.freja_buff[3])
    destroyHudText(eventPlayer.freja_buff[4])
    eventPlayer.freja_buff[3] = 0
    eventPlayer.freja_buff[4] = 0
rule "[Freja]: Ex":
    @Event playerDealtKnockback
    @Hero freja
    @Condition eventAbility == null
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT) or not victim.has_nano) == false
    #@Condition victim.freja_buff[0] > 0
    
    if not victim.isAlive() or victim.getHealth() > victim.getMaxHealth() * FrejaBuff[2]:
        goto lbl_0
    damage(victim, attacker, 44444)
    smallMessage(eventPlayer, "  斩杀： {0} ".format(heroIcon(victim.getHero())))
    wait(1, Wait.ABORT_WHEN_FALSE)
    lbl_0:
rule "[Freja]: Ammo":
    @Event playerEarnedElimination
    @Hero freja
    @Disabled
    
    eventPlayer.setAmmo(0, eventPlayer.getAmmo() + 1)
rule "[Freja]: Dmg. reduction":
    @Event eachPlayer
    @Hero freja
    @Condition eventPlayer.isUsingAbility2() == true
    #@Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) != 0
    @Condition eventPlayer.isInAir() == true
    
    if eventPlayer.getTeam() == Team.2:
        goto lbl_0
    eventPlayer.startHealingOverTime(null, 10, 30)
    eventPlayer.freja_buff[5] = getLastHealingOverTimeId()
    lbl_0:
    eventPlayer.setDamageReceived(75)
    hudText(eventPlayer, null, " \r\n", "受到伤害减免：{0}%".format(25), HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    #eventPlayer.hudText = "受到伤害减免：{0}%".format(25)
    eventPlayer.freja_buff[2] = getLastCreatedText()
    waitUntil(not eventPlayer.isInAir() and eventPlayer.isOnGround(), 99999)
    eventPlayer.hudText = ""
    destroyHudText(eventPlayer.freja_buff[2])
    eventPlayer.freja_buff[2] = 0
    eventPlayer.setDamageReceived(100)
    if eventPlayer.getTeam() == Team.2:
        goto lbl_1
    stopHealingOverTime(eventPlayer.freja_buff[5])
    eventPlayer.freja_buff[5] = null
    lbl_1:
rule "[Freja]: set Projectile speed":
    @Event eachPlayer
    @Hero freja
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setProjectileSpeed(100)
    waitUntil(not eventPlayer.isUsingUltimate(), 99999)
    eventPlayer.setProjectileSpeed(500)
