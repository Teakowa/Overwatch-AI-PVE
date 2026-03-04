rule "[Baptiste]: Detect switch to Baptiste":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.reset_pvar[10] != eventPlayer.getHero()

    eventPlayer.reset_pvar[10] = eventPlayer.getHero()
    eventPlayer.reset_pvar[0] = true


rule "[Baptiste] Initialize":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 200
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    #applyCustomHp()
    eventPlayer.setMaxAmmo(0, 45)
    eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())
    eventPlayer.setMaxAmmo(1, 25)
    eventPlayer.setAmmo(1, eventPlayer.getMaxAmmo(1))
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["大 76", "Kai了", "天使", "飞饼摩西", "锁头摩西"]))
    lbl_0:
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
    eventPlayer.reset_pvar[0] = false


