rule "[Player]: status reset":
    @Event eachPlayer
    @Condition eventPlayer.isAlive() == true
    @Condition (eventPlayer.hasStatus(Status.INVINCIBLE) or eventPlayer.hasStatus(Status.PHASED_OUT) or eventPlayer.unaffected == true) == true
    @Condition eventPlayer.mauga_berserker_soul != true
    
    resetStatuses()
    wait(1)
