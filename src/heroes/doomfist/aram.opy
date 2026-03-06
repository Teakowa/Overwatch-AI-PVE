# doomfist aram-mode overlay
#!include "40-power-block-damage.opy"
rule "[Doomfist]: block HUD":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.doom_buff != 0
    @Condition eventPlayer.isInSpawnRoom() != true
    @Condition eventPlayer.reset_pvar[0] == false
    
    #hudText(eventPlayer, null, "\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r", "{0}".format(floor(eventPlayer.doom_buff)), HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    #eventPlayer.doom_buff_hud = getLastCreatedText()
    waitUntil(eventPlayer.doom_buff == 0 or eventPlayer.reset_pvar[0] or eventPlayer.isInSpawnRoom(), 999999986991104)
    eventPlayer.hudText = ""
    #destroyHudText(eventPlayer.doom_buff_hud)
