rule "[JunkerQueen]: Taunt enemies":
    @Event eachPlayer
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.unaffected != true
    @Condition eventPlayer.taunt == true
    @Condition (eventPlayer.getHero() == Hero.ORISA and (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate())) == false
    @Condition (eventPlayer.getHero() == Hero.MAUGA and eventPlayer.isUsingAbility1()) == false
    @Disabled

    bigMessage(eventPlayer, "嘲讽")
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), getPlayersOnHero(Hero.JUNKER_QUEEN, getOppositeTeam(eventPlayer.getTeam()))[0].getEyePosition()), 270)
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    disableAllAbilities()
    waitUntil(eventPlayer.isDead() or not eventPlayer.taunt or eventPlayer.hasStatus(Status.PHASED_OUT), 2)
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    enableAllAbilities()
    eventPlayer.stopFacing()
    eventPlayer.taunt = false

#!include "ability1.opy"
