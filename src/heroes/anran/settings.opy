#!mainFile "../../main.opy"

macro INIT_ANRAN_WORKSHOP_SETTINGS():
    AnranBuff[0] = createWorkshopSettingFloat("英雄：安燃", "踏焰疾行：虚化持续时间", ANRAN_ABILITY2_PHASED_OUT_DURATION, 0, 5, 151)
    AnranBuff[1] = createWorkshopSettingFloat("英雄：安燃", "灼烧层数：每层每秒治疗量", ANRAN_BURN_STACK_HEAL_PER_SECOND, 0, 10, 152)
