rule "[torbjorn/init.opy]: Detect switch to Torbjorn":
    @Event eachPlayer
    @Hero torbjorn
    
    eventPlayer.reset_pvar[0] = true
