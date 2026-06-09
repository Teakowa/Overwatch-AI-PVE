#!mainFile "../../aramMain.opy"
#!optimizeStrict

rule "[Mercy]: Life Grip Clear Effect":
    @Event playerDealtHealing
    @Hero mercy
    @Condition eventAbility == Button.RELOAD

    heal(healee, healer, healee.getMaxHealth().scaledBy(MERCY_ARAM_HEALTH_SCALAR))

#!include "reload.opy"
#!include "ultimate.opy"
