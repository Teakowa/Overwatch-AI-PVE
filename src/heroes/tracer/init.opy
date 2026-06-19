#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitTracer():
    @Name "[tracer/init.opy]: heroInitTracer()"

    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 8)
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["跳跳熊", "FLETA", "EVAEL", "炸弹摩西", "瞬移摩西"]))
    lbl_0:
