rule "【布丽吉塔】恢复包选中目标":
    @Event eachPlayer
    @Hero brigitte
    @Condition Brigitte[1] != 0
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition distance(eventPlayer, eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam())) <= 27.25

    sorted(getLivingPlayers(eventPlayer.getTeam()), lambda player: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getPosition(), player.getPosition())))[0].brig_repair_pack = true
