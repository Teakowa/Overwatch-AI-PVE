#!mainFile "../../aramMain.opy"

globalvar Brigitte

macro INIT_BRIGITTE_WORKSHOP_SETTINGS():
    Brigitte[1] = createWorkshopSettingInt("英雄：布丽吉塔", "恢复包：提供的护甲", 150, 0, 200, 31)
    Brigitte[2] = createWorkshopSettingInt("英雄：布丽吉塔", "集结号令：每秒额外护甲", 25, 0, 150, 34)
