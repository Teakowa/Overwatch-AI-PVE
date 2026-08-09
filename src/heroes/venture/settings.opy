#!mainFile "../../main.opy"

globalvar VentureBuff 48

macro INIT_VENTURE_WORKSHOP_SETTINGS():
    VentureBuff[0] = createWorkshopSettingInt("英雄：探奇", "遁地：额外移动速度 %", 56, 0, 100, 149)
