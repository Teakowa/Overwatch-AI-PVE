rule "[Anran/init.opy]: Detect switch to Anran":
    @Event eachPlayer
    @Hero anran

    eventPlayer.reset_pvar[0] = true

rule "[Anran/init.opy]: Initialize Anran":
    @Event eachPlayer
    @Hero anran
    @Condition eventPlayer.reset_pvar[0] != false

    resetHero()
    eventPlayer.reset_pvar[0] = false
