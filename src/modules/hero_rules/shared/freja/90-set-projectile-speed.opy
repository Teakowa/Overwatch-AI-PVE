rule "[Freja]: set Projectile speed":
    @Event eachPlayer
    @Hero freja
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setProjectileSpeed(100)
    waitUntil(not eventPlayer.isUsingUltimate(), 99999)
    eventPlayer.setProjectileSpeed(500)
