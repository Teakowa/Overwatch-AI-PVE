rule "[Domina/init.opy]: Detect switch to Domina":
    @Event eachPlayer
    @Hero domina

    eventPlayer.reset_pvar[0] = true

rule "[Domina/init.opy]: Initialize Domina":
    @Event eachPlayer
    @Hero domina
    @Condition eventPlayer.reset_pvar[0] != false

    resetHero()
    eventPlayer.reset_pvar[0] = false
