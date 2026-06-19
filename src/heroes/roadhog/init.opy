#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitRoadhog():
    @Name "[roadhog/init.opy]: heroInitRoadhog()"

    eventPlayer.setMaxAmmo(0, 5)
    eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())
    eventPlayer.startForcingName(random.choice(["链钩摩西", "肥猪摩西", "小鱿摩西", "奶霸摩西"]))
    #removeTankPassive()
