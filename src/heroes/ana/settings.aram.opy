#!mainFile "../../aramMain.opy"

macro INIT_ANA_WORKSHOP_SETTINGS():
    Ana_GrenadeDamage[0] = createWorkshopSettingInt("英雄：安娜", "生物手雷：额外最大生命值伤害 %", 15, 0, 20, 104)
    Ana_GrenadeDamage[1] = createWorkshopSettingInt("英雄：安娜", "生物手雷：额外最大生命值治疗 %", 8, 0, 20, 105) / 100

