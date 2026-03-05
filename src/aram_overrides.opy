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
    #随机禁用英雄池中的4名英雄（1 重装 2输出 1辅助）
    Hero_BAN[0] = createWorkshopSettingInt("模式", "初始随机英雄池：重装", 1, 1, 4, 11)
    CustomAIArray = [Hero.FREJA, Hero.VENTURE, Hero.PHARAH, Hero.ILLARI, Hero.JUNO, Hero.HAZARD, Hero.VENDETTA]
    CustomAI = createWorkshopSettingEnum("模式", "自定义 AI", 0, ["弗蕾娅", "探奇", "法老之鹰", "伊拉锐", "朱诺", "骇灾", "斩仇"], 12)
    Hero_BAN[1] = createWorkshopSettingInt("模式", "初始随机英雄池：输出", 2, 1, 4, 12)
    Hero_BAN[2] = createWorkshopSettingInt("模式", "初始随机英雄池：支援", 1, 1, 4, 13)
    Hero_BAN[3] = createWorkshopSettingInt("模式", "扩展随机英雄池：重装", 2, 2, 6, 14)
    Hero_BAN[4] = createWorkshopSettingInt("模式", "扩展随机英雄池：输出", 3, 2, 8, 15)
    Hero_BAN[5] = createWorkshopSettingInt("模式", "扩展随机英雄池：支援", 2, 2, 6, 16)
    #AI/Script Initial
    FalloffMin = [2.5, 2.5, 50, 8, 1, 10, 14, 22, 40, 18, 30, 10, 12.5, 25, 30, 10, 2.5, 3.75, 2.5, 23, 15, 100000000, 2.5, 20, 2.5, 17.5, 5.75, 15, 30, 25, 9.6, 15, 32, 2.5, 18, 9.75, 20, 30, 30, 15, 20, 2.5, 25]
    ProjectileSpeed = [100000000, 100000000, 100000000, 40, 100000000, 50, 70, 110, 100000000, 90, 100000000, 100000000, 100000000, 100000000, 100000000, 50, 80, 35, 100000000, 115, 75, 100000000, 100000000, 100, 80, 100000000, 100000000, 100000000, 100000000, 100000000, 48, 75, 160, 100000000, 90, 80, 100, 100000000, 100000000, 50, 100000000, 140, 625]

rule "Initialize Hero Ability Settings":
    #Brigitte_RepairPacksArmor
    Brigitte[1] = createWorkshopSettingInt("英雄：布丽吉塔", "恢复包：提供的护甲", 150, 0, 200, 31)
    Brigitte[3] = createWorkshopSettingInt("英雄：布丽吉塔", "能量盾击：使敌人减速 %", 90, 0, 90, 32)
    #Brigitte_RallyArmor
    Brigitte[2] = createWorkshopSettingInt("英雄：布丽吉塔", "集结号令：每秒额外护甲", 25, 0, 150, 34)
    Brigitte[0] = createWorkshopSettingInt("英雄：布丽吉塔", "集结号令：每秒伤害减免", 2, 0, 5, 33)
    MercyBuff[0] = createWorkshopSettingInt("英雄：天使", "女武神：伤害减免", 35, 0, 90, 40)
    HazardBuff[0] = createWorkshopSettingInt("英雄：骇灾", "狂跃：造成目标最大生命值的额外伤害 %", 30, 0, 500, 70) / 100
    HazardBuff[1] = createWorkshopSettingFloat("英雄：骇灾", "灾厄馈赠（被动）：基于受到伤害获得终极技能充能 %", 2.5, 0, 500, 70)
    HazardBuff[2] = createWorkshopSettingInt("英雄：骇灾", "灾厄馈赠（被动）：基于受到原始伤害（未被减伤）回复生命值 %", 80, 0, 500, 70) / 100
    Orisa_Fortify[0] = createWorkshopSettingInt("英雄：奥丽莎", "强固防御获得的临时护甲", 100, 0, 200, 50)
    #Orisa_FortifyRicochet
    Orisa_Fortify[1] = createWorkshopSettingInt("英雄：奥丽莎", "强固防御反弹伤害比例", 50, 0, 100, 51)
    Orisa_Fortify[2] = createWorkshopSettingInt("英雄：奥丽莎", "能量标枪：使敌人减速 %", 70, 0, 90, 31)
    Genji[0] = createWorkshopSettingInt("英雄：源氏", "分数", 1500, 500, 5000, 60)
    Genji[1] = createWorkshopSettingInt("英雄：源氏", "龙刃：额外造成伤害 %", 50, 0, 100, 61)
    Zen_KnockupStrength = createWorkshopSettingFloat("英雄：禅雅塔", "无影脚击退距离", 15.5, 0, 100, 71)
    #Ram_AnnihilationDamage
    Ram_Annihilation[0] = createWorkshopSettingInt("英雄：拉玛刹", "天罚形态：铁臂：最大临时生命值", 400, 0, 1000, 100)
    Ram_Annihilation[1] = createWorkshopSettingInt("英雄：拉玛刹", "天罚形态：猛拳：基于已造成伤害的百分比回复 ", 100, 0, 500, 101) / 100
    Ram_Annihilation[5] = createWorkshopSettingInt("英雄：拉玛刹", "诛 （终极技能）额外造成伤害 %", 30, 0, 100, 101)
    #Ram_AnnihilationSpeed
    Ram_Annihilation[3] = createWorkshopSettingInt("英雄：拉玛刹", "诛 （终极技能）移动速度加成 %", 25, 0, 100, 102)
    Ram_Annihilation[4] = createWorkshopSettingInt("英雄：拉玛刹", "诛 （终极技能）受到伤害减免 %", 20, 0, 99, 103)
    Ana_GrenadeDamage[0] = createWorkshopSettingInt("英雄：安娜", "生物手雷：额外最大生命值伤害 %", 15, 0, 20, 104)
    Ana_GrenadeDamage[1] = createWorkshopSettingInt("英雄：安娜", "生物手雷：额外最大生命值治疗 %", 8, 0, 20, 105) / 100
    #SojournBuffHP
    SojournBuff[0] = createWorkshopSettingInt("英雄：索杰恩", "处决生命值低于 % 的英雄", 15, 0, 30, 105) / 100
    #SojournBuffDamage
    SojournBuff[1] = createWorkshopSettingInt("英雄：索杰恩", "处决造成的伤害", 44444, 44444, 99999, 106)
    SojournBuff[3] = createWorkshopSettingInt("英雄：索杰恩", "机体超频： 流血伤害", 25, 0, 90, 108)
    #Sombra_HackHealRec
    SombraBuff[0] = createWorkshopSettingInt("英雄：黑影", "黑客入侵减少治疗量 %", 50, 0, 50, 111)
    #Tracer_KillResetCooldown
    Tracer_Ability[0] = createWorkshopSettingBool("英雄：猎空", "猎空：参与击杀后重置技能冷却", true, 113)
    #Tracer_KillHeal
    Tracer_Ability[1] = createWorkshopSettingBool("英雄：猎空", "猎空：参与击杀后回复已损失生命值", true, 114)
    ZaryaBuff[0] = createWorkshopSettingInt("英雄：查莉娅", "投射屏障 为目标提供的临时生命值", 100, 0, 150, 117)
    ZaryaBuff[1] = createWorkshopSettingInt("英雄：查莉娅", "重力喷涌 使目标减速 %", 70, 0, 90, 117)
    ZaryaBuff[2] = createWorkshopSettingBool("英雄：查莉娅", "胜利意志（被动）", true, 115)
    ZaryaBuff[3] = createWorkshopSettingInt("英雄：查莉娅", "胜利意志（被动） 持续时间", 30, 0, 60, 116)
    ZaryaBuff[4] = createWorkshopSettingInt("英雄：查莉娅", "胜利意志（被动） 每秒治疗量", 35, 0, 60, 116)
    IllariBuff = createWorkshopSettingFloat("英雄：伊拉锐", "桎梏灼日 额外伤害增幅 %", 5, 0, 20, 118) / 100
    ReaperBuff[0] = createWorkshopSettingInt("英雄：死神", "收割：击杀获得灵魂层数", 1, 0, 5, 119)
    ReaperBuff[1] = createWorkshopSettingFloat("英雄：死神", "收割：每层灵魂减少技能冷却", 0.08, 0, 0.1, 119)
    ReaperBuff[2] = createWorkshopSettingInt("英雄：死神", "幽灵形态：基础伤害增幅 %", 20, 0, 30, 119)
    ReaperBuff[3] = createWorkshopSettingInt("英雄：死神", "幽灵形态：灵魂层数提供伤害增幅 %", 2, 0, 5, 119)
    ReaperBuff[4] = createWorkshopSettingInt("英雄：死神", "暗影步：基础伤害减免 %", 10, 0, 25, 119)
    ReaperBuff[5] = createWorkshopSettingInt("英雄：死神", "暗影步：灵魂层数提供伤害减免 %", 1, 0, 1.5, 119)
    ReaperBuff[6] = createWorkshopSettingFloat("英雄：死神", "恐怖扳机：冷却时间", 1.5, 0, 3, 119)
    ReaperBuff[7] = createWorkshopSettingFloat("英雄：死神", "恐怖扳机：基于灵魂层数造成流血伤害", 1, 0, 3, 119) / 2
    ReaperBuff[8] = createWorkshopSettingInt("英雄：死神", "死亡绽放：灵魂层数提供伤害增幅 %", 1, 0, 5, 119)
    MaugaBuff[0] = createWorkshopSettingInt("英雄：毛加", "狂战士之魂：额外最大生命值 %", 200, 0, 500, 122) / 100
    MaugaBuff[1] = createWorkshopSettingInt("英雄：毛加", "狂战士之魂：额外伤害减免 %", 40, 0, 80, 123)
    MaugaBuff[2] = createWorkshopSettingInt("英雄：毛加", "狂战士之魂：额外伤害增幅 %", 150, 0, 300, 120)
    MaugaBuff[5] = createWorkshopSettingInt("英雄：毛加", "狂战士之魂：击退抵抗 %", 80, 0, 80, 122)
    MaugaBuff[6] = createWorkshopSettingInt("英雄：毛加", "狂战士之魂：每秒损失最大生命值 %", 20, 0, 80, 122) / 100
    MaugaBuff[7] = createWorkshopSettingInt("英雄：毛加", "狂战士之魂：击杀回复最大生命值 %", 30, 0, 80, 122) / 100
    MaugaBuff[3] = createWorkshopSettingInt("英雄：毛加", "蛮力冲撞：被击倒的敌人造成最大生命值伤害 %", 5, 0, 50, 122) / 100
    MaugaBuff[4] = createWorkshopSettingFloat("英雄：毛加", "心脏过载：额外伤害减免", 25, 0, 50, 121)
    S76Buff[0] = createWorkshopSettingInt("英雄：士兵 76", "疾跑：心之钢冷却", 5, 0, 5, 124)
    S76Buff[1] = createWorkshopSettingInt("英雄：士兵 76", "疾跑：心之钢单次叠加生命值", 10, 0, 25, 125)
    S76Buff[2] = createWorkshopSettingInt("英雄：士兵 76", "疾跑：心之钢最大叠加生命值", 2500, 0, 5000, 126)
    S76Buff[3] = createWorkshopSettingInt("英雄：士兵 76", "疾跑：灼烧最大生命值伤害 %", 5, 0, 10, 127) / 100
    S76Buff[4] = createWorkshopSettingFloat("英雄：士兵 76", "疾跑：灼烧范围", 6.5, 0, 10, 128)
    SigmaBuff[0] = createWorkshopSettingInt("英雄：西格玛", "超能之球：基于当前生命值造成额外伤害 %", 50, 0, 200, 130) / 100
    SigmaBuff[1] = createWorkshopSettingInt("英雄：西格玛", "超能之球：额外伤害所需充能次数", 5, 0, 10, 131)
    JunoBuff = createWorkshopSettingInt("英雄：朱诺", "轨道射线：友方英雄伤害减免 %", 80, 0, 200, 130)
    DoomBuff[0] = createWorkshopSettingFloat("英雄：末日铁拳", "悍猛格挡：伤害吸收倍率", 7, 0, 10, 131)
    DoomBuff[1] = createWorkshopSettingInt("英雄：末日铁拳", "悍猛格挡：最大吸收伤害", 1800, 0, 1800, 132) + 0.001
    FrejaBuff[0] = createWorkshopSettingInt("英雄：弗蕾娅", "无情猎杀：每层伤害", 25, 0, 75, 133)
    FrejaBuff[1] = createWorkshopSettingInt("英雄：弗蕾娅", "无情猎杀：最大生命值百分比伤害", 5, 0, 50, 134) / 100
    FrejaBuff[2] = createWorkshopSettingInt("英雄：弗蕾娅", "无情猎杀：斩杀阈值", 20, 0, 40, 135) / 100
    WuyangBuff[0] = createWorkshopSettingInt("英雄：无漾", "玄武杖：水珠爆炸减速 %", 30, 0, 70, 136)
    WuyangBuff[1] = createWorkshopSettingInt("英雄：无漾", "养神泉：泉水提供的额外护盾", 75, 0, 300, 137)
    WuyangBuff[2] = createWorkshopSettingInt("英雄：无漾", "飞流步：每秒自我治疗", 50, 0, 300, 138)
    WuyangBuff[3] = createWorkshopSettingInt("英雄：无漾", "飞流步：伤害减免", 30, 0, 90, 139)
    WuyangBuff[4] = createWorkshopSettingInt("英雄：无漾", "惊涛波：爆炸减速 %", 70, 0, 90, 140)
    WuyangBuff[5] = createWorkshopSettingInt("英雄：无漾", "惊涛波：友方每秒额外生命值回复 %", 15, 0, 50, 141) / 100
    #Setup Headshot Damage
    HeadshotDamage[0] = createWorkshopSettingFloat("暴击倍率", "禅雅塔：暴击倍率（以下实际数值将被除以100）", 250, 200, 300, 70) / 100
    #AshHeadshotDamage
    HeadshotDamage[1] = createWorkshopSettingFloat("暴击倍率", "艾什：暴击倍率", 275, 200, 300, 107) / 100
    HeadshotDamage[3] = createWorkshopSettingFloat("暴击倍率", "半藏：暴击倍率", 275, 200, 300, 107) / 100
    #Baptiste_HeadshotDamage
    HeadshotDamage[4] = createWorkshopSettingFloat("暴击倍率", "巴蒂斯特：暴击倍率", 250, 200, 300, 110) / 100
    HeadshotDamage[2] = createWorkshopSettingFloat("暴击倍率", "雾子：暴击倍率", 250, 200, 300, 110) / 100
    VendettaBuff[0] = createWorkshopSettingInt("英雄：斩仇", "帕拉蒂尼之牙：暴击造成额外最大生命值伤害 %", 8, 0, 30, 150) / 100
    VendettaBuff[1] = createWorkshopSettingInt("英雄：斩仇", "帕拉蒂尼之牙：暴击对护甲造成额外最大生命值伤害 %", 16, 0, 50, 150) / 100
    VendettaBuff[2] = createWorkshopSettingInt("英雄：斩仇", "旋风疾步：命中敌人回复已损失生命值 %", 40, 0, 100, 152) / 100
    VendettaBuff[3] = createWorkshopSettingInt("英雄：斩仇", "旋风疾步：对护甲造成额外伤害", 25, 0, 50, 153)
    VendettaBuff[4] = createWorkshopSettingFloat("英雄：斩仇", "斩地巨剑：击倒持续时间", 3.5, 0, 5, 154)
    VendettaBuff[5] = createWorkshopSettingInt("英雄：斩仇", "斩地巨剑：斩杀阈值 %", 20, 0, 40, 155) / 100
    VendettaBuff[6] = createWorkshopSettingInt("英雄：斩仇", "帕拉蒂尼之牙：暴击回复最大生命值 %", 40, 0, 80, 150) / 100

