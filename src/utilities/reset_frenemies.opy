#!mainFile "../main.opy"
#!optimizeStrict

#!defineMember _reset_requested reset_pvar[0]
#!defineMember _friendly_brigitte_reference reset_pvar[1]
#!defineMember _friendly_kiriko_reference reset_pvar[3]
#!defineMember _friendly_sombra_reference reset_pvar[4]
#!defineMember _enemy_ramattra_reference reset_pvar[5]
#!defineMember _enemy_sombra_reference reset_pvar[6]
#!defineMember _enemy_ana_reference reset_pvar[7]
#!defineMember _enemy_anran_reference reset_pvar[8]
#!defineMember _enemy_hanzo_reference reset_pvar[9]
#!defineMember _enemy_freja_reference reset_pvar[11]
#!defineMember _friendly_baptiste_reference reset_pvar[12]
#!defineMember _friendly_wuyang_reference reset_pvar[13]
#!defineMember _enemy_wuyang_reference reset_pvar[14]
#!defineMember _team_front_anchor reset_pvar[15]
#!defineMember _team_back_anchor reset_pvar[16]

def resetFrenemies():
    @Name "[utilities/reset.opy]: resetFrenemies()"
    
    eventPlayer._enemy_anran_reference = getPlayersOnHero(Hero.ANRAN, getOppositeTeam(eventPlayer.getTeam())).first()
    eventPlayer._friendly_brigitte_reference = getPlayersOnHero(Hero.BRIGITTE, eventPlayer.getTeam()).first()
    eventPlayer._friendly_kiriko_reference = getPlayersOnHero(Hero.KIRIKO, eventPlayer.getTeam()).first()
    eventPlayer._friendly_sombra_reference = getPlayersOnHero(Hero.SOMBRA, eventPlayer.getTeam()).first()
    eventPlayer._enemy_ramattra_reference = getPlayersOnHero(Hero.RAMATTRA, getOppositeTeam(eventPlayer.getTeam())).first()
    eventPlayer._enemy_sombra_reference = getPlayersOnHero(Hero.SOMBRA, getOppositeTeam(eventPlayer.getTeam())).first()
    eventPlayer._enemy_ana_reference = getPlayersOnHero(Hero.ANA, getOppositeTeam(eventPlayer.getTeam())).first()
    eventPlayer._enemy_hanzo_reference = getPlayersOnHero(Hero.HANZO, getOppositeTeam(eventPlayer.getTeam())).first()
    eventPlayer._enemy_freja_reference = getPlayersOnHero(Hero.FREJA, getOppositeTeam(eventPlayer.getTeam())).first()
    eventPlayer._friendly_baptiste_reference = getPlayersOnHero(Hero.BAPTISTE, eventPlayer.getTeam()).first()
    eventPlayer._friendly_wuyang_reference = getPlayersOnHero(Hero.WUYANG, eventPlayer.getTeam()).first()
    eventPlayer._enemy_wuyang_reference = getPlayersOnHero(Hero.WUYANG, getOppositeTeam(eventPlayer.getTeam())).first()
    eventPlayer._team_front_anchor = getPlayersInSlot(0, eventPlayer.getTeam())
    eventPlayer._team_back_anchor = getPlayersInSlot(5, eventPlayer.getTeam())
