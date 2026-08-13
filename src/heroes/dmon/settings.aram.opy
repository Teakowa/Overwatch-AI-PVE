#!mainFile "../../aramMain.opy"

# D.Mon ARAM balance values (shared rules, mode-specific tuning).
# Same workshop setting interface as Main (INIT_DMON_WORKSHOP_SETTINGS)
# but defaults come from the ARAM DMON_* constants below; the ARAM build
# must never fall back to the Main defaults.
#!define DMON_PRIMARY_MAX_HEALTH_PERCENT 8
#!define DMON_PRIMARY_HEAL 50
#!define DMON_DASH_SPEED_PERCENT 80
#!define DMON_DASH_STUN_DURATION 1.2
#!define DMON_ULT_KNOCKDOWN_DURATION 2.0
#!define DMON_REPEATER_ARMOR_SPECIAL_PERCENT 30

globalvar DmonBuff

macro INIT_DMON_WORKSHOP_SETTINGS():
    DmonBuff[0] = createWorkshopSettingInt("英雄：D.Mon", "等离子剑：额外最大生命值伤害 %", DMON_PRIMARY_MAX_HEALTH_PERCENT, 0, 50, 194)
    DmonBuff[1] = createWorkshopSettingInt("英雄：D.Mon", "等离子剑：基础回复", DMON_PRIMARY_HEAL, 0, 100, 195)
    DmonBuff[2] = createWorkshopSettingInt("英雄：D.Mon", "强力屏障：助推移动速度 %", DMON_DASH_SPEED_PERCENT, 0, 200, 196)
    DmonBuff[3] = createWorkshopSettingFloat("英雄：D.Mon", "突进刺击：眩晕时间", DMON_DASH_STUN_DURATION, 0, 3, 197)
    DmonBuff[4] = createWorkshopSettingFloat("英雄：D.Mon", "无极斩：击倒时间", DMON_ULT_KNOCKDOWN_DURATION, 0, 5, 198)
    DmonBuff[5] = createWorkshopSettingInt("英雄：D.Mon", "聚合发射器：护甲特攻真实伤害 %", DMON_REPEATER_ARMOR_SPECIAL_PERCENT, 0, 100, 199)
