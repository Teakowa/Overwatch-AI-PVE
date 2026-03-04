def resetFrenemies():
    @Name "[utilities/reset.opy]: resetFrenemies()"
    
    eventPlayer.reset_pvar[1] = getPlayersOnHero(Hero.BRIGITTE, eventPlayer.getTeam())[0]
    eventPlayer.reset_pvar[3] = getPlayersOnHero(Hero.KIRIKO, eventPlayer.getTeam())[0]
    eventPlayer.reset_pvar[4] = getPlayersOnHero(Hero.SOMBRA, eventPlayer.getTeam())[0]
    eventPlayer.reset_pvar[5] = getPlayersOnHero(Hero.RAMATTRA, getOppositeTeam(eventPlayer.getTeam()))[0]
    eventPlayer.reset_pvar[6] = getPlayersOnHero(Hero.SOMBRA, getOppositeTeam(eventPlayer.getTeam()))[0]
    eventPlayer.reset_pvar[7] = getPlayersOnHero(Hero.ANA, getOppositeTeam(eventPlayer.getTeam()))[0]
    eventPlayer.reset_pvar[9] = getPlayersOnHero(Hero.HANZO, getOppositeTeam(eventPlayer.getTeam()))[0]
    eventPlayer.reset_pvar[11] = getPlayersOnHero(Hero.FREJA, getOppositeTeam(eventPlayer.getTeam()))[0]
    eventPlayer.reset_pvar[12] = getPlayersOnHero(Hero.BAPTISTE, eventPlayer.getTeam())[0]
    eventPlayer.reset_pvar[13] = getPlayersOnHero(Hero.WUYANG, eventPlayer.getTeam())[0]
    eventPlayer.reset_pvar[14] = getPlayersOnHero(Hero.WUYANG, getOppositeTeam(eventPlayer.getTeam()))[0]
    eventPlayer.reset_pvar[15] = getPlayersInSlot(0, eventPlayer.getTeam())
    eventPlayer.reset_pvar[16] = getPlayersInSlot(5, eventPlayer.getTeam())

