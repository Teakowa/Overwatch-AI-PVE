#!mainFile "../../aramMain.opy"

macro INIT_DOOMFIST_WORKSHOP_SETTINGS():
    DoomBuff[0] = createWorkshopSettingFloat("英雄：末日铁拳", "悍猛格挡：伤害吸收倍率", 7, 0, 10, 131)
    DoomBuff[1] = createWorkshopSettingInt("英雄：末日铁拳", "悍猛格挡：最大吸收伤害", 2500, 0, 3000, 132) + 0.001
