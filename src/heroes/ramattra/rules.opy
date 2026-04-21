#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.

#!optimizeStrict

rule "[Ramattra]: Pain endures":
    @Event playerDealtFinalBlow
    @Hero ramattra
    @Condition eventPlayer.getUltCharge() != 100
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition (eventAbility == Button.ULTIMATE or eventAbility == Button.ABILITY_1) == true

    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 25)
    wait(0.3)


rule "[Ramattra]: block":
    @Event playerTookDamage
    @Hero ramattra
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate()) == true
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.ram_block_damage <= Ram_Annihilation[0]
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) <= 325

    eventPlayer.ram_block_damage += eventDamage
    eventPlayer.hudText = "{0}/{1}".format(floor(eventPlayer.ram_block_damage), Ram_Annihilation[0])


rule "[Ramattra]: block HP":
    @Event eachPlayer
    @Hero ramattra
    @Condition Ram_Annihilation[0] != 0
    @Condition eventPlayer.ram_block_damage != 0
    @Condition eventPlayer.ram_block_damage >= Ram_Annihilation[0]

    eventPlayer.addHealthPool(Health.NORMAL, Ram_Annihilation[0] if eventPlayer.ram_block_damage >= Ram_Annihilation[0] else eventPlayer.ram_block_damage, false, false)
    eventPlayer.ram_block_damage = 0
    eventPlayer.hudText = ""
    #if eventPlayer.getTeam() == Team.2:
    #        goto lbl_0
    #eventPlayer.startHealingOverTime(eventPlayer, 5, eventPlayer.getMaxHealth() * 0.25)
    lbl_0:


rule "[Ramattra]: block HUD":
    @Event eachPlayer
    @Team 2
    @Hero ramattra
    @Condition eventPlayer.isInSpawnRoom() != true
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate()) == true
    @Condition eventPlayer.reset_pvar[0] == false
    @Condition eventPlayer.ram_block_damage > 0

    #hudText(eventPlayer, null, "\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r", "{0}/{1}".format(floor(eventPlayer.ram_block_damage), Ram_Annihilation[0]), HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    #eventPlayer.ram_block_damage_hud = getLastCreatedText()
    waitUntil(eventPlayer.ram_block_damage == 0 or eventPlayer.reset_pvar[0] or eventPlayer.isInSpawnRoom(), Math.INFINITY)
    eventPlayer.hudText = ""
    #destroyHudText(eventPlayer.ram_block_damage_hud)

#!include "ability1.opy"
#!include "ultimate.opy"
