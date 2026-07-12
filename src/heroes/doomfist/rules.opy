#!mainFile "../../main.opy"
#!optimizeStrict

playervar doom_buff
playervar doom_buff_hud



rule "[Doomfist]: block HUD":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.doom_buff != 0
    @Condition eventPlayer.isInSpawnRoom() != true
    @Condition eventPlayer._reset_requested == false
    @Condition eventPlayer.doom_buff > 0

    waitUntil(eventPlayer.doom_buff == 0 or eventPlayer._reset_requested or eventPlayer.isInSpawnRoom(), Math.INFINITY)
    eventPlayer.hudText = ""

rule "[Doomfist] The Best Defense get armor":
    @Event playerDealtDamage
    @Condition isHero(attacker, Hero.DOOMFIST)
    @Condition eventAbility in [Button.SECONDARY_FIRE, Button.ABILITY_1, Button.ULTIMATE] == true

    attacker.heart_steel[1] += 50
    if attacker.heart_steel[0] == null:
        goto lbl_0
    removeHealthPool(attacker.heart_steel[0])
    lbl_0:
    attacker.addHealthPool(Health.ARMOR, attacker.heart_steel[1], false, false)
    attacker.heart_steel[0] = getLastCreatedHealthPool()
    wait(1)

rule "[Doomfist] remove The Best Defense armor":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.heart_steel[1] != 0
    @Condition eventPlayer.heart_steel[0] != 0

    wait(3, Wait.ABORT_WHEN_FALSE)
    removeHealthPool(eventPlayer.heart_steel[0])
    eventPlayer.heart_steel[1] = 0
    eventPlayer.heart_steel[0] = 0
    wait(WAIT_SHORT_FRAME)
    if ruleCondition:
        loop()

#!include "ability1.opy"
#!include "secondary.opy"
#!include "ability2.opy"
#!include "ultimate.opy"


