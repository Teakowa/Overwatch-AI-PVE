# brigitte aram-mode overlay

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
