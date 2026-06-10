#!mainFile "../../main.opy"

macro INIT_ZARYA_WORKSHOP_SETTINGS():
    ZaryaBuff[0] = createWorkshopSettingInt("英雄：查莉娅", "投射屏障 为目标提供的临时生命值", ZARYA_PROJECTED_BARRIER_OVERHEALTH_DEFAULT, ZARYA_PROJECTED_BARRIER_OVERHEALTH_MIN, ZARYA_PROJECTED_BARRIER_OVERHEALTH_MAX, 117)
    ZaryaBuff[2] = createWorkshopSettingBool("英雄：查莉娅", "胜利意志（被动）", true, 115)
    ZaryaBuff[3] = createWorkshopSettingInt("英雄：查莉娅", "胜利意志（被动） 持续时间", ZARYA_WILL_TO_WIN_DURATION_DEFAULT, ZARYA_WILL_TO_WIN_DURATION_MIN, ZARYA_WILL_TO_WIN_DURATION_MAX, 116)
    ZaryaBuff[4] = createWorkshopSettingInt("英雄：查莉娅", "胜利意志（被动） 每秒治疗量", ZARYA_WILL_TO_WIN_HEAL_PER_SECOND_DEFAULT, ZARYA_WILL_TO_WIN_HEAL_PER_SECOND_MIN, ZARYA_WILL_TO_WIN_HEAL_PER_SECOND_MAX, 116)

