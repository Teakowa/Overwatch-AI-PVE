#!mainFile "../../aramMain.opy"
#!optimizeStrict

# sojourn aram-only overclock execution

rule "[Sojourn] Overclock Buff":
    @Event eachPlayer
    @Hero sojourn
    @Condition eventPlayer.isUsingUltimate() == true

    SojournBuff[0] += 5
    waitUntil(not eventPlayer.isUsingUltimate(), 10)
    SojournBuff[0] -= 5

rule "[Sojourn] Execution players less 10% HP expectancy":
    @Event playerDealtDamage
    @Hero sojourn
    @Condition SojournBuff[0] != 0
    @Condition (eventAbility == Button.SECONDARY_FIRE or eventAbility == Button.ULTIMATE) == true
    @Condition victim.zarya_buff[1] == null
    @Condition victim.untargetable() != true
    @Condition victim.has_nano != true
    @Condition victim.healthAtMostPercent(SojournBuff[0])

    damage(victim, attacker, SojournBuff[1])
