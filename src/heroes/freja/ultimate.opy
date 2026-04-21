rule "[Freja]: Revdraw Crossbow Stack":
    @Event playerDealtKnockback
    @Hero freja
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventPlayer.hasStatus(Status.INVINCIBLE) != true

    victim.freja_buff[0] += 15
    wait(5)

rule "[Freja]: set Projectile speed":
    @Event eachPlayer
    @Hero freja
    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.setProjectileSpeed(100)
    waitUntil(not eventPlayer.isUsingUltimate(), 99999)
    eventPlayer.setProjectileSpeed(500)
