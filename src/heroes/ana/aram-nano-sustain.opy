#!include "nano-full-health-trigger-shared.opy"

rule "Has Nano":
    @Event playerReceivedHealing
    @Condition eventAbility == Button.ULTIMATE
    @Condition healer.getHero() == Hero.ANA
    @Condition eventPlayer.has_nano != true

    eventPlayer.has_nano = true
    waitUntil(eventPlayer.isDead(), 8)
    eventPlayer.has_nano = false

rule "[Ana] Nano Boost Healing":
    @Event playerDealtHealing
    @Hero ana
    @Condition eventAbility == Button.ULTIMATE
    @Condition healer.getHero() == Hero.ANA == true
    @Condition eventPlayer.has_nano == true

    heal(healee, healer, 99999)
    healee.startHealingOverTime(healer, 10, ceil(healee.getMaxHealth() * 0.2))
