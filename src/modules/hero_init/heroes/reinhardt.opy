rule "[reinhardt/init.opy]: Detect switch to Reinhardt":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.reset_pvar[10] != eventPlayer.getHero()

    eventPlayer.reset_pvar[10] = eventPlayer.getHero()
    eventPlayer.reset_pvar[0] = true


rule "[reinhardt/init.opy]: Initialize Reinhardt":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 250
    eventPlayer.custom_hp_pvar[1] = 250
    eventPlayer.custom_hp_pvar[2] = 0
    #applyCustomHp()
    #eventPlayer.setKnockbackReceived(116.667)
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["小米Su7 Ultra", "Hadi", "冲锋摩西", "抡锤摩西"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false


