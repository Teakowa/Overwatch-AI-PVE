rule "[JetpackCat]: Frenetic Flight fuel regeneration":
    @Event eachPlayer
    @Hero jetpackCat
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) != true
    @Condition eventPlayer.getAbilityResource(Button.SECONDARY_FIRE) < 100
    @Disabled

    wait(0.1)
    eventPlayer.setAbilityResource(Button.SECONDARY_FIRE, min(100, eventPlayer.getAbilityResource(Button.SECONDARY_FIRE) + 7.5))
    if ruleCondition:
        loop()

rule "[JetpackCat]: Claws Out melee stun":
    @Event playerDealtDamage
    @Hero jetpackCat
    @Condition eventAbility == Button.MELEE
    @Condition victim.getTeam() != attacker.getTeam()
    @Condition victim.unaffected != true
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false

    victim.setStatusEffect(attacker, Status.STUNNED, 1.2)
    heal(eventPlayer, eventPlayer, 25 + eventDamage)

#!include "ability1.opy"
#!include "ability2.opy"
#!include "ultimate.opy"
