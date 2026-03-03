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
    applyMoveSpeedOverride(13.043)
    waitUntil(not eventPlayer.isUsingUltimate() or eventPlayer.isDead(), 10)
    if eventPlayer.isDead():
        goto lbl_0
    clearMoveSpeedOverride(13.043)
    lbl_0:
