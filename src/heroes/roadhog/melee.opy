#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Roadhog]: Slaughter melee":
    @Event playerDealtDamage
    @Hero roadhog
    @Condition eventAbility == Button.MELEE
    @Condition eventPlayer.roadhog_slaughter_target == victim
    @Condition victim.getTeam() != attacker.getTeam()
    @Condition victim.unaffected != true
    @Condition victim.untargetable() != true

    eventPlayer.roadhog_slaughter_target = null
    damage(victim, attacker, min(victim.getMaxHealth().percentOf(10), 40))
    wait(0.016)
    if victim.isAlive() and victim.zarya_buff[1] == null and victim.untargetable() != true and victim.has_nano != true and victim.healthAtMostPercent(8):
        damage(victim, attacker, victim.getHealth())
