#!mainFile "../../main.opy"
#!optimizeStrict

playervar reaper_buff
#!defineMember reaper_soul_count reaper_buff[0]
#!defineMember reaper_effect_hud reaper_buff[1]
#!defineMember reaper_soul_hud   reaper_buff[2]

#!include "fly.opy"
#!include "passive.opy"
#!include "secondary.opy"
#!include "ability1.opy"
#!include "ability2.opy"
#!include "ultimate.opy"

rule "[Reaper]: HUD & Reset":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isInSpawnRoom() != true
    @Condition eventPlayer._reset_requested == false
    @Condition eventPlayer.reaper_soul_count > 0

    if eventPlayer.reaper_soul_hud != 0:
        goto lbl_0
    hudText(eventPlayer, null, " \r\n\r\n\n", "已收割灵魂： {0}".format(eventPlayer.reaper_soul_count), HudPosition.LEFT, 3, null, null, rgb(255, 255, 255, 200), HudReeval.STRING)
    eventPlayer.reaper_soul_hud = getLastCreatedText()
    lbl_0:
    waitUntil(eventPlayer.reaper_soul_count == 0 or eventPlayer._reset_requested, Math.INFINITY)
    destroyHudText(eventPlayer.reaper_soul_hud)
    eventPlayer.reaper_soul_hud = 0