rule "[Vendetta]: Whirlwind Dash":
    @Event playerReceivedKnockback
    @Condition attacker.getHero() == Hero.VENDETTA
    @Condition eventAbility == Button.ABILITY_1

    damage(eventPlayer, attacker, VendettaBuff[3])
    heal(eventPlayer, eventPlayer, (eventPlayer.getMaxHealth() - eventPlayer.getHealth()) * VendettaBuff[2])
    wait(1)
