macro BOOTSTRAP_PLAYER_DEATH_RESET_PRE():
    wait(getAverageServerLoad() / 100)

macro BOOTSTRAP_PLAYER_DEATH_RESET_MODE_HOOK():
    pass

#!include "player-death-reset.opy"
