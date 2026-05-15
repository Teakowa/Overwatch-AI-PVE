#!optimizeStrict

rule "[Reinhardt]: Earthshatter":
    @Event playerDealtFinalBlow
    @Hero reinhardt
    @Condition eventAbility == Button.ABILITY_1

    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    wait(1)

rule "[Reinhardt]: Earthshatter":
    @Event playerDealtFinalBlow
    @Hero reinhardt
    @Condition eventAbility == Button.ULTIMATE

    eventPlayer.setUltCharge(100)
    wait(0.5)

rule "[Reinhardt]: Crusaders stand":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.reinhardt_buff == false
    @Condition eventPlayer.getHealthOfType(Health.ARMOR) <= 0

    eventPlayer.reinhardt_buff = true
    wait(15)
    eventPlayer.reinhardt_buff = false
    smallMessage(eventPlayer, "  {0} 十字军坚定 已就绪".format(abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE)))

rule "[Reinhardt]: Crusaders stand":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.reinhardt_buff == true

    bigMessage(eventPlayer, "  十字军坚定")
    smallMessage(eventPlayer, "  {0} 无视击退".format(iconString(Icon.FLAG)))
    eventPlayer.addHealthPool(Health.NORMAL, 300, false, false)
    eventPlayer.setKnockbackReceived(0)
    waitUntil(not eventPlayer.reinhardt_buff, 8)
    eventPlayer.setKnockbackReceived(100)

rule "[Rein]: fly":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true

    eventPlayer.applyImpulse(eventPlayer.getFacingDirection(), 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait()
    if ruleCondition:
        loop()

#!include "secondary.opy"

#!include "ability2.opy"
#!include "ultimate.opy"
