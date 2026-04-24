#!optimizeStrict

rule "[Player] Override allowed heroes list when player joins lobby":
    @Event eachPlayer
    @Team 2
    @Disabled
    
    eventPlayer.setAllowedHeroes(Heros)

rule "[Player]: Override allowed heroes list when player joins lobby":
    @Event playerJoined
    @Team 2
    
    eventPlayer.heros = [random.shuffle(getTankHeroes().exclude(Hero.WINSTON)).slice(0, Hero_BAN[0]), random.shuffle(getDamageHeroes()).slice(0, Hero_BAN[1]), random.shuffle(getSupportHeroes()).slice(0, Hero_BAN[2])]
    eventPlayer.setAllowedHeroes(eventPlayer.heros)
    wait(0.16)
    eventPlayer.hudText = ""

#!include "player-hud-text-init.opy"
