rule "[Hazard]: stun Downpour":
    @Event playerTookDamage
    @Condition HazardBuff[10] == true
    @Condition eventAbility == Button.ULTIMATE
    @Condition attacker.getHero() == Hero.HAZARD
    @Condition attacker.getUltCharge() < HazardBuff[11] * 6
    @Disabled

    if attacker.getUltCharge() > HazardBuff[11] * 6:
        goto lbl_0
    attacker.setUltCharge(attacker.getUltCharge() + HazardBuff[11])
    lbl_0:
