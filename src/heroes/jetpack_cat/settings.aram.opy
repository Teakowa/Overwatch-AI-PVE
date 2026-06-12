#!mainFile "../../aramMain.opy"

macro INIT_JETPACK_CAT_WORKSHOP_SETTINGS():
    JetpackCatBuff[0] = createWorkshopSettingInt("英雄：喷气猫", "狂乱飞行：受到伤害 %", JETPACK_CAT_ARAM_ABILITY1_DAMAGE_RECEIVED, 0, 100, 162)
    JetpackCatBuff[1] = createWorkshopSettingInt("英雄：喷气猫", "瞌睡轰炸：额外最大生命值伤害 %", JETPACK_CAT_ARAM_MAX_HEALTH_PERCENT, 0, 100, 164)
    JetpackCatBuff[2] = createWorkshopSettingFloat("英雄：喷气猫", "利爪出击：眩晕持续时间", JETPACK_CAT_ARAM_STUNNED_DURATION, 0, 5, 165)
