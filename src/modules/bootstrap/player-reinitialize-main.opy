macro BOOTSTRAP_PLAYER_REINITIALIZE_BEFORE_WAIT_UNTIL():
    pass

macro BOOTSTRAP_PLAYER_REINITIALIZE_AFTER_WAIT_UNTIL():
    wait(eventPlayer.getSlot() * 0.032)

#!include "player-reinitialize.opy"
