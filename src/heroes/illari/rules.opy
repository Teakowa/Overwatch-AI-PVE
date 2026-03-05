rule "[Illari]: Captive Sun HUD":
    @Event eachPlayer
    @Hero illari
    @Condition eventPlayer.isUsingUltimate() == true
    
    createEffect(eventPlayer, Effect.RING, rgb(254, 180, 21), eventPlayer, 10, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.illari_captive_hud[0] = getLastCreatedEntity()
    eventPlayer.hudText = "最大生命值伤害：{0}%".format(((len([player for player in getLivingPlayers(eventPlayer.getTeam()) if isInLoS(eventPlayer, player) and distance(eventPlayer, player) <= 10 and player != eventPlayer])) * IllariBuff) * 100)
    #hudText(eventPlayer, null, "\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r", "最大生命值伤害：{0}%".format(((len([player for player in getLivingPlayers(eventPlayer.getTeam()) if isInLoS(eventPlayer, player) and distance(eventPlayer, player) <= 10 and player != eventPlayer])) * IllariBuff) * 100), HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    #eventPlayer.illari_captive_hud[1] = getLastCreatedText()
    waitUntil(not eventPlayer.isUsingUltimate(), 8)
    wait(0.98)
    destroyEffect(eventPlayer.illari_captive_hud[0])
    #destroyHudText(eventPlayer.illari_captive_hud[1])
    eventPlayer.hudText = ""
    eventPlayer.illari_captive_hud[0] = 0
    eventPlayer.illari_captive_hud[1] = 0
rule "[Illari] Captive Sun":
    @Event playerDealtDamage
    @Hero illari
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventDamage > 5
    
    damage(victim, attacker, (IllariBuff * (len([player for player in getLivingPlayers(eventPlayer.getTeam()) if isInLoS(eventPlayer, player) and distance(eventPlayer, player) <= 10 and player != eventPlayer]))) * victim.getMaxHealth())
