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

    lbl_0:

rule "[Brigitte]Rally provides permanent armor to self":

    @Event eachPlayer

    @Hero brigitte

    @Condition Brigitte[2] != 0

    @Condition eventPlayer.isUsingUltimate() == true

    @Condition len(eventPlayer.brig_rally_armor_id) < 9

    # @Condition getAverageServerLoad() < ANTI_CRASH_DEACTIVATE_PERCENT

    eventPlayer.dmg_reduction += Brigitte[0]

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

rule "【布丽吉塔】盾击伤害调整":

    @Event playerDealtDamage

    @Hero brigitte

    @Condition eventAbility == Button.PRIMARY_FIRE

    @Condition attacker.isFiringSecondaryFire() == true

    @Condition attacker.isUsingUltimate() != true

    victim.setStatusEffect(attacker, Status.STUNNED, 1.2)

    if victim.zarya_buff[1] != null or victim.unaffected == true:

        goto lbl_0

    victim.brigitte_buff[0] = true

    lbl_0:

    victim.mov_speed_penalty += Brigitte[3]

rule "[Brigitte]: speed":

    @Event eachPlayer

    @Condition eventPlayer.isAlive() == true

    @Condition eventPlayer.unaffected != true

    @Condition eventPlayer.brigitte_buff[0] == true

    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff - eventPlayer.mov_speed_penalty)

    waitUntil(not eventPlayer.brigitte_buff[0] or eventPlayer.mov_speed_penalty == 0 or eventPlayer.unaffected or eventPlayer.hasStatus(Status.INVINCIBLE), 1.5)

    eventPlayer.setMoveSpeed(100)

    eventPlayer.brigitte_buff[0] = false

    eventPlayer.mov_speed_penalty = 0

rule "【布丽吉塔】恢复包选中目标":

    @Event eachPlayer

    @Hero brigitte

    @Condition Brigitte[1] != 0

    @Condition eventPlayer.isUsingAbility2() == true

    @Condition distance(eventPlayer, eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam())) <= 27.25

    sorted(getLivingPlayers(eventPlayer.getTeam()), lambda player: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getPosition(), player.getPosition())))[0].brig_repair_pack = true

rule "【布丽吉塔】恢复包提供护甲":

    @Event eachPlayer

    @Condition Brigitte[1] != 0

    @Condition eventPlayer.getHero() != Hero.BRIGITTE

    @Condition (eventPlayer.isAlive() and eventPlayer.brig_repair_pack) == true

    eventPlayer.brig_repair_pack = false

    if eventPlayer.brig_repair_pack_id == null:

        goto lbl_0

    removeHealthPool(eventPlayer.brig_repair_pack_id)

    lbl_0:

    eventPlayer.addHealthPool(Health.ARMOR, Brigitte[1], false, false)

    smallMessage(eventPlayer, "  {0} 获得来自 {1} 的护甲".format(abilityIconString(Hero.BRIGITTE, Button.ABILITY_2), eventPlayer.reset_pvar[1].getHero()))

    eventPlayer.brig_repair_pack_id = getLastCreatedHealthPool()

rule "[brigitte/rally.opy]: Rally 30% speed boost":

    @Event eachPlayer

    @Hero brigitte

    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.mov_speed_buff += 13.043

    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff)

    waitUntil(not eventPlayer.isUsingUltimate(), 10)

    eventPlayer.mov_speed_buff = 0

    eventPlayer.setMoveSpeed(100)