rule "[Anti Crash]: Activate anti crash":
    @Condition getServerLoad() > ANTI_CRASH_ACTIVATE_PERCENT
    
    wait(ANTI_CRASH_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    smallMessage(getAllPlayers(), "  服务器过载  ")
    setSlowMotion(1)
    wait(0.5)
    waitUntil(getServerLoad() < ANTI_CRASH_DEACTIVATE_PERCENT, 999999986991104)
    setSlowMotion(100)

rule "[Player] Override allowed heroes list when player joins lobby":
    @Event eachPlayer
    @Team 2
    @Disabled
    
    eventPlayer.setAllowedHeroes(Heros)

rule "[Player]: Override allowed heroes list when player joins lobby":
    @Event playerJoined
    @Team 2
    
    eventPlayer.heros = [random.shuffle(getTankHeroes().exclude(Hero.WINSTON)).slice(0, Hero_BAN[0]), random.shuffle(getDamageHeroes()).slice(0, Hero_BAN[1]), random.shuffle(getSupportHeroes()).slice(0, Hero_BAN[2])]
    eventPlayer.setAllowedHeroes(eventPlayer.heros)
    wait(0.16)
    eventPlayer.hudText = ""

#!include "modules/bootstrap/player-hud-text-init.opy"

rule "[Player]: when game star lock hero":
    @Event eachPlayer
    @Team 2
    @Condition isGameInProgress() == true
    @Condition isTeamOnDefense(eventPlayer.getTeam()) == false
    @Condition eventPlayer.extra_hero != true
    
    eventPlayer.heros = [eventPlayer.getHero()]
    eventPlayer.setAllowedHeroes(eventPlayer.heros)

rule "[Player]: Dead count":
    @Event playerDied
    @Team 2
    @Condition isGameInProgress() == true
    @Condition eventPlayer.extra_hero != true
    @Condition eventPlayer.getStatistic(Stat.DEATHS) >= 2
    
    waitUntil(eventPlayer.isInSpawnRoom(), 8)
    eventPlayer.extra_hero = true

rule "[Player]: extra hero pick when dead & attack":
    @Event eachPlayer
    @Team 2
    @Condition isTeamOnOffense(Team.2) == true
    @Condition (eventPlayer.getStatistic(Stat.DEATHS) >= 2 or eventPlayer.extra_hero) == true
    
    eventPlayer.heros = []
    #eventPlayer.heros = [eventPlayer.getHero()]
    wait(0.16)
    setPlayerHeros()

rule "[Player]: extra hero pick when dead & defense":
    @Event eachPlayer
    @Team 2
    @Condition (isTeamOnDefense(Team.2) or isMatchBetweenRounds() or getMatchRound() > 1) == true
    @Condition (eventPlayer.getStatistic(Stat.DEATHS) >= 2 or eventPlayer.extra_hero) == true
    
    eventPlayer.heros = []
    #eventPlayer.heros = [eventPlayer.getHero()]
    wait(0.16)
    setPlayerHeros()

rule "[Player]: extra hero pick when refresh & defense":
    @Event eachPlayer
    @Team 2
    @Condition isTeamOnDefense(Team.2) == true
    @Condition (eventPlayer.getStatistic(Stat.DEATHS) >= 2 or eventPlayer.extra_hero) == true
    
    eventPlayer.heros = []
    #eventPlayer.heros = [eventPlayer.getHero()]
    wait(0.16)
    setPlayerHeros()

def setPlayerHeros():
    @Name "[Player]: set extra hero"
    
    wait(0.16)
    eventPlayer.heros = [random.shuffle(getTankHeroes()).slice(0, Hero_BAN[3]), random.shuffle(getDamageHeroes()).slice(0, Hero_BAN[4]), random.shuffle(getSupportHeroes()).slice(0, Hero_BAN[5]), eventPlayer.getHero()]
    eventPlayer.setAllowedHeroes(eventPlayer.heros)
    smallMessage(eventPlayer, "  {0} 扩展英雄池已开启".format(iconString(Icon.RECYCLE)))

def setThirdPerson():
    @Name "[utilities/Player]: Set Third Person"
    
    eventPlayer.startCamera(updateEveryFrame(raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + worldVector(vect(1 * (min(-2.5 / 2.5, -0.75)), 0, 0), eventPlayer, Transform.ROTATION) + updateEveryFrame(eventPlayer.getFacingDirection() * -2.5), getAllPlayers(), eventPlayer, false).getHitPosition()), updateEveryFrame(raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 200, getAllPlayers(), eventPlayer, false).getHitPosition()), 60)
    eventPlayer.startCamera(raycast(eventPlayer + (Vector.UP * (distance(eventPlayer.getEyePosition(), eventPlayer) + 0.5)), raycast(eventPlayer + (Vector.UP * (distance(eventPlayer.getEyePosition(), eventPlayer) + 1)), eventPlayer + (Vector.UP * (distance(eventPlayer.getEyePosition(), eventPlayer) + 0.8)) + eventPlayer.getFacingDirection() * -2, null, eventPlayer, true).getHitPosition(), null, eventPlayer, true).getHitPosition(), eventPlayer + eventPlayer.getFacingDirection() * 50, 100)
    waitUntil(eventPlayer.third_person != true, 999999986991104)
    eventPlayer.stopCamera()

rule "[utilities/reset]: setup var when player joins lobby":
    @Event eachPlayer
    
    resetFrenemies()

rule "[utilities/reset]: Default respawn time":
    @Event eachPlayer
    @Team 1
    
    eventPlayer.setRespawnTime(2)

rule "[utilities/reset]: Default respawn time":
    @Event eachPlayer
    @Team 2
    
    eventPlayer.setRespawnTime(5)

rule "[utilities/reset]: reset when died":
    @Event playerDied
    
    eventPlayer.hudText = ""
    eventPlayer.has_nano = false
    eventPlayer.zarya_buff[0] = true
    eventPlayer.zarya_buff[1] = null
    eventPlayer.ram_block_damage = 0
    eventPlayer.sigma_hyperspheres = 0
    eventPlayer.doom_buff = 0
    stopAllHealingModifications()
    resetStats()
    resetStatuses()
    resetFrenemies()

rule "[reset.opy]: Reinitialize hero on new round":
    @Event eachPlayer
    @Condition isMatchBetweenRounds() == true
    @Condition eventPlayer.getHero() != Hero.SOMBRA
    
    eventPlayer.extra_hero = true
    waitUntil(not isMatchBetweenRounds(), 999999986991104)
    wait(1)
    resetHero()
    eventPlayer.reset_pvar[0] = true
    logToInspector("called init after new round")

rule "[utilities/hero_setup.opy]: Reset and initialize hero on hero switch":
    @Event eachPlayer
    @Condition eventPlayer.reset_pvar[0] != false
    
    #wait(10 * TICK_DURATION)
    eventPlayer.ram_block_damage = 0
    eventPlayer.sigma_hyperspheres = 0
    destroyHudText(eventPlayer.ChangelogText1)
    destroyHudText(eventPlayer.ChangelogText2)
    resetHero()

def clearCustomHp():
    @Name "[custom_hp.opy]: clearCustomHp()"
    
    eventPlayer.removeAllHealthPools()
    wait()
    eventPlayer.setMaxHealth(100)
    wait()
    eventPlayer.custom_hp_pvar[0] = 0
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    eventPlayer.custom_hp_pvar[3] = eventPlayer.getMaxHealthOfType(Health.NORMAL)
    eventPlayer.custom_hp_pvar[4] = eventPlayer.getMaxHealthOfType(Health.ARMOR)
    eventPlayer.custom_hp_pvar[5] = eventPlayer.getMaxHealthOfType(Health.SHIELDS)
    eventPlayer.custom_hp_pvar[6] = 1

def applyCustomHp():
    @Name "[custom_hp.opy]: applyCustomHp()"
    @Delimiter

#!include "modules/ai/core/10-core-global-and-targeting.opy"
#!include "modules/ai/movement/20-movement.opy"
#!include "modules/ai/control/30-control-tracer-reaper-genji.opy"
#!include "modules/ai/control/31-control-supports.opy"
#!include "modules/ai/control/32-control-tanks.opy"
#!include "modules/ai/control/33-control-projectile-and-special.opy"

rule "[Brigitte]: remove Rally provides permanent armor":
    @Event eachPlayer
    @Condition Brigitte[2] != 0
    @Condition getPlayersOnHero(Hero.BRIGITTE, eventPlayer.getTeam())[0].isUsingUltimate() == true
    
    waitUntil(not eventPlayer.reset_pvar[1].isUsingUltimate() and eventPlayer.brig_rally_armor_id != [], 60)
    wait(2)
    removeHealthPool(eventPlayer.brig_rally_armor_id[0])
    eventPlayer.brig_rally_armor_id.remove(eventPlayer.brig_rally_armor_id[0])
    if len(eventPlayer.brig_rally_armor_id) != 0:
        loop()
    eventPlayer.brig_rally_armor_id = []
    eventPlayer.dmg_reduction = 0
    eventPlayer.hudText = ""
    eventPlayer.setDamageReceived(100)
    #if eventPlayer.getHero() != Hero.BRIGITTE:
    #        goto lbl_0
    #stopDamageModification(eventPlayer.brig_rally_dmg_redc[1])
    #eventPlayer.brig_rally_dmg_redc[0] = 0
    #eventPlayer.brig_rally_dmg_redc[1] = 0
    lbl_0:

rule "[Brigitte]Rally provides permanent armor to self":
    @Event eachPlayer
    @Hero brigitte
    @Condition Brigitte[2] != 0
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition len(eventPlayer.brig_rally_armor_id) < 9
    @Condition getServerLoad() < ANTI_CRASH_DEACTIVATE_PERCENT
    
    #stopDamageModification(eventPlayer.brig_rally_dmg_redc[1])
    eventPlayer.dmg_reduction += Brigitte[0]
    eventPlayer.setDamageReceived(100 - eventPlayer.dmg_reduction)
    eventPlayer.hudText = "受到伤害减免：{0}%".format(eventPlayer.dmg_reduction)
    eventPlayer.addHealthPool(Health.ARMOR, Brigitte[2], false, false)
    #eventPlayer.brig_rally_dmg_redc[0] += Brigitte[0]
    eventPlayer.brig_rally_armor_id.append(getLastCreatedHealthPool())
    #startDamageModification(eventPlayer, getPlayers(getOppositeTeam(eventPlayer.getTeam())), 100 - eventPlayer.brig_rally_dmg_redc[0], DamageReeval.RECEIVERS_AND_DAMAGERS)
    #eventPlayer.brig_rally_dmg_redc[1] = getLastDamageModification()
    wait(0.5)
    if ruleCondition:
        loop()

rule "[Brigitte]Rally provides permanent armor to allies":
    @Event eachPlayer
    @Team 2
    @Condition getPlayersOnHero(Hero.BRIGITTE, eventPlayer.getTeam()).isUsingUltimate() == true
    @Condition distance(eventPlayer, getPlayersOnHero(Hero.BRIGITTE, eventPlayer.getTeam())) <= 8.5
    @Condition eventPlayer.getHero() != Hero.BRIGITTE
    @Condition len(eventPlayer.brig_rally_armor_id) < 9
    @Condition getServerLoad() < ANTI_CRASH_DEACTIVATE_PERCENT
    
    eventPlayer.addHealthPool(Health.ARMOR, Brigitte[2], false, false)
    eventPlayer.brig_rally_armor_id.append(getLastCreatedHealthPool())
    wait(0.5)
    if ruleCondition:
        loop()

rule "[Orisa]: Fortify provides 100 temporary armor":
    @Event eachPlayer
    @Hero orisa
    @Condition Orisa_Fortify[0] != 0
    @Condition any([i == true for i in [eventPlayer.isUsingAbility1(), eventPlayer.isUsingUltimate()]]) == true
    
    wait(0.16)
    eventPlayer.unaffected = true
    eventPlayer.hazard_buff[0] = false
    eventPlayer.zarya_graviton_buff[0] = false
    eventPlayer.brigitte_buff[0] = false
    eventPlayer.orisa_buff = false
    eventPlayer.addHealthPool(Health.ARMOR, Orisa_Fortify[0], true, false)
    eventPlayer.orisa_fortify_armor_id = getLastCreatedHealthPool()
    eventPlayer.startHealingOverTime(eventPlayer, eventPlayer.getMaxHealth() * 0.1, 4)
    if eventPlayer.isUsingAbility1() == true:
        waitUntil(not eventPlayer.isUsingAbility1(), 999999986991104)
    else:
        waitUntil(not eventPlayer.isUsingUltimate(), 999999986991104)
    removeHealthPool(eventPlayer.orisa_fortify_armor_id)
    eventPlayer.unaffected = false

rule "[Mauga]: Fortify provides 100 temporary armor":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.unaffected = true
    eventPlayer.hazard_buff[0] = false
    eventPlayer.brigitte_buff[0] = false
    eventPlayer.orisa_buff = false
    eventPlayer.zarya_graviton_buff[0] = false
    waitUntil(not eventPlayer.isUsingAbility1(), 3)
    eventPlayer.unaffected = false

#!include "aram_overrides_segments/hero_rules_mercy_valkyrie_refresh_rez.opy"

rule "[Ana]: Headhunter":
    @Event playerDealtDamage
    @Team 2
    @Hero ana
    @Condition eventWasCriticalHit == true
    @Disabled
    
    if eventPlayer.getNormalizedHealth() != 1:
        eventPlayer.startHealingOverTime(eventPlayer, 0.625, ceil(eventDamage * 31.25 * 10))
    else:
        ([player for player in getLivingPlayers(eventPlayer.getTeam()) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) == true and player != eventPlayer]).startHealingOverTime(eventPlayer, 0.625, ceil(eventDamage * 31.25 * 10) / (len([player for player in getLivingPlayers(eventPlayer.getTeam()) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) == true and player != eventPlayer])))
    wait(0.625)

#!include "aram_overrides_segments/hero_rules_ana_biotic_and_full_health_nano_prep.opy"

rule "Has Nano":
    @Event playerReceivedHealing
    #This checks that the ability used to deal the healing is the ultimate.
    @Condition eventAbility == Button.ULTIMATE
    #This checks if the player who dealt the healing is Ana or an Echo duplicating an Ana.
    @Condition healer.getHero() == Hero.ANA
    @Condition eventPlayer.has_nano != true
    
    eventPlayer.has_nano = true
    waitUntil(eventPlayer.isDead(), 8)
    eventPlayer.has_nano = false

rule "[Ana] Biotic Grenade Hit for allies":
    @Event playerDealtHealing
    @Hero ana
    @Condition eventAbility == Button.ABILITY_2
    
    healee.startHealingOverTime(healer, 3, healee.getMaxHealth() * Ana_GrenadeDamage[1])

rule "[Ana] Nano Boost Healing":
    @Event playerDealtHealing
    @Hero ana
    @Condition eventAbility == Button.ULTIMATE
    @Condition healer.getHero() == Hero.ANA == true
    @Condition eventPlayer.has_nano == true
    
    heal(healee, healer, 99999)
    healee.startHealingOverTime(healer, 10, ceil(healee.getMaxHealth() * 0.2))

rule "[Ana] Nano Boost ":
    @Event eachPlayer
    @Condition eventPlayer.has_nano == true
    
    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 50)
    eventPlayer.dmg_reduction += 50
    smallMessage(eventPlayer, "  {0} 获得纳米激素额外减伤".format(abilityIconString(Hero.ANA, Button.ULTIMATE)))
    wait(10)
    eventPlayer.has_nano = false

rule "[Ana] Nano Boost ":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.has_nano == true
    @Condition eventPlayer.dmg_reduction > 0
    
    eventPlayer.setDamageReceived(100 - eventPlayer.dmg_reduction)
    eventPlayer.hudText = "受到伤害减免：{0}%".format(eventPlayer.dmg_reduction)
    wait(1)
    eventPlayer.dmg_reduction -= 5
    if ruleCondition:
        loop()
    eventPlayer.dmg_reduction = 0
    eventPlayer.has_nano = false
    eventPlayer.hudText = ""

rule "【布丽吉塔】盾击伤害调整":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition attacker.isFiringSecondaryFire() == true
    @Condition attacker.isUsingUltimate() != true
    
    victim.setStatusEffect(attacker, Status.STUNNED, 1.2)
    if victim.zarya_buff[1] != null or victim.unaffected == true:
        goto lbl_0
    victim.brigitte_buff[0] = true
    lbl_0:
    victim.mov_speed_penalty += Brigitte[3]

rule "[Brigitte]: speed":
    @Event eachPlayer
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.unaffected != true
    @Condition eventPlayer.brigitte_buff[0] == true
    
    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff - eventPlayer.mov_speed_penalty)
    waitUntil(not eventPlayer.brigitte_buff[0] or eventPlayer.mov_speed_penalty == 0 or eventPlayer.unaffected or eventPlayer.hasStatus(Status.INVINCIBLE), 1.5)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.brigitte_buff[0] = false
    eventPlayer.mov_speed_penalty = 0

#!include "aram_overrides_segments/hero_rules_brigitte_repair_pack_target_and_armor.opy"

rule "[brigitte/rally.opy]: Rally 30% speed boost":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate() == true
    
    #30% movement speed buff during ralley
    eventPlayer.mov_speed_buff += 13.043
    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff)
    waitUntil(not eventPlayer.isUsingUltimate(), 10)
    eventPlayer.mov_speed_buff = 0
    eventPlayer.setMoveSpeed(100)

