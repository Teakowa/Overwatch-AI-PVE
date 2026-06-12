#!mainFile "../../main.opy"

macro INIT_EMRE_WORKSHOP_SETTINGS():
    EmreBuff[0] = createWorkshopSettingFloat("英雄：埃姆雷", "赛博手雷：点燃持续时间", EMRE_ABILITY2_BURNING_DURATION, 0, 10, 160)
    EmreBuff[1] = createWorkshopSettingInt("英雄：埃姆雷", "协议覆写：额外最大生命值伤害 %", EMRE_ULTIMATE_MAX_HEALTH_PERCENT, 0, 50, 161)
