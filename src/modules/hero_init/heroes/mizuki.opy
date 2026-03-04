rule "[Mizuki/init.opy]: Detect switch to Mizuki":
    @Event eachPlayer
    @Hero mizuki
    
    eventPlayer.reset_pvar[0] = true


rule "[Mizuki/init.opy]: Initialize Mizuki":
    @Event eachPlayer
    @Hero mizuki
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.reset_pvar[0] = false
