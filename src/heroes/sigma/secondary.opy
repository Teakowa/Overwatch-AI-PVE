#!optimizeStrict


rule "[Sigma]: shield cd":
    @Event eachPlayer
    @Hero sigma
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) <= 0.98

    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0.5)
    wait(0.5)