#!mainFile "../../aramMain.opy"
#!optimizeStrict

rule "[Moira][ARAM]: Back to Basics":
    @Event playerEarnedElimination
    @Hero moira

    APPLY_MOIRA_ARAM_BACK_TO_BASICS()
