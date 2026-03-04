rule "[JetpackCat/init.opy]: Detect switch to JetpackCat":
    @Event eachPlayer
    @Hero jetpackCat
    @Condition eventPlayer.reset_pvar[10] != eventPlayer.getHero()

    eventPlayer.reset_pvar[10] = eventPlayer.getHero()
    eventPlayer.reset_pvar[0] = true


rule "[JetpackCat/init.opy]: Initialize JetpackCat":
    @Event eachPlayer
    @Hero jetpackCat
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    # eventPlayer.custom_hp_pvar[0] = 225
    # eventPlayer.custom_hp_pvar[1] = 0
    # eventPlayer.custom_hp_pvar[2] = 0
    # applyCustomHp()
    eventPlayer.reset_pvar[0] = false
