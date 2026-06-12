#!mainFile "../../main.opy"

macro INIT_MIZUKI_WORKSHOP_SETTINGS():
    MizukiBuff[0] = createWorkshopSettingFloat("英雄：水月", "替身人偶：无敌与虚化持续时间", MIZUKI_ABILITY1_INVINCIBLE_DURATION, 0, 5, 172)
    MizukiBuff[1] = createWorkshopSettingFloat("英雄：水月", "魂链：定身持续时间", MIZUKI_ABILITY2_ROOTED_DURATION, 0, 5, 173)
    MizukiBuff[2] = createWorkshopSettingInt("英雄：水月", "魂帽：额外治疗目标最大生命值 %", MIZUKI_RULES_MAX_HEALTH_PERCENT, 0, 50, 174)
