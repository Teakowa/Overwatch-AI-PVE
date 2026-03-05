def removeTankPassive():
    @Name "[passives/tank/knockback.opy]: removeTankPassive()"

    if RESET_REMOVE_TANK_PASSIVE_ENABLED():
        eventPlayer.setKnockbackReceived(166.667)
