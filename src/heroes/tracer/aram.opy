#!mainFile "../../aramMain.opy"
#!optimizeStrict

#!include "ability2.opy"

rule "[Tracer] Instant Respawn":
    @Event playerDied
    @Hero tracer

    wait(0.16)
    eventPlayer.respawn()
    eventPlayer.setAbilityCharge(Button.ABILITY_1, 3)

rule "[Tracer] Pulse Bomb Damage":
    @Event playerDealtDamage
    @Hero tracer
    #@Condition attacker.getHero() == Hero.TRACER == true
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventDamage > 10

    damage(victim, attacker, ceil(eventDamage * 2))
