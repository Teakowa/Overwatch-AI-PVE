rule "[symmetra/init.opy]: Detect switch to Symmetra":
    @Event eachPlayer
    @Hero symmetra
    
    eventPlayer.reset_pvar[0] = true


rule "[symmetra/init.opy]: Initialize Symmetra":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 125
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 125
    #applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["性♂感荷官在线烫头", "绿洲城首家赌场", "麻豆传媒摄影师", "烫头摩西"]))
    lbl_0:
    getPlayers(eventPlayer.getTeam()).reset_pvar[3] = eventPlayer
    eventPlayer.reset_pvar[0] = false


