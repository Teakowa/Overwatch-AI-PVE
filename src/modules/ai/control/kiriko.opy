#!optimizeStrict

rule "[AI/control]: Kiriko Ability 1":
    @Event eachPlayer
    @Team 1
    @Hero kiriko
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) != true
    @Condition eventPlayer.getNormalizedHealth() < 0.5
    
    if len(getLivingPlayers(Team.2)) < 2:
        goto lbl_0
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), (sorted(getLivingPlayers(Team.1).exclude(eventPlayer), lambda i: i.getHealth())[0].getEyePosition() + sorted(getLivingPlayers(Team.1).exclude(eventPlayer), lambda i: i.getHealth()).getPosition()) / 2), 10000)
    wait(WAIT_AI_THROTTLE_MIN)
    eventPlayer.startForcingButton(Button.ABILITY_1)
    waitUntil(eventPlayer.isUsingAbility1(), 5)
    eventPlayer.startFacing(updateEveryFrame(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition() + eventPlayer.botTarget.getVelocity() * distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()) / ProjectileSpeed[getAllHeroes().index(eventPlayer.getHero())])), 10000)
    lbl_0:
    eventPlayer.setProjectileSpeed(0)
    eventPlayer.setProjectileGravity(500)
    wait(WAIT_AI_THROTTLE_MIN)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.startForcingButton(Button.ABILITY_2)
    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_2), 5)
    eventPlayer.stopForcingButton(Button.ABILITY_2)
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.setProjectileGravity(100)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)



