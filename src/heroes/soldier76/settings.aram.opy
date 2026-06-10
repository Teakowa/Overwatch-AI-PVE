#!mainFile "../../aramMain.opy"

macro INIT_SOLDIER76_WORKSHOP_SETTINGS():
    S76Buff[0] = createWorkshopSettingInt("英雄：士兵 76", "生物力场：心之钢叠层间隔", 1, 0, 5, 124)
    S76Buff[1] = createWorkshopSettingInt("英雄：士兵 76", "生物力场：心之钢单次叠加生命值", 10, 0, 25, 125)
    S76Buff[2] = createWorkshopSettingInt("英雄：士兵 76", "生物力场：心之钢最大叠加生命值", 2500, 0, 5000, 126)
    S76Buff[3] = createWorkshopSettingInt("英雄：士兵 76", "辅助攻击：额外造成自身最大生命值伤害 %", 12, 0, 50, 127)
    S76Buff[4] = createWorkshopSettingInt("英雄：士兵 76", "辅助攻击：燃烧持续时间", 2, 0, 5, 128)

