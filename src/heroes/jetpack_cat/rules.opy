#!optimizeStrict

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
