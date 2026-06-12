#!mainFile "../../aramMain.opy"

macro INIT_WIDOWMAKER_WORKSHOP_SETTINGS():
    WidowmakerBuff[0] = createWorkshopSettingInt("英雄：黑百合", "狙击暴击：额外最大生命值伤害 %", 50, 0, 100, 185)
    WidowmakerBuff[1] = createWorkshopSettingInt("英雄：黑百合", "红外侦测期间狙击暴击：额外最大生命值伤害 %", 90, 0, 100, 186)
