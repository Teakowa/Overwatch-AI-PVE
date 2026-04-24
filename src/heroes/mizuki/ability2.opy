#!optimizeStrict

rule "[Mizuki]: Soul Chain weakens target":
    @Event playerDealtDamage
    @Hero mizuki
    @Condition eventAbility == Button.ABILITY_2
    @Condition victim.getTeam() != attacker.getTeam()

	victim.setStatusEffect(attacker, Status.ROOTED, 2)
    victim.setDamageDealt(50)
    if abs(victim.mov_speed_buff) < 60:
        victim.mov_speed_buff = -60
        victim.setMoveSpeed(min(max(100 + victim.mov_speed_buff, 20), 200))
    wait(4)
    if victim.isDead() != true:
        if victim.mov_speed_buff == -60:
            victim.mov_speed_buff = 0
            victim.setMoveSpeed(min(max(100 + victim.mov_speed_buff, 20), 200))
    victim.setDamageDealt(100)
