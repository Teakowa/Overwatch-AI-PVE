rule "[Ana]: Sleep tanks for longer duration":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.ABILITY_1
    @Condition victim.unaffected == false
    
    victim.clearStatusEffect(Status.ASLEEP)
    #waitUntil(victim.hasStatus(Status.ASLEEP), 999999986991104)
    victim.setStatusEffect(attacker, Status.KNOCKED_DOWN, 4)
    #heart_steel_hp
    eventPlayer.heart_steel[1] += 50 if eventPlayer.getTeam() == Team.2 else 100
    eventPlayer.heart_steel[2] = true

rule "[Ana]: Sleep tanks for longer duration":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.heart_steel[1] > 0
    @Condition eventPlayer.heart_steel[2] == true
    
    if eventPlayer.heart_steel[0] == null:
        goto lbl_0
    removeHealthPool(eventPlayer.heart_steel[0])
    lbl_0:
    eventPlayer.addHealthPool(Health.ARMOR, eventPlayer.heart_steel[1], true, false)
    eventPlayer.heart_steel[0] = getLastCreatedHealthPool()
    eventPlayer.heart_steel[2] = false
