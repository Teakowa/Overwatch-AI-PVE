#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Player]: changelog hud init":
    wait(HUD_TEXT_INIT_WAIT)
    hudText(localPlayer if localPlayer.getTeam() == Team.2 and not isGameInProgress() and localPlayer.isInSpawnRoom() else null, null, Mark, localPlayer.changelog_body if localPlayer.getTeam() == Team.2 else "", HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
