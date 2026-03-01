rule "[Mizuki/init.opy]: Detect switch to Mizuki":
    @Event eachPlayer
    @Hero mizuki
    
    eventPlayer.reset_pvar[0] = true


rule "[Mizuki/init.opy]: Initialize Mizuki":
    @Event eachPlayer
    @Hero mizuki
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    # eventPlayer.custom_hp_pvar[0] = 250
    # eventPlayer.custom_hp_pvar[1] = 0
    # eventPlayer.custom_hp_pvar[2] = 0
    # applyCustomHp()
    eventPlayer.reset_pvar[0] = false
