rule "[Bot] ACC":
    @Event eachPlayer
    @Team 1
    @Condition getMatchTime() == 0
    @Condition (getCurrentMap() in [Map.ROUTE66, Map.HAVANA, Map.CIRCUIT_ROYAL, Map.DORADO, Map.JUNKERTOWN, Map.RIALTO, Map.SHAMBALI_MONASTERY] or getCurrentMap() in [Map.BLIZZ_WORLD, Map.BLIZZ_WORLD_WINTER, Map.EICHENWALDE, Map.EICHENWALDE_HALLOWEEN, Map.HOLLYWOOD, Map.HOLLYWOOD_HALLOWEEN, Map.KINGS_ROW, Map.KINGS_ROW_WINTER, Map.MIDTOWN, Map.NUMBANI, Map.PARAISO]) == true
    @Condition (isInLoS(eventPlayer, getPayloadPosition()) and eventPlayer.isAlive() and len(getPlayersOnObjective(Team.2)) >= 1 and len(getPlayersOnObjective(Team.1)) < 3 and getPayloadProgressPercentage() >= 2.5 and distance(eventPlayer, getPayloadPosition()) >= 2.5 and distance(eventPlayer, getPayloadPosition()) < 25) == true

    eventPlayer.startAcceleration(directionTowards(eventPlayer, getPayloadPosition()), 80, 3, Relativity.TO_WORLD)
    wait(2)
    if ruleCondition:
        loop()
    eventPlayer.stopAcceleration()

rule "[Kiriko]: Swift Step":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0

    resetStatuses()
    eventPlayer.setStatusEffect(eventPlayer, Status.INVINCIBLE, 1.5)
    eventPlayer.setStatusEffect(eventPlayer, Status.PHASED_OUT, 1.5)

rule "[kiriko]: remove swift step hp":
    @Event eachPlayer
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.kiriko_buff != []

    wait(3, Wait.ABORT_WHEN_FALSE)
    removeHealthPool(eventPlayer.kiriko_buff[0])
    eventPlayer.kiriko_buff.remove(eventPlayer.kiriko_buff[0])
    if len(eventPlayer.kiriko_buff) != 0:
        loop()
    eventPlayer.kiriko_buff = []

rule "[Kiriko]: headshot damage":
    @Event playerDealtDamage
    @Hero kiriko
    @Condition HeadshotDamage[2] > 2
    @Condition eventWasCriticalHit == true
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, ceil((eventDamage * (HeadshotDamage[2] - 2)) / 2))
#!include "ability1.opy"
#!include "ability2.opy"
#!include "ultimate.opy"
