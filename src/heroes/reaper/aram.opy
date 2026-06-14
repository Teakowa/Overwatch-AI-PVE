#!mainFile "../../aramMain.opy"
#!optimizeStrict

playervar reaper_buff
#!defineMember reaper_soul_count reaper_buff[0]
#!defineMember reaper_effect_hud reaper_buff[1]
#!defineMember reaper_soul_hud   reaper_buff[2]

#!include "fly.opy"
#!include "ability1.opy"
#!include "ability2.opy"
#!include "passive.opy"
#!include "secondary.opy"

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
    waitUntil(eventPlayer.reaper_soul_count == 0 or eventPlayer._reset_requested, 999999986991104)
    destroyHudText(eventPlayer.reaper_soul_hud)
    eventPlayer.reaper_soul_hud = 0

rule "[Reaper]: ultimate Death Blossom":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.setDamageDealt(100 + eventPlayer.reaper_soul_count * ReaperBuff[8])
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.setStatusEffect(eventPlayer, Status.INVINCIBLE, 2.5 if eventPlayer.reaper_soul_count.percentOf(5) >= 2.5 else eventPlayer.reaper_soul_count.percentOf(5))
    eventPlayer.setStatusEffect(eventPlayer, Status.PHASED_OUT, 2.5 if eventPlayer.reaper_soul_count.percentOf(5) >= 2.5 else eventPlayer.reaper_soul_count.percentOf(5))
    waitUntil(not eventPlayer.isUsingUltimate(), 3.016)
    eventPlayer.setDamageDealt(100)

rule "[Reaper]: Death Blossom remove Mov. speed penalty":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.mov_speed_buff += 100
    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff)
    waitUntil(not eventPlayer.isUsingUltimate(), 3.5)
    eventPlayer.mov_speed_buff = 0
    eventPlayer.setMoveSpeed(100)
