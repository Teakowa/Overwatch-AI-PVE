#!mainFile "../../aramMain.opy"
#!optimizeStrict

# illari aram-only captive sun suite

rule "[Illari]: Captive Sun HUD":
    @Event eachPlayer
    @Hero illari
    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.heart_steel[5] = len(getPlayersInRadius(eventPlayer, ILLARI_ARAM_HUD_RADIUS, eventPlayer.getTeam(), LosCheck.SURFACES).exclude(eventPlayer))
    eventPlayer.hudText = "最大生命值伤害：{0}%".format(eventPlayer.heart_steel[5] * IllariBuff)
    waitUntil(not eventPlayer.isUsingUltimate(), 8)
    wait(0.98)
    destroyEffect(eventPlayer.heart_steel[3])
    eventPlayer.hudText = ""
    eventPlayer.heart_steel[3] = 0
    eventPlayer.heart_steel[4] = 0

rule "[Illari] Captive Sun":
    @Event playerDealtDamage
    @Hero illari
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventDamage > 5

    eventPlayer.heart_steel[5] = len(getPlayersInRadius(eventPlayer, ILLARI_ARAM_DAMAGE_RADIUS, eventPlayer.getTeam(), LosCheck.SURFACES).exclude(eventPlayer))
    damage(victim, attacker, victim.maxHealthPercent(eventPlayer.heart_steel[5] * IllariBuff))


