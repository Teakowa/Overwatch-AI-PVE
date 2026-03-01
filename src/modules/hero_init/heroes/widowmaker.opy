rule "[widowmaker/init.opy]: Detect switch to Widowmaker":
    @Event eachPlayer
    @Hero widowmaker
    
    eventPlayer.reset_pvar[0] = true


rule "[widowmaker/init.opy]: Initialize Widowmaker":
    @Event eachPlayer
    @Hero widowmaker
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 175
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    #applyCustomHp()
    eventPlayer.setMaxAmmo(0, 25)
    eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["ANS", "亿枪一个", "KAI了就是KAI了？", "女兵摩西", "MN3"]))
    lbl_0:
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
    eventPlayer.reset_pvar[0] = false


