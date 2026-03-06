rule "[Junkrat]: Steel Trap bleed":
    @Event playerDealtDamage
    @Hero junkrat
    @Condition eventAbility == Button.ABILITY_2
    
    victim.startDamageOverTime(attacker, 9999, 10)
    eventPlayer.junkrat_buff = getLastDamageOverTimeId()

rule "[Junkrat]: Steel Trap bleed":
    @Event playerReceivedHealing
    @Condition eventPlayer.junkrat_buff != null
    @Condition eventPlayer.isAlive() == true
    
    stopDamageOverTime(eventPlayer.junkrat_buff)
    eventPlayer.junkrat_buff = null
