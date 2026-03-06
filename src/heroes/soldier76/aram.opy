# soldier76 aram-mode overlay

rule "[Soldier: 76]: Third Person":
    @Event eachPlayer
    @Team 2
    @Hero soldier
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.third_person = false if eventPlayer.third_person == true else true
    setThirdPerson()
