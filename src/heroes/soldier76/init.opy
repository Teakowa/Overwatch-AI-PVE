#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Soldier: 76]: Detect switch to Soldier 76":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero soldier

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Soldier: 76]: Initialize":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["国服顶尖小巴蒂", "跑男摩西", "奶棒摩西", "Kai了", "飞弹摩西"]))
    lbl_0:
    eventPlayer._reset_requested = false

