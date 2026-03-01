rule "[Baptiste]: Immortality Field":
    @Event eachPlayer
    @Condition eventPlayer.hasStatus(Status.UNKILLABLE) == true
    @Condition eventPlayer.reset_pvar[12].getAbilityCooldown(Button.ABILITY_2) > 0
    
    eventPlayer.setStatusEffect(eventPlayer.reset_pvar[12], Status.PHASED_OUT, 0.26)
    #heal(eventPlayer, eventPlayer.reset_pvar[12], 50)
    eventPlayer.startHealingOverTime(eventPlayer.reset_pvar[12], 5, 50 if eventPlayer.getTeam() == Team.1 else 25)
    wait(8)


rule "[Mauga] Overrun knockdown duration":
    @Event playerDealtDamage
    @Hero mauga
    @Condition eventAbility == Button.ABILITY_1
    
    victim.setStatusEffect(attacker, Status.BURNING, 2)
    if not victim.hasStatus(Status.KNOCKED_DOWN):
        goto lbl_0
    victim.setStatusEffect(attacker, Status.KNOCKED_DOWN, 2)
    if victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT) or victim.has_nano:
        goto lbl_1
    damage(victim, attacker, ceil(victim.getMaxHealth() * MaugaBuff[3]))
    lbl_0:
    lbl_1:


rule "[Orisa]Fortify ricochet damage":
    @Event playerTookDamage
    @Hero orisa
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate()) == true
    @Condition eventPlayer.hasStatus(Status.HACKED) != true
    
    damage(attacker, eventPlayer, Orisa_Fortify[1] / 100 * eventDamage)


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


