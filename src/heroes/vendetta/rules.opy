#!optimizeStrict

rule "[Vendetta]: Palatine Fang":
    @Event playerDealtKnockback
    @Hero vendetta
    @Condition eventAbility == Button.PRIMARY_FIRE
    #@Condition victim.getHealthOfType(Health.ARMOR) > 0

    if eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0:
        goto lbl_0
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, eventPlayer.getAbilityCooldown(Button.ABILITY_1) - 1)
    lbl_0:
    if eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0:
        goto lbl_1
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.getAbilityCooldown(Button.ABILITY_2) - 1)
    lbl_1:
    damage(victim, attacker, victim.getMaxHealth() * VendettaBuff[0] if victim.getHealthOfType(Health.ARMOR) == 0 else victim.getMaxHealth() * VendettaBuff[1])
    wait()
    eventPlayer.startHealingOverTime(eventPlayer, eventPlayer.getMaxHealth() * VendettaBuff[6] / 1.5, 1.5)
    wait(0.032)
#!include "ability1.opy"
#!include "ability2.opy"
#!include "ultimate.opy"
