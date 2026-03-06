rule "[Roadhog]: Hogdrogen Exposure":
    @Event playerDealtHealing
    @Hero roadhog
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventAbility == Button.SECONDARY_FIRE
    
    heal(healee, healer, 50)
    wait(0.5)
