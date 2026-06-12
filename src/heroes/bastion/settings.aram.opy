#!mainFile "../../aramMain.opy"

macro INIT_BASTION_WORKSHOP_SETTINGS():
    BastionBuff[0] = createWorkshopSettingInt("英雄：堡垒", "强袭模式：额外最大生命值伤害 %", 12, 0, 50, 153)
    BastionBuff[1] = createWorkshopSettingFloat("英雄：堡垒", "强袭模式：点燃持续时间", 1, 0, 5, 154)
    BastionBuff[2] = createWorkshopSettingInt("英雄：堡垒", "炮击模式：额外当前生命值伤害 %", BASTION_ARAM_HEALTH_SCALAR, 0, 100, 155)
