rule "[Cassdy] Peacekeeper Alt Fire Reload":
    @Event eachPlayer
    @Hero cassidy
    @Condition eventPlayer.getAmmo() == 0
    
    wait(0.75, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())
