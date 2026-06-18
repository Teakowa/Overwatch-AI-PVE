#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Vendetta/init.opy]: Detect switch to Vendetta":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero vendetta

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Vendetta/init.opy]: Initialize Vendetta":
    @Event eachPlayer
    @Hero vendetta
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["大剑摩西", "一刀摩西"]))
    lbl_0:
    if eventPlayer.getTeam() == Team.2:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +35%\r\n*受到伤害-45%\r\n{1}\r\n{2}\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), "{0} 暴击额外其{1}%最大生命值伤害，并回复{2}最大生命值".format(abilityIconString(eventPlayer.getHero(), Button.PRIMARY_FIRE), VendettaBuff[0] * 100, VendettaBuff[6] * 100), "{0}\r\n{1}\r\n{2}".format("{0} 每命中一名敌人回复{1}%已损失生命值".format(abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), VendettaBuff[2] * 100), "{0} 使敌人沉默，持续期间不可阻挡".format(abilityIconString(eventPlayer.getHero(), Button.ABILITY_2)), "{0} 击倒敌人，生命值低于{1}%的敌人将被斩杀".format(abilityIconString(eventPlayer.getHero(), Button.ULTIMATE), VendettaBuff[5] * 100)))
    eventPlayer._reset_requested = false
