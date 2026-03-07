macro BOOTSTRAP_PLAYER_HERO_SWITCH_RESET_PRE():
    eventPlayer.ram_block_damage = 0
    eventPlayer.sigma_hyperspheres = 0

macro BOOTSTRAP_PLAYER_HERO_SWITCH_RESET_POST():
    pass

#!include "player-hero-switch-reset.opy"
