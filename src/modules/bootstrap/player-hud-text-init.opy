#!optimizeStrict

rule "[Player]: hudText init":
    wait(HUD_TEXT_INIT_WAIT)
    hudText(getPlayersInSlot(0, Team.2), null, HUD_TEXT_SPACER, getPlayersInSlot(0, Team.2).hudText, HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudText(getPlayersInSlot(1, Team.2), null, HUD_TEXT_SPACER, getPlayersInSlot(1, Team.2).hudText, HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudText(getPlayersInSlot(2, Team.2), null, HUD_TEXT_SPACER, getPlayersInSlot(2, Team.2).hudText, HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudText(getPlayersInSlot(3, Team.2), null, HUD_TEXT_SPACER, getPlayersInSlot(3, Team.2).hudText, HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudText(getPlayersInSlot(4, Team.2), null, HUD_TEXT_SPACER, getPlayersInSlot(4, Team.2).hudText, HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudText(getPlayersInSlot(5, Team.2), null, HUD_TEXT_SPACER, getPlayersInSlot(5, Team.2).hudText, HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
