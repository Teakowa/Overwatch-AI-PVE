rule "[Orisa]: stun when ult":
    @Event playerDealtKnockback
    @Hero orisa
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition victim.isAlive() == true
    @Condition victim.unaffected != true
    
    wait(0.3, Wait.ABORT_WHEN_FALSE)
    if victim.zarya_buff[1] != null:
        goto lbl_0
    victim.orisa_buff = true
    lbl_0:
    victim.mov_speed_penalty += Orisa_Fortify[2]

rule "[Orisa]: speed":
    @Event eachPlayer
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.unaffected != true
    @Condition eventPlayer.orisa_buff == true
    
    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff - eventPlayer.mov_speed_penalty)
    waitUntil(not eventPlayer.orisa_buff or eventPlayer.unaffected or eventPlayer.hasStatus(Status.INVINCIBLE) or eventPlayer.hasStatus(Status.PHASED_OUT), 2)
    eventPlayer.mov_speed_penalty = 0
    eventPlayer.setMoveSpeed(100)
    eventPlayer.orisa_buff = false

rule "[Orisa]: fly":
    @Event eachPlayer
    @Hero orisa
    @Condition (eventPlayer.isUsingAbility2() or eventPlayer.isUsingUltimate()) == true
    #@Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    
    eventPlayer.applyImpulse(eventPlayer.getFacingDirection(), 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait()
    if ruleCondition:
        loop()
