#!mainFile "../../aramMain.opy"

macro INIT_EMRE_WORKSHOP_SETTINGS():
    EmreBuff[0] = createWorkshopSettingInt("英雄：埃姆雷", "赛博手雷：额外最大生命值伤害 %", EMRE_ARAM_ABILITY2_MAX_HEALTH_PERCENT, 0, 50, 160)
    EmreBuff[1] = createWorkshopSettingInt("英雄：埃姆雷", "协议覆写：额外最大生命值伤害 %", EMRE_ARAM_ULTIMATE_MAX_HEALTH_PERCENT, 0, 50, 161)
