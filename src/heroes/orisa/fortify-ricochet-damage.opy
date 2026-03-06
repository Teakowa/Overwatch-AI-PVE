rule "[Orisa]Fortify ricochet damage":
    @Event playerTookDamage
    @Hero orisa
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate()) == true
    @Condition eventPlayer.hasStatus(Status.HACKED) != true
    
    damage(attacker, eventPlayer, Orisa_Fortify[1] / 100 * eventDamage)
