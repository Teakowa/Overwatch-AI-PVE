#!mainFile "../../main.opy"
#!optimizeStrict

rule "[bastion/init.opy]: Detect switch to Bastion":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero bastion

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[bastion/init.opy]: Initialize Bastion":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["电脑", "嘟嘟嘟嘟嘟", "大炮摩西", "无可奉告"]))
    lbl_0:
    eventPlayer._reset_requested = false
