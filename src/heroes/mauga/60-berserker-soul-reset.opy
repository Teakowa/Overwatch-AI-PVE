rule "[Mauga]: Berserker Soul reset":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isInSpawnRoom() == true
    
    eventPlayer.mauga_berserker_soul = false
