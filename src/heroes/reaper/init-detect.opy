rule "[reaper/init.opy]: Detect switch to Reaper":
    @Event eachPlayer
    @Hero reaper
    
    eventPlayer.reset_pvar[0] = true
