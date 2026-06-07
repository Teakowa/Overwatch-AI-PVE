#!optimizeStrict

rule "[Mercy]: Life Grip Clear Effect":
    @Event playerDealtHealing
    @Hero mercy
    @Condition eventAbility == Button.RELOAD

    heal(healee, healer, healee.getMaxHealth() * 0.5)

#!include "reload.opy"
#!include "ultimate.opy"