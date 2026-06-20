#!mainFile "../../main.opy"
#!optimizeStrict

playervar roadhog_slaughter
#!defineMember roadhog_slaughter_target      roadhog_slaughter[0]
#!defineMember roadhog_slaughter_expires_at roadhog_slaughter[1]

rule "[Roadhog]: Chain Hook slaughter mark":
    @Event playerDealtDamage
    @Hero roadhog
    @Condition eventAbility == Button.ABILITY_1
    @Condition victim.getTeam() != attacker.getTeam()
    @Condition victim.unaffected != true
    @Condition victim.untargetable() != true

    eventPlayer.roadhog_slaughter_target = victim
    eventPlayer.roadhog_slaughter_expires_at = getTotalTimeElapsed() + 3

rule "[Roadhog]: Slaughter mark clear":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.roadhog_slaughter_target != null

    if eventPlayer.roadhog_slaughter_target == null:
        pass
    elif eventPlayer._reset_requested != false or eventPlayer.isDead():
        eventPlayer.roadhog_slaughter_target = null
        eventPlayer.roadhog_slaughter_expires_at = 0
    elif eventPlayer.roadhog_slaughter_target.isDead() or eventPlayer.roadhog_slaughter_target.getTeam() == eventPlayer.getTeam() or eventPlayer.roadhog_slaughter_target.untargetable() == true:
        eventPlayer.roadhog_slaughter_target = null
        eventPlayer.roadhog_slaughter_expires_at = 0
    elif getTotalTimeElapsed() >= eventPlayer.roadhog_slaughter_expires_at:
        eventPlayer.roadhog_slaughter_target = null
        eventPlayer.roadhog_slaughter_expires_at = 0
    elif ruleCondition:
        wait(0.1)
        loop()

rule "[Roadhog]: Slaughter melee":
    @Event playerDealtDamage
    @Hero roadhog
    @Condition eventAbility == Button.MELEE
    @Condition eventPlayer.roadhog_slaughter_target == victim
    @Condition eventPlayer.roadhog_slaughter_expires_at > getTotalTimeElapsed()
    @Condition victim.getTeam() != attacker.getTeam()
    @Condition victim.unaffected != true
    @Condition victim.untargetable() != true

    eventPlayer.roadhog_slaughter_target = null
    eventPlayer.roadhog_slaughter_expires_at = 0
    damage(victim, attacker, min(victim.getMaxHealth().percentOf(10), 40))
    wait(0.016)
    if victim.isAlive() and victim.zarya_buff[1] == null and victim.untargetable() != true and victim.has_nano != true and victim.healthAtMostPercent(8):
        damage(victim, attacker, victim.getHealth())

#!include "ability2.opy"
