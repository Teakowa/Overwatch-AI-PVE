rule "[Juno]: Hyper Ring Max. range":
    @Event eachPlayer
    @Hero juno
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.setProjectileSpeed(117.7)
    waitUntil(not eventPlayer.isUsingAbility2(), 5)
    eventPlayer.setProjectileSpeed(100)
#!include "20-track-orbital-ray-position.opy"
rule "[Juno]: Orbial Ray Damage":
    @Event eachPlayer
    @Condition eventPlayer.juno_buff[0] == true
    
    smallMessage(eventPlayer, "   {0} 轨道射线： 伤害减免 {1}%".format(abilityIconString(Hero.JUNO, Button.ULTIMATE), 100 - JunoBuff))
    eventPlayer.setDamageReceived(100 - JunoBuff)
    waitUntil(not eventPlayer.juno_buff[0], 10)
    eventPlayer.setDamageReceived(100)
    smallMessage(eventPlayer, "   {0} 轨道射线： 伤害减免已结束".format(abilityIconString(Hero.JUNO, Button.ULTIMATE)))
rule "[Juno]: Pulsar Torpedoes Healing":
    @Event playerReceivedHealing
    @Condition healer.getHero() == Hero.JUNO
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition eventPlayer.mauga_berserker_soul != true
    
    eventPlayer.healing_increase += 50
    eventPlayer.setHealingReceived(100 - eventPlayer.healing_decrease + eventPlayer.healing_increase)
    waitUntil(eventPlayer.isDead(), 4)
    eventPlayer.setHealingReceived(100)
    eventPlayer.healing_increase = 0
    wait(2.6)
