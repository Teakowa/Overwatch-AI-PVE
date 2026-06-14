#!mainFile "../../main.opy"
#!optimizeStrict

rule "[reaper/init.opy]: Detect switch to Reaper":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero reaper

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[reaper/init.opy]: Initialize Reaper":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["滚筒洗衣机", "转圈摩西", "龙卷风摩西", "哈哈摩西", "菜就多练"]))
    lbl_0:
    eventPlayer._reset_requested = false
