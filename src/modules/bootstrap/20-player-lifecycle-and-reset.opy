#!include "shared/10-setup-var-when-player-joins-lobby.opy"

rule "[utilities/reset]: Default respawn time":
    @Event eachPlayer
    @Team 1
    
    eventPlayer.setRespawnTime(TEAM1_RESPAWN_TIME_DEFAULT)

rule "[utilities/reset]: Default respawn time":
    @Event eachPlayer
    @Team 2
    
    eventPlayer.setRespawnTime(TEAM2_RESPAWN_TIME_DEFAULT)

rule "[utilities/reset]: reset when died":
    @Event playerDied
    
    wait(getAverageServerLoad() / 100)
    #!include "player-death-reset-common.opy"
    #!include "player-death-reset-cleanup.opy"



def applySignedMoveSpeed():
    @Name "[utilities/move_speed.opy]: applySignedMoveSpeed()"
    
    eventPlayer.setMoveSpeed(min(max(100 + eventPlayer.mov_speed_buff, 20), 200))

def clearMoveSpeedDebuffs():
    @Name "[utilities/move_speed.opy]: clearMoveSpeedDebuffs()"
    
    eventPlayer.brigitte_buff[0] = false
    eventPlayer.orisa_buff = false
    eventPlayer.wuyang_buff[3] = false
    eventPlayer.wuyang_buff[4] = false
    eventPlayer.mov_speed_penalty = 0
    eventPlayer.mov_speed_buff = 0
    applySignedMoveSpeed()

rule "[reset.opy]: Reinitialize hero on new round":
    @Event eachPlayer
    @Condition isMatchBetweenRounds() == true
    @Condition eventPlayer.getHero() != Hero.SOMBRA
    
    #!include "player-round-reinitialize-wait.opy"
    wait(eventPlayer.getSlot() * 0.032)
    #!include "player-round-reinitialize-finish.opy"


rule "[utilities/hero_setup.opy]: Reset and initialize hero on hero switch":
    @Event eachPlayer
    @Condition eventPlayer.reset_pvar[0] != false
    
    #wait(10 * TICK_DURATION)
    #!include "player-hero-switch-reset-common.opy"
    logToInspector("called reset hero")
