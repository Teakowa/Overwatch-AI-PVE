#!optimizeStrict

rule "[Ash] ammo add by Coach Gun":
    @Event eachPlayer
    @Team 2
    @Hero ashe
    @Condition eventPlayer.isUsingAbility1() == true

    waitUntil(not eventPlayer.isUsingAbility1(), 0.55)
    eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo() if eventPlayer.getAmmo() + 5 > eventPlayer.getMaxAmmo() else eventPlayer.getAmmo() + 5)
