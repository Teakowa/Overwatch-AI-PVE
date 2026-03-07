rule "[reset.opy]: Reinitialize hero on new round":
    @Event eachPlayer
    @Condition isMatchBetweenRounds() == true
    @Condition eventPlayer.getHero() != Hero.SOMBRA
    
    eventPlayer.extra_hero = true
    #!include "player-round-reinitialize-wait.opy"
    #!include "player-round-reinitialize-finish.opy"

rule "[utilities/hero_setup.opy]: Reset and initialize hero on hero switch":
    @Event eachPlayer
    @Condition eventPlayer.reset_pvar[0] != false
    
    eventPlayer.ram_block_damage = 0
    eventPlayer.sigma_hyperspheres = 0
    #!include "player-hero-switch-reset-common.opy"
