rule "[Mercy]: Life Grip Clear Effect":
    @Event playerDealtHealing
    @Hero mercy
    @Condition eventAbility == Button.ABILITY_2
    
    healee.startHealingOverTime(healer, 2, healee.getMaxHealth() * 0.2)
