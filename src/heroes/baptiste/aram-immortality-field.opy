# baptiste aram-only immortality field

rule "[Baptiste]: Immortality Field":
    @Event eachPlayer
    @Condition eventPlayer.hasStatus(Status.UNKILLABLE) == true
    @Condition eventPlayer.reset_pvar[12].getAbilityCooldown(Button.ABILITY_2) > 0
    
    #heal(eventPlayer, eventPlayer.reset_pvar[12], 50)
    eventPlayer.startHealingOverTime(eventPlayer.reset_pvar[12], 5, 50 if eventPlayer.getTeam() == Team.1 else 25)
    wait(8)
