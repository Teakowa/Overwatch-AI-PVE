#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Illari]: Captive Sun HUD":
    @Event eachPlayer
    @Hero illari
    @Condition eventPlayer.isUsingUltimate() == true

    createEffect(eventPlayer, Effect.RING, rgb(254, 180, 21), eventPlayer, 10, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.illari_captive_hud[0] = getLastCreatedEntity()
    eventPlayer.illari_captive_hud[2] = len(getPlayersInRadius(eventPlayer, ILLARI_ULTIMATE_HUD_RADIUS, eventPlayer.getTeam(), LosCheck.SURFACES).exclude(eventPlayer))
    eventPlayer.hudText = "最大生命值伤害：{0}%".format(eventPlayer.illari_captive_hud[2] * IllariBuff)
    waitUntil(not eventPlayer.isUsingUltimate(), 8)
    wait(0.98)
    destroyEffect(eventPlayer.illari_captive_hud[0])
    eventPlayer.hudText = ""
    eventPlayer.illari_captive_hud[0] = 0
    eventPlayer.illari_captive_hud[1] = 0

rule "[Illari] Captive Sun":
    @Event playerDealtDamage
    @Hero illari
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventDamage > 5

    eventPlayer.illari_captive_hud[2] = len(getPlayersInRadius(eventPlayer, ILLARI_ULTIMATE_DAMAGE_RADIUS, eventPlayer.getTeam(), LosCheck.SURFACES).exclude(eventPlayer))
    damage(victim, attacker, victim.maxHealthPercent(eventPlayer.illari_captive_hud[2] * IllariBuff))


