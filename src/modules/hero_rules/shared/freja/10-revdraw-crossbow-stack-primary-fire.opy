rule "[Freja]: Revdraw Crossbow Stack":
    @Event playerDealtDamage
    @Hero freja
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition eventPlayer.hasStatus(Status.INVINCIBLE) != true
    
    victim.freja_buff[0]++
