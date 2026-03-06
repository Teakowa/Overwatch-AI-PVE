rule "[Freja]: Ex":
    @Event playerDealtKnockback
    @Hero freja
    @Condition eventAbility == null
    @Condition victim.hasStatus(Status.INVINCIBLE) != true
    @Condition victim.zarya_buff[1] == null
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false
    @Condition victim.has_nano != true

    if not victim.isAlive() or victim.getHealth() > victim.getMaxHealth() * FrejaBuff[2]:
        goto lbl_0
    damage(victim, attacker, 44444)
    smallMessage(eventPlayer, "  斩杀： {0} ".format(heroIcon(victim.getHero())))
    wait(1, Wait.ABORT_WHEN_FALSE)
    lbl_0:

rule "[Freja]: Dmg. reduction":
    @Event eachPlayer
    @Hero freja
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isInAir() == true

    eventPlayer.setDamageReceived(75)
    hudText(eventPlayer, null, " \r\n", "受到伤害减免：{0}%".format(25), HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.freja_buff[2] = getLastCreatedText()
    waitUntil(not eventPlayer.isInAir() and eventPlayer.isOnGround(), 99999)
    destroyHudText(eventPlayer.freja_buff[2])
    eventPlayer.freja_buff[2] = 0
    eventPlayer.setDamageReceived(100)
