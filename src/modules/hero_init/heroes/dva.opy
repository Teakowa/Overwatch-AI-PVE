rule "[D.Va]: Detect switch to D.Va":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isInAlternateForm() == false
    @Condition eventPlayer.reset_pvar[10] != eventPlayer.getHero()

    eventPlayer.reset_pvar[10] = eventPlayer.getHero()
    eventPlayer.reset_pvar[0] = true


rule "[D.Va] Initialize":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    #eventPlayer.custom_hp_pvar[0] = 100
    #eventPlayer.custom_hp_pvar[1] = 500
    #eventPlayer.custom_hp_pvar[2] = 0
    #applyCustomHp()
    #removeTankPassive()
    eventPlayer.reset_pvar[0] = false


