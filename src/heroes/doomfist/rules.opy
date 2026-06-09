#!mainFile "../../main.opy"
#!optimizeStrict

playervar doom_buff
playervar doom_buff_hud



rule "[Doomfist]: block HUD":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.doom_buff != 0
    @Condition eventPlayer.isInSpawnRoom() != true
    @Condition eventPlayer.reset_pvar[0] == false
    @Condition eventPlayer.doom_buff > 0

    #hudText(eventPlayer, null, "\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r", "{0}".format(floor(eventPlayer.doom_buff)), HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    #eventPlayer.doom_buff_hud = getLastCreatedText()
    waitUntil(eventPlayer.doom_buff == 0 or eventPlayer.reset_pvar[0] or eventPlayer.isInSpawnRoom(), Math.INFINITY)
    eventPlayer.hudText = ""
    #destroyHudText(eventPlayer.doom_buff_hud)

rule "[Doomfist] The Best Defense get armor":
    @Event playerDealtDamage
    @Condition attacker.getHero() == Hero.DOOMFIST
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