#!include "aram_overrides_segments/hero_rules_kiriko_bot_ptp1_and_acc.opy"

rule "[Kiriko]: Protection Suzu Clear Effect":
    @Event playerDealtHealing
    @Hero kiriko
    @Condition eventAbility == Button.ABILITY_2
    #@Condition healer.getHero() == Hero.KIRIKO == true
    @Condition healee.mauga_berserker_soul != true
    
    if healee != healer:
        goto lbl_0
    resetStatuses()
    lbl_0:
    healee.unaffected = true
    healee.setStatusEffect(healer, Status.INVINCIBLE, 2.5)
    healee.setStatusEffect(healer, Status.PHASED_OUT, 2.5)
    wait(2.5)
    healee.unaffected = false

rule "[Kiriko]: Swift Step":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0
    
    resetStatuses()
    eventPlayer.setStatusEffect(eventPlayer, Status.INVINCIBLE, 2.5)
    eventPlayer.setStatusEffect(eventPlayer, Status.PHASED_OUT, 2.5)

rule "[kiriko]: swift step hp":
    @Event eachPlayer
    @Condition getPlayersOnHero(Hero.KIRIKO, eventPlayer.getTeam())[0].isHoldingButton(Button.ABILITY_1) == true
    @Condition getPlayersOnHero(Hero.KIRIKO, eventPlayer.getTeam())[0].isUsingAbility1() == true
    @Condition len(eventPlayer.kiriko_buff) < 5
    
    waitUntil(not eventPlayer.reset_pvar[3].isUsingAbility1() and len(getPlayersInRadius(eventPlayer.reset_pvar[3], 5, eventPlayer.getTeam(), LosCheck.SURFACES)) > 0 and eventPlayer.reset_pvar[3].hasStatus(Status.PHASED_OUT) == true, 0.5)
    wait(0.16)
    #if eventPlayer.kiriko_buff == null:
    #        goto lbl_0
    #removeHealthPool(eventPlayer.kiriko_buff[0])
    lbl_0:
    if not eventPlayer.isAlive() or distance(eventPlayer.reset_pvar[3], eventPlayer) > 5 and not isInLoS(eventPlayer.reset_pvar[3], eventPlayer):
        goto lbl_1
    eventPlayer.addHealthPool(Health.NORMAL, 100 + ceil(eventPlayer.getMaxHealth() * 0.15), false, false)
    #eventPlayer.kiriko_buff = getLastCreatedHealthPool()
    lbl_1:
    eventPlayer.kiriko_buff.append(getLastCreatedHealthPool())

rule "[kiriko]: remove swift step hp":
    @Event eachPlayer
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.kiriko_buff != []
    
    wait(3, Wait.ABORT_WHEN_FALSE)
    removeHealthPool(eventPlayer.kiriko_buff[0])
    eventPlayer.kiriko_buff.remove(eventPlayer.kiriko_buff[0])
    if len(eventPlayer.kiriko_buff) != 0:
        loop()
    eventPlayer.kiriko_buff = []

rule "[Lifeweaver]: Life Grip Healing":
    @Event playerDealtHealing
    @Hero lifeweaver
    @Condition healer.isUsingAbility2() == true
    #@Condition healer.getHero() == Hero.LIFEWEAVER
    @Condition healee.hasStatus(Status.INVINCIBLE) == true
    
    if healee.mauga_berserker_soul == true:
        goto lbl_0
    resetStatuses()
    lbl_0:
    healee.startHealingOverTime(healer, 2.5, ceil(healee.getMaxHealth() / 2.5))
    healee.setMoveSpeed(130)
    wait(2.6)

rule "[Mercy]: Life Grip Clear Effect":
    @Event playerDealtHealing
    @Hero mercy
    @Condition eventAbility == Button.ABILITY_2
    
    healee.startHealingOverTime(healer, 2, healee.getMaxHealth() * 0.2)

rule "[Sigma]: ult damage":
    @Event playerDealtDamage
    @Hero sigma
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventDamage > 75
    
    damage(victim, attacker, eventDamage / 2)

rule "[Sigma]: Hyperspheres Layer Damage":
    @Event playerDealtDamage
    @Hero sigma
    @Condition SigmaBuff[0] != 0
    @Condition eventPlayer.sigma_hyperspheres < SigmaBuff[1] + 1
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    eventPlayer.sigma_hyperspheres++
    eventPlayer.hudText = "{0}|{1}".format(eventPlayer.sigma_hyperspheres, 3)
    wait(0.6)

rule "[Sigma]: Hyperspheres Layer Damage":
    @Event playerDealtDamage
    @Hero sigma
    @Condition SigmaBuff[0] != 0
    @Condition eventPlayer.sigma_hyperspheres == SigmaBuff[1] + 1
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    eventPlayer.sigma_hyperspheres = 0
    eventPlayer.hudText = "{0}|{1}".format(eventPlayer.sigma_hyperspheres, 3)
    damage(victim, attacker, attacker.getHealth() * SigmaBuff[0])
    wait(4)

rule "[Sigma]: Hyperspheres HUD":
    @Event eachPlayer
    @Team 2
    @Hero sigma
    @Condition SigmaBuff[0] != 0
    @Condition eventPlayer.isInSpawnRoom() != true
    @Condition eventPlayer.reset_pvar[0] == false
    @Disabled
    
    hudText(eventPlayer, null, "\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r", "{0}|{1}".format(eventPlayer.sigma_hyperspheres, SigmaBuff[1]), HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.sigma_hyperspheres_hud = getLastCreatedText()
    waitUntil(eventPlayer.reset_pvar[0] or eventPlayer.isInSpawnRoom(), 999999986991104)
    destroyHudText(eventPlayer.sigma_hyperspheres_hud)
    destroyInWorldText(eventPlayer.sigma_hyperspheres_hud)

rule "[Venture] Dragonblade Healing":
    @Event playerDealtDamage
    @Hero venture
    @Condition eventAbility == Button.ULTIMATE
    
    damage(victim, attacker, eventPlayer.getMaxHealth() * 0.1)
    wait(0.16)

rule "[Genji] Dragonblade Healing":
    @Event playerDealtDamage
    @Hero genji
    @Condition eventAbility == Button.ULTIMATE
    
    heal(eventPlayer, eventPlayer, eventDamage)
    damage(victim, attacker, eventPlayer.getMaxHealth() * 0.1)
    wait(0.16)

rule "[Genji] Dragonblade Execution players less 10% HP expectancy":
    @Event playerDealtDamage
    @Hero genji
    @Condition eventAbility == Button.ABILITY_1
    @Condition victim.zarya_buff[1] == null
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false
    @Condition victim.has_nano != true
    @Condition victim.getHealth() <= victim.getMaxHealth() * 0.1
    
    damage(victim, attacker, SojournBuff[1])

#!include "aram_overrides_segments/hero_rules_genji_dragonblade_fix_and_tracer_recall_heal.opy"

rule "[Venture] Burrow speed and healing":
    @Event eachPlayer
    @Hero venture
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.mov_speed_buff = 56
    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff)
    waitUntil(not eventPlayer.isUsingAbility1(), 99999)
    eventPlayer.mov_speed_buff = 0
    eventPlayer.setMoveSpeed(100)

#!include "modules/hero_rules/shared/cassidy/10-flashbang-stun.opy"

rule "[Cassdy] Peacekeeper Alt Fire":
    @Event eachPlayer
    @Hero cassidy
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    eventPlayer.setDamageDealt(180)
    waitUntil(not eventPlayer.isFiringSecondaryFire(), 0.75)
    eventPlayer.setDamageDealt(100)

#!include "modules/hero_rules/shared/cassidy/30-alt-fire-reload.opy"

rule "[Sojourn] Overclock Buff":
    @Event eachPlayer
    @Hero sojourn
    @Condition eventPlayer.isUsingUltimate() == true
    
    SojournBuff[0] += 0.05
    waitUntil(not eventPlayer.isUsingUltimate(), 10)
    SojournBuff[0] -= 0.05

rule "[Sojourn] Execution players less 10% HP expectancy":
    @Event playerDealtDamage
    @Hero sojourn
    @Condition SojournBuff[0] != 0
    @Condition (eventAbility == Button.SECONDARY_FIRE or eventAbility == Button.ULTIMATE) == true
    @Condition victim.zarya_buff[1] == null
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false
    @Condition victim.has_nano != true
    @Condition victim.getHealth() <= SojournBuff[0] * victim.getMaxHealth()
    
    damage(victim, attacker, SojournBuff[1])

rule "[Ashe]: headshot damage":
    @Event playerDealtDamage
    @Hero ashe
    @Condition HeadshotDamage[1] > 1
    @Condition eventWasCriticalHit == true
    @Condition eventAbility != Button.ABILITY_1
    @Condition eventAbility != Button.ABILITY_2
    @Condition eventAbility != Button.ULTIMATE
    
    damage(victim, attacker, ceil((eventDamage * (HeadshotDamage[1] - 2)) / 2))

rule "[Zenyatta]: headshot damage":
    @Event playerDealtDamage
    @Hero zenyatta
    @Condition HeadshotDamage[0] > 1
    @Condition eventWasCriticalHit == true
    @Condition eventAbility != Button.ABILITY_1
    @Condition eventAbility != Button.ABILITY_2
    @Condition eventAbility != Button.ULTIMATE
    
    damage(victim, attacker, ceil((eventDamage * (HeadshotDamage[0] - 2)) / 2))

rule "[Baptiste]: headshot damage":
    @Event playerDealtDamage
    @Hero baptiste
    @Condition HeadshotDamage[4] > 1
    @Condition eventWasCriticalHit == true
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    damage(victim, attacker, ceil((eventDamage * (HeadshotDamage[4] - 2)) / 2))

rule "[Kiriko]: headshot damage":
    @Event playerDealtDamage
    @Hero kiriko
    @Condition HeadshotDamage[2] > 1
    @Condition eventWasCriticalHit == true
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    damage(victim, attacker, ceil((eventDamage * (HeadshotDamage[2] - 2)) / 2))

rule "[Baptiste]: Immortality Field":
    @Event eachPlayer
    @Condition eventPlayer.hasStatus(Status.UNKILLABLE) == true
    @Condition eventPlayer.reset_pvar[12].getAbilityCooldown(Button.ABILITY_2) > 0
    
    #heal(eventPlayer, eventPlayer.reset_pvar[12], 50)
    eventPlayer.startHealingOverTime(eventPlayer.reset_pvar[12], 5, 50 if eventPlayer.getTeam() == Team.1 else 25)
    wait(8)

rule "[Mauga] Overrun knockdown duration":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.setStatusEffect(eventPlayer, Status.INVINCIBLE, 5)
    waitUntil(not eventPlayer.isUsingAbility1(), 5)
    eventPlayer.clearStatusEffect(Status.INVINCIBLE)

rule "[Mauga] Overrun knockdown duration":
    @Event playerDealtDamage
    @Hero mauga
    @Condition eventAbility == Button.ABILITY_1
    
    victim.setStatusEffect(attacker, Status.BURNING, 2)
    if victim.hasStatus(Status.KNOCKED_DOWN):
        goto lbl_0
    victim.setStatusEffect(attacker, Status.KNOCKED_DOWN, 0.5)
    lbl_0:
    if victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT) or victim.has_nano:
        goto lbl_1
    damage(victim, attacker, ceil(victim.getMaxHealth() * MaugaBuff[3]))
    lbl_1:

rule "[Mauga]: Cage Fight heal":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer.mauga_berserker_soul != true
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition (len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if distance(eventPlayer, player) <= 7 and player.hasStatus(Status.ROOTED)])) > 0
    
    eventPlayer.startHealingOverTime(eventPlayer, 2, 120 * (len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if distance(eventPlayer, player) <= 7 and player.hasStatus(Status.ROOTED)])))
    wait(1.996)
    if ruleCondition:
        loop()

rule "[Mauga]: Berserker Soul status active":
    @Event playerTookDamage
    @Hero mauga
    #@Condition eventDamage > eventPlayer.getHealth() + 25
    @Condition eventPlayer.mauga_berserker_soul != true
    @Condition eventPlayer.getHealth() <= 250
    
    eventPlayer.mauga_berserker_soul = true
    bigMessage(eventPlayer, "狂战士之魂！")
    waitUntil(eventPlayer.isDead(), 99999)
    eventPlayer.mauga_berserker_soul = false

rule "[Mauga]: Berserker Soul reset":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isInSpawnRoom() == true
    
    eventPlayer.mauga_berserker_soul = false

rule "[Mauga]: Berserker Soul Ability":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer.mauga_berserker_soul == true
    
    eventPlayer.dmg_amplification = MaugaBuff[2]
    eventPlayer.dmg_reduction = MaugaBuff[1]
    playEffect(eventPlayer, DynamicEffect.GOOD_PICKUP_EFFECT, Color.WHITE, eventPlayer, 200)
    eventPlayer.setStatusEffect(null, Status.UNKILLABLE, 6)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1.2)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 0.2)
    eventPlayer.setDamageDealt(100 + eventPlayer.dmg_amplification)
    eventPlayer.setDamageReceived(100 - eventPlayer.dmg_reduction)
    eventPlayer.setHealingDealt(0)
    eventPlayer.setHealingReceived(0)
    eventPlayer.setKnockbackReceived(100 - MaugaBuff[5])
    eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.getMaxHealth() * MaugaBuff[0], true, false)
    eventPlayer.mauga_berserker_soul_id[0] = getLastCreatedHealthPool()
    wait(0.16)
    eventPlayer.setHealth(eventPlayer.getMaxHealth())
    wait(0.16)
    eventPlayer.startDamageOverTime(null, 9999, eventPlayer.getMaxHealth() * MaugaBuff[6])
    eventPlayer.mauga_berserker_soul_id[1] = getLastDamageOverTimeId()
    waitUntil(not eventPlayer.mauga_berserker_soul or eventPlayer.isDead(), 9999)
    eventPlayer.dmg_amplification = 0
    eventPlayer.dmg_reduction = 0
    stopDamageOverTime(eventPlayer.mauga_berserker_soul_id[1])
    removeHealthPool(eventPlayer.mauga_berserker_soul_id[0])
    eventPlayer.setHealingDealt(100)
    eventPlayer.setHealingReceived(100)
    eventPlayer.setDamageDealt(100)
    eventPlayer.setDamageReceived(100)
    eventPlayer.setKnockbackReceived(100)
    eventPlayer.mauga_berserker_soul_id = null
    #eventPlayer.mauga_berserker_soul = false

rule "[Mauga]: Berserker Soul kill to heal":
    @Event playerDealtFinalBlow
    @Hero mauga
    @Condition eventPlayer.mauga_berserker_soul == true
    
    eventPlayer.setHealth(eventPlayer.getMaxHealth() * MaugaBuff[7] + eventPlayer.getHealth())
    wait(0.5)

rule "[Mauga]: Berserker Soul cd":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer.mauga_berserker_soul == true
    #@Condition any([i >= 2 for i in [eventPlayer.getAbilityCooldown(Button.ABILITY_1), eventPlayer.getAbilityCooldown(Button.ABILITY_2)]]) == true
    @Condition (eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 2 or eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 2) == true
    
    if eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 2:
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 2)
    else:
        eventPlayer.setAbilityCooldown(Button.ABILITY_2, 2)
    wait(1.96)
    if ruleCondition:
        loop()

rule "[Orisa]Fortify ricochet damage":
    @Event playerTookDamage
    @Hero orisa
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate()) == true
    @Condition eventPlayer.hasStatus(Status.HACKED) != true
    
    damage(attacker, eventPlayer, Orisa_Fortify[1] / 100 * eventDamage)

rule "[Illari]: Captive Sun HUD":
    @Event eachPlayer
    @Hero illari
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.hudText = "最大生命值伤害：{0}%".format(((len([player for player in getLivingPlayers(eventPlayer.getTeam()) if isInLoS(eventPlayer, player) and distance(eventPlayer, player) <= 10 and player != eventPlayer])) * IllariBuff) * 100)
    #hudText(eventPlayer, null, "\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r", "最大生命值伤害：{0}%".format((len([player for player in getLivingPlayers(eventPlayer.getTeam()) if isInLoS(eventPlayer, player) and distance(eventPlayer, player) <= 10 and player != eventPlayer])) * IllariBuff), HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    #eventPlayer.heart_steel[4] = getLastCreatedText()
    waitUntil(not eventPlayer.isUsingUltimate(), 8)
    wait(0.98)
    destroyEffect(eventPlayer.heart_steel[3])
    #destroyHudText(eventPlayer.heart_steel[4])
    eventPlayer.hudText = ""
    eventPlayer.heart_steel[3] = 0
    eventPlayer.heart_steel[4] = 0

