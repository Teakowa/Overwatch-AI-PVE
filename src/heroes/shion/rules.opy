#!mainFile "../../main.opy"
#!optimizeStrict

playervar shion_buff
#!defineMember shion_stack_count            shion_buff[0]
#!defineMember shion_stack_gate             shion_buff[1]
#!defineMember shion_buff_active            shion_buff[2]
#!defineMember shion_execution_kill_window  shion_buff[3]
#!defineMember shion_ult_refund_armed       shion_buff[4]

rule "[Shion]: State reset":
    @Event eachPlayer
    @Hero shion
    @Condition (eventPlayer._reset_requested != false or eventPlayer.isDead()) == true
    @Condition (eventPlayer.shion_stack_count != 0 or eventPlayer.shion_stack_gate == true or eventPlayer.shion_buff_active == true or eventPlayer.shion_execution_kill_window == true or eventPlayer.shion_ult_refund_armed == true) == true

    eventPlayer.shion_stack_count = 0
    eventPlayer.shion_stack_gate = false
    eventPlayer.shion_buff_active = false
    eventPlayer.shion_execution_kill_window = false
    eventPlayer.shion_ult_refund_armed = false
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
    wait(0.25)
    eventPlayer.shion_stack_gate = false

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
        eventPlayer.hudText = "死怨：狂势激活 | 伤害+{0}% | 减伤{1}%".format(ShionBuff[1], ShionBuff[2])
    wait(8)
    eventPlayer.shion_buff_active = false
    eventPlayer.setDamageDealt(100)
    eventPlayer.setDamageReceived(100)
    eventPlayer.hudText = ""

rule "[Shion]: Execution kill window":
    @Event playerDealtDamage
    @Hero shion
    @Condition eventPlayer.isAlive() == true
    @Condition eventAbility == Button.SECONDARY_FIRE

    eventPlayer.shion_execution_kill_window = true
    wait(0.6)
    eventPlayer.shion_execution_kill_window = false

rule "[Shion]: Execution kill reset cooldown":
    @Event playerEarnedElimination
    @Hero shion
    @Condition ShionBuff[3] == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.shion_execution_kill_window == true
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) > 0

    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0)

#!include "ultimate.opy"
