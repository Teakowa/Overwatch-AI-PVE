rule "[Sombra]: kiil reset cooldown":
    @Event playerEarnedElimination
    @Hero sombra
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
    wait(0.5)
