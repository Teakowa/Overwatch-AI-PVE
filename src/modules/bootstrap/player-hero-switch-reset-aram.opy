macro BOOTSTRAP_PLAYER_HERO_SWITCH_RESET_PRE():
    eventPlayer.ram_block_damage = 0
    eventPlayer.sigma_hyperspheres = 0

macro BOOTSTRAP_PLAYER_HERO_SWITCH_RESET_POST():
    pass

rule "[utilities/hero_setup.opy]: Reset and initialize hero on hero switch":
    @Event eachPlayer
    @Condition eventPlayer.reset_pvar[0] != false
    
    BOOTSTRAP_PLAYER_HERO_SWITCH_RESET_PRE()
    destroyHudText(eventPlayer.ChangelogText1)
    destroyHudText(eventPlayer.ChangelogText2)
    resetHero()
    BOOTSTRAP_PLAYER_HERO_SWITCH_RESET_POST()
