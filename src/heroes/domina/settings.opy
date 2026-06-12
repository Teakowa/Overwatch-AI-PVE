#!mainFile "../../main.opy"

macro INIT_DOMINA_WORKSHOP_SETTINGS():
    DominaBuff[0] = createWorkshopSettingInt("英雄：金驭", "主攻击：额外最大生命值伤害 %", DOMINA_RULES_MAX_HEALTH_PERCENT, 0, 50, 156)
    DominaBuff[1] = createWorkshopSettingInt("英雄：金驭", "终极技能：斩杀伤害", DOMINA_ULTIMATE_EXECUTE_DAMAGE, 0, 50000, 157)
