#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitDmon():
    @Name "[dmon/init.opy]: heroInitDmon()"

    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.heroNum = BotHeroArray.index(eventPlayer.getHero())
    lbl_0:

