rule "[Tracer] Instant Respawn":
    @Event playerDied
    @Hero tracer
    
    wait(0.16)
    eventPlayer.respawn()
    eventPlayer.setAbilityCharge(Button.ABILITY_1, 3)
