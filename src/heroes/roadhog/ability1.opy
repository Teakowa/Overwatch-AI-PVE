#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Roadhog]: Chain Hook slaughter mark":
    @Event playerDealtDamage
    @Hero roadhog
    @Condition eventAbility == Button.ABILITY_1
    @Condition victim.getTeam() != attacker.getTeam()
    @Condition victim.unaffected != true
    @Condition victim.untargetable() != true

    eventPlayer.roadhog_slaughter_target = victim
    current_slaughter_target = victim
    wait(3)
    if eventPlayer.roadhog_slaughter_target == current_slaughter_target:
        eventPlayer.roadhog_slaughter_target = null
