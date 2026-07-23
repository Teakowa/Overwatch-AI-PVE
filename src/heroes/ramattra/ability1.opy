#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Ramattra]: Pummel Knockback":
    @Event playerDealtDamage
    @Hero ramattra
    @Condition eventAbility == Button.ABILITY_1
    @Disabled

    victim.applyImpulse(directionFromAngles(horizontalAngleOfDirection(victim.getPosition() - attacker.getPosition()), -20), RAMATTRA_ABILITY1_FORWARD_IMPULSE, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    victim.applyImpulse(Vector.UP, RAMATTRA_ABILITY1_UPWARD_IMPULSE, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    victim.setEnvironmentalKillCreditor(attacker)
    wait(0.5)

rule "[Ramattra]: Pummel healing":
    @Event eachPlayer
    @Team 1
    @Hero ramattra
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) <= 325

    eventPlayer.ram_pummel_damage_dealt = eventPlayer.getHeroStatistic(Hero.RAMATTRA, HeroStat.DAMAGE_DEALT)
    wait(1)
    if ruleCondition:
        eventPlayer.ram_block_damage += (eventPlayer.getHeroStatistic(Hero.RAMATTRA, HeroStat.DAMAGE_DEALT) - eventPlayer.ram_pummel_damage_dealt) * 2.5
        eventPlayer.ram_pummel_damage_dealt = eventPlayer.getHeroStatistic(Hero.RAMATTRA, HeroStat.DAMAGE_DEALT)
        loop()

rule "[Ramattra]: Pummel healing":
    @Event eachPlayer
    @Team 2
    @Hero ramattra
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) <= 325

    eventPlayer.ram_pummel_damage_dealt = eventPlayer.getHeroStatistic(Hero.RAMATTRA, HeroStat.DAMAGE_DEALT)
    wait(1)
    if ruleCondition:
        eventPlayer.ram_block_damage += (eventPlayer.getHeroStatistic(Hero.RAMATTRA, HeroStat.DAMAGE_DEALT) - eventPlayer.ram_pummel_damage_dealt) * 1.5
        eventPlayer.ram_pummel_damage_dealt = eventPlayer.getHeroStatistic(Hero.RAMATTRA, HeroStat.DAMAGE_DEALT)
        eventPlayer.hudText = "{0}/{1}".format(floor(eventPlayer.ram_block_damage), Ram_Annihilation[0])
        loop()
