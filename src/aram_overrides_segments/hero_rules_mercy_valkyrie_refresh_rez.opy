rule "[Mercy]: Valkyrie":
    @Event eachPlayer
    @Hero mercy
    @Condition MercyBuff[0] != 0
    @Condition eventPlayer.isUsingUltimate() == true
    
    getLivingPlayers(eventPlayer.getTeam()).startHealingOverTime(eventPlayer, 15, 45)
    eventPlayer.setDamageDealt(200)
    eventPlayer.setDamageReceived(100 - MercyBuff[0])
    waitUntil(not eventPlayer.isUsingUltimate(), 20)
    eventPlayer.setDamageReceived(100)
    eventPlayer.setDamageDealt(100)

rule "【天使】女武神刷新复活冷却时间":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) != 0
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)

