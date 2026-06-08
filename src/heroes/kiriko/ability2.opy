#!optimizeStrict

rule "[Kiriko]: Protection Suzu Clear Effect":
    @Event playerDealtHealing
    @Hero kiriko
    @Condition eventAbility == Button.ABILITY_2
    #@Condition healer.getHero() == Hero.KIRIKO == true
    @Condition healee.mauga_berserker_soul != true

    if healee != healer:
        goto lbl_0
    resetStatuses()
    lbl_0:
    healee.unaffected = true
    healee.setStatusEffect(healer, Status.INVINCIBLE, KIRIKO_ABILITY2_INVINCIBLE_DURATION)
    healee.setStatusEffect(healer, Status.PHASED_OUT, KIRIKO_ABILITY2_PHASED_OUT_DURATION)
    wait(1.8)
    healee.unaffected = false
