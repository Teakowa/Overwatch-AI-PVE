#!mainFile "../../main.opy"

macro INIT_MOIRA_WORKSHOP_SETTINGS():
    MoiraBuff[0] = createWorkshopSettingFloat("英雄：莫伊拉", "技能期间：回复已损失生命值 %", 45, 0, 100, 146) / 100
