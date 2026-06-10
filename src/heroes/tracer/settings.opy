#!mainFile "../../main.opy"

macro INIT_TRACER_WORKSHOP_SETTINGS():
    Tracer_Ability[0] = createWorkshopSettingBool("英雄：猎空", "猎空：参与击杀后重置技能冷却", true, 113)
    Tracer_Ability[1] = createWorkshopSettingBool("英雄：猎空", "猎空：参与击杀后回复已损失生命值", true, 114)

