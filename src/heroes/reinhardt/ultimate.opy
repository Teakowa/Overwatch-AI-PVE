rule "[Reinhardt]: Earthshatter":
    @Event playerDealtFinalBlow
    @Hero reinhardt
    @Condition eventWasCriticalHit == true
    @Condition eventAbility == Button.ULTIMATE

    eventPlayer.setUltCharge(100)
