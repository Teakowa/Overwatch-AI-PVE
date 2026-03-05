rule "[Reaper]: Wraith Form to fly":
    @Event eachPlayer
    @Hero reaper
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate()) == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    
    eventPlayer.applyImpulse(Vector.UP, 5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(0.1, Wait.ABORT_WHEN_FALSE)
    loop()

rule "[Reaper]: Wraith Form to fly":
    @Event eachPlayer
    @Hero reaper
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate()) == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    
    eventPlayer.applyImpulse(Vector.DOWN, 5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(0.1, Wait.ABORT_WHEN_FALSE)
    loop()

rule "[Reaper]: kill to gain soul buff":
    @Event playerEarnedElimination
    @Hero reaper
    #@Condition eventPlayer.reaper_buff[0] < 50
    @Condition ReaperBuff[0] != 0
    
    eventPlayer.reaper_buff[0] += ReaperBuff[0] + 1 if eventPlayer.getTeam() == Team.1 else ReaperBuff[0]

