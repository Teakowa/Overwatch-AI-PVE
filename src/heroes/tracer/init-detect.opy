rule "[tracer/init.opy]: Detect switch to Tracer":
    @Event eachPlayer
    @Hero tracer
    
    eventPlayer.reset_pvar[0] = true
