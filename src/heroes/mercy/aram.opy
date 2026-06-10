#!mainFile "../../aramMain.opy"
#!optimizeStrict

rule "[Mercy]: Life Grip Clear Effect":
    @Event playerDealtHealing
    @Hero mercy
    @Condition eventAbility == Button.RELOAD

    heal(healee, healer, healee.maxHealthPercent(MERCY_ARAM_MAX_HEALTH_PERCENT))

#!include "reload.opy"
#!include "ultimate.opy"
