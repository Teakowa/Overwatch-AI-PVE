# sojourn aram-only overclock execution

rule "[Sojourn] Overclock Buff":
    @Event eachPlayer
    @Hero sojourn
    @Condition eventPlayer.isUsingUltimate() == true

    SojournBuff[0] += 0.05
    waitUntil(not eventPlayer.isUsingUltimate(), 10)
    SojournBuff[0] -= 0.05

rule "[Sojourn] Execution players less 10% HP expectancy":
    @Event playerDealtDamage
    @Hero sojourn
    @Condition SojournBuff[0] != 0
    @Condition (eventAbility == Button.SECONDARY_FIRE or eventAbility == Button.ULTIMATE) == true
    @Condition victim.zarya_buff[1] == null
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false
    @Condition victim.has_nano != true
    @Condition victim.getHealth() <= SojournBuff[0] * victim.getMaxHealth()

    damage(victim, attacker, SojournBuff[1])
