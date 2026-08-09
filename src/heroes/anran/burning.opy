#!mainFile "../../main.opy"
#!optimizeStrict


playervar anran_combat_refresh
playervar anran_combat_ticks
playervar anran_burn_target
playervar anran_burn_damage_mod

rule "[Anran]: combat refresh on damage":
    @Event playerDealtDamage
    @Hero anran
    @Condition eventDamage > 0

    eventPlayer.anran_combat_refresh = true

rule "[Anran]: combat refresh on damage taken":
    @Event playerTookDamage
    @Hero anran
    @Condition eventDamage > 0

    eventPlayer.anran_combat_refresh = true

rule "[Anran]: burn-state sustain":
    @Event eachPlayer
    @Hero anran
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true

    if eventPlayer.anran_combat_refresh == true:
        eventPlayer.anran_combat_refresh = false
        eventPlayer.anran_combat_ticks = ANRAN_COMBAT_DURATION
    elif eventPlayer.anran_combat_ticks > 0:
        eventPlayer.anran_combat_ticks -= 1
    if eventPlayer.anran_combat_ticks <= 0:
        goto lbl_0
    if len(getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())).filter(lambda player: player.hasStatus(Status.BURNING) == true)) == 0:
        goto lbl_0
    heal(eventPlayer, eventPlayer, ceil(25 + eventPlayer.maxHealthPercent(5)))
    lbl_0:
    wait(1)
    if ruleCondition:
        loop()

rule "[Anran]: burning target damage amp":
    @Event eachPlayer
    @Hero anran
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true

    eventPlayer.anran_burn_target = getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())).filter(lambda player: player.hasStatus(Status.BURNING) == true)
    if not eventPlayer.anran_burn_target:
        if eventPlayer.anran_burn_damage_mod != null:
            stopDamageModification(eventPlayer.anran_burn_damage_mod)
            eventPlayer.anran_burn_damage_mod = null
        wait(0.5)
        if ruleCondition:
            loop()
        goto lbl_0
    if eventPlayer.anran_burn_damage_mod != null:
        stopDamageModification(eventPlayer.anran_burn_damage_mod)
    startDamageModification(eventPlayer.anran_burn_target, eventPlayer, AnranBuff[1], DamageReeval.RECEIVERS_AND_DAMAGERS)
    eventPlayer.anran_burn_damage_mod = getLastDamageModification()
    wait(0.5)
    if ruleCondition:
        loop()
    if eventPlayer.anran_burn_damage_mod != null:
        stopDamageModification(eventPlayer.anran_burn_damage_mod)
        eventPlayer.anran_burn_damage_mod = null
    lbl_0:

rule "[Anran]: burn interaction cleanup":
    @Event playerDied
    @Hero anran

    if eventPlayer.anran_burn_damage_mod != null:
        stopDamageModification(eventPlayer.anran_burn_damage_mod)
    eventPlayer.anran_burn_damage_mod = null
    eventPlayer.anran_burn_target = []
    eventPlayer.anran_combat_refresh = false
    eventPlayer.anran_combat_ticks = 0
