rule "[utilities/reset]: setup var when player joins lobby":
    @Event eachPlayer
    
    resetFrenemies()


rule "[utilities/reset]: Default respawn time":
    @Event eachPlayer
    @Team 1
    
    eventPlayer.setRespawnTime(TEAM1_RESPAWN_TIME_DEFAULT)


rule "[utilities/reset]: Default respawn time":
    @Event eachPlayer
    @Team 2
    
    eventPlayer.setRespawnTime(TEAM2_RESPAWN_TIME_DEFAULT)


rule "[utilities/reset]: reset when died":
    @Event playerDied
    
    wait(getAverageServerLoad() / 100)
    eventPlayer.hudText = ""
    eventPlayer.has_nano = false
    eventPlayer.zarya_buff[0] = true
    eventPlayer.zarya_buff[1] = null
    eventPlayer.ram_block_damage = 0
    eventPlayer.sigma_hyperspheres = 0
    eventPlayer.doom_buff = 0
    resetStats()
    resetStatuses()
    resetFrenemies()


def storeOverhealth():
    @Name "[utilities/overhealth]: Store Overhealth"
    
    eventPlayer.storedOverhealth[0] = eventPlayer.getMaxHealth() - eventPlayer.getMaxHealthOfType(Health.NORMAL) - eventPlayer.getMaxHealthOfType(Health.ARMOR) - eventPlayer.getMaxHealthOfType(Health.SHIELDS)


def enableAllAbilities():
    @Name "[utilities/reset.opy]: enableAllAbilities()"
    
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.allowButton(Button.MELEE)
    eventPlayer.allowButton(Button.JUMP)
    eventPlayer.allowButton(Button.CROUCH)
    eventPlayer.allowButton(Button.RELOAD)
    eventPlayer.allowButton(Button.INTERACT)
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.setUltEnabled(true)
    eventPlayer.setMeleeEnabled(true)
    eventPlayer.setJumpEnabled(true)
    eventPlayer.setCrouchEnabled(true)
    eventPlayer.setReloadEnabled(true)


def disableAllAbilities():
    @Name "[utilities/reset.opy]: disableAllAbilities()"
    
    #eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.disallowButton(Button.MELEE)
    #eventPlayer.disallowButton(Button.JUMP)
    #eventPlayer.disallowButton(Button.CROUCH)
    #eventPlayer.disallowButton(Button.RELOAD)
    #eventPlayer.disallowButton(Button.INTERACT)
    #eventPlayer.setPrimaryFireEnabled(false)
    #eventPlayer.setSecondaryFireEnabled(false)
    #eventPlayer.setAbility1Enabled(false)
    #eventPlayer.setAbility2Enabled(false)
    #eventPlayer.setUltEnabled(false)
    #eventPlayer.setMeleeEnabled(false)
    #eventPlayer.setJumpEnabled(false)
    #eventPlayer.setCrouchEnabled(false)
    #eventPlayer.setReloadEnabled(false)


def resetStats():
    @Name "[utilities/reset.opy]: resetStats()"
    
    eventPlayer.mov_speed_penalty = 0
    eventPlayer.mov_speed_buff = 0
    eventPlayer.setDamageReceived(100)
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.setProjectileGravity(100)
    eventPlayer.setHealingReceived(100)
    eventPlayer.setKnockbackReceived(100)
    eventPlayer.setKnockbackDealt(100)
    eventPlayer.setGravity(100)
    eventPlayer.setMoveSpeed(100)


def resetStatuses():
    @Name "[utilities/reset.opy]: resetStatuses()"
    
    eventPlayer.stopAllDamageOverTime()
    eventPlayer.stopForcingThrottle()
    eventPlayer.freja_buff[0] = 0
    eventPlayer.freja_buff[1] = 0
    eventPlayer.brigitte_buff[0] = false
    eventPlayer.orisa_buff = false
    eventPlayer.mov_speed_penalty = 0
    eventPlayer.mov_speed_buff = 0
    eventPlayer.taunt = false
    eventPlayer.clearStatusEffect(Status.ASLEEP)
    eventPlayer.clearStatusEffect(Status.BURNING)
    eventPlayer.clearStatusEffect(Status.FROZEN)
    eventPlayer.clearStatusEffect(Status.HACKED)
    eventPlayer.clearStatusEffect(Status.INVINCIBLE)
    eventPlayer.clearStatusEffect(Status.KNOCKED_DOWN)
    eventPlayer.clearStatusEffect(Status.PHASED_OUT)
    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.clearStatusEffect(Status.STUNNED)
    eventPlayer.clearStatusEffect(Status.UNKILLABLE)


