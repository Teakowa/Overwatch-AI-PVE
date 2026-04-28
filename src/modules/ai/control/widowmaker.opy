#!optimizeStrict

rule "[AI/control]: Widowmaker Fly Sky Attack Mode":
    @Event eachPlayer
    @Team 1
    @Hero widowmaker
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isFiringPrimaryFire() == false
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer.getPosition().y > -2
    @Condition (eventPlayer.hasStatus(Status.KNOCKED_DOWN) or eventPlayer.hasStatus(Status.ASLEEP) or eventPlayer.hasStatus(Status.FROZEN)) != true
    @Condition len(getPlayersInRadius(eventPlayer, 22, getOppositeTeam(eventPlayer.getTeam()))) > 0
    
    wait(0.3)
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 4)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.setDamageReceived(70)
    if not eventPlayer.isOnGround():
        goto lbl_0
    eventPlayer.applyImpulse(vect(random.uniform(-0.3, 0.3), 1, random.uniform(-0.3, 0.3)), 30, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.setGravity(0)
    wait(1.2)
    eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
    eventPlayer.setGravity(60)
    wait(0.4)
    lbl_0:
    eventPlayer.setGravity(80)
    waitUntil(eventPlayer.isOnGround(), 4)
    eventPlayer.setDamageReceived(100)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.setGravity(100)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    wait(3)
    if ruleCondition:
        loop()


