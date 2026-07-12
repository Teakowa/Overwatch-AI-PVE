#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Freja]: Dmg. reduction":
    @Event eachPlayer
    @Hero freja
    @Condition eventPlayer.isUsingAbility2() == true
    #@Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) != 0
    @Condition eventPlayer.isInAir() == true

    if eventPlayer.getTeam() == Team.2:
        goto lbl_0
    heal(eventPlayer, null, FREJA_ABILITY2_HEAL)
    eventPlayer.setDamageReceived(FREJA_ABILITY2_DAMAGE_RECEIVED)
    eventPlayer.hudText = "受到伤害减免：{0}%".format(25)
    lbl_0:
    waitUntil(not eventPlayer.isInAir() and eventPlayer.isOnGround(), 99999)
    eventPlayer.hudText = ""
    eventPlayer.setDamageReceived(100)