rule "[Illari] Captive Sun":
    @Event playerDealtDamage
    @Hero illari
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventDamage > 5
    
    damage(victim, attacker, IllariBuff / 100 * len(getPlayersInRadius(eventPlayer, 10, eventPlayer.getTeam(), LosCheck.SURFACES)) * victim.getMaxHealth())

rule "[Zenyatta] remove Snap Kick hp":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.heart_steel[1] != 0
    
    wait(5)
    removeHealthPool(eventPlayer.heart_steel[0])
    eventPlayer.heart_steel[1] = 0
    eventPlayer.heart_steel[0] = 0
    wait(0.16)
    if ruleCondition:
        loop()

rule "[Zenyatta] Snap Kick (enemy)":
    @Event playerReceivedKnockback
    @Condition attacker.getHero() == Hero.ZENYATTA == true
    @Condition eventAbility == Button.MELEE
    
    heal(attacker, attacker, victim.getMaxHealth() * 0.25)
    victim.setStatusEffect(attacker, Status.STUNNED, 1.5)
    attacker.heart_steel[1] += 150
    if attacker.heart_steel[0] == null:
        goto lbl_0
    removeHealthPool(attacker.heart_steel[0])
    lbl_0:
    attacker.addHealthPool(Health.NORMAL, attacker.heart_steel[1], false, false)
    attacker.heart_steel[0] = getLastCreatedHealthPool()
    #eventPlayer.KnockbackDirection = directionFromAngles(attacker.getHorizontalFacingAngle(), -10)
    #eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0.5)
    wait()
    #eventPlayer.applyImpulse(eventPlayer.KnockbackDirection, Zen_KnockupStrength * 2, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    #eventPlayer.applyImpulse(Vector.UP, Zen_KnockupStrength * 2 * 0.3, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    damage(eventPlayer, attacker, eventDamage * 0.5)
    #eventPlayer.isKnocked = true

def Knockback():
    @Name "[Zenyatta] Sub Knockback"
    
    wait()
    eventPlayer.applyImpulse(eventPlayer.KnockbackDirection, Zen_KnockupStrength, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.applyImpulse(Vector.UP, Zen_KnockupStrength * 0.3, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)

#!include "aram_overrides_segments/hero_rules_zenyatta_snap_kick_self_ground_wall.opy"

rule "[Zenyatta]: Transcendence":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.mov_speed_penalty = 0
    eventPlayer.mov_speed_buff += 25
    wait(0.16)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 6)
    eventPlayer.setHealingDealt(133.34)
    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff)
    waitUntil(not eventPlayer.isUsingUltimate(), 6)
    eventPlayer.mov_speed_buff = 0
    eventPlayer.setHealingDealt(100)
    eventPlayer.setMoveSpeed(100)

rule "[Tracer] Instant Respawn":
    @Event playerDied
    @Hero tracer
    
    wait(0.16)
    eventPlayer.respawn()
    eventPlayer.setAbilityCharge(Button.ABILITY_1, 3)

rule "[Ramattra] ult speed":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.mov_speed_buff += Ram_Annihilation[3]
    eventPlayer.setDamageDealt(100 + Ram_Annihilation[5])
    eventPlayer.setDamageReceived(100 - Ram_Annihilation[4])
    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff - eventPlayer.mov_speed_penalty)
    eventPlayer.setKnockbackReceived(30)
    waitUntil(not eventPlayer.isUsingUltimate(), 999999986991104)
    eventPlayer.mov_speed_buff = 0
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setDamageReceived(100)
    eventPlayer.setKnockbackReceived(100)
    eventPlayer.setDamageDealt(100)
    wait(0.16)
    removeTankPassive()

rule "[Ramattra] ult start":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) <= eventPlayer.custom_hp_pvar[0] + 50
    
    eventPlayer.ram_block_damage += 50
    eventPlayer.hudText = "{0}/{1}".format(floor(eventPlayer.ram_block_damage), Ram_Annihilation[0])
    wait(1.16)
    if ruleCondition:
        loop()

rule "[Ramattra] ult healing":
    @Event playerDealtDamage
    @Hero ramattra
    #@Condition attacker.getHero() == Hero.RAMATTRA == true
    @Condition attacker.isUsingUltimate() == true
    @Condition attacker.getHealth() < attacker.getMaxHealth()
    #@Condition eventAbility == Button.PRIMARY_FIRE == true
    
    heal(attacker, attacker, eventDamage * Ram_Annihilation[1])
    wait(0.0016)

rule "[Ramattra]: Pummel healing":
    @Event playerDealtDamage
    @Team 1
    @Hero ramattra
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventAbility == Button.ABILITY_1
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) <= eventPlayer.custom_hp_pvar[0] + 50
    
    eventPlayer.ram_block_damage += eventDamage * 2.5
    eventPlayer.hudText = "{0}/{1}".format(floor(eventPlayer.ram_block_damage), Ram_Annihilation[0])
    wait(0.3)

rule "[Ramattra]: Pummel healing":
    @Event playerDealtDamage
    @Team 2
    @Hero ramattra
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventAbility == Button.ABILITY_1
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) <= eventPlayer.custom_hp_pvar[0] + 50
    
    eventPlayer.ram_block_damage += eventDamage * 1.5
    wait(0.3)

#!include "aram_overrides_segments/hero_rules_ramattra_pain_endures_and_ball_grapple_reset.opy"

rule "[Tracer] Pulse Bomb Damage":
    @Event playerDealtDamage
    @Hero tracer
    #@Condition attacker.getHero() == Hero.TRACER == true
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventDamage > 10
    
    damage(victim, attacker, ceil(eventDamage * 2))

rule "[Mei]: Endothermic Blaster":
    @Event playerDealtDamage
    @Hero mei
    @Condition eventWasCriticalHit == true
    @Condition eventAbility == Button.SECONDARY_FIRE
    
    victim.setStatusEffect(attacker, Status.FROZEN, 0.75)
    wait(0.2)

rule "[Mei]: Ice move":
    @Event eachPlayer
    @Hero mei
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    
    eventPlayer.applyImpulse(eventPlayer.getFacingDirection(), 5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait()
    if ruleCondition:
        loop()

rule "[Sombra]: Apply OW1 hack on top of OW2 hack":
    @Event eachPlayer
    @Condition eventPlayer.hasStatus(Status.HACKED) == true
    @Condition eventPlayer.vendetta_hud != true
    
    stopChasingVariable(eventPlayer.hack_timer)
    eventPlayer.setStatusEffect(eventPlayer.reset_pvar[6], Status.HACKED, 5)
    eventPlayer.hack_timer = 5
    chaseAtRate(eventPlayer.hack_timer, 0, 1, ChaseRateReeval.NONE)

rule "[Sombra]: hack healing received":
    @Event eachPlayer
    @Condition eventPlayer.hasStatus(Status.HACKED) == true
    
    eventPlayer.setHealingReceived(100 - SombraBuff[0])
    waitUntil(not eventPlayer.hasStatus(Status.HACKED), 5)
    eventPlayer.setHealingReceived(100)

#!include "aram_overrides_segments/hero_rules_sombra_and_tracer_kill_reset_cooldown.opy"

rule "[Ana]: Sleep tanks for longer duration":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.ABILITY_1
    @Condition victim.unaffected == false
    
    victim.clearStatusEffect(Status.ASLEEP)
    #waitUntil(victim.hasStatus(Status.ASLEEP), 999999986991104)
    victim.setStatusEffect(attacker, Status.KNOCKED_DOWN, 4)
    #heart_steel_hp
    eventPlayer.heart_steel[1] += 50 if eventPlayer.getTeam() == Team.2 else 100
    eventPlayer.heart_steel[2] = true

rule "[Ana]: Sleep tanks for longer duration":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.heart_steel[1] > 0
    @Condition eventPlayer.heart_steel[2] == true
    
    if eventPlayer.heart_steel[0] == null:
        goto lbl_0
    removeHealthPool(eventPlayer.heart_steel[0])
    lbl_0:
    eventPlayer.addHealthPool(Health.ARMOR, eventPlayer.heart_steel[1], true, false)
    eventPlayer.heart_steel[0] = getLastCreatedHealthPool()
    eventPlayer.heart_steel[2] = false

#!include "aram_overrides_segments/hero_rules_ball_adaptive_shield_disable_and_zarya_barrier_target.opy"

rule "[Zarya]: Projected Barrier Shields":
    @Event eachPlayer
    @Condition eventPlayer.getHero() != Hero.ZARYA
    @Condition (eventPlayer.isAlive() and eventPlayer.zarya_barrier_shields[0]) == true
    
    if eventPlayer.mauga_berserker_soul == true:
        goto lbl_0
    resetStatuses()
    lbl_0:
    eventPlayer.zarya_barrier_shields[0] = false
    if eventPlayer.zarya_barrier_shields[1] == null:
        goto lbl_1
    removeHealthPool(eventPlayer.zarya_barrier_shields[1])
    lbl_1:
    eventPlayer.addHealthPool(Health.NORMAL, ZaryaBuff[0], false, false)
    eventPlayer.zarya_barrier_shields[1] = getLastCreatedHealthPool()
    wait(3, Wait.RESTART_WHEN_TRUE)
    removeHealthPool(eventPlayer.zarya_barrier_shields[1])
    eventPlayer.zarya_barrier_shields[1] = null

rule "[Soldier: 76]: HeartSteel":
    @Event eachPlayer
    @Team 2
    @Hero soldier
    @Condition any([isInSetup(), isGameInProgress()]) == true
    @Condition S76Buff[1] != 0
    @Condition eventPlayer.isInSpawnRoom() != true
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getSpeed() != 0
    @Condition eventPlayer.getMaxHealth() < S76Buff[2]
    
    wait(S76Buff[0], Wait.ABORT_WHEN_FALSE)
    #heart_steel_hp_id
    if eventPlayer.heart_steel[0] == null:
        goto lbl_0
    removeHealthPool(eventPlayer.heart_steel[0])
    lbl_0:
    if eventPlayer.getMaxHealth() > S76Buff[2]:
        goto lbl_1
    #heart_steel_hp
    eventPlayer.heart_steel[1] += S76Buff[1] + (eventPlayer.getSpeed() - 5.5)
    #heart_steel_hp_lost
    lbl_1:
    eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.heart_steel[1], true, false)
    smallMessage(eventPlayer, "  心之钢 {0} {1}".format(iconString(Icon.PLUS), S76Buff[1]))
    eventPlayer.heart_steel[0] = getLastCreatedHealthPool()
    if ruleCondition:
        loop()

rule "[Soldier: 76]: HeartSteel":
    @Event eachPlayer
    @Team 1
    @Hero soldier
    @Condition S76Buff[1] != 0
    @Condition eventPlayer.isAlive() == true
    
    wait(S76Buff[0], Wait.ABORT_WHEN_FALSE)
    #heart_steel_hp_id
    if eventPlayer.heart_steel[0] == null:
        goto lbl_0
    removeHealthPool(eventPlayer.heart_steel[0])
    lbl_0:
    if eventPlayer.getMaxHealth() >= S76Buff[2]:
        goto lbl_1
    #heart_steel_hp
    eventPlayer.heart_steel[1] += S76Buff[1] + (eventPlayer.getSpeed() - 5.5)
    #heart_steel_hp_lost
    lbl_1:
    eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.heart_steel[1], true, false)
    smallMessage(eventPlayer, "  心之钢 {0} {1}".format(iconString(Icon.PLUS), S76Buff[1]))
    eventPlayer.heart_steel[0] = getLastCreatedHealthPool()
    if ruleCondition:
        loop()

rule "[Soldier: 76]: 燃烧":
    @Event eachPlayer
    @Team 2
    @Hero soldier
    @Condition eventPlayer.isUsingUltimate() != true
    @Condition S76Buff[3] != 0
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getSpeed() != 0
    @Condition (len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and distance(eventPlayer, player) <= S76Buff[4] and not player.hasStatus(Status.INVINCIBLE) and player.getPosition().y - eventPlayer.getPosition().y <= 2])) > 0
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    ([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and distance(eventPlayer, player) <= S76Buff[4] and not player.hasStatus(Status.INVINCIBLE) and player.getPosition().y - eventPlayer.getPosition().y <= 2]).setStatusEffect(eventPlayer, Status.BURNING, 2)
    ([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and distance(eventPlayer, player) <= S76Buff[4] and not player.hasStatus(Status.INVINCIBLE) and player.getPosition().y - eventPlayer.getPosition().y <= 2]).startDamageOverTime(eventPlayer, 2, eventPlayer.getMaxHealth() * S76Buff[3])
    wait(1.9)
    if ruleCondition:
        loop()

rule "[Soldier: 76]: 燃烧":
    @Event eachPlayer
    @Team 1
    @Hero soldier
    @Condition eventPlayer.isUsingUltimate() != true
    @Condition S76Buff[3] != 0
    @Condition eventPlayer.isAlive() == true
    @Condition (len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and distance(eventPlayer, player) <= S76Buff[4] and not player.hasStatus(Status.INVINCIBLE) and player.getPosition().y - eventPlayer.getPosition().y <= 2])) > 0
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    ([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and distance(eventPlayer, player) <= S76Buff[4] and not player.hasStatus(Status.INVINCIBLE) and player.getPosition().y - eventPlayer.getPosition().y <= 2]).setStatusEffect(eventPlayer, Status.BURNING, 2)
    ([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and distance(eventPlayer, player) <= S76Buff[4] and not player.hasStatus(Status.INVINCIBLE) and player.getPosition().y - eventPlayer.getPosition().y <= 2]).startDamageOverTime(eventPlayer, 2, eventPlayer.getMaxHealth() * S76Buff[3])
    wait(1.9)
    if ruleCondition:
        loop()

rule "[Soldier: 76]: 治疗":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isAlive() == true
    
    wait(0.16, Wait.ABORT_WHEN_FALSE)
    eventPlayer.startHealingOverTime(eventPlayer, 5, eventPlayer.getMaxHealth() * 0.1)

rule "[Soldier: 76]: 替代射击":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.dmg_amplification += 300
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setDamageDealt(100 + eventPlayer.dmg_amplification)
    waitUntil(not eventPlayer.isUsingUltimate() or eventPlayer.reset_pvar[0] != false, 8)
    eventPlayer.setDamageDealt(100)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.setPrimaryFireEnabled(true)

rule "[Soldier: 76]: 替代射击":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    waitUntil(not eventPlayer.isFiringSecondaryFire(), 0.496)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0.16)

rule "[Reinhardt] firestrike healing":
    @Event playerDealtDamage
    @Hero reinhardt
    @Condition (eventAbility == Button.ABILITY_2 or eventAbility == Button.ULTIMATE) == true
    
    if eventAbility == Button.ULTIMATE:
        goto lbl_0
    eventPlayer.startHealingOverTime(eventPlayer, 2, eventDamage * 2)
    lbl_0:
    victim.setStatusEffect(attacker, Status.BURNING, 2)
    victim.startDamageOverTime(attacker, 2, victim.getMaxHealth() * 0.05)

rule "[Reinhardt]: Earthshatter":
    @Event playerDealtFinalBlow
    @Hero reinhardt
    @Condition eventAbility == Button.ABILITY_1
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    wait(1)

rule "[Reinhardt]: Earthshatter":
    @Event playerDealtFinalBlow
    @Hero reinhardt
    @Condition eventAbility == Button.ULTIMATE
    
    eventPlayer.setUltCharge(100)
    wait(0.5)

rule "[Reinhardt]: Crusaders stand":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.reinhardt_buff == false
    @Condition eventPlayer.getHealthOfType(Health.ARMOR) <= 0
    
    eventPlayer.reinhardt_buff = true
    wait(15)
    eventPlayer.reinhardt_buff = false
    smallMessage(eventPlayer, "  {0} 十字军坚定 已就绪".format(abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE)))

rule "[Reinhardt]: Crusaders stand":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.reinhardt_buff == true
    
    bigMessage(eventPlayer, "  十字军坚定")
    smallMessage(eventPlayer, "  {0} 无视击退".format(iconString(Icon.FLAG)))
    eventPlayer.addHealthPool(Health.NORMAL, 300, false, false)
    eventPlayer.setKnockbackReceived(0)
    waitUntil(not eventPlayer.reinhardt_buff, 8)
    eventPlayer.setKnockbackReceived(100)

#!include "aram_overrides_segments/hero_rules_reinhardt_shield_slam_and_overhealth.opy"

