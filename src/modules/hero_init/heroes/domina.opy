rule "[Domina/init.opy]: Detect switch to Domina":
    @Event eachPlayer
    @Hero domina
    
    eventPlayer.reset_pvar[0] = true


rule "[Domina/init.opy]: Initialize Domina":
    @Event eachPlayer
    @Hero domina
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    # eventPlayer.custom_hp_pvar[0] = 400
    # eventPlayer.custom_hp_pvar[1] = 0
    # eventPlayer.custom_hp_pvar[2] = 100
    # applyCustomHp()
    eventPlayer.reset_pvar[0] = false
