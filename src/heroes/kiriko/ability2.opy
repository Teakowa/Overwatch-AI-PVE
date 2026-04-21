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
    healee.setStatusEffect(healer, Status.INVINCIBLE, 1.8)
    healee.setStatusEffect(healer, Status.PHASED_OUT, 1.8)
    wait(1.8)
    healee.unaffected = false
