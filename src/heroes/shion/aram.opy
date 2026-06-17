#!mainFile "../../aramMain.opy"
#!optimizeStrict

playervar shion_buff
#!defineMember shion_stack_count            shion_buff[0]
#!defineMember shion_stack_gate             shion_buff[1]
#!defineMember shion_buff_active            shion_buff[2]
#!defineMember shion_stack_timeout_snapshot shion_buff[3]
#!defineMember shion_execution_kill_window  shion_buff[4]

rule "[Shion]: State clear on death":
    @Event playerDied
    @Hero shion
    eventPlayer.shion_stack_count = 0
    eventPlayer.shion_stack_gate = false
    eventPlayer.shion_buff_active = false
    eventPlayer.shion_stack_timeout_snapshot = 0
    eventPlayer.shion_execution_kill_window = false
    eventPlayer.setDamageDealt(100)
    eventPlayer.setDamageReceived(100)
    eventPlayer.hudText = ""

rule "[Shion]: Damage stack":
    @Event playerDealtDamage
    @Hero shion
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.shion_buff_active != true
    @Condition eventDamage > 5
    @Condition (eventAbility == Button.PRIMARY_FIRE or eventAbility == Button.SECONDARY_FIRE or eventAbility == Button.ULTIMATE) == true
    @Condition eventPlayer.shion_stack_gate != true

    eventPlayer.shion_stack_count += 1
    eventPlayer.shion_stack_gate = true
    waitUntil(eventPlayer.isDead() or eventPlayer._reset_requested != false, 0.5)
    eventPlayer.shion_stack_gate = false

rule "[Shion]: Stack timeout clear":
    @Event eachPlayer
    @Hero shion
    @Condition eventPlayer.shion_stack_count != 0
    @Condition eventPlayer.shion_buff_active != true
    @Condition eventPlayer.shion_stack_timeout_snapshot == 0

    eventPlayer.shion_stack_timeout_snapshot = eventPlayer.shion_stack_count
    wait(2)
    if eventPlayer.isDead() or eventPlayer._reset_requested != false or eventPlayer.shion_buff_active == true:
        eventPlayer.shion_stack_timeout_snapshot = 0
    elif eventPlayer.shion_stack_count > eventPlayer.shion_stack_timeout_snapshot:
        eventPlayer.shion_stack_timeout_snapshot = 0
        loop()
    else:
        eventPlayer.shion_stack_count = 0
        eventPlayer.shion_stack_timeout_snapshot = 0

rule "[Shion]: Full stack buff":
    @Event eachPlayer
    @Hero shion
    @Condition eventPlayer.shion_stack_count >= ShionBuff[0]
    @Condition eventPlayer.shion_buff_active != true

    eventPlayer.shion_stack_count = 0
    eventPlayer.shion_buff_active = true
    eventPlayer.setDamageDealt(100 + ShionBuff[1])
    eventPlayer.setDamageReceived(100 - ShionBuff[2])
    if eventPlayer.getTeam() == Team.2:
        eventPlayer.hudText = "死怨：狂势激活 | 伤害+{0}% | 减伤{1}% | Execution斩杀{2}%".format(ShionBuff[1], ShionBuff[2], ShionBuff[5])
    waitUntil(eventPlayer.isDead() or eventPlayer._reset_requested != false or eventPlayer.shion_buff_active == false, 8)
    eventPlayer.shion_buff_active = false
    eventPlayer.setDamageDealt(100)
    eventPlayer.setDamageReceived(100)
    eventPlayer.hudText = ""

rule "[Shion]: Execution full stack execute":
    @Event playerDealtDamage
    @Hero shion
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.shion_buff_active == true
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition victim.zarya_buff[1] == null
    @Condition victim.untargetable() != true
    @Condition victim.has_nano != true
    @Condition victim.healthAtMostPercent(ShionBuff[5])

    damage(victim, attacker, victim.getHealth())

#!include "secondary.opy"

rule "[Shion]: Ultimate kill charge refund":
    @Event playerEarnedElimination
    @Hero shion
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.getUltCharge() < 100

    eventPlayer.setUltCharge(min(100, eventPlayer.getUltCharge() + ShionBuff[4]))