rule "[Doomfist] Seismic Slam upper":
    @Event playerTookDamage
    @Condition attacker.getHero() == Hero.DOOMFIST
    @Condition eventAbility in [Button.SECONDARY_FIRE, Button.ABILITY_1, Button.ULTIMATE] == true
    
    attacker.heart_steel[1] += 50
    if attacker.heart_steel[0] == null:
        goto lbl_0
    removeHealthPool(attacker.heart_steel[0])
    lbl_0:
    attacker.addHealthPool(Health.ARMOR, attacker.heart_steel[1], false, false)
    attacker.heart_steel[0] = getLastCreatedHealthPool()
    wait(0.16)

rule "[Doomfist] Seismic Slam upper":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.heart_steel[1] != 0
    
    wait(3)
    removeHealthPool(eventPlayer.heart_steel[0])
    eventPlayer.heart_steel[1] = 0
    eventPlayer.heart_steel[0] = 0
    wait(0.16)
    if ruleCondition:
        loop()

rule "[Doomfist] Seismic Slam upper":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.ABILITY_1
    @Condition victim.unaffected != true
    @Condition (victim.getHero() == Hero.ORISA and (victim.isUsingAbility1() or victim.isUsingUltimate())) == false
    @Condition (victim.getHero() == Hero.MAUGA and victim.isUsingAbility1()) == false
    
    eventPlayer.doom_buff += 50
    eventPlayer.hudText = "{0}".format(floor(eventPlayer.doom_buff))
    victim.applyImpulse(Vector.UP, 6, Relativity.TO_PLAYER)
    victim.applyImpulse(worldVector(Vector.BACKWARD, attacker, Transform.ROTATION), 3.5, Relativity.TO_WORLD)
    victim.startForcingThrottle(0, 0, 0, 0, 0, 0)
    waitUntil(victim.isOnGround(), 1.2)
    victim.stopForcingThrottle()

rule "[Doomfist] Seismic Slam upper":
    @Event playerDealtKnockback
    @Hero doomfist
    @Condition eventAbility == Button.MELEE
    
    eventPlayer.doom_buff += 50
    eventPlayer.hudText = "{0}".format(floor(eventPlayer.doom_buff))

rule "[Doomfist]: Meteor Strike":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.ULTIMATE
    @Condition victim.unaffected != true
    
    eventPlayer.doom_buff += 250

rule "[Doomfist]: Power Block":
    @Event playerTookDamage
    @Hero doomfist
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.doom_buff <= DoomBuff[1]
    
    eventPlayer.doom_buff += DoomBuff[1] - eventPlayer.doom_buff if eventPlayer.doom_buff + eventDamage * DoomBuff[0] > DoomBuff[1] else eventDamage * DoomBuff[0]
    eventPlayer.hudText = "{0}".format(floor(eventPlayer.doom_buff))
    wait()

rule "[Doomfist]: Power Block Damage":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition eventPlayer.doom_buff != 0
    
    damage(victim, attacker, eventPlayer.doom_buff)
    eventPlayer.doom_buff = 0

rule "[Doomfist]: block HUD":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.doom_buff != 0
    @Condition eventPlayer.isInSpawnRoom() != true
    @Condition eventPlayer.reset_pvar[0] == false
    
    #hudText(eventPlayer, null, "\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r", "{0}".format(floor(eventPlayer.doom_buff)), HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    #eventPlayer.doom_buff_hud = getLastCreatedText()
    waitUntil(eventPlayer.doom_buff == 0 or eventPlayer.reset_pvar[0] or eventPlayer.isInSpawnRoom(), 999999986991104)
    eventPlayer.hudText = ""
    #destroyHudText(eventPlayer.doom_buff_hud)

#!include "aram_overrides_segments/hero_rules_hazard_violent_leap_cooldown_and_hp.opy"

rule "[Hazard]: Spike Guard cd":
    @Event playerDealtDamage
    @Hero hazard
    @Condition eventAbility == Button.ABILITY_1
    @Condition HazardBuff[0] != 0
    @Condition victim.hasStatus(Status.INVINCIBLE) != true
    @Condition victim.zarya_buff[1] == null
    
    damage(victim, attacker, victim.getMaxHealth() * HazardBuff[0])
    wait(0.032)

rule "[Hazard]: Spike Guard get Ultimate and heal":
    @Event playerTookDamage
    @Hero hazard
    @Condition eventPlayer.hazard_using_ability_sec == true
    
    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + (HazardBuff[1] if eventPlayer.getTeam() == Team.2 else HazardBuff[1] * 2.5))
    heal(eventPlayer, eventPlayer, eventDamage / 0.35 * HazardBuff[2])
    wait(min(0.16, getAverageServerLoad() / 100))

rule "[Hazard]: Spike Guard using tracking":
    @Event eachPlayer
    @Hero hazard
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    
    eventPlayer.hazard_using_ability_sec = true
    waitUntil(not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), 12)
    eventPlayer.hazard_using_ability_sec = false

rule "[Orisa]: stun when ult":
    @Event playerDealtKnockback
    @Hero orisa
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition victim.isAlive() == true
    @Condition victim.unaffected != true
    
    wait(0.3, Wait.ABORT_WHEN_FALSE)
    if victim.zarya_buff[1] != null:
        goto lbl_0
    victim.orisa_buff = true
    lbl_0:
    victim.mov_speed_penalty += Orisa_Fortify[2]

rule "[Orisa]: speed":
    @Event eachPlayer
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.unaffected != true
    @Condition eventPlayer.orisa_buff == true
    
    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff - eventPlayer.mov_speed_penalty)
    waitUntil(not eventPlayer.orisa_buff or eventPlayer.unaffected or eventPlayer.hasStatus(Status.INVINCIBLE) or eventPlayer.hasStatus(Status.PHASED_OUT), 2)
    eventPlayer.mov_speed_penalty = 0
    eventPlayer.setMoveSpeed(100)
    eventPlayer.orisa_buff = false

rule "[Orisa]: fly":
    @Event eachPlayer
    @Hero orisa
    @Condition (eventPlayer.isUsingAbility2() or eventPlayer.isUsingUltimate()) == true
    #@Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    
    eventPlayer.applyImpulse(eventPlayer.getFacingDirection(), 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait()
    if ruleCondition:
        loop()

rule "[Rein]: fly":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    
    eventPlayer.applyImpulse(eventPlayer.getFacingDirection(), 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait()
    if ruleCondition:
        loop()

rule "[Mauga]: fly":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    
    eventPlayer.applyImpulse(eventPlayer.getFacingDirection(), 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait()
    if ruleCondition:
        loop()

rule "[Ramattra]: block":
    @Event playerTookDamage
    @Hero ramattra
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate()) == true
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.ram_block_damage <= Ram_Annihilation[0]
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) <= eventPlayer.custom_hp_pvar[0] + 50
    
    eventPlayer.ram_block_damage += eventDamage
    eventPlayer.hudText = "{0}/{1}".format(floor(eventPlayer.ram_block_damage), Ram_Annihilation[0])

rule "[Ramattra]: block":
    @Event eachPlayer
    @Hero ramattra
    @Condition Ram_Annihilation[0] != 0
    @Condition eventPlayer.ram_block_damage != 0
    @Condition eventPlayer.ram_block_damage >= Ram_Annihilation[0]
    
    eventPlayer.addHealthPool(Health.NORMAL, Ram_Annihilation[0] if eventPlayer.ram_block_damage >= Ram_Annihilation[0] else eventPlayer.ram_block_damage, false, false)
    eventPlayer.ram_block_damage = 0
    eventPlayer.hudText = ""
    #eventPlayer.startHealingOverTime(eventPlayer, 5, eventPlayer.getMaxHealth() * 0.25)

rule "[Ramattra]: block HUD":
    @Event eachPlayer
    @Team 2
    @Hero ramattra
    @Condition eventPlayer.isInSpawnRoom() != true
    @Condition eventPlayer.reset_pvar[0] == false
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate()) == true
    
    #hudText(eventPlayer, null, "\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r", "{0}/{1}".format(floor(eventPlayer.ram_block_damage), Ram_Annihilation[0]), HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    #eventPlayer.ram_block_damage_hud = getLastCreatedText()
    waitUntil(eventPlayer.ram_block_damage == 0 or eventPlayer.reset_pvar[0] or eventPlayer.isInSpawnRoom(), 999999986991104)
    eventPlayer.hudText = ""
    #destroyHudText(eventPlayer.ram_block_damage_hud)

rule "[Ramattra]: Annihilation dmg reduc":
    @Event eachPlayer
    @Condition getPlayersOnHero(Hero.RAMATTRA, getOppositeTeam(eventPlayer.getTeam())).isUsingUltimate() == true
    @Condition distance(eventPlayer, getPlayersOnHero(Hero.RAMATTRA, getOppositeTeam(eventPlayer.getTeam()))) > 13
    
    startDamageModification(getPlayersOnHero(Hero.RAMATTRA, getOppositeTeam(eventPlayer.getTeam())), eventPlayer, 0.01)
    eventPlayer.ram_dmg_reduc = getLastDamageModification()
    waitUntil(not getPlayersOnHero(Hero.RAMATTRA, getOppositeTeam(eventPlayer.getTeam())).isUsingUltimate() or distance(eventPlayer, getPlayersOnHero(Hero.RAMATTRA, getOppositeTeam(eventPlayer.getTeam()))) <= 13, 120)
    stopDamageModification(eventPlayer.ram_dmg_reduc)
    eventPlayer.ram_dmg_reduc = null

#!include "aram_overrides_segments/hero_rules_reaper_wraith_fly_and_kill_soul_buff.opy"

rule "[Reaper]: kill to gain soul buff":
    @Event playerDealtFinalBlow
    @Hero reaper
    #@Condition eventPlayer.reaper_buff[0] < 50
    
    eventPlayer.reaper_buff[0] += ReaperBuff[0] + 1 if eventPlayer.getTeam() == Team.1 else 0.5

#!include "aram_overrides_segments/hero_rules_reaper_wraith_shadowstep_cooldown_and_buffs.opy"

rule "[Reaper]: Ability Dire Triggers":
    @Event eachPlayer
    @Hero reaper
    #@Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) > 1.5
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    waitUntil(not eventPlayer.isFiringSecondaryFire(), 0.6)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, ReaperBuff[6])

rule "[Reaper]: Ability Dire Triggers dot":
    @Event playerDealtDamage
    @Hero reaper
    @Condition eventAbility == Button.SECONDARY_FIRE
    
    #wait(0.16)
    victim.startDamageOverTime(attacker, 1, victim.getMaxHealth() * 0.1 + eventPlayer.reaper_buff[0] * ReaperBuff[7])
    #victim.reaper_buff = getLastDamageOverTimeId()
    #wait(1)
    #victim.reaper_buff = 0

rule "[Reaper]: ultimate Death Blossom":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setDamageDealt(100 + eventPlayer.reaper_buff[0] * ReaperBuff[8])
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.setStatusEffect(eventPlayer, Status.INVINCIBLE, 2.5 if eventPlayer.reaper_buff[0] * 0.05 >= 2.5 else eventPlayer.reaper_buff[0] * 0.05)
    eventPlayer.setStatusEffect(eventPlayer, Status.PHASED_OUT, 2.5 if eventPlayer.reaper_buff[0] * 0.05 >= 2.5 else eventPlayer.reaper_buff[0] * 0.05)
    waitUntil(not eventPlayer.isUsingUltimate(), 3.016)
    eventPlayer.setDamageDealt(100)

rule "[Reaper]: HUD & Reset":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isInSpawnRoom() != true
    @Condition eventPlayer.reset_pvar[0] == false
    @Condition eventPlayer.reaper_buff[0] > 0
    
    if eventPlayer.reaper_buff[2] != 0:
        goto lbl_0
    hudText(eventPlayer, null, " \r\n\r\n\n", "已收割灵魂： {0}".format(eventPlayer.reaper_buff[0]), HudPosition.LEFT, 3, null, null, rgb(255, 255, 255, 200), HudReeval.STRING)
    eventPlayer.reaper_buff[2] = getLastCreatedText()
    lbl_0:
    waitUntil(eventPlayer.reaper_buff[0] == 0 or eventPlayer.reset_pvar[0], 999999986991104)
    destroyHudText(eventPlayer.reaper_buff[2])
    eventPlayer.reaper_buff[2] = 0

rule "[Moira]: Fade disable on Coalescence":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.isUsingUltimate() == true
    @Disabled
    
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.disallowButton(Button.ABILITY_1)
    waitUntil(not eventPlayer.isUsingUltimate(), 9)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.setAbility1Enabled(true)

rule "[Moira]: kill enemy":
    @Event playerEarnedElimination
    @Hero moira
    @Condition victim.moira_buff != true
    
    victim.moira_buff = true
    eventPlayer.hudText = "{0} / 6".format(len([player for player in getPlayers(getOppositeTeam(eventPlayer.getTeam())) if player.moira_buff == true]))

rule "[Moira]: kill enemy":
    @Event playerDealtFinalBlow
    @Hero moira
    @Condition victim.moira_buff != true
    
    victim.moira_buff = true
    eventPlayer.hudText = "{0} / 6".format(len([player for player in getPlayers(getOppositeTeam(eventPlayer.getTeam())) if player.moira_buff == true]))

rule "[Moira]: auto charge Coalescence":
    @Event eachPlayer
    @Hero moira
    @Condition len([player for player in getPlayers(getOppositeTeam(eventPlayer.getTeam())) if player.moira_buff == true]) >= 6
    @Condition eventPlayer.getUltCharge() != 100
    
    eventPlayer.setUltCharge(100)
    wait(15)
    if ruleCondition:
        loop()

rule "[Zarya]: will to win":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.reset_pvar[0] == false
    @Condition eventPlayer.isInSpawnRoom() != true
    @Condition eventPlayer.getHero() == Hero.ZARYA
    @Condition ZaryaBuff[2] == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.zarya_buff[0] == true
    @Condition eventPlayer.getHealth() <= eventPlayer.getMaxHealth() * 0.3
    
    bigMessage(eventPlayer, "胜利意志！")
    eventPlayer.setStatusEffect(null, Status.UNKILLABLE, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 1)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
    eventPlayer.startHealingOverTime(eventPlayer, ZaryaBuff[3], ZaryaBuff[4])
    eventPlayer.zarya_buff[1] = getLastHealingOverTimeId()
    wait(15)
    eventPlayer.zarya_buff[0] = false
    eventPlayer.zarya_buff[1] = null

rule "[Reaper]: Death Blossom remove Mov. speed penalty":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.mov_speed_buff += 100
    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff)
    waitUntil(not eventPlayer.isUsingUltimate(), 3.5)
    eventPlayer.mov_speed_buff = 0
    eventPlayer.setMoveSpeed(100)

rule "[Junkrat]: Steel Trap bleed":
    @Event playerDealtDamage
    @Hero junkrat
    @Condition eventAbility == Button.ABILITY_2
    
    victim.startDamageOverTime(attacker, 9999, 10)
    eventPlayer.junkrat_buff = getLastDamageOverTimeId()

rule "[Junkrat]: Steel Trap bleed":
    @Event playerReceivedHealing
    @Condition eventPlayer.junkrat_buff != null
    @Condition eventPlayer.isAlive() == true
    
    stopDamageOverTime(eventPlayer.junkrat_buff)
    eventPlayer.junkrat_buff = null

rule "[Junkrat]: arsonist":
    @Event playerDealtDamage
    @Hero junkrat
    #@Condition victim.hasStatus(Status.BURNING) == false
    @Condition eventAbility != Button.MELEE
    
    victim.setStatusEffect(attacker, Status.BURNING, 3)
    if victim.hasStatus(Status.BURNING) != true:
        goto lbl_0
    damage(victim, attacker, victim.getHealth() * 0.1)
    lbl_0:
    wait(1)

rule "[Juno] Track Orbital Ray Position":
    @Event eachPlayer
    @Hero juno
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.isAlive() == true
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    getPlayersInRadius(eventPlayer, 12.5, eventPlayer.getTeam()).juno_buff[0] = true
    wait(10)
    getPlayers(eventPlayer.getTeam()).juno_buff[0] = false

rule "[Juno]: Orbial Ray Damage":
    @Event eachPlayer
    @Condition eventPlayer.juno_buff[0] == true
    
    smallMessage(eventPlayer, "   {0} 轨道射线： 伤害减免 {1}%".format(abilityIconString(Hero.JUNO, Button.ULTIMATE), JunoBuff))
    eventPlayer.setDamageReceived(100 - JunoBuff)
    waitUntil(not eventPlayer.juno_buff[0], 10)
    eventPlayer.setDamageReceived(100)
    smallMessage(eventPlayer, "   {0} 轨道射线： 伤害减免已结束".format(abilityIconString(Hero.JUNO, Button.ULTIMATE)))

