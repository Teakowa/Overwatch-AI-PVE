#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitAna():
    @Name "[ana/init.opy]: heroInitAna()"

    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["老年摩西", "睡觉摩西", "末日铁娜", "独眼摩西"]))
    eventPlayer.heroNum = BotHeroArray.index(eventPlayer.getHero())
    lbl_0:
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
