rule "Changelog":
    @Event eachPlayer
    @Team 2
    @Condition isGameInProgress() != true
    @Condition eventPlayer.isInSpawnRoom() == true
    
    wait(WAIT_SHORT_FRAME)
    changelogText()
    waitUntil(not eventPlayer.isInSpawnRoom(), WAIT_TIMEOUT_FOREVER)
    destroyHudText(eventPlayer.ChangelogText1)
    destroyHudText(eventPlayer.ChangelogText2)


def changelogText():
    @Name "Changelog Content"
    
    hudSubtext(eventPlayer, " \r\n\n", HudPosition.LEFT, 0, true, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    eventPlayer.ChangelogText1 = getLastCreatedText()
    if eventPlayer.getHero() == Hero.DVA:
        hudText(eventPlayer, null, Mark, "\r\n●\"{0}\"\r\n*造成伤害 +35%\r\n*受到伤害 -25%\r\n{1} 防御矩阵\r\n\u00a0持续时间提高至 4 秒\r\n 完全充能时间由 6 秒降低至 3 秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE)), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.DOOMFIST:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +25%\r\n*受到伤害 -45%\r\n*裂地重拳\r\n\u00a0 将敌人击飞拉近并使其失控\r\n*悍猛格挡 吸收并存储伤害\r\n*火箭重拳 附带悍猛格挡存储的全部伤害 对目标造成额外伤害\n\n※※离开重生室隐藏".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.JUNKER_QUEEN:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +30%\r\n*受到伤害 -50%\r\n*血斩 冷却时间降低至 6 秒\r\n*锯齿利刃 冷却时间降低至 4 秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.MAUGA:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +25%\r\n*受到伤害 -35%\r\n*狂战士之魂（被动） 受到致命伤害触发 回复100%最大生命值并进入狂战士状态\r\n*蛮力冲撞 击倒时间提高至2秒\r\n*心脏过载 冷却时间降低至10秒 治疗量+100% 伤害减免60%\r\n*笼中斗 持续时间提高并免疫暴击\r\n".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.ORISA:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*受到伤害 -60%\r\n*强固防御\r\n\u00a0 冷却时间降低至 12 秒\r\n\u00a0 持续期间获得 额外临时护甲\r\n  反弹受到伤害的{1}%\r\n*标枪旋击\r\n\u00a0 冷却时间增加至 8 秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), Orisa_Fortify[1]), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.RAMATTRA:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +20%\r\n*受到伤害 -35%\r\n*吞噬漩涡 冷却时间降低\r\n* 诛 -{1}%受到伤害 +30%移速 70%击退抵抗\r\n回复{2}%已造成伤害的生命值\n\n※离开重生室隐藏".format(eventPlayer.getHero(), Ram_Annihilation[4], Ram_Annihilation[1] * 100), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.JUNO:
        hudText(eventPlayer, null, Mark, "\r\n{0}\r\n{1}\r\n{2}\n\n※※离开重生室隐藏".format("●{0}\r\n*造成治疗 +10%".format(eventPlayer.getHero()), "{0} 超能环域 冷却时间降低至12秒".format(abilityIconString(eventPlayer.getHero(), Button.ABILITY_1)), "{0}\r\n{1}".format("{0} 脉冲星飞雷 冷却时间降低至8秒".format(abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE)), "{0} 轨道射线 范围内所有友方受到伤害-{1}%（唯一特效）".format(abilityIconString(eventPlayer.getHero(), Button.ULTIMATE), JunoBuff))), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.REINHARDT:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +5%\r\n*受到伤害 -25%\r\n*冲锋 根据剩余持续时间返还最多3秒cd\r\n*烈焰打击 恢复100%已造成伤害的生命值\r\n*裂地猛击 造成击杀返还100%充能\n\n※※离开重生室隐藏".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.ROADHOG:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 -10%\r\n*受到伤害 +10%\r\n{1}呼吸器\r\n  冷却时间增加至10秒\r\n{2}拴猪圈\r\n  冷却时间增加至14秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2)), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.SIGMA:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +25%\r\n*受到伤害 -25%\r\n*超能之球 每3次攻击强化下一次攻击 附带自身当前生命值{1}%伤害（不含临时生命值）\r\n*实验屏障 充能速度提高\r\n*引力乱流 最大生命值伤害增加至 75%\n\n※离开重生室隐藏".format(eventPlayer.getHero(), SigmaBuff[0] * 100), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.WINSTON:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*受到伤害 -35%\r\n*造成伤害 +10%\r\n{2} 屏障发射器\r\n  冷却时间降低至11秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.PRIMARY_FIRE), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2)), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.WRECKING_BALL:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +35%\r\n*受到伤害 -15%\r\n*工程抓钩\r\n  冷却时间降低至4秒\r\n  在重生室中无冷却时间\r\n*感应护盾 冷却时间降低至12秒\r\n*重力坠击 冷却时间降低至6秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.ZARYA:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +30%\r\n*受到伤害 -30%\r\n*粒子屏障 冷却时间降低至8秒\r\n*投射屏障 为目标提供3秒{1}点临时生命值\r\n*重力喷涌\r\n  使敌人减速\r\n  充能速度提高8%\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), ZaryaBuff[0]), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.HAZARD:
        hudText(eventPlayer, null, Mark, "\r\n{0}\r\n{1}\r\n{2}\n\n※※离开重生室隐藏".format("●{0}\r\n*造成伤害 +20%\r\n*受到伤害 -40%".format(eventPlayer.getHero()), "*尖刺护体 受到伤害获得{0}%终极技能充能并回复HP".format(HazardBuff[1]), "{0}".format("*千针雨 不再根据伤害获得能量")), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.DOMINA:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*已接入初始化链路\r\n*生命值改写因 Health Pool Bug 暂不启用（仅保留声明）\n\n※※离开重生室隐藏".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.ANRAN:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*队伍2 造成伤害 +35% 受到伤害 -30%\r\n*怒炎冲 冷却时间降低至6秒\r\n*熠闪舞 冷却时间降低至6秒\r\n*烈焰 对所有燃烧中的敌人伤害提高25%（开始伤害调整）\n\n※※离开重生室隐藏".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.EMRE:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*已接入初始化链路\r\n*生命值改写因 Health Pool Bug 暂不启用（仅保留声明）\n\n※※离开重生室隐藏".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.MIZUKI:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*已接入初始化链路\r\n*生命值改写因 Health Pool Bug 暂不启用（仅保留声明）\n\n※※离开重生室隐藏".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.JETPACK_CAT:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*已接入初始化链路\r\n*生命值改写因 Health Pool Bug 暂不启用（仅保留声明）\n\n※※离开重生室隐藏".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.ASHE:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +35%\r\n*毒蛇\r\n  弹药增加至 15 发\r\n  暴击倍率提高至 ×{1}\r\n  完成击杀后恢复全部子弹\r\n*延时雷管\r\n  冷却时间降低至8秒\r\n*短筒猎枪\r\n  冷却时间降低至8秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), HeadshotDamage[1]), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.SOMBRA:
        hudText(eventPlayer, null, " \r\n\r\n\n 非重装 AI 伤害减免 25%\r\n 重装 AI 最高伤害减免 40%\r\n 完整更新日志 workshop.codes/3TP7F/update-log\r\n 坐牢交流群: 361913638", "\r\n●{0}\r\n*造成伤害 +35%\r\n*受到伤害 -30%\r\n*位移传动  击杀后重置CD\r\n*黑客入侵  沉默敌人5秒并 使敌方额外减疗{1}%\r\n*电磁脉冲  充能速度提高15%\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), SombraBuff[0]), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.CASSIDY:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +30%\r\n*受到伤害 -6%\r\n{1}维和者\r\n  换弹速度降低至0.75秒\r\n  连射伤害提高至75点/发\r\n{2}闪光弹 击晕敌人\r\n*神射手 充能速度降低16%\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.PRIMARY_FIRE), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2)), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.GENJI:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +45%\r\n*受到伤害 -50%\r\n*造成击杀后恢复50HP\r\n*影 使下一次近身攻击100%暴击\r\n*闪 冷却时间降低至6秒 持续期间免疫伤害\r\n*龙刃 持续时间增加至8秒\r\n  造成伤害+{1}% 受到伤害 -10%\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), Genji[1]), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.HANZO:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +30%\r\n*弹道速度+35%\r\n*暴击倍率提高至 ×{1}\r\n*岚 冷却时间降低至7秒\r\n*音 冷却时间降低至9秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), HeadshotDamage[3]), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.JUNKRAT:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 -5%\r\n*受到伤害 +30%\r\n*所有击退效果-50%\r\n{1} 震荡地雷\r\n  冷却时间增加至10秒\r\n{2} 炸弹轮胎\r\n  充能速度降低30%\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), abilityIconString(eventPlayer.getHero(), Button.ULTIMATE)), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.MEI:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +30%\r\n*冰霜枪\r\n  可以冰冻敌人\r\n{1} 冰墙\r\n  冷却时间降低至8秒\r\n{2} 急冻\r\n  冷却时间降低至10秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1)), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.VENTURE:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +40%\r\n*受到伤害 -30%\r\n钻地  \r\n  持续时间 +300%\r\n  移动速度 +156%\r\n钻头突刺 冷却时间 -25%\n\n※※离开重生室隐藏".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.ECHO:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +35%\r\n*受到伤害 -30%\r\n*人格复制 持续期间保留50%充能\n\n※※离开重生室隐藏".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.PHARAH:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +35%\r\n*受到伤害 -15%\r\n{1} 推进背包\r\n  补充全部燃料并额外获得75%燃料\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1)), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.REAPER:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +35%\r\n*受到伤害 -35%\r\n*收割（被动）击杀获得灵魂层数\r\n灵魂层数会增强技能并缩短冷却\n\n※※离开重生室隐藏".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.SOJOURN:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +35%\r\n*电磁炮充能速度+20%\r\n*电磁炮-充能射击 处决生命值低于{2}%的敌人\r\n *机体超频 强化充能射击：处决阈值增加至20%\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2), SojournBuff[0] * 100), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.SOLDIER:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +30%\r\n{1} 生物力场\r\n  冷却时间降低至15秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1)), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.FREJA:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +30%\r\n*受到伤害 -30%\r\n{1} 狩猎者 造成伤害时给敌方施加“狩猎”印记\r\n{2} 瞄准射击 爆炸造成20 × 印记层数 额外伤害\r\n  引爆后敌方生命值低于20%则将其斩杀\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.PRIMARY_FIRE), abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE)), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.SYMMETRA:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 -40%\r\n*受到伤害 +20%\r\n{1}\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1)), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.TORBJORN:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 -20%\r\n{2} 熔火核心\r\n  充能速度降低30%\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.PRIMARY_FIRE), abilityIconString(eventPlayer.getHero(), Button.ULTIMATE)), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.BASTION:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +25%\r\n*受到伤害 -30%\r\n{1} 强攻模式\r\n  移动速度 +200%\r\n{2} A-36战术榴弹\r\n  冷却时间降低至6秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE)), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.TRACER:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +60%\r\n*受到伤害 -65%\r\n*击杀后回复所有状态\r\n*回溯 CD降低 2秒内回复50HP\r\n*重生 阵亡后立刻重生\r\n*脉冲炸弹 充能速度 +30%\n\n※※离开重生室隐藏".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.WIDOWMAKER:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +35%\r\n*受到伤害 +15%\r\n*移除开镜伤害衰减\n\n※※离开重生室隐藏".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.ANA:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +15%\r\n*造成治疗 +22%\r\n*生物手雷\r\n  使敌方燃烧 每秒造成{1}%最大生命值伤害\r\n*麻醉镖\r\n  冷却时间降低至10秒\r\n*纳米激素\r\n  治疗目标全部已损失生命值\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), Ana_GrenadeDamage), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.BAPTISTE:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +50%\r\n*暴击倍率提高至 ×{1}\r\n*维生力场\r\n  冷却时间降低至 12 秒\r\n*增幅矩阵\r\n  持续时间提高至 15 秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), HeadshotDamage[4]), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.BRIGITTE:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +25%\r\n*造成治疗+10%\r\n*受到伤害 -57%\r\n*恢复包 提供永久护甲\r\n*能量盾击 可穿透屏障击晕敌人\r\n*集结号令 为自身提供额外临时护甲\n\n".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.ILLARI:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +60%\r\n*弹道速度提高500%\r\n*治疗光塔 冷却时间降低50%\r\n*桎梏灼日\r\n  造成额外最大生命值伤害\r\n  充能速度降低10%\n\n※※离开重生室隐藏".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.KIRIKO:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +25%\r\n{1}\r\n{2}\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), "暴击倍率提高至 ×{0}".format(HeadshotDamage[2] + 1), "{0} 瞬 最远距离提高至 105 米\r\n{1} 铃 冷却时间降低至 10 秒\r\n  无敌时间提高至 1.8 秒".format(abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2))), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.LIFEWEAVER:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n{1} 花瓣平台\r\n  冷却时间降低至 9 秒\r\n{2} 生命之握\r\n  冷却时间降低至 9 秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2)), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.LUCIO:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +20%\r\n*受到伤害 -30%\n\n※※离开重生室隐藏".format(eventPlayer.getHero()), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.MERCY:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*女武神\r\n  受到伤害 -{1}%\r\n  持续期间重生无冷却时间\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), MercyBuff[0]), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.ZENYATTA:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +60%\r\n*受到伤害+5%\r\n  暴击倍率提高至 ×{1}\r\n* 蹬 将禅雅塔向相反方向击飞\r\n* 圣 治疗量提高至400/s 移速+25%\r\n  无法被命中 免疫所有控制\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), 1 + HeadshotDamage[0]), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.MOIRA:
        hudText(eventPlayer, null, Mark, "\r\n{0}\r\n{1}\r\n{2}\n\n※※离开重生室隐藏".format("●{0}\r\n 受到伤害-10%\r\n造成治疗+15%".format(eventPlayer.getHero()), "{0} 消散 冷却时间增加至 8 秒".format(abilityIconString(eventPlayer.getHero(), Button.ABILITY_1)), ""), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    elif eventPlayer.getHero() == Hero.VENDETTA:
        hudText(eventPlayer, null, Mark, "\r\n●{0}\r\n*造成伤害 +35%\r\n*受到伤害-45%\r\n{1}\r\n{2}\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), "{0} 暴击额外其{1}%最大生命值伤害，并回复{2}最大生命值".format(abilityIconString(eventPlayer.getHero(), Button.PRIMARY_FIRE), VendettaBuff[0] * 100, VendettaBuff[6] * 100), "{0}\r\n{1}\r\n{2}".format("{0} 每命中一名敌人回复{1}%已损失生命值".format(abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), VendettaBuff[2] * 100), "{0} 使敌人沉默，持续期间不可阻挡".format(abilityIconString(eventPlayer.getHero(), Button.ABILITY_2)), "{0} 击倒敌人，生命值低于{1}%的敌人将被斩杀".format(abilityIconString(eventPlayer.getHero(), Button.ULTIMATE), VendettaBuff[5] * 100))), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
