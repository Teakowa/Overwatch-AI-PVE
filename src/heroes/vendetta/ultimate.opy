#!optimizeStrict

rule "[Vendetta]: Sundering Blade":
    @Event playerReceivedKnockback
    @Condition attacker.getHero() == Hero.VENDETTA
    @Condition eventAbility == Button.ULTIMATE
    #@Condition eventAbility != Button.PRIMARY_FIRE
    #@Condition eventAbility != Button.ABILITY_1

    eventPlayer.setStatusEffect(attacker, Status.KNOCKED_DOWN, VendettaBuff[4])
    #waitUntil(victim.hasStatus(Status.KNOCKED_DOWN), 0.5)
    waitUntil(victim.getHealth() <= victim.getMaxHealth() * VendettaBuff[5], VendettaBuff[4])
    if victim.getHealth() <= victim.getMaxHealth() * VendettaBuff[5]:
        damage(victim, attacker, 44444)
    wait(1)