def resetFrenemies():
    @Name "[utilities/reset.opy]: resetFrenemies()"
    
    eventPlayer.reset_pvar[1] = getPlayersOnHero(Hero.BRIGITTE, eventPlayer.getTeam())[0]
    eventPlayer.reset_pvar[3] = getPlayersOnHero(Hero.KIRIKO, eventPlayer.getTeam())[0]
    eventPlayer.reset_pvar[4] = getPlayersOnHero(Hero.SOMBRA, eventPlayer.getTeam())[0]
    eventPlayer.reset_pvar[5] = getPlayersOnHero(Hero.RAMATTRA, getOppositeTeam(eventPlayer.getTeam()))[0]
    eventPlayer.reset_pvar[6] = getPlayersOnHero(Hero.SOMBRA, getOppositeTeam(eventPlayer.getTeam()))[0]
    eventPlayer.reset_pvar[7] = getPlayersOnHero(Hero.ANA, getOppositeTeam(eventPlayer.getTeam()))[0]
    eventPlayer.reset_pvar[9] = getPlayersOnHero(Hero.HANZO, getOppositeTeam(eventPlayer.getTeam()))[0]
    eventPlayer.reset_pvar[11] = getPlayersOnHero(Hero.FREJA, getOppositeTeam(eventPlayer.getTeam()))[0]
    eventPlayer.reset_pvar[12] = getPlayersOnHero(Hero.BAPTISTE, eventPlayer.getTeam())[0]
    eventPlayer.reset_pvar[13] = getPlayersOnHero(Hero.WUYANG, eventPlayer.getTeam())[0]
    eventPlayer.reset_pvar[14] = getPlayersOnHero(Hero.WUYANG, getOppositeTeam(eventPlayer.getTeam()))[0]
    eventPlayer.reset_pvar[15] = getPlayersInSlot(0, eventPlayer.getTeam())
    eventPlayer.reset_pvar[16] = getPlayersInSlot(5, eventPlayer.getTeam())


rule "[reset.opy]: Reinitialize hero on new round":
    @Event eachPlayer
    @Condition isMatchBetweenRounds() == true
    @Condition eventPlayer.getHero() != Hero.SOMBRA
    
    waitUntil(not isMatchBetweenRounds(), WAIT_TIMEOUT_FOREVER)
    wait(1)
    resetHero()
    eventPlayer.reset_pvar[0] = true
    logToInspector("called init after new round")


rule "[utilities/hero_setup.opy]: Reset and initialize hero on hero switch":
    @Event eachPlayer
    @Condition eventPlayer.reset_pvar[0] != false
    
    #wait(10 * TICK_DURATION)
    destroyHudText(eventPlayer.ChangelogText1)
    destroyHudText(eventPlayer.ChangelogText2)
    resetHero()
    logToInspector("called reset hero")


rule "[utilities/overhealth]: Decay Overhealth":
    @Event eachPlayer
    @Condition eventPlayer.overhealth_decay == true
    @Condition eventPlayer.getMaxHealth() - eventPlayer.getMaxHealthOfType(Health.NORMAL) - eventPlayer.getMaxHealthOfType(Health.ARMOR) - eventPlayer.getMaxHealthOfType(Health.SHIELDS) > 0
    @Disabled
    
    wait(5, Wait.RESTART_WHEN_TRUE)
    storeOverhealth()
    #While has OH
    while eventPlayer.getMaxHealth() - eventPlayer.getMaxHealthOfType(Health.NORMAL) - eventPlayer.getMaxHealthOfType(Health.ARMOR) - eventPlayer.getMaxHealthOfType(Health.SHIELDS) > 0:
        #If OH gained, delay again
        if eventPlayer.getMaxHealth() - eventPlayer.getMaxHealthOfType(Health.NORMAL) - eventPlayer.getMaxHealthOfType(Health.ARMOR) - eventPlayer.getMaxHealthOfType(Health.SHIELDS) > eventPlayer.storedOverhealth[0]:
            loop()
        #If not full HP, replace current OH with current OH - 1
        if eventPlayer.getHealth() < eventPlayer.getMaxHealth():
            eventPlayer.storedOverhealth[1] = eventPlayer.getHealth() - eventPlayer.storedOverhealth[0]
            while eventPlayer.getHealth() > eventPlayer.storedOverhealth[1]:
                eventPlayer.setHealth(eventPlayer.storedOverhealth[1])
            eventPlayer.storedOverhealth[0]--
            if eventPlayer.storedOverhealth[0] < 1:
                return
            eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.storedOverhealth[0], false, false)
            #Else just subtract 1 from health
        else:
            eventPlayer.setHealth(eventPlayer.getHealth() - 1)
            storeOverhealth()
        wait(0.12)


