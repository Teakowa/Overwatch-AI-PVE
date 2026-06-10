#!mainFile "../../aramMain.opy"

macro INIT_ORISA_WORKSHOP_SETTINGS():
    Orisa_Fortify[0] = createWorkshopSettingInt("英雄：奥丽莎", "强固防御获得的临时护甲", 100, 0, 200, 50)
    Orisa_Fortify[1] = createWorkshopSettingInt("英雄：奥丽莎", "强固防御反弹伤害比例", 50, 0, 100, 51)
    Orisa_Fortify[2] = createWorkshopSettingInt("英雄：奥丽莎", "能量标枪：使敌人减速 %", 70, 0, 90, 31)

