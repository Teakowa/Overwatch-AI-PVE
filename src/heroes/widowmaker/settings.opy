#!mainFile "../../main.opy"

macro INIT_WIDOWMAKER_WORKSHOP_SETTINGS():
    WidowmakerBuff[0] = createWorkshopSettingFloat("英雄：黑百合", "红外侦测：暴击倍率 %", 300, 250, 500, 185) / 100
