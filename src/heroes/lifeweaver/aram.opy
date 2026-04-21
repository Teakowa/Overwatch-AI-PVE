# lifeweaver aram-only life grip healing

rule "[Lifeweaver]: Life Grip Healing":

    @Event playerDealtHealing

    @Hero lifeweaver

    @Condition healer.isUsingAbility2() == true

    #@Condition healer.getHero() == Hero.LIFEWEAVER

    @Condition healee.hasStatus(Status.INVINCIBLE) == true

    if healee.mauga_berserker_soul == true:

        goto lbl_0

    resetStatuses()

    lbl_0:

    healee.startHealingOverTime(healer, 2.5, ceil(healee.getMaxHealth() / 2.5))

    healee.setMoveSpeed(130)

    wait(2.6)
