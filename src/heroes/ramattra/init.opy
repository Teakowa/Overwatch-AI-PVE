#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Ramattra]: Detect switch to Ramattra":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero ramattra

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Ramattra] Initialize":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer._reset_requested != false

    resetHero()
    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["我 扛 不 住 辣", "鲑鱼大帝", "Suffer as i have!", "抱头摩西", "痛苦摩西"]))
    lbl_0:
    eventPlayer._reset_requested = false
