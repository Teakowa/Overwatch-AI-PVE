#!optimizeStrict

rule "[Player]Hero BAN":
    @Condition Hero_BAN == true
    
    if not getCurrentMap() in HERO_BAN_NO_ROADHOG_MAPS:
        goto lbl_0
    Heros.remove(Hero.ROADHOG)
    lbl_0:
    if getCurrentMap() in HERO_BAN_NO_ROADHOG_MAPS:
        goto lbl_1
    Heros.remove(random.choice(getTankHeroes()))
    lbl_1:
    Heros.remove(random.choice(getDamageHeroes()))
    Heros.remove(random.choice(getDamageHeroes()))
    if not getCurrentMap() in HERO_BAN_NO_LUCIO_MAPS:
        goto lbl_2
    Heros.remove(Hero.LUCIO)
    lbl_2:
    if getCurrentMap() in HERO_BAN_NO_LUCIO_MAPS:
        goto lbl_3
    Heros.remove(random.choice(getSupportHeroes()))
    lbl_3:


rule "[Player]: Override allowed heroes list when player joins lobby":
    @Event playerJoined
    @Team 2
    
    if "{0}".format(eventPlayer) in ["他又"]:
        eventPlayer.setAllowedHeroes(getAllHeroes())
    elif "{0}".format(eventPlayer) in Collaborator:
        eventPlayer.setAllowedHeroes(Heros.concat([Hero.MERCY, Hero.JUNKRAT, Hero.TORBJORN]))
    else:
        eventPlayer.setAllowedHeroes(Heros)
    wait(WAIT_SHORT_FRAME)
    eventPlayer.hudText = ""

#!include "player-hud-text-init.opy"
