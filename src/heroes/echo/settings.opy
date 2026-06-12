#!mainFile "../../main.opy"

macro INIT_ECHO_WORKSHOP_SETTINGS():
    EchoBuff[0] = createWorkshopSettingInt("英雄：回声", "聚焦光束：伤害倍率 %", ECHO_ABILITY2_DAMAGE_DEALT, 100, 300, 158)
    EchoBuff[1] = createWorkshopSettingInt("英雄：回声", "复制：最低终极技能充能 %", 10, 0, 100, 159)
