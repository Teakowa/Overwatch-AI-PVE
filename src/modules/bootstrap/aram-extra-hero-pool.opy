#!mainFile "../../aramMain.opy"
#!optimizeStrict

# Expanded hero pool lifecycle (Team 2 / players).
#
# Eligibility and pool application are independent of attack/defense state.
# `extra_hero` is the authoritative eligibility flag. `aram_extra_pool_applied`
# stores the getMatchRound() phase in which the pool/lock was last synchronized
# (null = dirty / never synchronized), so a real round/side change or eligible
# death re-syncs players without per-frame setAllowedHeroes() churn.

def setPlayerHeros():
    @Name "[Player]: set extra hero"

    wait(eventPlayer.getSlot() * 1 + 0.25)
    eventPlayer.heros = [random.shuffle(getTankHeroes()).slice(0, Hero_BAN[3]), random.shuffle(getDamageHeroes()).slice(0, Hero_BAN[4]), random.shuffle(getSupportHeroes()).slice(0, Hero_BAN[5]), eventPlayer.getHero()]
    eventPlayer.setAllowedHeroes(eventPlayer.heros)
    eventPlayer.aram_extra_pool_applied = getMatchRound()
    logToInspector("aram extra hero pool applied")
    smallMessage(eventPlayer, "  {0} 扩展英雄池已开启".format(iconString(Icon.RECYCLE)))

rule "[Player]: when game star lock hero":
    @Event eachPlayer
    @Team 2
    @Condition isGameInProgress() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.extra_hero != true
    @Condition eventPlayer.aram_extra_pool_applied != getMatchRound()

    eventPlayer.heros = [eventPlayer.getHero()]
    eventPlayer.setAllowedHeroes(eventPlayer.heros)
    eventPlayer.aram_extra_pool_applied = getMatchRound()

rule "[Player]: Dead count":
    @Event playerDied
    @Team 2
    @Condition isGameInProgress() == true
    @Condition (eventPlayer.extra_hero == true or eventPlayer.getStatistic(Stat.DEATHS) >= 2) == true

    waitUntil(eventPlayer.isInSpawnRoom(), 8)
    eventPlayer.extra_hero = true
    eventPlayer.aram_extra_pool_applied = null

rule "[Player]: extra hero pool refresh on new round":
    @Event eachPlayer
    @Team 2
    @Condition isGameInProgress() == true
    @Condition eventPlayer.extra_hero != true
    @Condition getMatchRound() > 1

    eventPlayer.extra_hero = true
    eventPlayer.aram_extra_pool_applied = null

rule "[Player]: extra hero pool sync":
    @Event eachPlayer
    @Team 2
    @Condition isGameInProgress() == true
    @Condition eventPlayer.extra_hero == true
    @Condition eventPlayer.aram_extra_pool_applied != getMatchRound()

    setPlayerHeros()
