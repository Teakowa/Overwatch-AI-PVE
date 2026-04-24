#!optimizeStrict

rule "[Ana]: Headhunter":
    @Event playerDealtDamage
    @Team 2
    @Hero ana
    @Condition eventWasCriticalHit == true
    @Disabled

    if eventPlayer.getNormalizedHealth() != 1:
        eventPlayer.startHealingOverTime(eventPlayer, 0.625, ceil(eventDamage * 31.25 * 10))
    else:
        ([player for player in getLivingPlayers(eventPlayer.getTeam()) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) == true and player != eventPlayer]).startHealingOverTime(eventPlayer, 0.625, ceil(eventDamage * 31.25 * 10) / (len([player for player in getLivingPlayers(eventPlayer.getTeam()) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) == true and player != eventPlayer])))
    wait(0.625)

rule "[Ana] Biotic Grenade Hit":
    @Event playerTookDamage
    @Condition eventAbility == Button.ABILITY_2
    @Condition attacker.getHero() == Hero.ANA == true
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false
    @Condition victim.has_nano != true

    if victim.zarya_buff[1] != null:
        goto lbl_0
    eventPlayer.setStatusEffect(attacker, Status.BURNING, 3)
    eventPlayer.startDamageOverTime(attacker, 3, ceil(Ana_GrenadeDamage[0] / 100 * victim.getMaxHealth()))
    wait(3)
    lbl_0:

rule "[Ana]: Damage Full Health Allies So Nano Can Heal":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.getUltCharge() == 100

    waitUntil(eventPlayer.getUltCharge() == 0, 99999)
    eventPlayer.nano_full_health = [i for i in eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam()) if i.getHealth() >= i.getMaxHealth()]
    damage(eventPlayer.nano_full_health, null, 0.05)
    wait(0.216)
    heal(eventPlayer.nano_full_health, null, 0.05)
    eventPlayer.nano_full_health = null

rule "Has Nano":
    @Event playerReceivedHealing
    @Condition eventAbility == Button.ULTIMATE
    @Condition healer.getHero() == Hero.ANA
    @Condition eventPlayer.has_nano != true

    eventPlayer.has_nano = true
    waitUntil(eventPlayer.isDead(), 8)
    eventPlayer.has_nano = false

rule "[Ana] Nano Boost Healing":
    @Event playerDealtHealing
    @Hero ana
    @Condition eventAbility == Button.ULTIMATE
    @Condition healer.getHero() == Hero.ANA == true
    @Condition eventPlayer.has_nano == true

    heal(healee, healer, 99999)
    healee.startHealingOverTime(healer, 10, ceil(healee.getMaxHealth() * 0.2))

rule "[Ana] Biotic Grenade Hit for allies":
    @Event playerDealtHealing
    @Hero ana
    @Condition eventAbility == Button.ABILITY_2

    healee.startHealingOverTime(healer, 3, healee.getMaxHealth() * Ana_GrenadeDamage[1])

rule "[Ana] Nano Boost ":
    @Event eachPlayer
    @Condition eventPlayer.has_nano == true

    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 50)
    eventPlayer.dmg_reduction += 50
    smallMessage(eventPlayer, "  {0} 获得纳米激素额外减伤".format(abilityIconString(Hero.ANA, Button.ULTIMATE)))
    wait(10)
    eventPlayer.has_nano = false

rule "[Ana] Nano Boost ":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.has_nano == true
    @Condition eventPlayer.dmg_reduction > 0

    eventPlayer.setDamageReceived(100 - eventPlayer.dmg_reduction)
    eventPlayer.hudText = "受到伤害减免：{0}%".format(eventPlayer.dmg_reduction)
    wait(1)
    eventPlayer.dmg_reduction -= 5
    if ruleCondition:
        loop()
    eventPlayer.dmg_reduction = 0
    eventPlayer.has_nano = false
    eventPlayer.hudText = ""

rule "[Ana]: Sleep tanks for longer duration":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.ABILITY_1
    @Condition victim.unaffected == false

    victim.clearStatusEffect(Status.ASLEEP)
    #waitUntil(victim.hasStatus(Status.ASLEEP), 999999986991104)
    victim.setStatusEffect(attacker, Status.KNOCKED_DOWN, 4)
    #heart_steel_hp
    eventPlayer.heart_steel[1] += 50 if eventPlayer.getTeam() == Team.2 else 100
    eventPlayer.heart_steel[2] = true

rule "[Ana]: Sleep tanks for longer duration":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.heart_steel[1] > 0
    @Condition eventPlayer.heart_steel[2] == true

    if eventPlayer.heart_steel[0] == null:
        goto lbl_0
    removeHealthPool(eventPlayer.heart_steel[0])
    lbl_0:
    eventPlayer.addHealthPool(Health.ARMOR, eventPlayer.heart_steel[1], true, false)
    eventPlayer.heart_steel[0] = getLastCreatedHealthPool()
    eventPlayer.heart_steel[2] = false