rule "[Juno]: Pulsar Torpedoes Healing":
    @Event playerReceivedHealing
    @Condition healer.getHero() == Hero.JUNO
    @Condition eventAbility == Button.SECONDARY_FIRE
    
    eventPlayer.healing_increase += 50
    eventPlayer.setHealingReceived(100 - eventPlayer.healing_decrease + eventPlayer.healing_increase)
    healee.startHealingOverTime(healer, 2.5, ceil(healee.getMaxHealth() * 0.25 / 2.5))
    waitUntil(eventPlayer.isDead(), 4)
    eventPlayer.setHealingReceived(100)
    eventPlayer.healing_increase = 0
    wait(2.6)

#!include "modules/hero_rules/shared/freja/10-revdraw-crossbow-stack-primary-fire.opy"

rule "[Freja]: Revdraw Crossbow Stack":
    @Event playerReceivedKnockback
    @Condition attacker.getHero() == Hero.FREJA
    @Condition eventAbility == Button.ULTIMATE
    
    victim.freja_buff[0] += 40
    #damage(victim, attacker, victim.getMaxHealth() * FrejaBuff[1])
    wait(5)

rule "[Freja]: Take Aim Damage":
    @Event playerDealtDamage
    @Hero freja
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false
    @Condition victim.has_nano != true
    @Condition victim.freja_buff[0] > 0
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.BLUE, victim, 0.8)
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.BLUE, victim, 10)
    damage(victim, attacker, FrejaBuff[0] * victim.freja_buff[0] + victim.getMaxHealth() * FrejaBuff[1])
    victim.freja_buff[0] = 0
    victim.freja_buff[1] = 0

rule "[Freja]: HUD & Reset":
    @Event eachPlayer
    @Condition eventPlayer.freja_buff[0] > 0
    
    if eventPlayer.freja_buff[3] != 0:
        goto lbl_0
    hudText(eventPlayer.reset_pvar[11], null, " \r\n", "  {0} 狩猎印记： {1}".format(heroIcon(eventPlayer.getHero()), eventPlayer.freja_buff[0]), HudPosition.LEFT, 1, null, null, rgb(255, 255, 255, 200), HudReeval.STRING)
    eventPlayer.freja_buff[3] = getLastCreatedText()
    lbl_0:
    eventPlayer.freja_buff[1] = eventPlayer.freja_buff[0]
    wait(15)
    if eventPlayer.freja_buff[0] > eventPlayer.freja_buff[1]:
        loop()
    eventPlayer.freja_buff[0] = 0
    eventPlayer.freja_buff[1] = 0
    destroyHudText(eventPlayer.freja_buff[3])
    eventPlayer.freja_buff[3] = 0

rule "[Freja]: Ex":
    @Event playerDealtKnockback
    @Hero freja
    @Condition eventAbility == null
    @Condition victim.hasStatus(Status.INVINCIBLE) != true
    @Condition victim.zarya_buff[1] == null
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false
    @Condition victim.has_nano != true
    #@Condition victim.freja_buff[0] > 0
    
    if not victim.isAlive() or victim.getHealth() > victim.getMaxHealth() * FrejaBuff[2]:
        goto lbl_0
    damage(victim, attacker, 44444)
    smallMessage(eventPlayer, "  斩杀： {0} ".format(heroIcon(victim.getHero())))
    wait(1, Wait.ABORT_WHEN_FALSE)
    lbl_0:

rule "[Freja]: Dmg. reduction":
    @Event eachPlayer
    @Hero freja
    @Condition eventPlayer.isUsingAbility2() == true
    #@Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) != 0
    @Condition eventPlayer.isInAir() == true
    
    eventPlayer.setDamageReceived(75)
    hudText(eventPlayer, null, " \r\n", "受到伤害减免：{0}%".format(25), HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.freja_buff[2] = getLastCreatedText()
    waitUntil(not eventPlayer.isInAir() and eventPlayer.isOnGround(), 99999)
    destroyHudText(eventPlayer.freja_buff[2])
    eventPlayer.freja_buff[2] = 0
    eventPlayer.setDamageReceived(100)

#!include "modules/hero_rules/shared/freja/90-set-projectile-speed.opy"

rule "[Torbjörn]: Forge Hammer":
    @Event eachPlayer
    @Hero torbjorn
    @Condition (eventPlayer.isInAlternateForm() and eventPlayer.getCurrentWeapon() == 2) == true
    
    eventPlayer.setDamageDealt(300)
    waitUntil(not (eventPlayer.isInAlternateForm() and eventPlayer.getCurrentWeapon() == 2), 999999986991104)
    eventPlayer.setDamageDealt(100)
    wait(1)

rule "[Torbjörn]: Forge Hammer":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.addHealthPool(Health.NORMAL, 100, false, false)
    eventPlayer.heart_steel = getLastCreatedHealthPool()
    waitUntil(not eventPlayer.isUsingAbility2(), 8)
    removeHealthPool(eventPlayer.heart_steel)

rule "[Juno]: Pulsar Torpedoes":
    @Event playerDealtDamage
    @Hero juno
    @Condition eventAbility == Button.SECONDARY_FIRE
    
    damage(victim, attacker, victim.getMaxHealth() * 0.2)

rule "[Bastion]: Configuration: Artillery":
    @Event playerDealtDamage
    @Hero bastion
    @Condition eventAbility == Button.ULTIMATE
    
    damage(victim, attacker, victim.getHealth() * 0.25)
    wait(0.25)

rule "[Roadhog]: Hogdrogen Exposure":
    @Event playerDealtHealing
    @Hero roadhog
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventAbility == Button.SECONDARY_FIRE
    
    heal(healee, healer, 50)
    wait(0.5)

rule "[Roadhog]: Breather":
    @Event eachPlayer
    @Team 1
    @Hero roadhog
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    heal(getLivingPlayers(eventPlayer.getTeam()), eventPlayer, 70)
    wait(0.65)
    if ruleCondition:
        loop()

rule "[Roadhog]: Breather":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isFiringSecondaryFire() != true
    @Condition eventPlayer.getAbilityResource(Button.SECONDARY_FIRE) <= 50
    
    wait(0.54)
    eventPlayer.setAbilityResource(Button.SECONDARY_FIRE, 50)
    wait(1.25)

rule "[Roadhog]: Breather":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    eventPlayer.mov_speed_buff += 75
    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff - eventPlayer.mov_speed_penalty)
    waitUntil(not eventPlayer.isFiringSecondaryFire(), 15)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.mov_speed_buff = 0

rule "[Roadhog]: Chain Hook return cd":
    @Event playerDealtDamage
    @Hero roadhog
    @Condition eventAbility == Button.ABILITY_1
    
    waitUntil(not eventPlayer.isUsingAbility1(), 1.75)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, eventPlayer.getAbilityCooldown(Button.ABILITY_1) * 0.5)

rule "[Roadhog]: hook lancher":
    @Event playerDealtDamage
    @Hero roadhog
    @Condition eventAbility == Button.ABILITY_1
    
    smallMessage(eventPlayer, "  {0} 长按 {1} 发射敌人".format(abilityIconString(Hero.ROADHOG, Button.ABILITY_1), Button.INTERACT))
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    waitUntil(not eventPlayer.isUsingAbility1() or distance(attacker, victim) <= 1.5, 8)
    #if eventPlayer.isHoldingButton(Button.INTERACT) != true:
    #        goto lbl_0
    if eventPlayer.getTeam() == Team.1 or eventPlayer.isHoldingButton(Button.INTERACT) == true:
        eventPlayer.cancelPrimaryAction()
        lbl_0:
        #victim.startForcingThrottle(0, 0, 0, 0, 0, 0)
        #victim.setGravity(10)
        victim.applyImpulse(attacker.getFacingDirection(), 85, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)

rule "[Wrecking Ball]: ctrl 0cd":
    @Event playerDealtKnockback
    @Hero wreckingBall
    @Condition eventAbility == Button.CROUCH
    
    victim.setStatusEffect(eventPlayer, Status.STUNNED, 0.3)
    eventPlayer.applyImpulse(Vector.UP, 15, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.setAbilityCooldown(Button.CROUCH, 0)

rule "[Winston]: Tesla Cannon Alt Fire":
    @Event playerTookDamage
    @Condition victim.unaffected != true
    @Condition attacker.getHero() == Hero.WINSTON
    @Condition (eventAbility == Button.SECONDARY_FIRE or eventAbility == null) == true
    
    wait(0.16)
    #victim.setStatusEffect(attacker, Status.STUNNED, 0.3)
    damage(victim, null, eventPlayer.getMaxHealth() * 0.1)
    wait(0.8)

rule "[Ashe]: Dynamite Damage":
    @Event playerDealtDamage
    @Hero ashe
    @Condition eventAbility == Button.ABILITY_2
    @Condition attacker != victim
    
    victim.startDamageOverTime(attacker, 2, victim.getMaxHealth() * 0.5 / 2)
    wait(5)

rule "[Ashe]: Dynamite cd":
    @Event playerDealtDamage
    @Hero ashe
    @Condition eventAbility == Button.ABILITY_2
    @Condition attacker != victim
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.getAbilityCooldown(Button.ABILITY_2) - 1)
    wait(1)

rule "[Wuyang]: mov_speed_penalty":
    @Event playerDealtKnockback
    @Hero wuyang
    #@Condition eventAbility == null
    
    if victim.mov_speed_penalty > 0 and victim.isAlive():
        victim.setHealth(victim.getHealth() - 45)
    else:
        victim.mov_speed_penalty = WuyangBuff[0]
        victim.setMoveSpeed(100 + victim.mov_speed_buff - victim.mov_speed_penalty)
        waitUntil(victim.mov_speed_penalty == 0 or victim.unaffected or victim.hasStatus(Status.INVINCIBLE), 1.25)
        victim.setMoveSpeed(100)
        victim.mov_speed_penalty = 0
    wait(0.32)

rule "[Wuyang]: xuanwu cd":
    @Event playerDealtKnockback
    @Hero wuyang
    @Condition eventAbility == null
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.getAbilityCooldown(Button.ABILITY_2) - 1)
    wait(0.5)

rule "[Wuyang]: Restorative shield Target":
    @Event playerReceivedHealing
    @Condition healer.getHero() == Hero.WUYANG
    @Condition eventAbility == null
    @Condition eventHealing <= 8
    @Condition healee.wuyang_buff[0] != true
    
    healee.wuyang_buff[0] = true
    wait(1)
    removeHealthPool(eventPlayer.wuyang_buff[1])

rule "[Wuyang]: Restorative shield":
    @Event eachPlayer
    @Condition eventPlayer.wuyang_buff[0] == true
    @Condition eventPlayer.getHero() != Hero.WUYANG
    
    eventPlayer.wuyang_buff[0] = false
    if eventPlayer.wuyang_buff[1] == null:
        goto lbl_0
    removeHealthPool(eventPlayer.wuyang_buff[1])
    lbl_0:
    eventPlayer.addHealthPool(Health.SHIELDS, WuyangBuff[1], true, false)
    eventPlayer.wuyang_buff[1] = getLastCreatedHealthPool()

rule "[Wuyang]: Rushing Torrent":
    @Event eachPlayer
    @Hero wuyang
    @Condition eventPlayer.isUsingAbility1() == true
    
    if eventPlayer.getNormalizedHealth() == 1:
        goto lbl_0
    eventPlayer.startHealingOverTime(eventPlayer, 4.5, WuyangBuff[2])
    eventPlayer.wuyang_buff[0] = getLastHealingOverTimeId()
    lbl_0:
    eventPlayer.dmg_reduction = WuyangBuff[3]
    eventPlayer.setDamageReceived(100 - eventPlayer.dmg_reduction)
    waitUntil(not eventPlayer.isUsingAbility1(), 4.5)
    eventPlayer.dmg_reduction = 0
    stopHealingOverTime(eventPlayer.wuyang_buff[0])
    eventPlayer.setDamageReceived(100)

