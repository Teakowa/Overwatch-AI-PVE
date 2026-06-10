#!mainFile "../../aramMain.opy"

macro INIT_BRIGITTE_WORKSHOP_SETTINGS():
    Brigitte[1] = createWorkshopSettingInt("英雄：布丽吉塔", "恢复包：提供的护甲", 150, 0, 200, 31)
    Brigitte[3] = createWorkshopSettingInt("英雄：布丽吉塔", "能量盾击：使敌人减速 %", 90, 0, 90, 32)
    Brigitte[2] = createWorkshopSettingInt("英雄：布丽吉塔", "集结号令：每秒额外护甲", 25, 0, 150, 34)
    Brigitte[0] = createWorkshopSettingInt("英雄：布丽吉塔", "集结号令：每秒伤害减免", 2, 0, 5, 33)

