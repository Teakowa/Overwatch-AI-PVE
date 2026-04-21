rule "[Zarya]: Detect switch to Zarya":
    @Event eachPlayer
    @Hero zarya

    eventPlayer.reset_pvar[0] = true

rule "[Zarya] Initialize":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.reset_pvar[0] != false

    resetHero()
    eventPlayer.zarya_buff[0] = true
    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["Sinatraa", "泡泡摩西", "东北雨姐"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false
