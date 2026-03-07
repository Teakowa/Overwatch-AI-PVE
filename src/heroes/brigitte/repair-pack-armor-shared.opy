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
