rule "[Sigma]: Hyperspheres Layer Damage":
    @Event playerDealtDamage
    @Hero sigma
    @Condition SigmaBuff[0] != 0
    @Condition eventPlayer.sigma_hyperspheres < SigmaBuff[1] + 1
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    eventPlayer.sigma_hyperspheres++
    eventPlayer.hudText = "{0}|{1}".format(eventPlayer.sigma_hyperspheres, 3)
    wait(0.6)

rule "[Sigma]: Hyperspheres Layer Damage":
    @Event playerDealtDamage
    @Hero sigma
    @Condition SigmaBuff[0] != 0
    @Condition eventPlayer.sigma_hyperspheres == SigmaBuff[1] + 1
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    eventPlayer.sigma_hyperspheres = 0
    eventPlayer.hudText = "{0}|{1}".format(eventPlayer.sigma_hyperspheres, 3)
    damage(victim, attacker, attacker.getHealth() * SigmaBuff[0])
    wait(4)

rule "[Sigma]: Hyperspheres HUD":
    @Event eachPlayer
    @Team 2
    @Hero sigma
    @Condition SigmaBuff[0] != 0
    @Condition eventPlayer.isInSpawnRoom() != true
    @Condition eventPlayer.reset_pvar[0] == false
    @Disabled
    
    hudText(eventPlayer, null, "\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r", "{0}|{1}".format(eventPlayer.sigma_hyperspheres, SigmaBuff[1]), HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.sigma_hyperspheres_hud = getLastCreatedText()
    waitUntil(eventPlayer.reset_pvar[0] or eventPlayer.isInSpawnRoom(), 999999986991104)
    destroyHudText(eventPlayer.sigma_hyperspheres_hud)
    destroyInWorldText(eventPlayer.sigma_hyperspheres_hud)
