#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Hanzo]: headshot damage":
    @Event playerDealtDamage
    @Hero hanzo
    @Condition HanzoBuff[0] > 0
    @Condition eventWasCriticalHit == true

    damage(victim, attacker, HanzoBuff[0])
