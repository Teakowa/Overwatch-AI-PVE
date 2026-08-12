#!mainFile "../../main.opy"

globalvar Brigitte

macro INIT_BRIGITTE_WORKSHOP_SETTINGS():
    Brigitte[1] = createWorkshopSettingInt("英雄：布丽吉塔", "恢复包：提供的护甲", BRIGITTE_REPAIR_PACK_ARMOR_DEFAULT, BRIGITTE_REPAIR_PACK_ARMOR_MIN, BRIGITTE_REPAIR_PACK_ARMOR_MAX, 30)
    Brigitte[2] = createWorkshopSettingInt("英雄：布丽吉塔", "集结号令：每秒额外护甲", BRIGITTE_RALLY_ARMOR_PER_SECOND_DEFAULT, BRIGITTE_RALLY_ARMOR_PER_SECOND_MIN, BRIGITTE_RALLY_ARMOR_PER_SECOND_MAX, 34)
