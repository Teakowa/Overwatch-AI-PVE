#!mainFile "../../main.opy"

macro INIT_GENJI_WORKSHOP_SETTINGS():
    Genji[0] = createWorkshopSettingInt("英雄：源氏", "分数", GENJI_SCORE_DEFAULT, GENJI_SCORE_MIN, GENJI_SCORE_MAX, 60)
    Genji[1] = createWorkshopSettingInt("英雄：源氏", "龙刃：额外造成伤害 %", GENJI_DRAGONBLADE_DAMAGE_PERCENT_DEFAULT, GENJI_DRAGONBLADE_DAMAGE_PERCENT_MIN, GENJI_DRAGONBLADE_DAMAGE_PERCENT_MAX, 61)

