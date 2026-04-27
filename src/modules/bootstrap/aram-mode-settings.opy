#!optimizeStrict

rule "Copyright (c) 2019-2025 他又（aka Teakowa）":
    disableInspector()
    Heros = getAllHeroes()
    Collaborator = ["他又"]
    Mark = " \r\n\r\n\n 非重装 AI 伤害减免 15%\r\n 重装 AI 最高伤害减免 30%\r\n 完整更新日志 workshop.codes/F288Z/update-log\r\n 中途退的会被永久BAN"
    #Setup Anti Crash
    ANTI_CRASH_ACTIVATE_PERCENT = createWorkshopSettingInt("Anti Crash", "激活阈值", 230, 0, 250)
    ANTI_CRASH_HOLD_TIME = createWorkshopSettingFloat("Anti Crash", "激活持续时间", 8, 0, 20, 1)
    ANTI_CRASH_DEACTIVATE_PERCENT = createWorkshopSettingInt("Anti Crash", "停用阈值", 180, 0, 250, 2)

rule "Initialize global variables":
    Debug_UltimateGain = createWorkshopSettingBool("Debug", "即时终极技能充能", false, 4)
    Hero_BAN[0] = createWorkshopSettingInt("模式", "初始随机英雄池：重装", 1, 1, 4, 11)
    CustomAIArray = [Hero.FREJA, Hero.VENTURE, Hero.PHARAH, Hero.ILLARI, Hero.JUNO, Hero.HAZARD, Hero.VENDETTA, Hero.EMRE, Hero.ANRAN]
    CustomAI = createWorkshopSettingEnum("模式", "自定义 AI", 0, ["弗蕾娅", "探奇", "法老之鹰", "伊拉锐", "朱诺", "骇灾", "斩仇", "埃姆雷", "安然"], 12)
    Hero_BAN[1] = createWorkshopSettingInt("模式", "初始随机英雄池：输出", 2, 1, 4, 12)
    Hero_BAN[2] = createWorkshopSettingInt("模式", "初始随机英雄池：支援", 1, 1, 4, 13)
    Hero_BAN[3] = createWorkshopSettingInt("模式", "扩展随机英雄池：重装", 2, 2, 6, 14)
    Hero_BAN[4] = createWorkshopSettingInt("模式", "扩展随机英雄池：输出", 3, 2, 8, 15)
    Hero_BAN[5] = createWorkshopSettingInt("模式", "扩展随机英雄池：支援", 2, 2, 6, 16)
    FalloffMin = [2.5, 2.5, 50, 8, 1, 10, 14, 22, 40, 18, 30, 10, 12.5, 25, 30, 10, 2.5, 3.75, 2.5, 23, 15, 100000000, 2.5, 20, 2.5, 17.5, 5.75, 15, 30, 25, 9.6, 15, 32, 2.5, 18, 9.75, 20, 30, 30, 15, 20, 2.5, 25]
    ProjectileSpeed = [100000000, 100000000, 100000000, 40, 100000000, 50, 70, 110, 100000000, 90, 100000000, 100000000, 100000000, 100000000, 100000000, 50, 80, 35, 100000000, 115, 75, 100000000, 100000000, 100, 80, 100000000, 100000000, 100000000, 100000000, 100000000, 48, 75, 160, 100000000, 90, 80, 100, 100000000, 100000000, 50, 100000000, 140, 625]
