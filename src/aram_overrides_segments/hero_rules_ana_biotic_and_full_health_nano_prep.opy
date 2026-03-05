rule "[Ana] Biotic Grenade Hit":
    @Event playerTookDamage
    @Condition eventAbility == Button.ABILITY_2
    @Condition attacker.getHero() == Hero.ANA == true
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false
    @Condition victim.has_nano != true
    
    if victim.zarya_buff[1] != null:
        goto lbl_0
    eventPlayer.setStatusEffect(attacker, Status.BURNING, 3)
    eventPlayer.startDamageOverTime(attacker, 3, ceil(Ana_GrenadeDamage[0] / 100 * victim.getMaxHealth()))
    wait(3)
    lbl_0:

rule "[Ana]: Damage Full Health Allies So Nano Can Heal":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.getUltCharge() == 100
    
    waitUntil(eventPlayer.getUltCharge() == 0, 99999)
    eventPlayer.nano_full_health = [i for i in eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam()) if i.getHealth() >= i.getMaxHealth()]
    damage(eventPlayer.nano_full_health, null, 0.05)
    wait(0.216)
    heal(eventPlayer.nano_full_health, null, 0.05)
    eventPlayer.nano_full_health = null

