rule "[Sigma]: shield cd":
    @Event eachPlayer
    @Hero sigma
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) <= 0.98
    
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0.5)
    wait(0.5)
rule "[Sigma]: ult damage":
    @Event playerDealtDamage
    @Hero sigma
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventDamage > 75
    
    damage(victim, attacker, eventDamage / 2)
rule "[Sigma]: Accretion knockdown":
    @Event playerDealtDamage
    @Hero sigma
    @Condition eventAbility == Button.ABILITY_2
    @Condition victim.hasStatus(Status.KNOCKED_DOWN) == true
    
    victim.setStatusEffect(attacker, Status.KNOCKED_DOWN, 1.8)
rule "[Sigma]: Hyperspheres Layer Damage":
    @Event playerDealtDamage
    @Hero sigma
    @Condition SigmaBuff[0] != 0
    @Condition eventPlayer.sigma_hyperspheres < 4
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    eventPlayer.sigma_hyperspheres++
    eventPlayer.hudText = "{0}|{1}".format(eventPlayer.sigma_hyperspheres, 3)
    wait(0.6)
rule "[Sigma]: Hyperspheres Layer Damage":
    @Event playerDealtDamage
    @Hero sigma
    @Condition SigmaBuff[0] != 0
    @Condition eventPlayer.sigma_hyperspheres == 4
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    eventPlayer.sigma_hyperspheres = 0
    eventPlayer.hudText = "{0}|{1}".format(eventPlayer.sigma_hyperspheres, 3)
    damage(victim, attacker, (attacker.getMaxHealthOfType(Health.NORMAL) + attacker.getMaxHealthOfType(Health.ARMOR) + attacker.getMaxHealthOfType(Health.SHIELDS)) * SigmaBuff[0])
    wait(4)
rule "[Sigma]: Hyperspheres HUD":
    @Event eachPlayer
    @Team 2
    @Hero sigma
    @Condition SigmaBuff[0] != 0
    @Condition eventPlayer.isInSpawnRoom() != true
    @Condition eventPlayer.reset_pvar[0] == false
    @Disabled
    
    eventPlayer.hudText = "{0}|{1}".format(eventPlayer.sigma_hyperspheres, 3)
    #hudText(eventPlayer, null, "\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r", "{0}|{1}".format(eventPlayer.sigma_hyperspheres, 3), HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    #eventPlayer.sigma_hyperspheres_hud = getLastCreatedText()
    waitUntil(eventPlayer.reset_pvar[0] or eventPlayer.isInSpawnRoom(), Math.INFINITY)
    eventPlayer.hudText = ""
    #destroyHudText(eventPlayer.sigma_hyperspheres_hud)
