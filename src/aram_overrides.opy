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

#!include "modules/bootstrap/shared/10-setup-var-when-player-joins-lobby.opy"

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



#!include "modules/ai/core/10-core-global-and-targeting.opy"
#!include "modules/ai/movement/20-movement.opy"
#!include "modules/ai/control/30-control-tracer-reaper-genji.opy"
#!include "modules/ai/control/31-control-supports.opy"
#!include "modules/ai/control/32-control-tanks.opy"
#!include "modules/ai/control/33-control-projectile-and-special.opy"


#!include "heroes/orisa/aram-05-fortify-armor.opy"

#!include "heroes/mauga/aram-05-fortify.opy"

#!include "heroes/mercy/aram.opy"

#!include "heroes/ana/aram-05-headhunter.opy"

#!include "heroes/ana/aram.opy"

rule "[Ana] Biotic Grenade Hit for allies":
    @Event playerDealtHealing
    @Hero ana
    @Condition eventAbility == Button.ABILITY_2
    
    healee.startHealingOverTime(healer, 3, healee.getMaxHealth() * Ana_GrenadeDamage[1])

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

#!include "heroes/brigitte/aram-05-rally-and-slam.opy"

#!include "heroes/brigitte/aram.opy"
#!include "heroes/kiriko/aram-05-support-suite.opy"

#!include "heroes/kiriko/aram.opy"

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

#!include "heroes/sigma/aram.opy"

#!include "heroes/sigma/aram-05-hyperspheres-suite.opy"

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
    
#!include "heroes/genji/aram.opy"

rule "[Genji] Dragonblade Execution players less 10% HP expectancy":
    @Event playerDealtDamage
    @Hero genji
    @Condition eventAbility == Button.ABILITY_1
    @Condition victim.zarya_buff[1] == null
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false
    @Condition victim.has_nano != true
    @Condition victim.getHealth() <= victim.getMaxHealth() * 0.1
    
    damage(victim, attacker, SojournBuff[1])

#!include "heroes/genji/shared/10-dragonblade-damage-fix.opy"
#!include "heroes/genji/shared/20-deflect.opy"
#!include "heroes/tracer/shared/10-recall-healing.opy"
#!include "heroes/ramattra/shared/70-pain-endures.opy"
#!include "heroes/wrecking_ball/shared/10-grappling-claw-cd-reset.opy"
#!include "heroes/sombra/shared/30-kill-reset-cooldown.opy"
#!include "heroes/tracer/shared/20-kill-heal.opy"
#!include "heroes/tracer/shared/30-kill-reset-cooldown.opy"
#!include "heroes/wrecking_ball/shared/20-disable-adaptive-shield-for-allies.opy"
#!include "heroes/zarya/shared/10-projected-barrier-target.opy"

#!include "heroes/venture/aram.opy"

#!include "heroes/cassidy/shared/10-flashbang-stun.opy"

#!include "heroes/cassidy/aram-05-alt-fire.opy"

#!include "heroes/cassidy/shared/30-alt-fire-reload.opy"

#!include "heroes/sojourn/aram.opy"

#!include "heroes/ashe/aram.opy"

#!include "heroes/zenyatta/aram-05-headshot-damage.opy"

#!include "heroes/baptiste/aram.opy"

#!include "heroes/kiriko/aram-10-headshot-damage.opy"

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

#!include "heroes/mauga/aram-10-frontline-suite.opy"

#!include "heroes/mauga/aram.opy"

#!include "heroes/orisa/aram.opy"

#!include "heroes/illari/aram.opy"

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

#!include "heroes/zenyatta/aram-10-snap-kick-enemy.opy"

