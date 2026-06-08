#!optimizeStrict

#!mainFile "../../main.opy"

playervar reinhardt_buff
playervar reinhardt_charge_cd

rule "[Reinhardt]: Crusaders stand":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.reinhardt_buff[0] == false
    @Condition eventPlayer.getHealthOfType(Health.ARMOR) <= 0

    eventPlayer.reinhardt_buff[0] = true

rule "[Reinhardt]: Crusaders stand":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.reinhardt_buff[0] == true

    bigMessage(eventPlayer, "  十字军坚定")
    smallMessage(eventPlayer, "  {0} 无视击退".format(abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE)))
    eventPlayer.addHealthPool(Health.NORMAL, REINHARDT_RULES_NORMAL_HEALTH_POOL_AMOUNT, false, false)
    eventPlayer.setKnockbackReceived(0)
    waitUntil(not eventPlayer.reinhardt_buff[0], 8)
    eventPlayer.setKnockbackReceived(100)
    wait(30)
    eventPlayer.reinhardt_buff[0] = false
    smallMessage(eventPlayer, "  {0} 十字军坚定 已就绪".format(abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE)))

#!include "secondary.opy"
#!include "ability1.opy"
#!include "ability2.opy"
#!include "ultimate.opy"
