rule "[Reinhardt]: Shield Slam knockback":
    @Event eachPlayer
    @Team 2
    @Hero reinhardt
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    eventPlayer.setKnockbackDealt(50)
    waitUntil(not eventPlayer.isFiringSecondaryFire(), 99999)
    eventPlayer.setKnockbackDealt(100)

rule "[Reinhardt]: Shield Slam stun":
    @Event playerDealtKnockback
    @Hero reinhardt
    @Condition eventAbility == Button.SECONDARY_FIRE
    
    victim.setStatusEffect(attacker, Status.STUNNED, 1.2)

rule "[Reinhardt]: Attack to get overhealth":
    @Event playerDealtKnockback
    @Hero reinhardt
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition attacker.getHero() == Hero.REINHARDT
    @Condition len(eventPlayer.rein_health_id) < 5
    
    eventPlayer.addHealthPool(Health.NORMAL, 50, false, false)
    eventPlayer.rein_health_id.append(getLastCreatedHealthPool())
    wait(0.5)
    #if ruleCondition:
    #        loop()

rule "[Reinhardt]: Attack to get overhealth removal":
    @Event eachPlayer
    @Hero reinhardt
    @Condition len(eventPlayer.rein_health_id) != 0
    
    wait(5, Wait.ABORT_WHEN_FALSE)
    removeHealthPool(eventPlayer.rein_health_id[0])
    eventPlayer.rein_health_id.remove(eventPlayer.rein_health_id[0])
    wait(0.25)
    if ruleCondition:
        loop()
    eventPlayer.rein_health_id = []

