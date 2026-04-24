#!optimizeStrict

rule "[Junker Queen]: Detect switch to Junker Queen":
    @Event eachPlayer
    @Hero junkerQueen

    eventPlayer.reset_pvar[0] = true

rule "[Junker Queen] Initialize":
    @Event eachPlayer
    @Hero junkerQueen
    @Condition eventPlayer.reset_pvar[0] != false

    resetHero()
    eventPlayer.setHealingDealt(144.46 if eventPlayer.getTeam() == Team.1 else 122.23)
    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["姐就是女王 自信放光芒", "你若爱就来 不爱莫张狂", "收起你的那些小小花花肠", "甜言或蜜语去哄小姑娘", "姐就是女王 自信放光芒", "有钱了不起 姐也很自强", "不惧风霜雪雨逆风也飞翔", "活成一束光世界都照亮"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false
