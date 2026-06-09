#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Ana]: Damage Full Health Allies So Nano Can Heal":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.getUltCharge() == 100

    waitUntil(eventPlayer.getUltCharge() == 0, 99999)
    eventPlayer.nano_full_health = [i for i in eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam()) if i.getHealth() >= i.getMaxHealth()]
    damage(eventPlayer.nano_full_health, null, 0.05)
    wait(0.216)
    heal(eventPlayer.nano_full_health, null, ANA_ULTIMATE_FULL_HEALTH_HEAL)
    eventPlayer.nano_full_health = null

rule "Has Nano":
    @Event playerReceivedHealing

    #This checks that the ability used to deal the healing is the ultimate.
    @Condition eventAbility == Button.ULTIMATE
    #This checks if the player who dealt the healing is Ana or an Echo duplicating an Ana.
    @Condition isHero(healer, Hero.ANA)
    eventPlayer.has_nano = true
    waitUntil(eventPlayer.isDead(), 8)
    eventPlayer.has_nano = false

rule "[Ana] Nano Boost Healing":
    @Event playerDealtHealing
    @Hero ana
    @Condition eventAbility == Button.ULTIMATE
    @Condition isHero(healer, Hero.ANA)

    heal(healee, healer, ANA_ULTIMATE_NANO_HEAL)
