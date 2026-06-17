#!mainFile "../../main.opy"

macro INIT_SHION_WORKSHOP_SETTINGS():
    ShionBuff[0] = createWorkshopSettingInt("英雄：死怨", "狂势（被动）最大层数", 5, 1, 10, 188)
    ShionBuff[1] = createWorkshopSettingInt("英雄：死怨", "狂势（被动）满层增益：额外伤害增幅 %", 30, 0, 200, 189)
    ShionBuff[2] = createWorkshopSettingInt("英雄：死怨", "狂势（被动）满层增益：伤害减免 %", 40, 0, 90, 190)
    ShionBuff[3] = createWorkshopSettingBool("英雄：死怨", "交叉枪决：击杀后重置冷却", true, 191)
    ShionBuff[4] = createWorkshopSettingInt("英雄：死怨", "杀戮狂宴：击杀返还终极充能 %", 50, 0, 100, 192)
    ShionBuff[5] = createWorkshopSettingInt("英雄：死怨", "狂势（被动）激活期间：参与击杀回复最大生命值 %", 12, 0, 50, 193)
