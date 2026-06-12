#!mainFile "../../main.opy"

macro INIT_REINHARDT_WORKSHOP_SETTINGS():
    ReinhardtBuff[0] = createWorkshopSettingInt("英雄：莱因哈特", "十字军坚定：额外生命值", REINHARDT_RULES_NORMAL_HEALTH_POOL_AMOUNT, 0, 600, 147)
    ReinhardtBuff[1] = createWorkshopSettingFloat("英雄：莱因哈特", "火焰打击：点燃持续时间", REINHARDT_ABILITY2_BURNING_DURATION, 0, 10, 148)
