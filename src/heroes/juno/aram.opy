rule "[Juno] Track Orbital Ray Position":

    @Event eachPlayer

    @Hero juno

    @Condition eventPlayer.isUsingUltimate() == true

    @Condition eventPlayer.isAlive() == true

    wait(0.5, Wait.ABORT_WHEN_FALSE)

    getPlayersInRadius(eventPlayer, 12.5, eventPlayer.getTeam()).juno_buff[0] = true

    wait(10)

    getPlayers(eventPlayer.getTeam()).juno_buff[0] = false

rule "[Juno]: Orbial Ray Damage":

    @Event eachPlayer

    @Condition eventPlayer.juno_buff[0] == true

    smallMessage(eventPlayer, "   {0} 轨道射线： 伤害减免 {1}%".format(abilityIconString(Hero.JUNO, Button.ULTIMATE), JunoBuff))

    eventPlayer.setDamageReceived(100 - JunoBuff)

    waitUntil(not eventPlayer.juno_buff[0], 10)

    eventPlayer.setDamageReceived(100)

    smallMessage(eventPlayer, "   {0} 轨道射线： 伤害减免已结束".format(abilityIconString(Hero.JUNO, Button.ULTIMATE)))

rule "[Juno]: Pulsar Torpedoes Healing":

    @Event playerReceivedHealing

    @Condition healer.getHero() == Hero.JUNO

    @Condition eventAbility == Button.SECONDARY_FIRE

    eventPlayer.healing_increase += 50

    eventPlayer.setHealingReceived(100 - eventPlayer.healing_decrease + eventPlayer.healing_increase)

    healee.startHealingOverTime(healer, 2.5, ceil(healee.getMaxHealth() * 0.25 / 2.5))

    waitUntil(eventPlayer.isDead(), 4)

    eventPlayer.setHealingReceived(100)

    eventPlayer.healing_increase = 0

    wait(2.6)

rule "[Juno]: Pulsar Torpedoes":

    @Event playerDealtDamage

    @Hero juno

    @Condition eventAbility == Button.SECONDARY_FIRE

    damage(victim, attacker, victim.getMaxHealth() * 0.2)