def Knockback():
    @Name "[Zenyatta] Sub Knockback"
    
    wait()
    eventPlayer.applyImpulse(eventPlayer.KnockbackDirection, Zen_KnockupStrength, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.applyImpulse(Vector.UP, Zen_KnockupStrength * 0.3, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)

#!include "heroes/zenyatta/aram.opy"

#!include "heroes/zenyatta/aram-20-transcendence.opy"

#!include "heroes/tracer/aram-10-instant-respawn.opy"
#!include "heroes/ramattra/aram-10-ult-suite.opy"
#!include "heroes/tracer/aram-20-pulse-bomb-damage.opy"

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

#!include "heroes/sombra/aram.opy"
#!include "heroes/ana/aram-10-sleep-tanks.opy"
    eventPlayer.heart_steel[0] = getLastCreatedHealthPool()
    eventPlayer.heart_steel[2] = false


#!include "heroes/zarya/aram-10-projected-barrier-shields.opy"

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

#!include "heroes/reinhardt/aram-05-combat-suite.opy"

#!include "heroes/reinhardt/aram.opy"

#!include "heroes/doomfist/aram-10-combat-suite.opy"

#!include "heroes/doomfist/aram.opy"


#!include "heroes/hazard/aram-05-spike-guard-suite.opy"

#!include "heroes/hazard/aram.opy"

#!include "heroes/orisa/aram-10-control-suite.opy"

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

#!include "heroes/ramattra/aram-20-block-suite.opy"

#!include "heroes/reaper/aram.opy"

#!include "heroes/moira/aram.opy"

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

#!include "heroes/zarya/aram-20-will-to-win.opy"

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

#!include "heroes/junkrat/aram.opy"

#!include "heroes/juno/aram.opy"

#!include "heroes/juno/aram-05-orbital-and-pulsar-heal.opy"

#!include "heroes/freja/shared/10-revdraw-crossbow-stack-primary-fire.opy"

#!include "heroes/freja/aram.opy"

#!include "heroes/freja/shared/90-set-projectile-speed.opy"

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

#!include "heroes/roadhog/aram.opy"

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

#!include "heroes/wrecking_ball/aram.opy"

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

#!include "heroes/wuyang/aram.opy"


rule "[Vendetta] Palatine Fang":
    @Event playerDealtDamage
    @Hero vendetta
    @Condition eventAbility != null
    
    heal(eventPlayer, eventPlayer, eventDamage * 0.4)
    wait()

rule "Initialize Heors":
    @Disabled
    @Delimiter

#!include "heroes/reaper/init.opy"
#!include "heroes/tracer/init.opy"
#!include "heroes/mercy/init.opy"
#!include "heroes/hanzo/init.opy"
#!include "heroes/freja/init.opy"
#!include "heroes/torbjorn/init.opy"
#!include "heroes/venture/init.opy"
#!include "heroes/vendetta/init.opy"
#!include "heroes/wuyang/init.opy"
#!include "heroes/reinhardt/init.opy"
#!include "heroes/hazard/init.opy"
#!include "heroes/domina/init.opy"
#!include "heroes/anran/init.opy"
#!include "heroes/emre/init.opy"
#!include "heroes/mizuki/init.opy"
#!include "heroes/jetpack_cat/init.opy"
#!include "heroes/pharah/init.opy"
#!include "heroes/winston/init.opy"
#!include "heroes/widowmaker/init.opy"
#!include "heroes/bastion/init.opy"
#!include "heroes/symmetra/init.opy"
#!include "heroes/zenyatta/init.opy"
#!include "heroes/genji/init.opy"
#!include "heroes/roadhog/init.opy"
#!include "heroes/cassidy/init.opy"
#!include "heroes/junkrat/init.opy"
#!include "heroes/zarya/init.opy"
#!include "heroes/soldier76/init.opy"
#!include "heroes/lucio/init.opy"
#!include "heroes/dva/init.opy"
#!include "heroes/mei/init.opy"
#!include "heroes/sombra/init.opy"
#!include "heroes/ana/init.opy"
#!include "heroes/orisa/init.opy"
#!include "heroes/brigitte/init.opy"
#!include "heroes/moira/init.opy"
#!include "heroes/wrecking_ball/init.opy"
#!include "heroes/sojourn/init.opy"
#!include "heroes/ashe/init.opy"
#!include "heroes/echo/init.opy"
#!include "heroes/baptiste/init.opy"
#!include "heroes/kiriko/init.opy"
#!include "heroes/junker_queen/init.opy"
#!include "heroes/sigma/init.opy"
#!include "heroes/ramattra/init.opy"
#!include "heroes/juno/init.opy"
#!include "heroes/doomfist/init.opy"
#!include "heroes/lifeweaver/init.opy"
#!include "heroes/mauga/init.opy"
#!include "heroes/illari/init.opy"

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

#!include "heroes/widowmaker/aram.opy"

#!include "heroes/cassidy/aram-10-falloff.opy"

rule "[Soldier: 76]: Third Person":
    @Event eachPlayer
    @Team 2
    @Hero soldier
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.third_person = false if eventPlayer.third_person == true else true
    setThirdPerson()

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
