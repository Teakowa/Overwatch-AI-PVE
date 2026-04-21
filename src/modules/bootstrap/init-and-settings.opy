rule "Copyright (c) 2019-2025 他又（aka Teakowa）":
    disableInspector()
    Collaborator = ["他又", "别感冒", "步六孤", "Destiny", "smile"]
    Mark = " \r\n\n 非重装 AI 减伤 25%\r\n 重装 AI 最高减伤 40%\r\n 完整更新日志 workshop.codes/3TP7F/update-log\r\n 企鹅聊天群：361913638\r\n 中途退、挂机永久BAN，不服的现在滚"


rule "Initialize global variables":
    Debug_UltimateGain = createWorkshopSettingBool("Debug", "即时终极技能充能", false, 4)
    #随机禁用英雄池中的4名英雄（1 重装 2输出 1辅助）
    Hero_BAN = createWorkshopSettingBool("模式", "英雄BAN池", false, 11)
    CustomAI = createWorkshopSettingEnum("模式", "自定义 AI", 0, ["弗蕾娅", "探奇", "法老之鹰", "伊拉锐", "朱诺", "骇灾", "斩仇", "埃姆雷"], 12)


rule "Initialize Hero Ability Settings":
    #Brigitte_RepairPacksArmor
    Brigitte[1] = createWorkshopSettingInt("英雄：布丽吉塔", "恢复包：提供的护甲", 125, 0, 200, 30)
    Brigitte[3] = createWorkshopSettingInt("英雄：布丽吉塔", "能量盾击：使敌人减速 %", 70, 0, 90, 31)
    #Brigitte_RallyArmor
    Brigitte[2] = createWorkshopSettingInt("英雄：布丽吉塔", "集结号令：每秒额外护甲", 25, 0, 150, 34)
    Brigitte[0] = createWorkshopSettingInt("英雄：布丽吉塔", "集结号令：每秒伤害减免", 1, 0, 5, 33)
    MercyBuff[0] = createWorkshopSettingInt("英雄：天使", "女武神：伤害减免", 35, 0, 90, 40)
    HazardBuff[0] = createWorkshopSettingInt("英雄：骇灾", "尖刺护体：基于受到伤害的额外伤害 %", 300, 0, 500, 70) / 100
    HazardBuff[1] = createWorkshopSettingFloat("英雄：骇灾", "灾厄馈赠（被动）：基于受到伤害获得终极技能充能 %", 3, 0, 500, 70)
    HazardBuff[2] = createWorkshopSettingInt("英雄：骇灾", "灾厄馈赠（被动）：基于受到原始伤害（未被减伤）回复生命值 %", 65, 0, 500, 70) / 100
    Orisa_Fortify[0] = createWorkshopSettingInt("英雄：奥丽莎", "强固防御：获得的临时护甲", 200, 0, 300, 50)
    #Orisa_FortifyRicochet
    Orisa_Fortify[1] = createWorkshopSettingInt("英雄：奥丽莎", "强固防御：反弹伤害比例", 50, 0, 100, 51)
    Orisa_Fortify[2] = createWorkshopSettingInt("英雄：奥丽莎", "能量标枪：使敌人减速 %", 70, 0, 90, 31)
    Genji[0] = createWorkshopSettingInt("英雄：源氏", "分数", 1500, 500, 5000, 60)
    Genji[1] = createWorkshopSettingInt("英雄：源氏", "龙刃：额外造成伤害 %", 50, 0, 100, 61)
    Zen_KnockupStrength = createWorkshopSettingFloat("英雄：禅雅塔", "无影脚击退距离", 15.5, 0, 100, 71)
    #Ram_AnnihilationDamage
    Ram_Annihilation[0] = createWorkshopSettingInt("英雄：拉玛刹", "天罚形态：铁臂：最大临时生命值", 400, 0, 1000, 100)
    Ram_Annihilation[1] = createWorkshopSettingInt("英雄：拉玛刹", "诛 （终极技能）基于已造成伤害的百分比回复 ", 150, 0, 500, 101) / 100
    Ram_Annihilation[5] = createWorkshopSettingInt("英雄：拉玛刹", "诛 （终极技能）额外造成伤害 %", 30, 0, 100, 101)
    #Ram_AnnihilationSpeed
    Ram_Annihilation[3] = createWorkshopSettingInt("英雄：拉玛刹", "诛 （终极技能）移动速度加成 %", 10, 0, 100, 102)
    Ram_Annihilation[4] = createWorkshopSettingInt("英雄：拉玛刹", "诛 （终极技能）受到伤害减免 %", 20, 0, 99, 103)
    Ana_GrenadeDamage[0] = createWorkshopSettingInt("英雄：安娜", "生物手雷 额外最大生命值伤害 %", 15, 0, 20, 104)
    Ana_GrenadeDamage[1] = createWorkshopSettingInt("英雄：安娜", "猎头精英：生命汲取比例 %", 150, 0, 250, 104) / 100
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
    ZaryaBuff[0] = createWorkshopSettingInt("英雄：查莉娅", "投射屏障 为目标提供的临时生命值", 50, 0, 150, 117)
    ZaryaBuff[2] = createWorkshopSettingBool("英雄：查莉娅", "胜利意志（被动）", true, 115)
    ZaryaBuff[3] = createWorkshopSettingInt("英雄：查莉娅", "胜利意志（被动） 持续时间", 30, 0, 45, 116)
    ZaryaBuff[4] = createWorkshopSettingInt("英雄：查莉娅", "胜利意志（被动） 每秒治疗量", 45, 0, 60, 116)
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
    MaugaBuff[0] = createWorkshopSettingInt("英雄：毛加", "狂战士之魂：额外最大生命值 %", 150, 0, 500, 122) / 100
    MaugaBuff[1] = createWorkshopSettingInt("英雄：毛加", "狂战士之魂：额外伤害减免 %", 45, 0, 80, 123)
    MaugaBuff[2] = createWorkshopSettingInt("英雄：毛加", "狂战士之魂：额外伤害增幅 %", 50, 0, 80, 120)
    MaugaBuff[5] = createWorkshopSettingInt("英雄：毛加", "狂战士之魂：击退抵抗 %", 80, 0, 80, 122)
    MaugaBuff[6] = createWorkshopSettingInt("英雄：毛加", "狂战士之魂：每秒损失最大生命值 %", 15, 0, 50, 122) / 100
    MaugaBuff[7] = createWorkshopSettingInt("英雄：毛加", "狂战士之魂：击杀回复最大生命值 %", 20, 0, 50, 122) / 100
    MaugaBuff[3] = createWorkshopSettingInt("英雄：毛加", "蛮力冲撞：被击倒的敌人造成最大生命值伤害 %", 10, 0, 50, 122) / 100
    MaugaBuff[4] = createWorkshopSettingFloat("英雄：毛加", "心脏过载：额外伤害减免", 25, 0, 50, 121)
    S76Buff[0] = createWorkshopSettingInt("英雄：士兵 76", "螺旋飞弹：燃烧持续时间", 3, 0, 3, 124)
    S76Buff[1] = createWorkshopSettingInt("英雄：士兵 76", "螺旋飞弹：每秒伤害", 25, 0, 100, 125)
    SigmaBuff[0] = createWorkshopSettingInt("英雄：西格玛", "超能之球：基于当前生命值造成额外伤害 %", 25, 0, 200, 130) / 100
    JunoBuff = createWorkshopSettingInt("英雄：朱诺", "轨道射线：友方英雄伤害减免 %", 50, 0, 200, 130)
    DoomBuff[0] = createWorkshopSettingFloat("英雄：末日铁拳", "悍猛格挡：伤害吸收倍率", 4, 0, 5, 131)
    DoomBuff[1] = createWorkshopSettingInt("英雄：末日铁拳", "悍猛格挡：最大吸收伤害", 300, 0, 500, 132) + 0.001
    FrejaBuff[0] = createWorkshopSettingInt("英雄：弗蕾娅", "无情猎杀：每层伤害", 20, 0, 25, 133)
    FrejaBuff[1] = createWorkshopSettingInt("英雄：弗蕾娅", "无情猎杀：最大生命值百分比伤害", 10, 0, 25, 134) / 100
    FrejaBuff[2] = createWorkshopSettingInt("英雄：弗蕾娅", "无情猎杀：斩杀阈值", 20, 0, 25, 135) / 100
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
