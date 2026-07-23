#!mainFile "../../aramMain.opy"

macro INIT_RAMATTRA_WORKSHOP_SETTINGS():
    Ram_Annihilation[0] = createWorkshopSettingInt("英雄：拉玛刹", "天罚形态：铁臂：最大临时生命值", 400, 0, 1000, 100)
    Ram_Annihilation[1] = createWorkshopSettingInt("英雄：拉玛刹", "诛 （终极技能）基于已造成伤害的百分比回复 ", 100, 0, 500, 101) / 100
    Ram_Annihilation[2] = createWorkshopSettingInt("英雄：拉玛刹", "诛 （终极技能）额外造成伤害 %", 30, 0, 100, 101)
    Ram_Annihilation[3] = createWorkshopSettingInt("英雄：拉玛刹", "诛 （终极技能）移动速度加成 %", 25, 0, 100, 102)
    Ram_Annihilation[4] = createWorkshopSettingInt("英雄：拉玛刹", "诛 （终极技能）受到伤害减免 %", 20, 0, 99, 103)
