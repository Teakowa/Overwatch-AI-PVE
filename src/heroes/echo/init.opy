rule "[Echo]: Detect switch to Echo":
    @Event eachPlayer
    @Hero echo
    
    eventPlayer.reset_pvar[0] = true


rule "[Echo] Initialize":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.reset_pvar[0] = false


