#!mainFile "../main.opy"

#!optimizeStrict

playervar changelog_text_state
#!defineMember changelog_subtext changelog_text_state[0]
#!defineMember changelog_body    changelog_text_state[1]

def changelogText():
    @Name "Changelog Content"

    eventPlayer.changelog_subtext = Mark
    eventPlayer.changelog_body = ""
    if eventPlayer.ChangelogText1 == 0:
        hudSubtext(eventPlayer, " \r\n\n", HudPosition.LEFT, 0, not isGameInProgress() and eventPlayer.isInSpawnRoom(), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText1 = getLastCreatedText()
    if eventPlayer.ChangelogText2 == 0:
        hudText(eventPlayer if not isGameInProgress() and eventPlayer.isInSpawnRoom() else null, null, eventPlayer.changelog_subtext, eventPlayer.changelog_body, HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.ChangelogText2 = getLastCreatedText()
    if eventPlayer.getHero() == Hero.DVA:
        eventPlayer.changelog_body = "\r\n●\"{0}\"\r\n*造成伤害 +35%\r\n*受到伤害 -25%\r\n{1} 防御矩阵\r\n\u00a0持续时间提高至约2.7秒\r\n 充能速度提高100%\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE))
    elif eventPlayer.getHero() == Hero.DOOMFIST:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +15%\r\n*受到伤害 -35%\r\n*裂地重拳\r\n\u00a0 将敌人击飞拉近并使其失控\r\n*悍猛格挡 以{1}倍倍率吸收伤害，最多存储{2}点\r\n*火箭重拳 附带悍猛格挡存储的全部伤害 对目标造成额外伤害\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), DoomBuff[0], floor(DoomBuff[1]))
    elif eventPlayer.getHero() == Hero.JUNKER_QUEEN:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +30%\r\n*受到伤害 -50%\r\n*血斩 冷却时间降低至 6 秒\r\n*锯齿利刃 冷却时间降低至 4 秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero())
    elif eventPlayer.getHero() == Hero.MAUGA:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +25%\r\n*受到伤害 -35%\r\n*狂战士之魂（被动） 受到致命伤害触发 回复100%最大生命值并进入狂战士状态\r\n*蛮力冲撞 击倒时间提高至2秒\r\n*心脏过载 冷却时间降低至10秒 治疗量+100% 伤害减免60%\r\n*笼中斗 持续时间提高并免疫暴击\r\n".format(eventPlayer.getHero())
    elif eventPlayer.getHero() == Hero.ORISA:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*受到伤害 -60%\r\n*强固防御\r\n\u00a0 冷却时间降低至 12 秒\r\n\u00a0 持续期间获得 额外临时护甲\r\n  反弹受到伤害的{1}%\r\n*标枪旋击\r\n\u00a0 冷却时间增加至 8 秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), Orisa_Fortify[1])
    elif eventPlayer.getHero() == Hero.RAMATTRA:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +20%\r\n*受到伤害 -35%\r\n*吞噬漩涡 冷却时间降低\r\n* 诛 -{1}%受到伤害 +30%移速 70%击退抵抗\r\n回复{2}%已造成伤害的生命值\n\n※离开重生室隐藏".format(eventPlayer.getHero(), Ram_Annihilation[4], Ram_Annihilation[1] * 100)
    elif eventPlayer.getHero() == Hero.JUNO:
        eventPlayer.changelog_body = "\r\n{0}\r\n{1}\r\n{2}\n\n※※离开重生室隐藏".format("●{0}\r\n*造成治疗 +10%".format(eventPlayer.getHero()), "{0} 超能环域 冷却时间降低至12秒".format(abilityIconString(eventPlayer.getHero(), Button.ABILITY_1)), "{0}\r\n{1}".format("{0} 脉冲星飞雷 冷却时间降低至8秒".format(abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE)), "{0} 轨道射线 范围内所有友方受到伤害-{1}%（唯一特效）".format(abilityIconString(eventPlayer.getHero(), Button.ULTIMATE), JunoBuff)))
    elif eventPlayer.getHero() == Hero.REINHARDT:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +5%\r\n*受到伤害 -25%\r\n*冲锋 根据剩余持续时间返还最多3秒cd\r\n*烈焰打击 恢复100%已造成伤害的生命值\r\n*裂地猛击 造成击杀返还100%充能\n\n※※离开重生室隐藏".format(eventPlayer.getHero())
    elif eventPlayer.getHero() == Hero.ROADHOG:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 -10%\r\n*受到伤害 +10%\r\n{1}呼吸器\r\n  冷却时间增加至10秒\r\n{2}拴猪圈\r\n  冷却时间增加至14秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2))
    elif eventPlayer.getHero() == Hero.SIGMA:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +25%\r\n*受到伤害 -25%\r\n*超能之球 每3次攻击强化下一次攻击 附带自身当前生命值{1}%伤害（不含临时生命值）\r\n*实验屏障 充能速度提高\r\n*引力乱流 最大生命值伤害增加至 75%\n\n※离开重生室隐藏".format(eventPlayer.getHero(), SigmaBuff[0] * 100)
    elif eventPlayer.getHero() == Hero.WINSTON:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*受到伤害 -35%\r\n*造成伤害 +10%\r\n{2} 屏障发射器\r\n  冷却时间降低至11秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.PRIMARY_FIRE), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2))
    elif eventPlayer.getHero() == Hero.WRECKING_BALL:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +35%\r\n*受到伤害 -15%\r\n*工程抓钩\r\n  冷却时间降低至4秒\r\n  在重生室中无冷却时间\r\n*感应护盾 冷却时间降低至12秒\r\n*重力坠击 冷却时间降低至6秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero())
    elif eventPlayer.getHero() == Hero.ZARYA:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +30%\r\n*受到伤害 -30%\r\n*粒子屏障 冷却时间降低至8秒\r\n*投射屏障 为目标提供3秒{1}点临时生命值\r\n*重力喷涌\r\n  使敌人减速\r\n  充能速度提高8%\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), ZaryaBuff[0])
    elif eventPlayer.getHero() == Hero.HAZARD:
        eventPlayer.changelog_body = "\r\n{0}\r\n{1}\r\n{2}\n\n※※离开重生室隐藏".format("●{0}\r\n*造成伤害 +25%\r\n*受到伤害 -45%".format(eventPlayer.getHero()), "*尖刺护体 基于受到伤害造成额外伤害\r\n  并在格挡期间获得{0}%终极技能充能和生命值回复".format(HazardBuff[1]), "{0}".format("*千针雨 不再根据伤害获得能量"))
    elif eventPlayer.getHero() == Hero.DOMINA:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +{1}%\r\n*受到伤害 -{2}%\r\n*屏障阵列 冷却时间降低至{3}秒\r\n*音速斥力场 冷却时间调整为{4}秒\r\n  命中击退目标造成{5}%减速{6}秒并击晕{7}秒\r\n*爆能水晶 命中敌人造成{5}%减速{6}秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), DOMINA_DAMAGE_DEALT_PERCENT - 100, 100 - DOMINA_PLAYER_DAMAGE_RECEIVED_PERCENT, DOMINA_BARRIER_ARRAY_COOLDOWN, DOMINA_SONIC_REPULSORS_COOLDOWN, DOMINA_SLOW_PERCENT, DOMINA_SLOW_DURATION, DOMINA_SONIC_STUN_DURATION)
    elif eventPlayer.getHero() == Hero.ANRAN:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +35%\r\n*受到伤害 -30%\r\n*怒炎冲 冷却时间降低至6秒\r\n*熠闪舞 冷却时间降低至6秒\r\n*烈焰 对所有燃烧中的敌人伤害提高25%（开始伤害调整）\n\n※※离开重生室隐藏".format(eventPlayer.getHero())
    elif eventPlayer.getHero() == Hero.EMRE:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +35%\r\n*受到伤害 -10%\r\n{1} 赛博手雷 冷却时间降低至6秒\r\n{2} 虹吸冲击枪 冷却时间降低至8秒\r\n*赛博手雷：击倒命中的敌人，并使其燃烧{3}秒\r\n  额外造成50点伤害\r\n*覆盖协议：使命中的敌人燃烧\r\n  并造成75+{4}%最大生命值额外伤害\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), EmreBuff[0], EmreBuff[1])
    elif eventPlayer.getHero() == Hero.MIZUKI:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害+35%\r\n*受到伤害 -20%\r\n{1} 疗魂斗笠 额外治疗队友25%最大生命值 返还0.5秒cd\r\n{2} 替魂纸人 清除负面状态\r\n{3} 缚魂锁链 使敌人虚弱\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2))
    elif eventPlayer.getHero() == Hero.JETPACK_CAT:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +35%\r\n*受到伤害 -40%\r\n*造成治疗 +50%\r\n{1} 救生索 受到伤害额外 -35%\r\n{2} 呼噜噜 施放时清除负面状态，并短暂进入无敌和虚化\r\n{3} 猫猫劫 受到伤害额外 -75%\r\n  对目标造成50%最大生命值伤害\r\n*近战造成1.2秒击晕\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2), abilityIconString(eventPlayer.getHero(), Button.ULTIMATE))
    elif eventPlayer.getHero() == Hero.ASHE:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +35%\r\n*毒蛇\r\n  弹药增加至 15 发\r\n  暴击倍率提高至 ×{1}\r\n  完成击杀后恢复全部子弹\r\n*延时雷管\r\n  冷却时间降低至8秒\r\n*短筒猎枪\r\n  冷却时间降低至8秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), HeadshotDamage[1])
    elif eventPlayer.getHero() == Hero.SOMBRA:
        eventPlayer.changelog_subtext = " \r\n\r\n\n 非重装 AI 伤害减免 25%\r\n 重装 AI 最高伤害减免 40%\r\n 完整更新日志 workshop.codes/3TP7F/update-log\r\n 坐牢交流群: 361913638"
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +35%\r\n*受到伤害 -30%\r\n*位移传动  击杀后重置CD\r\n*黑客入侵  沉默敌人5秒并 使敌方额外减疗{1}%\r\n*电磁脉冲  充能速度提高15%\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), SombraBuff[0])
    elif eventPlayer.getHero() == Hero.CASSIDY:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +25%\r\n*受到伤害 -8%\r\n{1}维和者\r\n  换弹速度降低至0.75秒\r\n  连射伤害提高至{2}%倍率\r\n{3}闪光弹 击晕敌人\r\n*神射手 充能速度降低16%\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.PRIMARY_FIRE), CASSIDY_SECONDARY_DAMAGE_DEALT, abilityIconString(eventPlayer.getHero(), Button.ABILITY_2))
    elif eventPlayer.getHero() == Hero.GENJI:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +45%\r\n*受到伤害 -50%\r\n*造成击杀后恢复50HP\r\n*影 使下一次近身攻击100%暴击\r\n*闪 冷却时间降低至6秒 持续期间免疫伤害\r\n*龙刃 持续时间增加至8秒\r\n  造成伤害+{1}% 受到伤害 -10%\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), Genji[1])
    elif eventPlayer.getHero() == Hero.HANZO:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +25%\r\n*弹道速度+35%\r\n*暴击额外伤害 +{1}\r\n*岚 冷却时间降低至7秒\r\n*音 冷却时间降低至9秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), HanzoBuff[0])
    elif eventPlayer.getHero() == Hero.JUNKRAT:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 -5%\r\n*受到伤害 +30%\r\n*所有击退效果-50%\r\n{1} 震荡地雷\r\n  冷却时间增加至10秒\r\n{2} 炸弹轮胎\r\n  充能速度降低30%\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), abilityIconString(eventPlayer.getHero(), Button.ULTIMATE))
    elif eventPlayer.getHero() == Hero.MEI:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +30%\r\n*冰霜枪\r\n  可以冰冻敌人\r\n{1} 冰墙\r\n  冷却时间降低至8秒\r\n{2} 急冻\r\n  冷却时间降低至10秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1))
    elif eventPlayer.getHero() == Hero.VENTURE:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +40%\r\n*受到伤害 -30%\r\n钻地  \r\n  持续时间 +300%\r\n  移动速度 +156%\r\n钻头突刺 冷却时间 -25%\n\n※※离开重生室隐藏".format(eventPlayer.getHero())
    elif eventPlayer.getHero() == Hero.ECHO:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +35%\r\n*受到伤害 -30%\r\n*聚焦光束 持续期间伤害提高至{1}%\r\n*人格复制期间终极充能最低保留{2}%\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), EchoBuff[0], EchoBuff[1])
    elif eventPlayer.getHero() == Hero.PHARAH:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +35%\r\n*受到伤害 -15%\r\n{1} 推进背包\r\n  补充全部燃料并额外获得75%燃料\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1))
    elif eventPlayer.getHero() == Hero.REAPER:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +35%\r\n*受到伤害 -35%\r\n*收割（被动）击杀获得灵魂层数\r\n灵魂层数会增强技能并缩短冷却\n\n※※离开重生室隐藏".format(eventPlayer.getHero())
    elif eventPlayer.getHero() == Hero.SOJOURN:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +35%\r\n*电磁炮充能速度+20%\r\n*电磁炮-充能射击 处决生命值低于{2}%的敌人\r\n *机体超频 强化充能射击：处决阈值增加至20%\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2), SojournBuff[0] * 100)
    elif eventPlayer.getHero() == Hero.SOLDIER:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +30%\r\n{1} 生物力场\r\n  冷却时间降低至15秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1))
    elif eventPlayer.getHero() == Hero.FREJA:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +10%\r\n*受到伤害 -10%\r\n{1} 狩猎者 造成伤害时给敌方施加“狩猎”印记\r\n{2} 瞄准射击 爆炸造成20 × 印记层数 额外伤害\r\n  引爆后敌方生命值低于20%则将其斩杀\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.PRIMARY_FIRE), abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE))
    elif eventPlayer.getHero() == Hero.SHION:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害时自我叠层 满层后8秒内 造成伤害 +{1}% 受到伤害 -{2}%\r\n{3} 交叉枪决 完成击杀后重置冷却\r\n{4} 终极期间每次击杀返还 {5}% 终极充能\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), ShionBuff[1], ShionBuff[2], abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE), abilityIconString(eventPlayer.getHero(), Button.ULTIMATE), ShionBuff[4])
    elif eventPlayer.getHero() == Hero.SIERRA:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +35%\r\n*受到伤害 -25%\r\n{1} 重构力场 每0.5秒回复25生命值\r\n{2} 标记次级火力 命中后回满弹药\r\n  使目标承受你的伤害提高{3}%\r\n  造成击杀后冷却缩短至0.5秒\r\n{4} 终极技能 击倒敌人{5}秒并造成额外伤害\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE), SierraBuff[1] - 100, abilityIconString(eventPlayer.getHero(), Button.ULTIMATE), SierraBuff[2])
    elif eventPlayer.getHero() == Hero.SYMMETRA:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 -40%\r\n*受到伤害 +20%\r\n{1}\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1))
    elif eventPlayer.getHero() == Hero.TORBJORN:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 -20%\r\n{2} 熔火核心\r\n  充能速度降低30%\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.PRIMARY_FIRE), abilityIconString(eventPlayer.getHero(), Button.ULTIMATE))
    elif eventPlayer.getHero() == Hero.BASTION:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +25%\r\n*受到伤害 -30%\r\n{1} 强攻模式\r\n  移动速度 +200%\r\n{2} A-36战术榴弹\r\n  冷却时间降低至6秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE))
    elif eventPlayer.getHero() == Hero.TRACER:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +60%\r\n*受到伤害 -65%\r\n*击杀后回复所有状态\r\n*回溯 CD降低 2秒内回复50HP\r\n*重生 阵亡后立刻重生\r\n*脉冲炸弹 充能速度 +30%\n\n※※离开重生室隐藏".format(eventPlayer.getHero())
    elif eventPlayer.getHero() == Hero.WIDOWMAKER:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +35%\r\n*受到伤害 +15%\r\n*移除开镜伤害衰减\n\n※※离开重生室隐藏".format(eventPlayer.getHero())
    elif eventPlayer.getHero() == Hero.ANA:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +15%\r\n*造成治疗 +50%\r\n*生物手雷\r\n  使敌方燃烧 每秒造成{1}%最大生命值伤害\r\n*麻醉镖\r\n  冷却时间降低至约8.5秒\r\n*纳米激素\r\n  治疗目标全部已损失生命值\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), Ana_GrenadeDamage)
    elif eventPlayer.getHero() == Hero.BAPTISTE:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +50%\r\n*暴击额外伤害 +{1}\r\n*维生力场\r\n  冷却时间降低至约10.5秒\r\n*增幅矩阵\r\n  持续时间提高至 15 秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), BaptisteBuff[0])
    elif eventPlayer.getHero() == Hero.BRIGITTE:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +25%\r\n*造成治疗 +45%\r\n*受到伤害 -57%\r\n*恢复包 提供永久护甲\r\n*能量盾击 可穿透屏障击晕敌人\r\n*集结号令 持续期间逐步提高自身伤害减免\n\n".format(eventPlayer.getHero())
    elif eventPlayer.getHero() == Hero.ILLARI:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +60%\r\n*受到伤害 +5%\r\n*阳光能量回复速度 +25%\r\n*治疗光塔 冷却时间降低50%\r\n*桎梏灼日\r\n  基于附近友军数量造成额外最大生命值伤害\n\n※※离开重生室隐藏".format(eventPlayer.getHero())
    elif eventPlayer.getHero() == Hero.KIRIKO:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +25%\r\n{1}\r\n{2}\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), "暴击倍率提高至 ×{0}".format(HeadshotDamage[2] + 1), "{0} 瞬 最远距离提高至 105 米\r\n{1} 铃 冷却时间降低至 10 秒\r\n  无敌时间提高至 1.8 秒".format(abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2)))
    elif eventPlayer.getHero() == Hero.LIFEWEAVER:
        eventPlayer.changelog_body = "\r\n●{0}\r\n{1} 花瓣平台\r\n  冷却时间降低至 9 秒\r\n{2} 生命之握\r\n  冷却时间降低至 9 秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2))
    elif eventPlayer.getHero() == Hero.LUCIO:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +20%\r\n*受到伤害 -30%\n\n※※离开重生室隐藏".format(eventPlayer.getHero())
    elif eventPlayer.getHero() == Hero.MERCY:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*女武神\r\n  受到伤害 -{1}%\r\n  持续期间重生无冷却时间\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), MercyBuff[0])
    elif eventPlayer.getHero() == Hero.ZENYATTA:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +60%\r\n*受到伤害+5%\r\n  暴击倍率提高至 ×{1}\r\n* 蹬 将禅雅塔向相反方向击飞\r\n* 圣 治疗量提高至400/s 移速+25%\r\n  无法被命中 免疫所有控制\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), 1 + HeadshotDamage[0])
    elif eventPlayer.getHero() == Hero.MOIRA:
        eventPlayer.changelog_body = "\r\n{0}\r\n{1}\r\n{2}\n\n※※离开重生室隐藏".format("●{0}\r\n 受到伤害-10%\r\n造成治疗+15%".format(eventPlayer.getHero()), "{0} 消散 冷却时间增加至 8 秒".format(abilityIconString(eventPlayer.getHero(), Button.ABILITY_1)), "")
    elif eventPlayer.getHero() == Hero.VENDETTA:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +35%\r\n*受到伤害-45%\r\n{1}\r\n{2}\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), "{0} 暴击额外其{1}%最大生命值伤害，并回复{2}最大生命值".format(abilityIconString(eventPlayer.getHero(), Button.PRIMARY_FIRE), VendettaBuff[0] * 100, VendettaBuff[6] * 100), "{0}\r\n{1}\r\n{2}".format("{0} 每命中一名敌人回复{1}%已损失生命值".format(abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), VendettaBuff[2] * 100), "{0} 使敌人沉默，持续期间不可阻挡".format(abilityIconString(eventPlayer.getHero(), Button.ABILITY_2)), "{0} 击倒敌人，生命值低于{1}%的敌人将被斩杀".format(abilityIconString(eventPlayer.getHero(), Button.ULTIMATE), VendettaBuff[5] * 100)))
    elif eventPlayer.getHero() == Hero.WUYANG:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*主攻击命中额外造成目标最大生命值8%伤害\r\n  并使{1}冷却缩短1秒\r\n{2} 飞流步 每秒回复{3}生命值\r\n  持续期间受到伤害 -{4}%\r\n{1} 对同一目标叠加2次后冻结{5}秒\r\n{6} 命中友方时将其治疗至满生命值\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), WuyangBuff[2], WuyangBuff[3], WUYANG_ABILITY2_FROZEN_DURATION, abilityIconString(eventPlayer.getHero(), Button.ULTIMATE))
