rule "[Anran/init.opy]: Detect switch to Anran":
    @Event eachPlayer
    @Hero anran
    @Condition eventPlayer.reset_pvar[10] != eventPlayer.getHero()

    eventPlayer.reset_pvar[10] = eventPlayer.getHero()
    eventPlayer.reset_pvar[0] = true


rule "[Anran/init.opy]: Initialize Anran":
    @Event eachPlayer
    @Hero anran
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    # eventPlayer.custom_hp_pvar[0] = 250
    # eventPlayer.custom_hp_pvar[1] = 0
    # eventPlayer.custom_hp_pvar[2] = 0
    # applyCustomHp()
    eventPlayer.reset_pvar[0] = false
