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
rule "【布丽吉塔】恢复包选中目标":
    @Event eachPlayer
    @Hero brigitte
    @Condition Brigitte[1] != 0
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition distance(eventPlayer, eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam())) <= 27.25
    
    sorted(getLivingPlayers(eventPlayer.getTeam()), lambda player: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getPosition(), player.getPosition())))[0].brig_repair_pack = true
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
