#!mainFile "aramMain.opy"
# ARAM reset profile for shared utilities.

#!define MOIRA_ARAM_BACK_TO_BASICS_BONUS 25

macro APPLY_MOIRA_ARAM_BACK_TO_BASICS():
    if isHero(eventPlayer, Hero.MOIRA):
        eventPlayer.setDamageDealt(100 + MOIRA_ARAM_BACK_TO_BASICS_BONUS + eventPlayer.getStatistic(Stat.ELIMINATIONS))
        eventPlayer.setHealingDealt(100 + MOIRA_ARAM_BACK_TO_BASICS_BONUS + eventPlayer.getStatistic(Stat.ELIMINATIONS))
        eventPlayer.setMaxHealth(100 + MOIRA_ARAM_BACK_TO_BASICS_BONUS + eventPlayer.getStatistic(Stat.ELIMINATIONS))

macro RESET_DISABLE_ALL_ABILITIES_EXTRA():
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.JUMP)
    eventPlayer.disallowButton(Button.CROUCH)
    eventPlayer.disallowButton(Button.RELOAD)
    eventPlayer.disallowButton(Button.INTERACT)
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setJumpEnabled(false)
    eventPlayer.setCrouchEnabled(false)
    eventPlayer.setReloadEnabled(false)

macro RESET_STATS_EXTRA():
    eventPlayer.setDamageDealt(100)
    eventPlayer.setHealingDealt(100)
    APPLY_MOIRA_ARAM_BACK_TO_BASICS()

macro RESET_STATUSES_EXTRA():
    eventPlayer.brigitte_buff[0] = false
    eventPlayer.orisa_buff = false
    eventPlayer.zarya_graviton_buff[0] = false

macro RESET_HERO_EXTRA_BEFORE_CLEAR():
    destroyEffect(eventPlayer.heart_steel[4])
    eventPlayer.third_person = false
    eventPlayer.stopCamera()

macro RESET_HERO_WAIT():
    if isHero(eventPlayer, Hero.MOIRA):
        eventPlayer.setUltEnabled(false)
        eventPlayer.disallowButton(Button.ULTIMATE)
    wait(WAIT_SHORT_FRAME)

macro RESET_REMOVE_TANK_PASSIVE_ENABLED():
    true
