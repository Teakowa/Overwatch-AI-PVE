#!mainFile "../../aramMain.opy"

macro INIT_FREJA_WORKSHOP_SETTINGS():
    FrejaBuff[0] = createWorkshopSettingInt("英雄：弗蕾娅", "无情猎杀：每层伤害", 25, 0, 75, 133)
    FrejaBuff[1] = createWorkshopSettingInt("英雄：弗蕾娅", "无情猎杀：最大生命值百分比伤害", 5, 0, 50, 134)
    FrejaBuff[2] = createWorkshopSettingInt("英雄：弗蕾娅", "无情猎杀：斩杀阈值", 20, 0, 40, 135)
