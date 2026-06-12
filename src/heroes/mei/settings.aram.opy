#!mainFile "../../aramMain.opy"

macro INIT_MEI_WORKSHOP_SETTINGS():
    MeiBuff[0] = createWorkshopSettingFloat("英雄：美", "冰风暴射击：冻结持续时间", MEI_ARAM_FROZEN_DURATION, 0, 5, 170)
    MeiBuff[1] = createWorkshopSettingFloat("英雄：美", "冰墙滑步：冲量强度", MEI_ARAM_IMPULSE, 0, 20, 171)
