rule "[hanzo/init.opy]: Detect switch to Hanzo":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer.reset_pvar[10] != eventPlayer.getHero()

    eventPlayer.reset_pvar[10] = eventPlayer.getHero()
    eventPlayer.reset_pvar[0] = true


rule "[hanzo/init.opy]: Initialize Hanzo":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 200
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    #applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["ANS", "吃矢不忘拉矢人", "拉矢摩西", "贩箭摩西"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false


