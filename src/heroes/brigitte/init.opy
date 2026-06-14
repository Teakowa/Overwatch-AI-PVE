#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Brigitte]: Detect switch to Brigitte":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero brigitte

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Brigitte] Initialize":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["那个女人", "炖鸡摩西", "持盾摩西", "贴膜摩西", "护 娜 十 三 锤", "泰格"]))
    lbl_0:
    getPlayers(eventPlayer.getTeam()).reset_pvar[1] = eventPlayer
    eventPlayer._reset_requested = false
