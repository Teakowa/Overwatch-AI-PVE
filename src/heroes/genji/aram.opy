#!mainFile "../../aramMain.opy"
#!optimizeStrict

# genji aram-only dragonblade healing

rule "[Genji] Dragonblade Healing":
    @Event playerDealtDamage
    @Hero genji
    @Condition eventAbility == Button.ULTIMATE

    heal(eventPlayer, eventPlayer, eventDamage)
    damage(victim, attacker, eventPlayer.getMaxHealth().scaledBy(GENJI_ARAM_HEALTH_SCALAR))
    wait(0.16)

rule "[Genji] Dragonblade Execution players less 10% HP expectancy":
    @Event playerDealtDamage
    @Hero genji
    @Condition eventAbility == Button.ABILITY_1
    @Condition victim.zarya_buff[1] == null
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false
    @Condition victim.has_nano != true
    @Condition victim.getHealth().isAtMostPercentOf(10, victim.getMaxHealth())

    damage(victim, attacker, SojournBuff[1])

rule "[Genji] Dragonblade Damage Fix":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.setDamageDealt(100 + Genji[1])
    eventPlayer.setDamageReceived(GENJI_ARAM_DAMAGE_RECEIVED)
    waitUntil(not eventPlayer.isUsingUltimate(), 8)
    eventPlayer.setDamageDealt(100)
    eventPlayer.setDamageReceived(100)

rule "[Genji]: Deflect":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isUsingAbility2() == true

    eventPlayer.setStatusEffect(eventPlayer, Status.INVINCIBLE, GENJI_ARAM_INVINCIBLE_DURATION)
    eventPlayer.setDamageDealt(GENJI_ARAM_DAMAGE_DEALT)
    waitUntil(not eventPlayer.isUsingAbility2(), 3)
    eventPlayer.setDamageDealt(100)
