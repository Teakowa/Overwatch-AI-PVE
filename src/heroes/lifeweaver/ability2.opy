#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Lifeweaver]: Life Grip Clear Effect":
    @Event playerReceivedHealing
    @Condition eventAbility == Button.ABILITY_2
    @Condition isHero(healer, Hero.LIFEWEAVER)
    @Condition eventPlayer.mauga_berserker_soul != true

    resetStatuses()
