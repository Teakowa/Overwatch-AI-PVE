#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Roadhog]: Chain Hook slaughter mark":
    @Event playerDealtDamage
    @Hero roadhog
    @Condition eventAbility == Button.ABILITY_1
    @Condition victim.getTeam() != attacker.getTeam()
    @Condition victim.unaffected != true
    @Condition victim.untargetable() != true

    victim.roadhog_slaughter = true
    wait(3)
    victim.roadhog_slaughter = false
