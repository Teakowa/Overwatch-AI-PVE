#!mainFile "../../aramMain.opy"
#!optimizeStrict

playervar freja_buff
#!defineMember freja_mark_count      freja_buff[0]
#!defineMember freja_mark_snapshot   freja_buff[1]
#!defineMember freja_air_hud         freja_buff[2]
#!defineMember freja_target_mark_hud freja_buff[3]
#!defineMember freja_self_mark_hud   freja_buff[4]

rule "[Freja]: Revdraw Crossbow Stack":
    @Event playerDealtDamage
    @Hero freja
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition eventPlayer.hasStatus(Status.INVINCIBLE) != true

    victim.freja_mark_count++

rule "[Freja]: Revdraw Crossbow Stack":
    @Event playerReceivedKnockback
    @Condition attacker.getHero() == Hero.FREJA
    @Condition eventAbility == Button.ULTIMATE

    victim.freja_mark_count += 40
    wait(5)

rule "[Freja]: Take Aim Damage":
    @Event playerDealtDamage
    @Hero freja
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false
    @Condition victim.has_nano != true
    @Condition victim.freja_mark_count > 0

    wait(0.5, Wait.ABORT_WHEN_FALSE)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.BLUE, victim, 0.8)
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.BLUE, victim, 10)
    damage(victim, attacker, FrejaBuff[0] * victim.freja_mark_count + victim.getMaxHealth().scaledBy(FrejaBuff[1]))
    victim.freja_mark_count = 0
    victim.freja_mark_snapshot = 0

rule "[Freja]: HUD & Reset":
    @Event eachPlayer
    @Condition eventPlayer.freja_mark_count > 0

    if eventPlayer.freja_target_mark_hud != 0:
        goto lbl_0
    hudText(eventPlayer.reset_pvar[11], null, " \r\n", "  {0} 狩猎印记： {1}".format(heroIcon(eventPlayer.getHero()), eventPlayer.freja_mark_count), HudPosition.LEFT, 1, null, null, rgb(255, 255, 255, 200), HudReeval.STRING)
    eventPlayer.freja_target_mark_hud = getLastCreatedText()
    lbl_0:
    eventPlayer.freja_mark_snapshot = eventPlayer.freja_mark_count
    wait(15)
    if eventPlayer.freja_mark_count > eventPlayer.freja_mark_snapshot:
        loop()
    eventPlayer.freja_mark_count = 0
    eventPlayer.freja_mark_snapshot = 0
    destroyHudText(eventPlayer.freja_target_mark_hud)
    eventPlayer.freja_target_mark_hud = 0

rule "[Freja]: Ex":
    @Event playerDealtKnockback
    @Hero freja
    @Condition eventAbility == null
    @Condition victim.hasStatus(Status.INVINCIBLE) != true
    @Condition victim.zarya_buff[1] == null
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false
    @Condition victim.has_nano != true

    if not victim.isAlive() or victim.getHealth().isAbovePercentOf(FrejaBuff[2] * 100, victim.getMaxHealth()):
        goto lbl_0
    damage(victim, attacker, FREJA_ARAM_EXECUTE_DAMAGE)
    smallMessage(eventPlayer, "  斩杀： {0} ".format(heroIcon(victim.getHero())))
    wait(1, Wait.ABORT_WHEN_FALSE)
    lbl_0:

rule "[Freja]: Dmg. reduction":
    @Event eachPlayer
    @Hero freja
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isInAir() == true

    eventPlayer.setDamageReceived(FREJA_ARAM_DAMAGE_RECEIVED)
    hudText(eventPlayer, null, " \r\n", "受到伤害减免：{0}%".format(25), HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.freja_air_hud = getLastCreatedText()
    waitUntil(not eventPlayer.isInAir() and eventPlayer.isOnGround(), 99999)
    destroyHudText(eventPlayer.freja_air_hud)
    eventPlayer.freja_air_hud = 0
    eventPlayer.setDamageReceived(100)

rule "[Freja]: set Projectile speed":
    @Event eachPlayer
    @Hero freja
    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.setProjectileSpeed(100)
    waitUntil(not eventPlayer.isUsingUltimate(), 99999)
    eventPlayer.setProjectileSpeed(FREJA_ARAM_PROJECTILE_SPEED)
