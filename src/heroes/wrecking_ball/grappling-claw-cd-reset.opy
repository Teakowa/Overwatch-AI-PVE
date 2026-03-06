rule "[Wrecking Ball] Grappling Claw cd reset":
    @Event eachPlayer
    @Hero wreckingBall
    @Condition eventPlayer.isInSpawnRoom() == true
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) != 0
    
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0)
