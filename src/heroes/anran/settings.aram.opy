#!mainFile "../../aramMain.opy"

globalvar AnranBuff

macro INIT_ANRAN_WORKSHOP_SETTINGS():
    AnranBuff[0] = createWorkshopSettingFloat("英雄：安燃", "踏焰疾行：虚化持续时间", ANRAN_ABILITY2_PHASED_OUT_DURATION, 0, 5, 151)
    AnranBuff[1] = createWorkshopSettingInt("英雄：安燃", "烈焰：对所有燃烧中的敌人伤害提高 %", ANRAN_ARAM_BURN_TARGET_DAMAGE_AMP_PERCENT, 100, 300, 152)
