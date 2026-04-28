#!optimizeStrict

rule "[Player]: when game star lock hero":
    @Event eachPlayer
    @Team 2
    @Condition isGameInProgress() == true
    @Condition isTeamOnDefense(eventPlayer.getTeam()) == false
    @Condition eventPlayer.extra_hero != true
    
    eventPlayer.heros = [eventPlayer.getHero()]
    eventPlayer.setAllowedHeroes(eventPlayer.heros)
    eventPlayer.aram_extra_pool_applied = false

rule "[Player]: Dead count":
    @Event playerDied
    @Team 2
    @Condition isGameInProgress() == true
    @Condition eventPlayer.extra_hero != true
    @Condition eventPlayer.getStatistic(Stat.DEATHS) >= 2
    
    waitUntil(eventPlayer.isInSpawnRoom(), 8)
    eventPlayer.extra_hero = true
    eventPlayer.aram_extra_pool_applied = false

rule "[Player]: extra hero pick when dead & attack":
    @Event eachPlayer
    @Team 2
    @Condition isTeamOnOffense(Team.2) == true
    @Condition (eventPlayer.getStatistic(Stat.DEATHS) >= 2 or eventPlayer.extra_hero) == true
    @Condition eventPlayer.aram_extra_pool_applied != true

    setPlayerHeros()

rule "[Player]: extra hero pick when dead & defense":
    @Event eachPlayer
    @Team 2
    @Condition (isTeamOnDefense(Team.2) or getMatchRound() > 1) == true
    @Condition (eventPlayer.getStatistic(Stat.DEATHS) >= 2 or eventPlayer.extra_hero) == true
    @Condition eventPlayer.aram_extra_pool_applied != true

    setPlayerHeros()

rule "[Player]: extra hero pick when refresh & defense":
    @Event eachPlayer
    @Team 2
    @Condition isTeamOnDefense(Team.2) == true
    @Condition (eventPlayer.getStatistic(Stat.DEATHS) >= 2 or eventPlayer.extra_hero) == true
    @Condition eventPlayer.aram_extra_pool_applied != true

    setPlayerHeros()

def setPlayerHeros():
    @Name "[Player]: set extra hero"
    
    wait(0.16)
    eventPlayer.heros = [random.shuffle(getTankHeroes()).slice(0, Hero_BAN[3]), random.shuffle(getDamageHeroes()).slice(0, Hero_BAN[4]), random.shuffle(getSupportHeroes()).slice(0, Hero_BAN[5]), eventPlayer.getHero()]
    eventPlayer.setAllowedHeroes(eventPlayer.heros)
    eventPlayer.aram_extra_pool_applied = true
    logToInspector("aram extra hero pool applied")
    smallMessage(eventPlayer, "  {0} 扩展英雄池已开启".format(iconString(Icon.RECYCLE)))
