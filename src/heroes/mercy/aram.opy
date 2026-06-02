#!optimizeStrict

rule "[Mercy]: Life Grip Clear Effect":
    @Event playerDealtHealing
    @Hero mercy
    @Condition eventAbility == Button.ABILITY_2

    heal(healee, healer, healee.getMaxHealth() * 0.4)

#!include "reload.opy"
#!include "ultimate.opy"