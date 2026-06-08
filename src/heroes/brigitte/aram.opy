#!optimizeStrict

#!mainFile "../../aramMain.opy"

playervar brig_repair_pack_state
#!defineMember repair_pack_pending brig_repair_pack_state[0]
#!defineMember repair_pack_id      brig_repair_pack_state[1]
playervar brig_rally_armor_id

rule "[Brigitte]: speed":
    @Event eachPlayer
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.unaffected != true
    @Condition eventPlayer.brigitte_buff[0] == true

    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff - eventPlayer.mov_speed_penalty)
    waitUntil(not eventPlayer.brigitte_buff[0] or eventPlayer.mov_speed_penalty == 0 or eventPlayer.unaffected or eventPlayer.hasStatus(Status.INVINCIBLE), 1.5)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.brigitte_buff[0] = false
    eventPlayer.mov_speed_penalty = 0

#!include "ability2.opy"
#!include "ultimate.opy"
