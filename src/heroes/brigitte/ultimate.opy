rule "【布丽吉塔】盾击伤害调整":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition attacker.isFiringSecondaryFire() == true
    @Condition attacker.isUsingUltimate() != true

    victim.setStatusEffect(attacker, Status.STUNNED, 1.2)
    if victim.zarya_buff[1] != null:
        goto lbl_0
    if victim.brigitte_buff[0] == true:
        goto lbl_0
    victim.brigitte_buff[0] = true
    if abs(victim.mov_speed_buff) < Brigitte[3]:
        victim.mov_speed_buff = -Brigitte[3]
        victim.setMoveSpeed(min(max(100 + victim.mov_speed_buff, 20), 200))
    wait(1.5)
    if victim.brigitte_buff[0] != true:
        goto lbl_0
    if victim.mov_speed_buff == -Brigitte[3]:
        victim.mov_speed_buff = 0
        victim.setMoveSpeed(min(max(100 + victim.mov_speed_buff, 20), 200))
    victim.brigitte_buff[0] = false
    lbl_0:

rule "[brigitte/rally.opy]: Rally 30% speed boost":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate() == true

    #30% movement speed buff during ralley
    if abs(eventPlayer.mov_speed_buff) < abs(13.043):
        eventPlayer.mov_speed_buff = 13.043
        applySignedMoveSpeed()
    waitUntil(not eventPlayer.isUsingUltimate() or eventPlayer.isDead(), 10)
    if eventPlayer.isDead():
        goto lbl_0
    if eventPlayer.mov_speed_buff == 13.043:
        eventPlayer.mov_speed_buff = 0
        applySignedMoveSpeed()
    lbl_0:

rule "[Brigitte]: remove Rally provides permanent armor":
    @Event eachPlayer
    @Condition Brigitte[2] != 0
    @Condition getPlayersOnHero(Hero.BRIGITTE, eventPlayer.getTeam())[0].isUsingUltimate() == true

    waitUntil(not eventPlayer.reset_pvar[1].isUsingUltimate() and eventPlayer.brig_rally_armor_id != [], 60)
    wait(2)
    removeHealthPool(eventPlayer.brig_rally_armor_id[0])
    eventPlayer.brig_rally_armor_id.remove(eventPlayer.brig_rally_armor_id[0])
    if len(eventPlayer.brig_rally_armor_id) != 0:
        loop()
    eventPlayer.brig_rally_armor_id = []
    eventPlayer.dmg_reduction = 0
    eventPlayer.hudText = ""
    eventPlayer.setDamageReceived(100)

rule "[Brigitte]Rally provides permanent armor to self":
    @Event eachPlayer
    @Hero brigitte
    @Condition Brigitte[2] != 0
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition len(eventPlayer.brig_rally_armor_id) < 9

    # @Condition getAverageServerLoad() < ANTI_CRASH_DEACTIVATE_PERCENT
    eventPlayer.dmg_reduction += 1.5
    eventPlayer.setDamageReceived(100 - eventPlayer.dmg_reduction)
    eventPlayer.hudText = "受到伤害减免：{0}%".format(eventPlayer.dmg_reduction)
    eventPlayer.addHealthPool(Health.ARMOR, Brigitte[2], false, false)
    eventPlayer.brig_rally_armor_id.append(getLastCreatedHealthPool())
    wait(0.5)
    if ruleCondition:
        loop()

rule "[Brigitte]Rally provides permanent armor to allies":
    @Event eachPlayer
    @Team 2
    @Condition getPlayersOnHero(Hero.BRIGITTE, eventPlayer.getTeam()).isUsingUltimate() == true
    @Condition distance(eventPlayer, getPlayersOnHero(Hero.BRIGITTE, eventPlayer.getTeam())) <= 8.5
    @Condition eventPlayer.getHero() != Hero.BRIGITTE
    @Condition len(eventPlayer.brig_rally_armor_id) < 9

    # @Condition getAverageServerLoad() < ANTI_CRASH_DEACTIVATE_PERCENT
    eventPlayer.addHealthPool(Health.ARMOR, Brigitte[2], false, false)
    eventPlayer.brig_rally_armor_id.append(getLastCreatedHealthPool())
    wait(0.5)
    if ruleCondition:
        loop()
