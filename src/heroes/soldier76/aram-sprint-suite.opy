rule "[Soldier: 76]: 燃烧":
    @Event eachPlayer
    @Team 2
    @Hero soldier
    @Condition eventPlayer.isUsingUltimate() != true
    @Condition S76Buff[3] != 0
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getSpeed() != 0
    @Condition (len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and distance(eventPlayer, player) <= S76Buff[4] and not player.hasStatus(Status.INVINCIBLE) and player.getPosition().y - eventPlayer.getPosition().y <= 2])) > 0

    wait(0.016, Wait.ABORT_WHEN_FALSE)
    ([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and distance(eventPlayer, player) <= S76Buff[4] and not player.hasStatus(Status.INVINCIBLE) and player.getPosition().y - eventPlayer.getPosition().y <= 2]).setStatusEffect(eventPlayer, Status.BURNING, 2)
    ([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and distance(eventPlayer, player) <= S76Buff[4] and not player.hasStatus(Status.INVINCIBLE) and player.getPosition().y - eventPlayer.getPosition().y <= 2]).startDamageOverTime(eventPlayer, 2, eventPlayer.getMaxHealth() * S76Buff[3])
    wait(1.9)
    if ruleCondition:
        loop()

rule "[Soldier: 76]: 燃烧":
    @Event eachPlayer
    @Team 1
    @Hero soldier
    @Condition eventPlayer.isUsingUltimate() != true
    @Condition S76Buff[3] != 0
    @Condition eventPlayer.isAlive() == true
    @Condition (len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and distance(eventPlayer, player) <= S76Buff[4] and not player.hasStatus(Status.INVINCIBLE) and player.getPosition().y - eventPlayer.getPosition().y <= 2])) > 0

    wait(0.016, Wait.ABORT_WHEN_FALSE)
    ([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and distance(eventPlayer, player) <= S76Buff[4] and not player.hasStatus(Status.INVINCIBLE) and player.getPosition().y - eventPlayer.getPosition().y <= 2]).setStatusEffect(eventPlayer, Status.BURNING, 2)
    ([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and distance(eventPlayer, player) <= S76Buff[4] and not player.hasStatus(Status.INVINCIBLE) and player.getPosition().y - eventPlayer.getPosition().y <= 2]).startDamageOverTime(eventPlayer, 2, eventPlayer.getMaxHealth() * S76Buff[3])
    wait(1.9)
    if ruleCondition:
        loop()

rule "[Soldier: 76]: 治疗":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isAlive() == true

    wait(0.16, Wait.ABORT_WHEN_FALSE)
    eventPlayer.startHealingOverTime(eventPlayer, 5, eventPlayer.getMaxHealth() * 0.1)