def clearCustomHp():
    @Name "[utilities/custom_hp.opy]: clearCustomHp()"
    
    eventPlayer.reset_pvar[8] = false
    eventPlayer.removeAllHealthPools()
    wait()
    eventPlayer.setMaxHealth(100)
    wait()
    eventPlayer.custom_hp_pvar[0] = 0
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    eventPlayer.custom_hp_pvar[3] = eventPlayer.getMaxHealthOfType(Health.NORMAL)
    eventPlayer.custom_hp_pvar[4] = eventPlayer.getMaxHealthOfType(Health.ARMOR)
    eventPlayer.custom_hp_pvar[5] = eventPlayer.getMaxHealthOfType(Health.SHIELDS)
    eventPlayer.custom_hp_pvar[6] = 1
    eventPlayer.reset_pvar[8] = true


def applyCustomHp():
    @Name "[utilities/custom_hp.opy]: applyCustomHp()"
    
    if eventPlayer.getMaxHealthOfType(Health.NORMAL) == eventPlayer.custom_hp_pvar[0] and eventPlayer.getMaxHealthOfType(Health.ARMOR) == eventPlayer.custom_hp_pvar[1] and eventPlayer.getMaxHealthOfType(Health.SHIELDS) == eventPlayer.custom_hp_pvar[2]:
        return
    #Find minimum hp scalar value that ensures
    #the scaled health/armor/shields is less or equal to
    #the desired custom health/armor/shield value
    eventPlayer.custom_hp_pvar[6] = min(min(eventPlayer.custom_hp_pvar[0] / eventPlayer.custom_hp_pvar[3] if eventPlayer.custom_hp_pvar[3] > 0 else CUSTOM_HP_SCALAR_FALLBACK, eventPlayer.custom_hp_pvar[1] / eventPlayer.custom_hp_pvar[4] if eventPlayer.custom_hp_pvar[4] > 0 else CUSTOM_HP_SCALAR_FALLBACK), eventPlayer.custom_hp_pvar[2] / eventPlayer.custom_hp_pvar[5] if eventPlayer.custom_hp_pvar[5] > 0 else CUSTOM_HP_SCALAR_FALLBACK)
    eventPlayer.setMaxHealth(100 * eventPlayer.custom_hp_pvar[6])
    waitUntil(eventPlayer.getMaxHealth() != eventPlayer.custom_hp_pvar[3] + eventPlayer.custom_hp_pvar[4] + eventPlayer.custom_hp_pvar[5], 1)
    if eventPlayer.custom_hp_pvar[0] - eventPlayer.getMaxHealthOfType(Health.NORMAL) >= 1:
        eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.custom_hp_pvar[0] - eventPlayer.getMaxHealthOfType(Health.NORMAL), true, false)
    if eventPlayer.custom_hp_pvar[1] - eventPlayer.getMaxHealthOfType(Health.ARMOR) >= 1:
        eventPlayer.addHealthPool(Health.ARMOR, eventPlayer.custom_hp_pvar[1] - eventPlayer.getMaxHealthOfType(Health.ARMOR), true, false)
    if eventPlayer.custom_hp_pvar[2] - eventPlayer.getMaxHealthOfType(Health.SHIELDS) >= 1:
        eventPlayer.addHealthPool(Health.SHIELDS, eventPlayer.custom_hp_pvar[2] - eventPlayer.getMaxHealthOfType(Health.SHIELDS), true, false)


def resetHero():
    @Name "[utilities/reset.opy]: resetHero()"
    
    destroyHudText(eventPlayer.reaper_buff[2])
    destroyHudText(eventPlayer.ram_block_damage_hud)
    destroyHudText(eventPlayer.sigma_hyperspheres_hud)
    destroyHudText(eventPlayer.doom_buff_hud)
    eventPlayer.reaper_buff[2] = 0
    eventPlayer.hudText = ""
    eventPlayer.ram_block_damage = 0
    eventPlayer.sigma_hyperspheres = 0
    eventPlayer.doom_buff = 0
    eventPlayer.reaper_buff[1] = 0
    eventPlayer.dmg_reduction = 0
    eventPlayer.dmg_amplification = 0
    eventPlayer.has_nano = false
    clearCustomHp()
    resetStats()
    resetStatuses()
    resetFrenemies()
    enableAllAbilities()
    #wait at least 1 tick
    wait()


def removeTankPassive():
    @Name "[passives/tank/knockback.opy]: removeTankPassive()"
    @Disabled
    
    eventPlayer.setKnockbackReceived(166.667)

