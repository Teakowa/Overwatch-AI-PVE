#!mainFile "../../aramMain.opy"

macro INIT_ROADHOG_WORKSHOP_SETTINGS():
    RoadhogBuff[0] = createWorkshopSettingInt("英雄：路霸", "吸气：每次治疗为队友恢复生命值", ROADHOG_ARAM_ABILITY2_HEAL, 0, 200, 176)
    RoadhogBuff[1] = createWorkshopSettingInt("英雄：路霸", "毒雾喷吐：每次治疗生命值", ROADHOG_ARAM_SECONDARY_FIRE_HEAL, 0, 200, 177)
