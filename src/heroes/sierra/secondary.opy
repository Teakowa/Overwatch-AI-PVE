#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.

#!optimizeStrict

playervar sierra_buff

rule "[Sierra]: secondary hit get ammo":
    @Event playerDealtDamage
    @Hero sierra
    @Condition eventAbility == Button.SECONDARY_FIRE
    # @Condition eventPlayer.getAmmo() != eventPlayer.getMaxAmmo()
    
    if victim.sierra_buff != true:
        victim.sierra_buff = true
    if eventPlayer.getAmmo() != eventPlayer.getMaxAmmo():
        eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())
    wait(4)

rule "[Sierra]: secondary target damage amp":
    @Event eachPlayer
    @Hero sierra
    @Condition getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())).filter(lambda player: player.sierra_buff == true) == true

    if eventPlayer.dmg_amplification != null:
        stopDamageModification(eventPlayer.dmg_amplification)
    startDamageModification(getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())).filter(lambda player: player.hasStatus(Status.BURNING)), eventPlayer, 150, DamageReeval.RECEIVERS_AND_DAMAGERS)
    eventPlayer.dmg_amplification = getLastDamageModification()
    wait(3)
    if ruleCondition:
        loop()
    stopDamageModification(eventPlayer.dmg_amplification)