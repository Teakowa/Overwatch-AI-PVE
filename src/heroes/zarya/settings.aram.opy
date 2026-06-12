#!mainFile "../../aramMain.opy"

macro INIT_ZARYA_WORKSHOP_SETTINGS():
    ZaryaBuff[0] = createWorkshopSettingInt("英雄：查莉娅", "投射屏障 为目标提供的临时生命值", 100, 0, 150, 117)
    ZaryaBuff[2] = createWorkshopSettingBool("英雄：查莉娅", "胜利意志（被动）", true, 115)
    ZaryaBuff[3] = createWorkshopSettingInt("英雄：查莉娅", "胜利意志（被动） 持续时间", 30, 0, 60, 116)
    ZaryaBuff[4] = createWorkshopSettingInt("英雄：查莉娅", "胜利意志（被动） 每秒治疗量", 35, 0, 60, 116)
