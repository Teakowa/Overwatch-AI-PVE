#!optimizeStrict

rule "[Lifeweaver]: Life Grip Clear Effect":
    @Event playerReceivedHealing
    @Condition eventAbility == Button.ABILITY_2
    @Condition healer.getHero() == Hero.LIFEWEAVER == true
    @Condition eventPlayer.mauga_berserker_soul != true

    resetStatuses()
