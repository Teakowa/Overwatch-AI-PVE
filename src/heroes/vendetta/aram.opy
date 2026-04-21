rule "[Vendetta]: Palatine Fang":
    @Event playerDealtKnockback
    @Hero vendetta
    @Condition eventAbility == Button.PRIMARY_FIRE
    #@Condition victim.getHealthOfType(Health.ARMOR) > 0

    if eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0:
        goto lbl_0
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, eventPlayer.getAbilityCooldown(Button.ABILITY_1) - 1)
    lbl_0:
    if eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0:
        goto lbl_1
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.getAbilityCooldown(Button.ABILITY_2) - 1)
    lbl_1:
    damage(victim, attacker, victim.getMaxHealth() * VendettaBuff[0] if victim.getHealthOfType(Health.ARMOR) == 0 else victim.getMaxHealth() * VendettaBuff[1])
    wait()
    eventPlayer.startHealingOverTime(eventPlayer, eventPlayer.getMaxHealth() * VendettaBuff[6] / 1.5, 1.5)
    wait(0.032)

rule "[Vendetta]: Whirlwind Dash":
    @Event playerReceivedKnockback
    @Condition attacker.getHero() == Hero.VENDETTA
    @Condition eventAbility == Button.ABILITY_1

    damage(eventPlayer, attacker, VendettaBuff[3])
    heal(eventPlayer, eventPlayer, (eventPlayer.getMaxHealth() - eventPlayer.getHealth()) * VendettaBuff[2])
    wait(1)

rule "[Vendetta]: Soaring Slice":
    @Event eachPlayer
    @Hero vendetta
    @Condition eventPlayer.isUsingAbility2() == true

    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 2.5)
    eventPlayer.unaffected = true
    waitUntil(not eventPlayer.isUsingAbility2(), 2.5)
    wait(0.8)
    eventPlayer.unaffected = false
    eventPlayer.clearStatusEffect(Status.PHASED_OUT)

rule "[Vendetta]: Soaring Slice hack":
    @Event playerDealtKnockback
    @Hero vendetta
    @Condition eventAbility == Button.ABILITY_2
    #@Condition eventPlayer.mov_speed_buff == true

    victim.vendetta_hud = true
    stopChasingVariable(victim.hack_timer)
    victim.setStatusEffect(attacker, Status.HACKED, 1)
    victim.hack_timer = 1
    chaseAtRate(victim.hack_timer, 0, 1, ChaseRateReeval.NONE)
    wait(2)
    victim.vendetta_hud = false

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
# vendetta aram-only palatine fang

rule "[Vendetta] Palatine Fang":
    @Event playerDealtDamage
    @Hero vendetta
    @Condition eventAbility != null

    heal(eventPlayer, eventPlayer, eventDamage * 0.4)
    wait()
