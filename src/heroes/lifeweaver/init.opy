rule "[Lifeweaver]: Detect switch to Lifeweaver":
    @Event eachPlayer
    @Hero lifeweaver

    eventPlayer.reset_pvar[0] = true

rule "[Lifeweaver] Initialize":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer.reset_pvar[0] != false

    resetHero()
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
    eventPlayer.reset_pvar[0] = false
