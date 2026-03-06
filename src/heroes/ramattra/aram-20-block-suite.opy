rule "[Ramattra]: block":
    @Event playerTookDamage
    @Hero ramattra
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate()) == true
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.ram_block_damage <= Ram_Annihilation[0]
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) <= eventPlayer.getMaxHealthOfType(Health.NORMAL) + 50
    
    eventPlayer.ram_block_damage += eventDamage
    eventPlayer.hudText = "{0}/{1}".format(floor(eventPlayer.ram_block_damage), Ram_Annihilation[0])

rule "[Ramattra]: block":
    @Event eachPlayer
    @Hero ramattra
    @Condition Ram_Annihilation[0] != 0
    @Condition eventPlayer.ram_block_damage != 0
    @Condition eventPlayer.ram_block_damage >= Ram_Annihilation[0]
    
    eventPlayer.addHealthPool(Health.NORMAL, Ram_Annihilation[0] if eventPlayer.ram_block_damage >= Ram_Annihilation[0] else eventPlayer.ram_block_damage, false, false)
    eventPlayer.ram_block_damage = 0
    eventPlayer.hudText = ""
    #eventPlayer.startHealingOverTime(eventPlayer, 5, eventPlayer.getMaxHealth() * 0.25)

rule "[Ramattra]: block HUD":
    @Event eachPlayer
    @Team 2
    @Hero ramattra
    @Condition eventPlayer.isInSpawnRoom() != true
    @Condition eventPlayer.reset_pvar[0] == false
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate()) == true
    
    #hudText(eventPlayer, null, "\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r", "{0}/{1}".format(floor(eventPlayer.ram_block_damage), Ram_Annihilation[0]), HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    #eventPlayer.ram_block_damage_hud = getLastCreatedText()
    waitUntil(eventPlayer.ram_block_damage == 0 or eventPlayer.reset_pvar[0] or eventPlayer.isInSpawnRoom(), 999999986991104)
    eventPlayer.hudText = ""
    #destroyHudText(eventPlayer.ram_block_damage_hud)

rule "[Ramattra]: Annihilation dmg reduc":
    @Event eachPlayer
    @Condition getPlayersOnHero(Hero.RAMATTRA, getOppositeTeam(eventPlayer.getTeam())).isUsingUltimate() == true
    @Condition distance(eventPlayer, getPlayersOnHero(Hero.RAMATTRA, getOppositeTeam(eventPlayer.getTeam()))) > 13
    
    startDamageModification(getPlayersOnHero(Hero.RAMATTRA, getOppositeTeam(eventPlayer.getTeam())), eventPlayer, 0.01)
    eventPlayer.ram_dmg_reduc = getLastDamageModification()
    waitUntil(not getPlayersOnHero(Hero.RAMATTRA, getOppositeTeam(eventPlayer.getTeam())).isUsingUltimate() or distance(eventPlayer, getPlayersOnHero(Hero.RAMATTRA, getOppositeTeam(eventPlayer.getTeam()))) <= 13, 120)
    stopDamageModification(eventPlayer.ram_dmg_reduc)
    eventPlayer.ram_dmg_reduc = null
