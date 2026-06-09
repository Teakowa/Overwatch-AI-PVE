#!mainFile "../../../main.opy"
#!optimizeStrict

rule "[AI/control]: Reaper Secondary":
    @Event eachPlayer
    @Team 1
    @Hero reaper
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isFiringPrimaryFire() == true
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) == 0
    
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    wait(max(getAverageServerLoad() / 1000, WAIT_AI_THROTTLE_MIN))
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    wait(3)
