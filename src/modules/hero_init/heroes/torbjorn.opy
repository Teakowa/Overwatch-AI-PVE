rule "[torbjorn/init.opy]: Detect switch to Torbjorn":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.reset_pvar[10] != eventPlayer.getHero()

    eventPlayer.reset_pvar[10] = eventPlayer.getHero()
    eventPlayer.reset_pvar[0] = true


rule "[torbjorn/init.opy]: Initialize Torbjorn":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 200
    eventPlayer.custom_hp_pvar[1] = 50
    eventPlayer.custom_hp_pvar[2] = 0
    #applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["你强任你强", "史", "十年老兵", "炮台摩西"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false


