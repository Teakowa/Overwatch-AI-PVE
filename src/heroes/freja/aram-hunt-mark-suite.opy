rule "[Freja]: Revdraw Crossbow Stack":
    @Event playerReceivedKnockback
    @Condition attacker.getHero() == Hero.FREJA
    @Condition eventAbility == Button.ULTIMATE

    victim.freja_buff[0] += 40
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
    damage(victim, attacker, FrejaBuff[0] * victim.freja_buff[0] + victim.getMaxHealth() * FrejaBuff[1])
    victim.freja_buff[0] = 0
    victim.freja_buff[1] = 0

rule "[Freja]: HUD & Reset":
    @Event eachPlayer
    @Condition eventPlayer.freja_buff[0] > 0

    if eventPlayer.freja_buff[3] != 0:
        goto lbl_0
    hudText(eventPlayer.reset_pvar[11], null, " \r\n", "  {0} 狩猎印记： {1}".format(heroIcon(eventPlayer.getHero()), eventPlayer.freja_buff[0]), HudPosition.LEFT, 1, null, null, rgb(255, 255, 255, 200), HudReeval.STRING)
    eventPlayer.freja_buff[3] = getLastCreatedText()
    lbl_0:
    eventPlayer.freja_buff[1] = eventPlayer.freja_buff[0]
    wait(15)
    if eventPlayer.freja_buff[0] > eventPlayer.freja_buff[1]:
        loop()
    eventPlayer.freja_buff[0] = 0
    eventPlayer.freja_buff[1] = 0
    destroyHudText(eventPlayer.freja_buff[3])
    eventPlayer.freja_buff[3] = 0
