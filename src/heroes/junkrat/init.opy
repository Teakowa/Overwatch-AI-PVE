rule "[Junkrat]: Detect switch to Junkrat":

    @Event eachPlayer

    @Hero junkrat

    eventPlayer.reset_pvar[0] = true


rule "[Junkrat] Initialize":

    @Event eachPlayer

    @Hero junkrat

    @Condition eventPlayer.reset_pvar[0] != false

    resetHero()

    if eventPlayer.getTeam() != Team.1:

        goto lbl_0

    eventPlayer.startForcingName(random.choice(["拉 史 大 王", "拉 史 摩 西", "鼠鼠摩西", "鸭脖摩西", "夹子摩西"]))

    lbl_0:

    eventPlayer.reset_pvar[0] = false
