#!optimizeStrict

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