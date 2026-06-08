#!optimizeStrict

rule "[Mercy]: Life Grip Clear Effect":
    @Event playerDealtHealing
    @Hero mercy
    @Condition eventAbility == Button.RELOAD

    heal(healee, healer, healee.getMaxHealth() * MERCY_ARAM_LINE_8_HEALTH_SCALAR)

#!include "reload.opy"
#!include "ultimate.opy"