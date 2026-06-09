#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Reaper]: kill to gain soul buff":
    @Event playerEarnedElimination
    @Hero reaper
    #@Condition eventPlayer.reaper_soul_count < 50
    @Condition ReaperBuff[0] != 0

    eventPlayer.reaper_soul_count += ReaperBuff[0] + 1 if eventPlayer.getTeam() == Team.1 else ReaperBuff[0]