rule "[Wuyang]: Rushing Torrent jump":
    @Event eachPlayer
    @Hero wuyang
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    #@Condition eventPlayer.isInAir() != true
    
    eventPlayer.applyImpulse(Vector.UP, 12, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(0.16)
    waitUntil(eventPlayer.isOnGround(), 3)

rule "[Wuyang]: Ebb and Flow lost control":
    @Event playerReceivedKnockback
    @Condition eventAbility == Button.ABILITY_2
    @Condition attacker.getHero() == Hero.WUYANG
    
    victim.startForcingThrottle(0, 0, 0, 0, 0, 0)
    #victim.applyImpulse(Vector.UP, 1, Relativity.TO_PLAYER)
    #victim.setGravity(0)
    waitUntil(victim.hasStatus(Status.INVINCIBLE), 0.75)
    victim.stopForcingThrottle()
    #victim.setGravity(100)

rule "[Wuyang]: Ebb and Flow set":
    @Event playerReceivedKnockback
    #@Condition eventPlayer.isUsingAbility2() == true
    @Condition eventAbility == Button.ABILITY_2
    @Condition attacker.getHero() == Hero.WUYANG
    
    victim.wuyang_buff[2]++
    #eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.getAbilityCooldown(Button.ABILITY_2) - 1)
    wait(0.16)

#!include "aram_overrides_segments/hero_rules_wuyang_ebb_and_flow_ability_countdown.opy"

rule "[Wuyang]: Tidal Blast mov_speed_penalty":
    @Event playerDealtKnockback
    @Hero wuyang
    @Condition eventAbility == Button.ULTIMATE
    
    victim.mov_speed_penalty += WuyangBuff[4]
    victim.setMoveSpeed(100 + victim.mov_speed_buff - victim.mov_speed_penalty)
    waitUntil(victim.mov_speed_penalty == 0 or victim.unaffected or victim.hasStatus(Status.INVINCIBLE), 3)
    victim.setMoveSpeed(100)
    victim.mov_speed_penalty -= WuyangBuff[4]

#!include "aram_overrides_segments/hero_rules_wuyang_tidal_blast_allies_target_healing.opy"

rule "[Vendetta] Palatine Fang":
    @Event playerDealtDamage
    @Hero vendetta
    @Condition eventAbility != null
    
    heal(eventPlayer, eventPlayer, eventDamage * 0.4)
    wait()

rule "Initialize Heors":
    @Disabled
    @Delimiter

rule "[reaper/init.opy]: Detect switch to Reaper":
    @Event eachPlayer
    @Hero reaper
    
    eventPlayer.reset_pvar[0] = true

rule "[reaper/init.opy]: Initialize Reaper":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 500
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["滚筒洗衣机", "转圈摩西", "龙卷风摩西", "哈哈摩西", "菜就多练"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:
    eventPlayer.reset_pvar[0] = false

rule "[tracer/init.opy]: Detect switch to Tracer":
    @Event eachPlayer
    @Hero tracer
    
    eventPlayer.reset_pvar[0] = true

rule "[tracer/init.opy]: Initialize Tracer":
    @Event eachPlayer
    @Hero tracer
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 8)
    eventPlayer.custom_hp_pvar[0] = 150
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 350
    applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["跳跳熊", "FLETA", "EVAEL", "炸弹摩西", "瞬移摩西"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:
    eventPlayer.reset_pvar[0] = false

rule "[mercy/init.opy]: Detect switch to Mercy":
    @Event eachPlayer
    @Hero mercy
    
    eventPlayer.reset_pvar[0] = true

rule "[mercy/init.opy]: Initialize Mercy":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 250
    eventPlayer.custom_hp_pvar[1] = 50
    eventPlayer.custom_hp_pvar[2] = 200
    applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["摩西", "拉使", "打我自动下载原神", "慈悲十三摩"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
    eventPlayer.reset_pvar[0] = false

rule "[hanzo/init.opy]: Detect switch to Hanzo":
    @Event eachPlayer
    @Hero hanzo
    
    eventPlayer.reset_pvar[0] = true

rule "[hanzo/init.opy]: Initialize Hanzo":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 450
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["ANS", "吃矢不忘拉矢人", "拉矢摩西", "贩箭摩西"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:
    eventPlayer.reset_pvar[0] = false

rule "[Freja/init.opy]: Detect switch to Freja":
    @Event eachPlayer
    @Hero freja
    
    eventPlayer.reset_pvar[0] = true

rule "[Freja/init.opy]: Initialize Freja":
    @Event eachPlayer
    @Hero freja
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 450
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    eventPlayer.setProjectileSpeed(500)
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["ANS", "射 爆", "拉矢摩西"]))
    lbl_0:
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).reset_pvar[11] = eventPlayer
    applyCustomHp()
    eventPlayer.reset_pvar[0] = false

rule "[torbjorn/init.opy]: Detect switch to Torbjorn":
    @Event eachPlayer
    @Hero torbjorn
    
    eventPlayer.reset_pvar[0] = true

rule "[torbjorn/init.opy]: Initialize Torbjorn":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.setHealingDealt(667)
    eventPlayer.custom_hp_pvar[0] = 300
    eventPlayer.custom_hp_pvar[1] = 400
    eventPlayer.custom_hp_pvar[2] = 0
    applyCustomHp()
    eventPlayer.reset_pvar[0] = false

rule "[venture/init.opy]: Detect switch to venture":
    @Event eachPlayer
    @Hero venture
    
    eventPlayer.reset_pvar[0] = true

rule "[venture/init.opy]: Initialize venture":
    @Event eachPlayer
    @Hero venture
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 350
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 50
    applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["钻地摩西", "丁真摩西"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false

rule "[reinhardt/init.opy]: Detect switch to Reinhardt":
    @Event eachPlayer
    @Hero reinhardt
    
    eventPlayer.reset_pvar[0] = true

rule "[reinhardt/init.opy]: Initialize Reinhardt":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 200
    eventPlayer.custom_hp_pvar[1] = 800
    eventPlayer.custom_hp_pvar[2] = 0
    applyCustomHp()
    #eventPlayer.setKnockbackReceived(116.667)
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["小米Su7", "Hadi", "冲锋摩西", "抡锤摩西"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:
    eventPlayer.reset_pvar[0] = false

rule "[Hazard/init.opy]: Detect switch to Hazard":
    @Event eachPlayer
    @Hero hazard
    
    eventPlayer.reset_pvar[0] = true

rule "[Hazard/init.opy]: Initialize Hazard":
    @Event eachPlayer
    @Hero hazard
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 550
    eventPlayer.custom_hp_pvar[1] = 250
    eventPlayer.custom_hp_pvar[2] = 0
    applyCustomHp()
    removeTankPassive()
    eventPlayer.reset_pvar[0] = false

rule "[pharah/init.opy]: Detect switch to Pharah":
    @Event eachPlayer
    @Hero pharah
    
    eventPlayer.reset_pvar[0] = true

rule "[pharah/init.opy]: Initialize Pharah":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 300
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 150
    applyCustomHp()
    eventPlayer.reset_pvar[0] = false

rule "[winston/init.opy]: Detect switch to Winston":
    @Event eachPlayer
    @Hero winston
    
    eventPlayer.reset_pvar[0] = true

rule "[winston/init.opy]: Initialize Winston":
    @Event eachPlayer
    @Hero winston
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 300
    eventPlayer.custom_hp_pvar[1] = 500
    eventPlayer.custom_hp_pvar[2] = 0
    applyCustomHp()
    removeTankPassive()
    eventPlayer.reset_pvar[0] = false
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["电音王子吴亦凡", "雷电法王杨永信", "电击摩西", "菜就多练"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:

rule "[widowmaker/init.opy]: Detect switch to Widowmaker":
    @Event eachPlayer
    @Hero widowmaker
    
    eventPlayer.reset_pvar[0] = true

rule "[widowmaker/init.opy]: Initialize Widowmaker":
    @Event eachPlayer
    @Hero widowmaker
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 350
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["ANS", "亿枪一个", "KAI了就是KAI了？", "女兵摩西", "MN3"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
    eventPlayer.reset_pvar[0] = false

rule "[widowmaker.opy]: Infra-Sight headshot":
    @Event playerDealtDamage
    @Hero widowmaker
    #@Condition eventWasCriticalHit == true
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.isFiringPrimaryFire() == true
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    if eventWasCriticalHit != true:
        goto lbl_0
    damage(victim, attacker, victim.getMaxHealth() * (0.9 if eventPlayer.isUsingUltimate() == true else 0.5))
    lbl_0:

#!include "aram_overrides_segments/hero_init_widowmaker_falloff_and_bastion_detect.opy"

rule "[bastion/init.opy]: Initialize Bastion":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 200
    eventPlayer.custom_hp_pvar[1] = 350
    eventPlayer.custom_hp_pvar[2] = 0
    applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["电脑", "嘟嘟嘟嘟嘟", "大炮摩西", "无可奉告", "豪华超跑"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:
    eventPlayer.reset_pvar[0] = false

rule "[symmetra/init.opy]: Detect switch to Symmetra":
    @Event eachPlayer
    @Hero symmetra
    
    eventPlayer.reset_pvar[0] = true

rule "[symmetra/init.opy]: Initialize Symmetra":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 250
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 250
    getPlayers(eventPlayer.getTeam()).reset_pvar[3] = eventPlayer
    applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["性♂感荷官在线烫头", "绿洲城首家赌场", "麻豆传媒摄影师", "烫头摩西"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:
    eventPlayer.reset_pvar[0] = false

rule "[zenyatta]: Detect switch to zenyatta":
    @Event eachPlayer
    @Hero zenyatta
    
    eventPlayer.reset_pvar[0] = true

rule "[zenyatta]: init":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 25
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 475
    applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["武僧", "出家摩西", "机械摩西", "就这", "JJONAK"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
    eventPlayer.reset_pvar[0] = false

rule "[Genji]: Detect switch to Genji":
    @Event eachPlayer
    @Hero genji
    
    eventPlayer.reset_pvar[0] = true

rule "[Genji]":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 475
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 25
    applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["国服{0}分顶尖镖师".format(Genji[0]), "飞镖摩西", "源神", "忍者摩西", "源氏凯"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:
    eventPlayer.reset_pvar[0] = false

rule "[roadhog]: Detect switch to roadhog":
    @Event eachPlayer
    @Hero roadhog
    
    eventPlayer.reset_pvar[0] = true

rule "[roadhog]":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    startHealingModification(getPlayers(eventPlayer.getTeam()), eventPlayer, 200, HealingReeval.RECEIVERS_AND_HEALERS)
    eventPlayer.custom_hp_pvar[0] = 400
    eventPlayer.custom_hp_pvar[1] = 800
    eventPlayer.custom_hp_pvar[2] = 0
    applyCustomHp()
    removeTankPassive()
    eventPlayer.reset_pvar[0] = false

rule "[Cassidy]: Detect switch to Cassidy":
    @Event eachPlayer
    @Hero cassidy
    
    eventPlayer.reset_pvar[0] = true

rule "[Cassidy]: Initialize Cassidy":
    @Event eachPlayer
    @Hero cassidy
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 450
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["张三", "天王老子", "KAI了", "麦克雷", "六连摩西", "菜就多练"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:
    eventPlayer.reset_pvar[0] = false

rule "[Cassidy.opy]: Revert sniper damage falloff":
    @Event playerDealtDamage
    @Hero cassidy
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition distance(attacker.getEyePosition(), victim) >= 25.1
    
    eventPlayer.scoped_shot_distance = distance(attacker.getEyePosition(), victim)
    #原OW2衰减计算（25-35米 70%衰减）
    eventPlayer.ow2_scoped_damage_falloff_scalar = 1 - (((eventPlayer.scoped_shot_distance - 25) / 10) * 0.7) + (1 - ((eventPlayer.scoped_shot_distance - 25) / 10))
    if eventPlayer.ow2_scoped_damage_falloff_scalar > 1:
        eventPlayer.ow2_scoped_damage_falloff_scalar = 1
        #Min damage scalar
    elif eventPlayer.ow2_scoped_damage_falloff_scalar < 0.3:
        eventPlayer.ow2_scoped_damage_falloff_scalar = 0.3
    eventPlayer.scoped_damage_base = eventDamage / eventPlayer.ow2_scoped_damage_falloff_scalar
    eventPlayer.ow1_scoped_damage_falloff_scalar = 1 - (((eventPlayer.scoped_shot_distance - 25) / 25) * 0.3)
    #Cap min/max scalar
    # Max damage scalar
    if eventPlayer.ow1_scoped_damage_falloff_scalar < 0.7:
        eventPlayer.ow1_scoped_damage_falloff_scalar = 0.7
    if eventPlayer.scoped_shot_distance > 50:
        eventPlayer.ow1_scoped_damage_falloff_scalar = 0.7
    eventPlayer.expected_scoped_damage = eventPlayer.scoped_damage_base * eventPlayer.ow1_scoped_damage_falloff_scalar
    damage(victim, attacker, ceil(eventPlayer.expected_scoped_damage - eventDamage))

rule "[Junkrat]: Detect switch to Junkrat":
    @Event eachPlayer
    @Hero junkrat
    
    eventPlayer.reset_pvar[0] = true

rule "[Junkrat] Initialize":
    @Event eachPlayer
    @Hero junkrat
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 450
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["拉 史 大 王", "拉 史 摩 西", "鼠鼠摩西", "鸭脖摩西", "夹子摩西"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:
    eventPlayer.reset_pvar[0] = false

rule "[Zarya]: Detect switch to Zarya":
    @Event eachPlayer
    @Hero zarya
    
    eventPlayer.reset_pvar[0] = true

rule "[Zarya] Initialize":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.zarya_buff[0] = true
    eventPlayer.custom_hp_pvar[0] = 450
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 450
    applyCustomHp()
    removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["Sinatraa", "泡泡摩西", "东北雨姐"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:
    eventPlayer.reset_pvar[0] = false

rule "[Soldier: 76]: Detect switch to Soldier 76":
    @Event eachPlayer
    @Hero soldier
    
    eventPlayer.reset_pvar[0] = true

rule "[Soldier: 76]: Initialize":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.heart_steel[1] = 0
    eventPlayer.custom_hp_pvar[0] = 200
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    applyCustomHp()
    #This creates the ring effect (4.5m)
    createEffect(getPlayers(eventPlayer.getTeam()), Effect.RING, rgb(254, 180, 21), eventPlayer, S76Buff[4], EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.heart_steel[4] = getLastCreatedEntity()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["国服顶尖小巴蒂", "跑酷摩西", "奶棒摩西", "Kai了", "飞弹摩西"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:
    eventPlayer.reset_pvar[0] = false

rule "[Soldier: 76]: Third Person":
    @Event eachPlayer
    @Team 2
    @Hero soldier
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.third_person = false if eventPlayer.third_person == true else true
    setThirdPerson()

rule "[Lucio]: Detect switch to Lucio":
    @Event eachPlayer
    @Hero lucio
    
    eventPlayer.reset_pvar[0] = true

rule "[Lucio] Initialize":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 200
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 250
    applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["巴西拳王", "喇叭摩西", "轮滑摩西"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:
    eventPlayer.reset_pvar[0] = false

rule "[D.Va]: Fix hp":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isInAlternateForm() == true
    
    wait(0.16)
    eventPlayer.custom_hp_pvar[0] = 150
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    applyCustomHp()

rule "[D.Va]: Detect switch to D.Va":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isInAlternateForm() == false
    
    eventPlayer.reset_pvar[0] = true

rule "[D.Va] Initialize":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 200
    eventPlayer.custom_hp_pvar[1] = 850
    eventPlayer.custom_hp_pvar[2] = 0
    applyCustomHp()
    removeTankPassive()
    eventPlayer.reset_pvar[0] = false

rule "[Mei]: Detect switch to Mei":
    @Event eachPlayer
    @Hero mei
    
    eventPlayer.reset_pvar[0] = true

rule "[Mei] Initialize":
    @Event eachPlayer
    @Hero mei
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 250
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 200
    applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["识得唔识得啊", "冰雕摩西", "麦克美", "周美玲冰雪大世界", "哈尔滨摩西"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:
    eventPlayer.reset_pvar[0] = false

rule "[Sombra]: Detect switch to Sombra":
    @Event eachPlayer
    @Hero sombra
    
    eventPlayer.reset_pvar[0] = true

rule "[Sombra] Initialize":
    @Event eachPlayer
    @Hero sombra
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 450
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["全民偶像酸不辣", "多少有点LIP", "就这", "菜就多练", "离谱摩西", "隐身摩西"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:
    getPlayers(eventPlayer.getTeam()).reset_pvar[4] = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).reset_pvar[7] = eventPlayer
    eventPlayer.reset_pvar[0] = false

rule "[Ana]: Detect switch to Ana":
    @Event eachPlayer
    @Hero ana
    
    eventPlayer.reset_pvar[0] = true

rule "[Ana] Initialize":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 300
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    applyCustomHp()
    eventPlayer.heart_steel[2] = true
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["老年摩西", "发烧摩西", "睡觉摩西", "末日铁娜", "独眼摩西"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
    eventPlayer.reset_pvar[0] = false

rule "[Orisa]: Detect switch to Orisa":
    @Event eachPlayer
    @Hero orisa
    
    eventPlayer.reset_pvar[0] = true

rule "[Orisa] Initialize":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 1000
    eventPlayer.custom_hp_pvar[1] = 3500
    eventPlayer.custom_hp_pvar[2] = 0
    applyCustomHp()
    removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["命运羊驼", "堡垒", "美羊羊", "唯一真神", "标枪摩西", "小米Su7"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:
    eventPlayer.reset_pvar[0] = false

rule "[Brigitte]: Detect switch to Brigitte":
    @Event eachPlayer
    @Hero brigitte
    
    eventPlayer.reset_pvar[0] = true

rule "[Brigitte] Initialize":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 200
    eventPlayer.custom_hp_pvar[1] = 650
    eventPlayer.custom_hp_pvar[2] = 0
    getPlayers(eventPlayer.getTeam()).reset_pvar[1] = eventPlayer
    applyCustomHp()
    #eventPlayer.setMaxHealth(41.667)
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["那个女人", "RUA里吐米", "炖鸡高手", "炖鸡摩西", "持盾摩西", "贴膜摩西", "这是什么", "泰格"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:
    eventPlayer.reset_pvar[0] = false

rule "[Moira]: Detect switch to Moira":
    @Event eachPlayer
    @Hero moira
    
    eventPlayer.reset_pvar[0] = true

rule "[Moira] Initialize":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 250
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 200
    applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["五  金  上  将", "五金上将莫伊拉", "五金摩西", "菜就多练"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:
    eventPlayer.reset_pvar[0] = false

rule "[Wrecking Ball]: Detect switch to Wrecking Ball":
    @Event eachPlayer
    @Hero wreckingBall
    
    eventPlayer.reset_pvar[0] = true

rule "[Wrecking Ball] Initialize":
    @Event eachPlayer
    @Hero wreckingBall
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 500
    eventPlayer.custom_hp_pvar[1] = 200
    eventPlayer.custom_hp_pvar[2] = 200
    applyCustomHp()
    removeTankPassive()
    eventPlayer.reset_pvar[0] = false

rule "[Sojourn]: Detect switch to Sojourn":
    @Event eachPlayer
    @Hero sojourn
    
    eventPlayer.reset_pvar[0] = true

rule "[Sojourn] Initialize":
    @Event eachPlayer
    @Hero sojourn
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 450
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["跳跳熊", "我超摩西", "我超", "ANS", "MN3", "EVAEL", "没KAI"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:
    eventPlayer.reset_pvar[0] = false

rule "[Ashe]: Detect switch to Ashe":
    @Event eachPlayer
    @Hero ashe
    
    eventPlayer.reset_pvar[0] = true

rule "[Ashe] Initialize":
    @Event eachPlayer
    @Hero ashe
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 450
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["张三的绯闻女友", "KAI了", "ANS", "Bob摩西", "菜就多练"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:
    eventPlayer.reset_pvar[0] = false

rule "[Echo]: Detect switch to Echo":
    @Event eachPlayer
    @Hero echo
    
    eventPlayer.reset_pvar[0] = true

rule "[Echo] Initialize":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 400
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 50
    applyCustomHp()
    eventPlayer.reset_pvar[0] = false

rule "[Baptiste]: Detect switch to Baptiste":
    @Event eachPlayer
    @Hero baptiste
    
    eventPlayer.reset_pvar[0] = true

rule "[Baptiste] Initialize":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 450
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["大 76", "Kai了", "天使", "锁血摩西", "锁头摩西"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
    eventPlayer.reset_pvar[0] = false

rule "[Kiriko]: Detect switch to Kiriko":
    @Event eachPlayer
    @Hero kiriko
    
    eventPlayer.reset_pvar[0] = true

rule "[Kiriko] Initialize":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 450
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["忍者摩西", "画符摩西"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:
    eventPlayer.reset_pvar[0] = false

rule "[Junker Queen]: Detect switch to Junker Queen":
    @Event eachPlayer
    @Hero junkerQueen
    
    eventPlayer.reset_pvar[0] = true

rule "[Junker Queen] Initialize":
    @Event eachPlayer
    @Hero junkerQueen
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.setHealingDealt(122.23)
    eventPlayer.custom_hp_pvar[0] = 850
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    applyCustomHp()
    removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["姐就是女王", "自信放光芒", "你若爱就来", "不爱莫张狂", "收起你的那些小小花花肠", "甜言或蜜语去哄小姑娘", "姐就是女王", "自信放光芒", "有钱了不起", "姐也很自强", "不惧风霜雪雨逆风也飞翔", "活成一束光世界都照亮"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:
    eventPlayer.reset_pvar[0] = false

rule "[Sigma]: Detect switch to Sigma":
    @Event eachPlayer
    @Hero sigma
    
    eventPlayer.reset_pvar[0] = true

rule "[Sigma] Initialize":
    @Event eachPlayer
    @Hero sigma
    @Condition eventPlayer.reset_pvar[0] != false
    
    eventPlayer.setMaxHealth(50)
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 400
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 450
    applyCustomHp()
    removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["老年跳高运动员", "长 者", "放盾摩西", "大爷摩西", "菜就多练"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:
    eventPlayer.reset_pvar[0] = false

rule "[Ramattra]: Detect switch to Ramattra":
    @Event eachPlayer
    @Hero ramattra
    
    eventPlayer.reset_pvar[0] = true

rule "[Ramattra] Initialize":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 500
    eventPlayer.custom_hp_pvar[1] = 700
    eventPlayer.custom_hp_pvar[2] = 0
    applyCustomHp()
    removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["依托答辩", "鲑鱼大帝", "Suffer as i have!", "鲑鱼摩西", "痛苦摩西", "抱头摩西"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:
    eventPlayer.reset_pvar[0] = false

rule "[Juno]: Detect switch to Juno":
    @Event eachPlayer
    @Hero juno
    
    eventPlayer.reset_pvar[0] = true

rule "[Juno] Initialize":
    @Event eachPlayer
    @Hero juno
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 50
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 375
    applyCustomHp()
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
    eventPlayer.reset_pvar[0] = false

rule "[Doomfist]: Detect switch to Doomfist":
    @Event eachPlayer
    @Hero doomfist
    
    eventPlayer.reset_pvar[0] = true

rule "[Doomfist] Initialize":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 300
    eventPlayer.custom_hp_pvar[1] = 500
    eventPlayer.custom_hp_pvar[2] = 0
    applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["男拳妈妈", "铁拳不准上桌吃饭", "吃个娜娜", "全部曹飞", "男拳摩西", "曹飞", "你这天使有用吗", "你倒是跑啊"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:
    getPlayers(eventPlayer.getTeam()).reset_pvar[2] = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).reset_pvar[5] = eventPlayer
    removeTankPassive()
    eventPlayer.reset_pvar[0] = false

rule "[Lifeweaver]: Detect switch to Lifeweaver":
    @Event eachPlayer
    @Hero lifeweaver
    
    eventPlayer.reset_pvar[0] = true

rule "[Lifeweaver] Initialize":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 175
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 350
    applyCustomHp()
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
    eventPlayer.reset_pvar[0] = false
    eventPlayer.setMaxAmmo(0, 9999)
    eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())

rule "[Mauga]: Detect switch to Mauga":
    @Event eachPlayer
    @Hero mauga
    
    eventPlayer.reset_pvar[0] = true

rule "[Mauga] Initialize":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 250
    eventPlayer.custom_hp_pvar[1] = 700
    eventPlayer.custom_hp_pvar[2] = 0
    applyCustomHp()
    removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.N = ["黑皮体育生", "黑皮摩西", "战斗爽", "Seiseiguigeigei", "发烧摩西", "小米SU7"]
    eventPlayer.startForcingName(random.choice(eventPlayer.N))
    lbl_0:
    eventPlayer.reset_pvar[0] = false

rule "[Illari]: Detect switch to Illari":
    @Event eachPlayer
    @Hero illari
    
    eventPlayer.reset_pvar[0] = true

rule "[Illari] Initialize":
    @Event eachPlayer
    @Hero illari
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 400
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    applyCustomHp()
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
    eventPlayer.reset_pvar[0] = false

rule "Changelog":
    @Event eachPlayer
    @Team 2
    @Condition isGameInProgress() != true
    @Condition eventPlayer.isInSpawnRoom() == true
    
    wait(0.16)
    changelogText()
    waitUntil(not eventPlayer.isInSpawnRoom(), 999999986991104)
    destroyHudText(eventPlayer.ChangelogText1)
    destroyHudText(eventPlayer.ChangelogText2)

def changelogText():
    @Name "Changelog Content"
    
    hudSubtext(eventPlayer, " \r\n\r\n\n", HudPosition.LEFT, 0, true, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    eventPlayer.ChangelogText1 = getLastCreatedText()
    if eventPlayer.getHero() == Hero.DVA:
        hudText(eventPlayer, null, Mark, "\r\n●\"{0}\"\r\n*造成伤害 +5%\r\n*受到伤害 -25%\r\n{1} 防御矩阵\r\n\u00a0持续时间提高至 4 秒\r\n 完全充能时间由 6 秒降低至 3 秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE)), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.DOOMFIST:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +10%\r\n*受到伤害 -30%\r\n*技能造成伤害获得额外护甲\r\n*裂地重拳\r\n\u00a0 将敌人击飞拉近并使其失控\n\n※※离开重生室隐藏".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.JUNKER_QUEEN:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +30%\r\n*受到伤害 -50%\r\n*血斩 冷却时间降低\r\n*锯齿利刃 冷却时间降低\n\n※※离开重生室隐藏".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.MAUGA:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +15%\r\n*受到伤害 -30%\r\n*蛮力冲撞 持续期间 无敌\r\n*心脏过载 长按{1}向面朝方向飞行\r\n".format(eventPlayer.getHero(), Button.JUMP), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.ORISA:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*受到伤害 -30%\r\n*强固防御\r\n\u00a0 反弹受到的{1}%伤害\r\n  每秒恢复10%最大生命值\r\n*标枪旋击\r\n\u00a0 长按{2}向面朝方向飞行\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), Orisa_Fortify[1], Button.JUMP), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.RAMATTRA:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +15%\r\n*受到伤害 -35%\r\n*天罚形态：铁壁 存储受到的伤害并转化为临时生命值\r\n* 诛 70%击退抵抗\r\n  获得{2}%已造成伤害的HP回复\r\n  造成击杀获得25%终极技能充能\n\n※离开重生室隐藏".format(eventPlayer.getHero(), Ram_Annihilation[4], Ram_Annihilation[1] * 100), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.JUNO:
        hudText(eventPlayer, null, Mark, "\r\n{0}\r\n{1}\n\n※※离开重生室隐藏".format("●{0}\r\n*造成治疗 +10%".format(eventPlayer.getHero()), "{0}\r\n{1}".format("{0} 脉冲星飞雷 额外造成20%最大生命值伤害与25%最大生命值治疗".format(abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE)), "{0} 轨道射线 范围内所有友方受到伤害-{1}%（唯一特效）".format(abilityIconString(eventPlayer.getHero(), Button.ULTIMATE), JunoBuff))), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.REINHARDT:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +10%\r\n*受到伤害 -25%\r\n*烈焰打击 恢复100%已造成伤害的生命值\r\n*裂地猛击 造成击杀返还100%充能\n\n※※离开重生室隐藏".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.ROADHOG:
        hudText(eventPlayer, null, Mark, "\r\n●{0} 获得额外75%移速加成\r\n  能量不会低于50%\r\n  友方获得100%治疗量\r\n{1}链钩 命中目标返还50%冷却\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE)), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.SIGMA:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +15%\r\n*受到伤害 -25%\r\n*超能之球 每5次攻击强化下一次攻击 附带自身当前生命值{1}%伤害\r\n*引力乱流 最大生命值伤害增加至 75%\n\n※离开重生室隐藏".format(eventPlayer.getHero(), SigmaBuff[0] * 100), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.WINSTON:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +10%\r\n*受到伤害 -30%\r\n{1} 集束电击 造成10%最大生命值伤害\r\n \n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.PRIMARY_FIRE)), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.WRECKING_BALL:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +5%\r\n*受到伤害 -25%\r\n{1}重力坠击\r\n  击晕命中的敌人并返还技能冷却\r\n\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.CROUCH)), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.ZARYA:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +5%\r\n*受到伤害 -30%\r\n*投射屏障 为目标提供3秒{1}点临时生命值\r\n\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), ZaryaBuff[0]), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.HAZARD:
        hudText(eventPlayer, null, Mark, "\r\n{0}\r\n{1}\r\n{2}\n\n※※离开重生室隐藏".format("●{0}\r\n*造成伤害 +5%\r\n*受到伤害 -20%".format(eventPlayer.getHero()), "*狂跃 造成{0}%最大生命值额外伤害\r\n  斩杀生命值低于{0}%的敌人".format(HazardBuff[0] * 100), "{0}".format("*千针雨 窃取敌人{0}%终极技能充能".format(HazardBuff[11]))), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.ASHE:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +40%\r\n*毒蛇\r\n  暴击倍率提高至 ×{1}\r\n*延时雷管\r\n  造成伤害返还1秒技能冷却\r\n灼烧造成目标最大生命值50%额外伤害\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), HeadshotDamage[1]), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.SOMBRA:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +10%\r\n*受到伤害 -20%\r\n*位移传动  击杀后重置CD\r\n*黑客入侵  沉默敌人5秒并 使敌方额外减疗{1}%\r\n\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), SombraBuff[0]), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.CASSIDY:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +10%\r\n*受到伤害 -6%\r\n{1}维和者\r\n  换弹速度降低至0.75秒\r\n  连射伤害提高至90点/发\r\n{2}闪光弹 击晕敌人\r\n*神射手 充能速度降低\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.PRIMARY_FIRE), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2)), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.GENJI:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +25%\r\n*受到伤害 -20%\r\n*造成击杀后恢复生命值\r\n*影 斩杀生命值低于10%的敌人\r\n*闪 持续期间无敌 反弹伤害提高200%\r\n*龙刃 持续时间增加至8秒\r\n  回复100%造成伤害的生命值\n\n※※离开重生室隐藏".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.HANZO:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +10%\r\n*弹道速度+35%\r\n*暴击倍率提高至 ×{1}\r\n*技能无冷却\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), HeadshotDamage[3]), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.JUNKRAT:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 -5%\r\n*受到伤害 +30%\r\n*所有击退效果-50%\r\n{1} 震荡地雷\r\n  冷却时间增加至10秒\r\n{2} 炸弹轮胎\r\n  充能速度降低30%\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), abilityIconString(eventPlayer.getHero(), Button.ULTIMATE)), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.MEI:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +1%\r\n*冰霜枪-冰锥\r\n  暴击使敌人冰冻\r\n{2} 急冻\r\n \n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1)), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.VENTURE:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +15%\r\n*受到伤害 -20%\r\n钻地  持续时间 +300%  移动速度 +156%\r\n钻头突刺 冷却时间 -25%\n\n※※离开重生室隐藏".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.ECHO:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +15%\r\n*受到伤害 -20%\r\n*人格复制 持续期间保留50%充能\n\n※※离开重生室隐藏".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.PHARAH:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +10%\r\n*受到伤害 -20%\r\n{1} 推进背包\r\n  补充全部燃料并额外获得75%燃料\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1)), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.REAPER:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +35%\r\n*受到伤害 -35%\r\n*收割（被动）击杀获得灵魂层数\r\n灵魂层数会增强技能并缩短冷却\n\n※※离开重生室隐藏".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.SOJOURN:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +15%\r\n*电磁炮充能速度+20%\r\n*电磁炮-充能射击 处决生命值低于{2}%的敌人\r\n *机体超频 强化充能射击：处决阈值增加至20%\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2), SojournBuff[0] * 100), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.SOLDIER:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +30%\r\n{1} 疾跑\r\n  持续期间每4秒获得20+400%额外移动速度的生命值\r\n灼烧周围的敌人造成8%最大生命值伤害\r\n{2}\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), "*长按{0}+{1}切换第三人称".format(Button.INTERACT, Button.RELOAD)), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.FREJA:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +10%\r\n*受到伤害 -10%\r\n{1} 狩猎 造成伤害给敌方施加“狩猎”印记\r\n{2} 瞄准射击 爆炸造成75 × 印记层数 额外伤害\r\n  引爆后敌方生命值低于35%则将其斩杀\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.PRIMARY_FIRE), abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE)), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.SYMMETRA:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 -15%\r\n{1}\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1)), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.TORBJORN:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 -20%\r\n* 锻造锤 所有造成的伤害与治疗提升 200%\r\n\n\n※※离开重生室隐藏".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.BASTION:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +25%\r\n*受到伤害 -30%\r\n{1} 火炮模式\r\n  炮弹造成敌方25%当前生命值额外伤害\r\n\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1)), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.TRACER:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +25%\r\n*受到伤害 -30%\r\n*击杀后回复所有状态\r\n*回溯 CD降低 2秒内回复50HP\r\n*重生 阵亡后立刻重生\r\n*脉冲炸弹 充能速度 +30%\n\n※※离开重生室隐藏".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.WIDOWMAKER:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +15%\r\n*受到伤害 +15%\r\n*移除开镜伤害衰减\r\n*暴击造成敌方50%最大生命值伤害\n\n※※离开重生室隐藏".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.ANA:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +15%\r\n*造成治疗 +30%\r\n*生物手雷\r\n  使敌方燃烧 每秒造成{1}%最大生命值伤害\r\n*麻醉镖\r\n  命中目标永久获得50可叠加护甲\r\n*纳米激素\r\n  治疗目标全部已损失生命值\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), Ana_GrenadeDamage[0]), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.BAPTISTE:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +20%\r\n*暴击倍率提高至 ×{1}\r\n*增幅矩阵\r\n  持续时间提高至 15 秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), HeadshotDamage[4]), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.BRIGITTE:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +15%\r\n*造成治疗+10%\r\n*受到伤害 -57%\r\n*恢复包 提供永久护甲\r\n*能量盾击 可穿透屏障击晕敌人\r\n*集结号令 为友方提供额外临时护甲\n\n".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.ILLARI:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +20%\r\n*弹道速度提高500%\r\n*桎梏灼日\r\n  造成额外最大生命值伤害\r\n \n\n※※离开重生室隐藏".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.KIRIKO:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +20%\r\n{1}\r\n{2}\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), "暴击倍率提高至 ×{0}".format(HeadshotDamage[2]), "{0} 瞬 最远距离提高至 105 米\r\n为友方提供临时生命值\r\n{1} 铃 无敌时间提高至 1.8 秒".format(abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2))), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.LIFEWEAVER:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n{1} 净化之握\r\n  恢复友方100%生命值\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2)), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.LUCIO:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +20%\r\n*受到伤害 -20%\r\n{1}音波 额外治疗切歌范围内友方120点生命值\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE)), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.MERCY:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*快速治疗\r\n  2秒内使友方恢复40%最大生命值\n\n※※离开重生室隐藏".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.ZENYATTA:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +60%\r\n*受到伤害+5%\r\n  暴击倍率提高至 ×{1}\r\n* 蹬 获得150点临时生命值\r\n  击晕命中的目标\r\n* 圣 治疗量提高至400/s 移速+25%\r\n  无法被命中 免疫所有控制\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), 1 + HeadshotDamage[0]), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.MOIRA:
        hudText(eventPlayer, null, Mark, "\r\n{0}\r\n{1}\r\n{2}\n\n※※离开重生室隐藏".format("●{0}\r\n 受到伤害-10%\r\n造成治疗+5%\r\n完成独特的击杀后每15秒刷新终极技能".format(eventPlayer.getHero()), "{0} ".format(abilityIconString(eventPlayer.getHero(), Button.ABILITY_2)), "{0} \r\n{1} ".format(abilityIconString(eventPlayer.getHero(), Button.ABILITY_2), abilityIconString(eventPlayer.getHero(), Button.ULTIMATE))), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.VENDETTA:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +10%\r\n*受到伤害-25%\r\n*获得40%全能吸血\r\n{1}\r\n{2}\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), "{0} 暴击额外其{1}%最大生命值伤害，并回复{2}最大生命值".format(abilityIconString(eventPlayer.getHero(), Button.PRIMARY_FIRE), VendettaBuff[0] * 100, VendettaBuff[6] * 100), "{0}\r\n{1}\r\n{2}".format("{0} 每命中一名敌人回复{1}%已损失生命值".format(VendettaBuff[2], null), "{0} 持续期间获得不可阻挡".format(abilityIconString(eventPlayer.getHero(), Button.ABILITY_2)), "{0} 击倒敌人，生命值低于{1}%的敌人将被斩杀".format(abilityIconString(eventPlayer.getHero(), Button.ULTIMATE), VendettaBuff[5] * 100))), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
