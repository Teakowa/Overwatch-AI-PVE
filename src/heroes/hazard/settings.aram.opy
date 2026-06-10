#!mainFile "../../aramMain.opy"

macro INIT_HAZARD_WORKSHOP_SETTINGS():
    HazardBuff[0] = createWorkshopSettingInt("英雄：骇灾", "狂跃：造成目标最大生命值的额外伤害 %", 30, 0, 500, 70) / 100
    HazardBuff[1] = createWorkshopSettingFloat("英雄：骇灾", "灾厄馈赠（被动）：基于受到伤害获得终极技能充能 %", 2.5, 0, 500, 70)
    HazardBuff[2] = createWorkshopSettingInt("英雄：骇灾", "灾厄馈赠（被动）：基于受到原始伤害（未被减伤）回复生命值 %", 80, 0, 500, 70) / 100

