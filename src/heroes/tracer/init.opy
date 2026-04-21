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
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["跳跳熊", "FLETA", "EVAEL", "炸弹摩西", "瞬移摩西"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false
