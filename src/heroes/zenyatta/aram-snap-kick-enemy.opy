rule "[Zenyatta] Snap Kick (enemy)":
    @Event playerReceivedKnockback
    @Condition attacker.getHero() == Hero.ZENYATTA == true
    @Condition eventAbility == Button.MELEE
    
    heal(attacker, attacker, victim.getMaxHealth() * 0.25)
    victim.setStatusEffect(attacker, Status.STUNNED, 1.5)
    attacker.heart_steel[1] += 150
    if attacker.heart_steel[0] == null:
        goto lbl_0
    removeHealthPool(attacker.heart_steel[0])
    lbl_0:
    attacker.addHealthPool(Health.NORMAL, attacker.heart_steel[1], false, false)
    attacker.heart_steel[0] = getLastCreatedHealthPool()
    wait()
    damage(eventPlayer, attacker, eventDamage * 0.5)
