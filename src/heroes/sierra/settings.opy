#!mainFile "../../main.opy"

macro INIT_SIERRA_WORKSHOP_SETTINGS():
    SierraBuff[0] = createWorkshopSettingInt("英雄：西拉", "重构力场：每跳自我治疗", SIERRA_ABILITY1_HEAL, 0, 100, 179)
    SierraBuff[1] = createWorkshopSettingInt("英雄：西拉", "标记次级火力：目标承受伤害 %", 150, 100, 300, 180)
    SierraBuff[2] = createWorkshopSettingFloat("英雄：西拉", "终极技能：击倒持续时间", SIERRA_ULTIMATE_KNOCKED_DOWN_DURATION, 0, 5, 181)
