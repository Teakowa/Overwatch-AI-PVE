#!mainFile "../../main.opy"

#!optimizeStrict

subroutine resetBetweenRounds

#!define TEAM1_RESPAWN_TIME_MODE TEAM1_RESPAWN_TIME_DEFAULT
#!define TEAM2_RESPAWN_TIME_MODE TEAM2_RESPAWN_TIME_DEFAULT

rule "[utilities/reset]: setup var when player joins lobby":
    @Event eachPlayer

    resetFrenemies()

rule "[utilities/reset]: Default respawn time":
    @Event eachPlayer
    @Team 1

    eventPlayer.setRespawnTime(TEAM1_RESPAWN_TIME_DEFAULT)

rule "[utilities/reset]: Default respawn time":
    @Event eachPlayer
    @Team 2

    eventPlayer.setRespawnTime(TEAM2_RESPAWN_TIME_DEFAULT)

rule "[utilities/reset]: reset when died":
    @Event playerDied

    wait(0.25)
    resetCombatState()
    resetStats()
    resetStatuses()
    resetFrenemies()

rule "[reset.opy]: Reinitialize hero on new round":
    @Event eachPlayer
    @Condition isMatchBetweenRounds() == true
    @Condition not isHero(eventPlayer, Hero.SOMBRA)

    # Spread engine-facing cleanup across frames instead of running it for
    # every player in the same transition tick (one server frame per slot).
    wait(eventPlayer.getSlot() * 0.016)
    eventPlayer._round_reinit_pending = true
    resetBetweenRounds()
    waitUntil(not isMatchBetweenRounds(), Math.INFINITY)
    wait(eventPlayer.getSlot() * 10 + 0.25)
    if eventPlayer._round_reinit_pending == true:
        eventPlayer.init_hero = eventPlayer.getCurrentHero()
        eventPlayer.call_init = true
        eventPlayer._reset_requested = true
        logToInspector("queued init after new round (main throttled)")

def resetBetweenRounds():
    @Name "[utilities/reset.opy]: resetBetweenRounds()"

    # Narrow between-round cleanup: only state that must not survive the round
    # boundary. Hero-local counters that resetHero() re-derives are deferred to
    # the (staggered) re-init so the full hero-reset path runs once per round.
    eventPlayer.stopAllDamageOverTime()
    eventPlayer.stopForcingThrottle()
    clearMoveSpeedDebuffs()
    eventPlayer.freja_buff[0] = 0
    eventPlayer.freja_buff[1] = 0
    eventPlayer.has_nano = false
    eventPlayer.zarya_buff[0] = true
    eventPlayer.zarya_buff[1] = null
    eventPlayer.doom_buff = 0
    eventPlayer.clearStatusEffect(Status.ASLEEP)
    eventPlayer.clearStatusEffect(Status.BURNING)
    eventPlayer.clearStatusEffect(Status.FROZEN)
    eventPlayer.clearStatusEffect(Status.HACKED)
    eventPlayer.clearStatusEffect(Status.INVINCIBLE)
    eventPlayer.clearStatusEffect(Status.KNOCKED_DOWN)
    eventPlayer.clearStatusEffect(Status.PHASED_OUT)
    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.clearStatusEffect(Status.STUNNED)
    eventPlayer.clearStatusEffect(Status.UNKILLABLE)

def applySignedMoveSpeed():
    @Name "[utilities/move_speed.opy]: applySignedMoveSpeed()"

    eventPlayer.setMoveSpeed(min(max(100 + eventPlayer.mov_speed_buff, 20), 200))

def clearMoveSpeedDebuffs():
    @Name "[utilities/move_speed.opy]: clearMoveSpeedDebuffs()"

    eventPlayer.brigitte_buff[0] = false
    eventPlayer.orisa_buff = false
    eventPlayer.resetWuyangState()
    eventPlayer.mov_speed_penalty = 0
    eventPlayer.mov_speed_buff = 0
    applySignedMoveSpeed()
