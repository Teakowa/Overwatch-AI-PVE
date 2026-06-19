#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitPharah():
    @Name "[pharah/init.opy]: heroInitPharah()"

    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    lbl_0:
