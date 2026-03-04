rule "[Genji]: Detect switch to Genji":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.reset_pvar[10] != eventPlayer.getHero()

    eventPlayer.reset_pvar[10] = eventPlayer.getHero()
    eventPlayer.reset_pvar[0] = true


rule "[Genji]: init":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 225
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    #applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["国服{0}分顶尖镖师".format(Genji[0]), "飞镖摩西", "源神", "忍者摩西", "源氏凯"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false


