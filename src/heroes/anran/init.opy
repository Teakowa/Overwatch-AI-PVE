#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitAnran():
    @Name "[anran/init.opy]: heroInitAnran()"

    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["扇风摩西", "加热摩西", "AAA成都烤肉总代", "别来无漾"]))
    eventPlayer.heroNum = BotHeroArray.index(eventPlayer.getHero())
    lbl_0:
