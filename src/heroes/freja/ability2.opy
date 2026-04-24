#!optimizeStrict

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
    eventPlayer.setDamageReceived(75)
    hudText(eventPlayer, null, " \r\n", "受到伤害减免：{0}%".format(25), HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    #eventPlayer.hudText = "受到伤害减免：{0}%".format(25)
    eventPlayer.freja_buff[2] = getLastCreatedText()
    lbl_0:
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
