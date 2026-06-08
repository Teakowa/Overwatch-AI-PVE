#!optimizeStrict

#!include "headshot.opy"

rule "[Kiriko]: Protection Suzu Clear Effect":
    @Event playerDealtHealing
    @Hero kiriko
    @Condition eventAbility == Button.ABILITY_2
    @Condition healee.mauga_berserker_soul != true

    if healee != healer:
        goto lbl_0
    resetStatuses()
    lbl_0:
    healee.unaffected = true
    healee.setStatusEffect(healer, Status.INVINCIBLE, KIRIKO_ARAM_ABILITY2_INVINCIBLE_DURATION)
    healee.setStatusEffect(healer, Status.PHASED_OUT, KIRIKO_ARAM_ABILITY2_PHASED_OUT_DURATION)
    wait(2.5)
    healee.unaffected = false

rule "[Kiriko]: Swift Step":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0

    resetStatuses()
    eventPlayer.setStatusEffect(eventPlayer, Status.INVINCIBLE, KIRIKO_ARAM_ABILITY1_INVINCIBLE_DURATION)
    eventPlayer.setStatusEffect(eventPlayer, Status.PHASED_OUT, KIRIKO_ARAM_ABILITY1_PHASED_OUT_DURATION)
