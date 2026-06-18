#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Orisa]: Detect switch to Orisa":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero orisa

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Orisa] Initialize":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer._reset_requested != false

    resetHero()
    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["命运羊驼", "美羊羊", "唯一真神", "标枪摩西", "小米Su7 Ultra"]))
    lbl_0:
    eventPlayer._reset_requested = false

