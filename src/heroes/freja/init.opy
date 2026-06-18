#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Freja/init.opy]: Detect switch to Freja":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero freja

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Freja/init.opy]: Initialize Freja":
    @Event eachPlayer
    @Hero freja
    @Condition eventPlayer._reset_requested != false

    resetHero()
    eventPlayer.setProjectileSpeed(FREJA_INIT_PROJECTILE_SPEED)
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["ANS", "射 爆", "拉矢摩西"]))
    lbl_0:
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).reset_pvar[11] = eventPlayer
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.FREJA:
            eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +10%\r\n*受到伤害 -10%\r\n{1} 狩猎者 造成伤害时给敌方施加“狩猎”印记\r\n{2} 瞄准射击 爆炸造成20 × 印记层数 额外伤害\r\n  引爆后敌方生命值低于20%则将其斩杀\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.PRIMARY_FIRE), abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE))
