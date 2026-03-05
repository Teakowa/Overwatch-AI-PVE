rule "[mercy/init.opy]: Detect switch to Mercy":
    @Event eachPlayer
    @Hero mercy
    
    eventPlayer.reset_pvar[0] = true
