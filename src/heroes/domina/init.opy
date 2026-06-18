#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Domina/init.opy]: Detect switch to Domina":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero domina

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Domina/init.opy]: Initialize Domina":
    @Event eachPlayer
    @Hero domina
    @Condition eventPlayer._reset_requested != false

    resetHero()
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.DOMINA:
            eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +{1}%\r\n*受到伤害 -{2}%\r\n*屏障阵列 冷却时间降低至{3}秒\r\n*音速斥力场 冷却时间调整为{4}秒\r\n  命中击退目标造成{5}%减速{6}秒并击晕{7}秒\r\n*爆能水晶 命中敌人造成{5}%减速{6}秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), DOMINA_DAMAGE_DEALT_PERCENT - 100, 100 - DOMINA_PLAYER_DAMAGE_RECEIVED_PERCENT, DOMINA_BARRIER_ARRAY_COOLDOWN, DOMINA_SONIC_REPULSORS_COOLDOWN, DOMINA_SLOW_PERCENT, DOMINA_SLOW_DURATION, DOMINA_SONIC_STUN_DURATION)
