rule "[hanzo/init.opy]: Detect switch to Hanzo":
    @Event eachPlayer
    @Hero hanzo
    
    eventPlayer.reset_pvar[0] = true
