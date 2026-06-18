#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Brigitte]: Detect switch to Brigitte":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero brigitte

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Brigitte] Initialize":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["那个女人", "炖鸡摩西", "持盾摩西", "贴膜摩西", "护 娜 十 三 锤", "泰格"]))
    lbl_0:
    getPlayers(eventPlayer.getTeam()).reset_pvar[1] = eventPlayer
    if eventPlayer.getTeam() == Team.2:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +25%\r\n*造成治疗+10%\r\n*受到伤害 -57%\r\n*恢复包 提供永久护甲\r\n*能量盾击 可穿透屏障击晕敌人\r\n*集结号令 为自身提供额外临时护甲\n\n".format(eventPlayer.getHero())
    eventPlayer._reset_requested = false
