#!mainFile "../../main.opy"
#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.

#!optimizeStrict


playervar sierra_buff

rule "[Sierra]: secondary hit get ammo":
    @Event playerDealtDamage
    @Hero sierra
    @Condition eventAbility == Button.SECONDARY_FIRE
    # @Condition eventPlayer.getAmmo() != eventPlayer.getMaxAmmo()
    
    if eventPlayer.sierra_buff == null:
        eventPlayer.sierra_buff = victim
    if eventPlayer.getAmmo() != eventPlayer.getMaxAmmo():
        eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())
    wait(3)
    eventPlayer.sierra_buff = null
    wait(1)

rule "[Sierra]: secondary target damage amp":
    @Event eachPlayer
    @Hero sierra
    @Condition eventPlayer.sierra_buff != null

    if eventPlayer.dmg_amplification != null:
        stopDamageModification(eventPlayer.dmg_amplification)
    startDamageModification([eventPlayer.sierra_buff], eventPlayer, SierraBuff[1], DamageReeval.RECEIVERS_AND_DAMAGERS)
    eventPlayer.dmg_amplification = getLastDamageModification()
    wait(3)
    if ruleCondition:
        loop()
    stopDamageModification(eventPlayer.dmg_amplification)

rule "[Sierra]: secondary kill":
    @Event playerDealtFinalBlow
    @Hero sierra
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) > 0.5
    
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, SIERRA_SECONDARY_SECONDARY_FIRE_COOLDOWN_SET)
