#!optimizeStrict

rule "[Mauga]: Cardiac Overdrive Dmg. reduction":
    @Event eachPlayer
    @Hero mauga
    @Condition MaugaBuff[4] != 0
    @Condition eventPlayer.mauga_berserker_soul != true
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.dmg_reduction >= 0

    eventPlayer.dmg_reduction = eventPlayer.dmg_reduction if eventPlayer.dmg_reduction > MaugaBuff[4] else MaugaBuff[4]
    eventPlayer.setDamageReceived(100 - eventPlayer.dmg_reduction)
    waitUntil(not eventPlayer.isUsingAbility2(), 3)
    eventPlayer.dmg_reduction -= MaugaBuff[4]
    eventPlayer.setDamageReceived(100)
