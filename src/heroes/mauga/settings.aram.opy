#!mainFile "../../aramMain.opy"

macro INIT_MAUGA_WORKSHOP_SETTINGS():
    MaugaBuff[0] = createWorkshopSettingInt("英雄：毛加", "狂战士之魂：额外最大生命值 %", 200, 0, 500, 122)
    MaugaBuff[1] = createWorkshopSettingInt("英雄：毛加", "狂战士之魂：额外伤害减免 %", 40, 0, 80, 123)
    MaugaBuff[2] = createWorkshopSettingInt("英雄：毛加", "狂战士之魂：额外伤害增幅 %", 150, 0, 300, 120)
    MaugaBuff[5] = createWorkshopSettingInt("英雄：毛加", "狂战士之魂：击退抵抗 %", 80, 0, 80, 122)
    MaugaBuff[6] = createWorkshopSettingInt("英雄：毛加", "狂战士之魂：每秒损失最大生命值 %", 20, 0, 80, 122)
    MaugaBuff[7] = createWorkshopSettingInt("英雄：毛加", "狂战士之魂：击杀回复最大生命值 %", 30, 0, 80, 122)
    MaugaBuff[3] = createWorkshopSettingInt("英雄：毛加", "蛮力冲撞：被击倒的敌人造成最大生命值伤害 %", 5, 0, 50, 122)
    MaugaBuff[4] = createWorkshopSettingFloat("英雄：毛加", "心脏过载：额外伤害减免", 25, 0, 50, 121)
