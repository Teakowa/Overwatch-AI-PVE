#!mainFile "../../aramMain.opy"
#!optimizeStrict

rule "Copyright (c) 2019-2025 他又（aka Teakowa）":
    disableInspector()
    Heros = getAllHeroes()
    Collaborator = ["他又"]
    Mark = " \r\n\r\n\n 非重装 AI 伤害减免 15%\r\n 重装 AI 最高伤害减免 30%\r\n 完整更新日志 workshop.codes/F288Z/update-log\r\n 中途退的会被永久BAN"
    ANTI_CRASH_ACTIVATE_PERCENT = ANTI_CRASH_ACTIVATE_DEFAULT
    ANTI_CRASH_HOLD_TIME = ANTI_CRASH_HOLD_DEFAULT
    ANTI_CRASH_DEACTIVATE_PERCENT = ANTI_CRASH_DEACTIVATE_DEFAULT

rule "Initialize global variables":
    Debug_UltimateGain = false
    Hero_BAN[0] = createWorkshopSettingInt("模式", "初始随机英雄池：重装", 1, 1, 4, 11)
    CustomAI = createWorkshopSettingEnum("模式", "自定义 AI", 0, ["弗蕾娅", "探奇", "法老之鹰", "伊拉锐", "朱诺", "骇灾", "斩仇", "埃姆雷", "安燃", "金驭", "西拉", "死怨"], 12)
    Hero_BAN[1] = createWorkshopSettingInt("模式", "初始随机英雄池：输出", 2, 1, 4, 12)
    Hero_BAN[2] = createWorkshopSettingInt("模式", "初始随机英雄池：支援", 1, 1, 4, 13)
    Hero_BAN[3] = 2
    Hero_BAN[4] = 3
    Hero_BAN[5] = 2
    FalloffMin = [2.5, 2.5, 50, 8, 1, 10, 14, 22, 40, 18, 30, 10, 12.5, 25, 30, 10, 2.5, 3.75, 2.5, 23, 15, 100000000, 2.5, 20, 2.5, 17.5, 5.75, 15, 30, 25, 9.6, 15, 32, 2.5, 18, 9.75, 20, 30, 30, 15, 20, 2.5, 25]
    ProjectileSpeed = [100000000, 100000000, 100000000, 40, 100000000, 50, 70, 110, 100000000, 90, 100000000, 100000000, 100000000, 100000000, 100000000, 50, 80, 35, 100000000, 115, 75, 100000000, 100000000, 100, 80, 100000000, 100000000, 100000000, 100000000, 100000000, 48, 75, 160, 100000000, 90, 80, 100, 100000000, 100000000, 50, 100000000, 140, 625]
    BotHeroArray = [Hero.TRACER, Hero.REAPER, Hero.WIDOWMAKER, Hero.PHARAH, Hero.REINHARDT, Hero.MERCY, Hero.TORBJORN, Hero.HANZO, Hero.WINSTON, Hero.ZENYATTA, Hero.BASTION, Hero.SYMMETRA, Hero.ZARYA, Hero.CASSIDY, Hero.SOLDIER, Hero.LUCIO, Hero.ROADHOG, Hero.JUNKRAT, Hero.DVA, Hero.MEI, Hero.GENJI, Hero.ANA, Hero.SOMBRA, Hero.ORISA, Hero.DOOMFIST, Hero.MOIRA, Hero.BRIGITTE, Hero.WRECKING_BALL, Hero.ASHE, Hero.BAPTISTE, Hero.SIGMA, Hero.ECHO, Hero.SOJOURN, Hero.JUNKER_QUEEN, Hero.KIRIKO, Hero.RAMATTRA, Hero.LIFEWEAVER, Hero.ILLARI, Hero.MAUGA, Hero.VENTURE, Hero.JUNO, Hero.HAZARD, Hero.FREJA]
    CustomAIArray = [Hero.FREJA, Hero.VENTURE, Hero.PHARAH, Hero.ILLARI, Hero.JUNO, Hero.HAZARD, Hero.VENDETTA, Hero.EMRE, Hero.ANRAN, Hero.DOMINA, Hero.SIERRA, Hero.SHION]
