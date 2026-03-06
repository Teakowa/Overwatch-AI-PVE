rule "[Kiriko]: Protection Suzu Clear Effect":
    @Event playerDealtHealing
    @Hero kiriko
    @Condition eventAbility == Button.ABILITY_2
    @Condition healee.mauga_berserker_soul != true
    
    if healee != healer:
        goto lbl_0
    resetStatuses()
    lbl_0:
    healee.unaffected = true
    healee.setStatusEffect(healer, Status.INVINCIBLE, 2.5)
    healee.setStatusEffect(healer, Status.PHASED_OUT, 2.5)
    wait(2.5)
    healee.unaffected = false

rule "[Kiriko]: Swift Step":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0
    
    resetStatuses()
    eventPlayer.setStatusEffect(eventPlayer, Status.INVINCIBLE, 2.5)
    eventPlayer.setStatusEffect(eventPlayer, Status.PHASED_OUT, 2.5)

rule "[kiriko]: swift step hp":
    @Event eachPlayer
    @Condition getPlayersOnHero(Hero.KIRIKO, eventPlayer.getTeam())[0].isHoldingButton(Button.ABILITY_1) == true
    @Condition getPlayersOnHero(Hero.KIRIKO, eventPlayer.getTeam())[0].isUsingAbility1() == true
    @Condition len(eventPlayer.kiriko_buff) < 5
    
    waitUntil(not eventPlayer.reset_pvar[3].isUsingAbility1() and len(getPlayersInRadius(eventPlayer.reset_pvar[3], 5, eventPlayer.getTeam(), LosCheck.SURFACES)) > 0 and eventPlayer.reset_pvar[3].hasStatus(Status.PHASED_OUT) == true, 0.5)
    wait(0.16)
    lbl_0:
    if not eventPlayer.isAlive() or distance(eventPlayer.reset_pvar[3], eventPlayer) > 5 and not isInLoS(eventPlayer.reset_pvar[3], eventPlayer):
        goto lbl_1
    eventPlayer.addHealthPool(Health.NORMAL, 100 + ceil(eventPlayer.getMaxHealth() * 0.15), false, false)
    lbl_1:
    eventPlayer.kiriko_buff.append(getLastCreatedHealthPool())
