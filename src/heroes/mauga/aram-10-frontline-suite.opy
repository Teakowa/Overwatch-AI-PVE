rule "[Mauga]: Fortify provides 100 temporary armor":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.unaffected = true
    eventPlayer.hazard_buff[0] = false
    eventPlayer.brigitte_buff[0] = false
    eventPlayer.orisa_buff = false
    eventPlayer.zarya_graviton_buff[0] = false
    waitUntil(not eventPlayer.isUsingAbility1(), 3)
    eventPlayer.unaffected = false

rule "[Mauga] Overrun knockdown duration":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.setStatusEffect(eventPlayer, Status.INVINCIBLE, 5)
    waitUntil(not eventPlayer.isUsingAbility1(), 5)
    eventPlayer.clearStatusEffect(Status.INVINCIBLE)

rule "[Mauga] Overrun knockdown duration":
    @Event playerDealtDamage
    @Hero mauga
    @Condition eventAbility == Button.ABILITY_1
    
    victim.setStatusEffect(attacker, Status.BURNING, 2)
    if victim.hasStatus(Status.KNOCKED_DOWN):
        goto lbl_0
    victim.setStatusEffect(attacker, Status.KNOCKED_DOWN, 0.5)
    lbl_0:
    if victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT) or victim.has_nano:
        goto lbl_1
    damage(victim, attacker, ceil(victim.getMaxHealth() * MaugaBuff[3]))
    lbl_1:

rule "[Mauga]: Berserker Soul status active":
    @Event playerTookDamage
    @Hero mauga
    #@Condition eventDamage > eventPlayer.getHealth() + 25
    @Condition eventPlayer.mauga_berserker_soul != true
    @Condition eventPlayer.getHealth() <= 250
    
    eventPlayer.mauga_berserker_soul = true
    bigMessage(eventPlayer, "狂战士之魂！")
    waitUntil(eventPlayer.isDead(), 99999)
    eventPlayer.mauga_berserker_soul = false
