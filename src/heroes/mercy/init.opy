#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitMercy():
    @Name "[mercy/init.opy]: heroInitMercy()"

    eventPlayer.setMaxAmmo(0, 20)
    eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["摩西", "拉使", "国服摩西请战", "我 有 恋 尸 癖", "慈 悲 十 三 摩", "食 尸 鬼"]))
    lbl_0:
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
