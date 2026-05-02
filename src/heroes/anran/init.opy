#!optimizeStrict

rule "[Anran/init.opy]: Detect switch to Anran":
    @Event eachPlayer
    @Hero anran

    eventPlayer.reset_pvar[0] = true

rule "[Anran/init.opy]: Initialize Anran":
    @Event eachPlayer
    @Hero anran
    @Condition eventPlayer.reset_pvar[0] != false

    resetHero()
    eventPlayer.anran_burn_stack = 0
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["扇风摩西", "加热摩西", "AAA成都烤肉总代", "别来无漾"]))
    eventPlayer.heroNum = BotHeroArray.index(eventPlayer.getHero())
    lbl_0:
    eventPlayer.reset_pvar[0] = false
