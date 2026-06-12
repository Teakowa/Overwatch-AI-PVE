#!mainFile "../../main.opy"

macro INIT_JUNKRAT_WORKSHOP_SETTINGS():
    JunkratBuff[0] = createWorkshopSettingFloat("英雄：狂鼠", "纵火狂：点燃持续时间", JUNKRAT_RULES_BURNING_DURATION, 0, 10, 144)
    JunkratBuff[1] = createWorkshopSettingFloat("英雄：狂鼠", "纵火狂：额外造成目标当前生命值伤害 %", JUNKRAT_RULES_HEALTH_SCALAR * 100, 0, 20, 145) / 100
