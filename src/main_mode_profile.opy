#
# Main mode profile macros consumed by shared reset utilities.
# Keep this file main-only to avoid macro redefinition in ARAM.
#

macro RESET_DISABLE_ALL_ABILITIES_EXTRA():
    pass

macro RESET_STATS_EXTRA():
    pass

macro RESET_STATUSES_EXTRA():
    clearMoveSpeedDebuffs()
    eventPlayer.taunt = false

macro RESET_HERO_EXTRA_BEFORE_CLEAR():
    pass

macro RESET_HERO_WAIT():
    wait()

macro RESET_REMOVE_TANK_PASSIVE_ENABLED():
    false
