rule "[Soldier: 76]: HeartSteel":
    @Event eachPlayer
    @Team 2
    @Hero soldier
    @Condition any([isInSetup(), isGameInProgress()]) == true
    @Condition S76Buff[1] != 0
    @Condition eventPlayer.isInSpawnRoom() != true
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getSpeed() != 0
    @Condition eventPlayer.getMaxHealth() < S76Buff[2]

    wait(S76Buff[0], Wait.ABORT_WHEN_FALSE)
    #heart_steel_hp_id
    if eventPlayer.heart_steel[0] == null:
        goto lbl_0
    removeHealthPool(eventPlayer.heart_steel[0])
    lbl_0:
    if eventPlayer.getMaxHealth() > S76Buff[2]:
        goto lbl_1
    #heart_steel_hp
    eventPlayer.heart_steel[1] += S76Buff[1] + (eventPlayer.getSpeed() - 5.5)
    #heart_steel_hp_lost
    lbl_1:
    eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.heart_steel[1], true, false)
    smallMessage(eventPlayer, "  心之钢 {0} {1}".format(iconString(Icon.PLUS), S76Buff[1]))
    eventPlayer.heart_steel[0] = getLastCreatedHealthPool()
    if ruleCondition:
        loop()

rule "[Soldier: 76]: HeartSteel":
    @Event eachPlayer
    @Team 1
    @Hero soldier
    @Condition S76Buff[1] != 0
    @Condition eventPlayer.isAlive() == true

    wait(S76Buff[0], Wait.ABORT_WHEN_FALSE)
    #heart_steel_hp_id
    if eventPlayer.heart_steel[0] == null:
        goto lbl_0
    removeHealthPool(eventPlayer.heart_steel[0])
    lbl_0:
    if eventPlayer.getMaxHealth() >= S76Buff[2]:
        goto lbl_1
    #heart_steel_hp
    eventPlayer.heart_steel[1] += S76Buff[1] + (eventPlayer.getSpeed() - 5.5)
    #heart_steel_hp_lost
    lbl_1:
    eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.heart_steel[1], true, false)
    smallMessage(eventPlayer, "  心之钢 {0} {1}".format(iconString(Icon.PLUS), S76Buff[1]))
    eventPlayer.heart_steel[0] = getLastCreatedHealthPool()
    if ruleCondition:
        loop()
