rule "[Freja/init.opy]: Detect switch to Freja":
    @Event eachPlayer
    @Hero freja
    
    eventPlayer.reset_pvar[0] = true
