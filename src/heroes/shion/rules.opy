#!mainFile "../../main.opy"
#!optimizeStrict

playervar shion_buff
#!defineMember shion_stack_count            shion_buff[0]
#!defineMember shion_stack_gate             shion_buff[1]
#!defineMember shion_buff_active            shion_buff[2]

rule "[Shion]: State clear on death":
    @Event playerDied
    @Hero shion
    eventPlayer.shion_stack_count = 0
    eventPlayer.shion_stack_gate = false
    eventPlayer.shion_buff_active = false
    eventPlayer.setDamageDealt(100)

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
        eventPlayer.hudText = "狂势 | {0}% 增伤 | {1}% 减伤".format(ShionBuff[1], ShionBuff[2])
    wait(8)
    eventPlayer.shion_buff_active = false
    eventPlayer.setDamageDealt(100)
    eventPlayer.setDamageReceived(100)
    eventPlayer.hudText = ""

#!include "secondary.opy"
#!include "ultimate.opy"
