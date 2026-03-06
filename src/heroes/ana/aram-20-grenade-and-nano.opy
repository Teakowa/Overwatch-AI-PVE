rule "[Ana] Biotic Grenade Hit for allies":
    @Event playerDealtHealing
    @Hero ana
    @Condition eventAbility == Button.ABILITY_2
    
    healee.startHealingOverTime(healer, 3, healee.getMaxHealth() * Ana_GrenadeDamage[1])

rule "[Ana] Nano Boost ":
    @Event eachPlayer
    @Condition eventPlayer.has_nano == true
    
    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 50)
    eventPlayer.dmg_reduction += 50
    smallMessage(eventPlayer, "  {0} 获得纳米激素额外减伤".format(abilityIconString(Hero.ANA, Button.ULTIMATE)))
    wait(10)
    eventPlayer.has_nano = false

rule "[Ana] Nano Boost ":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.has_nano == true
    @Condition eventPlayer.dmg_reduction > 0
    
    eventPlayer.setDamageReceived(100 - eventPlayer.dmg_reduction)
    eventPlayer.hudText = "受到伤害减免：{0}%".format(eventPlayer.dmg_reduction)
    wait(1)
    eventPlayer.dmg_reduction -= 5
    if ruleCondition:
        loop()
    eventPlayer.dmg_reduction = 0
    eventPlayer.has_nano = false
    eventPlayer.hudText = ""
