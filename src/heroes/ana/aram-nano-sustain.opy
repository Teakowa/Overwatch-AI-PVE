rule "[Ana]: Damage Full Health Allies So Nano Can Heal":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.getUltCharge() == 100

    waitUntil(eventPlayer.getUltCharge() == 0, 99999)
    eventPlayer.nano_full_health = [i for i in eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam()) if i.getHealth() >= i.getMaxHealth()]
    damage(eventPlayer.nano_full_health, null, 0.05)
    wait(0.216)
    heal(eventPlayer.nano_full_health, null, 0.05)
    eventPlayer.nano_full_health = null

rule "Has Nano":
    @Event playerReceivedHealing
    @Condition eventAbility == Button.ULTIMATE
    @Condition healer.getHero() == Hero.ANA
    @Condition eventPlayer.has_nano != true

    eventPlayer.has_nano = true
    waitUntil(eventPlayer.isDead(), 8)
    eventPlayer.has_nano = false

rule "[Ana] Nano Boost Healing":
    @Event playerDealtHealing
    @Hero ana
    @Condition eventAbility == Button.ULTIMATE
    @Condition healer.getHero() == Hero.ANA == true
    @Condition eventPlayer.has_nano == true

    heal(healee, healer, 99999)
    healee.startHealingOverTime(healer, 10, ceil(healee.getMaxHealth() * 0.2))
