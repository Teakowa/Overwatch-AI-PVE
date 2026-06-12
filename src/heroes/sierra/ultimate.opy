#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Sierra]: ultmate stun":
    @Event playerDealtKnockback
    @Hero sierra
    @Condition eventAbility == Button.ULTIMATE

    victim.setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, SierraBuff[2])
    damage(victim, attacker, eventDamage / SIERRA_ULTIMATE_EVENT_DAMAGE_DIVISOR)
    wait(1.5)
