#!include "init-detect.opy"

rule "[hanzo/init.opy]: Initialize Hanzo":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["ANS", "吃矢不忘拉矢人", "拉矢摩西", "贩箭摩西"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false


