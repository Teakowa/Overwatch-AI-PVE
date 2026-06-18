#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Cassidy]: Detect switch to Cassidy":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero cassidy

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Cassidy]: Initialize Cassidy":
    @Event eachPlayer
    @Hero cassidy
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["张三", "天王老子", "KAI了", "麦克雷", "六连摩西"]))
    lbl_0:
    if eventPlayer.getTeam() == Team.2:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +25%\r\n*受到伤害 -8%\r\n{1}维和者\r\n  换弹速度降低至0.75秒\r\n  连射伤害提高{2}%\r\n{3}闪光弹 击晕敌人\r\n*神射手 充能速度降低16%\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.PRIMARY_FIRE), CASSIDY_SECONDARY_DAMAGE_DEALT, abilityIconString(eventPlayer.getHero(), Button.ABILITY_2))
    eventPlayer._reset_requested = false
