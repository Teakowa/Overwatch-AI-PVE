#!mainFile "../../aramMain.opy"

macro INIT_LIFEWEAVER_WORKSHOP_SETTINGS():
    LifeweaverBuff[0] = createWorkshopSettingInt("英雄：生命之梭", "生命之握：额外治疗目标最大生命值 %", 100, 0, 200, 168)
    LifeweaverBuff[1] = createWorkshopSettingInt("英雄：生命之梭", "生命之握：移动速度 %", 130, 100, 200, 169)
