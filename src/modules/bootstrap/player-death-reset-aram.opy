macro BOOTSTRAP_PLAYER_DEATH_RESET_PRE():
    pass

macro BOOTSTRAP_PLAYER_DEATH_RESET_MODE_HOOK():
    stopAllHealingModifications()

#!include "player-death-reset.opy"
