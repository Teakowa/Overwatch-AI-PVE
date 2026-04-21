# illari aram-only captive sun suite

rule "[Illari]: Captive Sun HUD":

    @Event eachPlayer

    @Hero illari

    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.hudText = "最大生命值伤害：{0}%".format(((len([player for player in getLivingPlayers(eventPlayer.getTeam()) if isInLoS(eventPlayer, player) and distance(eventPlayer, player) <= 10 and player != eventPlayer])) * IllariBuff) * 100)

    #hudText(eventPlayer, null, "\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r", "最大生命值伤害：{0}%".format((len([player for player in getLivingPlayers(eventPlayer.getTeam()) if isInLoS(eventPlayer, player) and distance(eventPlayer, player) <= 10 and player != eventPlayer])) * IllariBuff), HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)

    #eventPlayer.heart_steel[4] = getLastCreatedText()

    waitUntil(not eventPlayer.isUsingUltimate(), 8)

    wait(0.98)

    destroyEffect(eventPlayer.heart_steel[3])

    #destroyHudText(eventPlayer.heart_steel[4])

    eventPlayer.hudText = ""

    eventPlayer.heart_steel[3] = 0

    eventPlayer.heart_steel[4] = 0

rule "[Illari] Captive Sun":

    @Event playerDealtDamage

    @Hero illari

    @Condition eventAbility == Button.ULTIMATE

    @Condition eventDamage > 5

    damage(victim, attacker, IllariBuff / 100 * len(getPlayersInRadius(eventPlayer, 10, eventPlayer.getTeam(), LosCheck.SURFACES)) * victim.getMaxHealth())
