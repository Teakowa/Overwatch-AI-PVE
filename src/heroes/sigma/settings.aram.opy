#!mainFile "../../aramMain.opy"

macro INIT_SIGMA_WORKSHOP_SETTINGS():
    SigmaBuff[0] = createWorkshopSettingInt("英雄：西格玛", "超能之球：基于当前生命值造成额外伤害 %", 50, 0, 200, 130) / 100
    SigmaBuff[1] = createWorkshopSettingInt("英雄：西格玛", "超能之球：额外伤害所需充能次数", 5, 0, 10, 131)

