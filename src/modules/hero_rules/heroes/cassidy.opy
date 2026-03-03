rule "[Cassdy] Flashbang stun":
    @Event playerDealtDamage
    @Hero cassidy
    @Condition eventAbility == Button.ABILITY_2
    
    victim.setStatusEffect(attacker, Status.STUNNED, 0.8)
rule "[Cassdy] Peacekeeper Alt Fire":
    @Event eachPlayer
    @Hero cassidy
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    eventPlayer.setDamageDealt(135)
    waitUntil(not eventPlayer.isFiringSecondaryFire(), 0.75)
    eventPlayer.setDamageDealt(100)
rule "[Cassdy] Peacekeeper Alt Fire Reload":
    @Event eachPlayer
    @Hero cassidy
    @Condition eventPlayer.getAmmo() == 0
    
    wait(0.75, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())
rule "[Cassdy] ammo restored by kills":
    @Event playerDealtFinalBlow
    @Team 1
    @Hero cassidy
    @Condition isGameInProgress() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAmmo() < eventPlayer.getMaxAmmo()
    
    eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())
