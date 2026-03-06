rule "[Doomfist] Seismic Slam upper":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.ABILITY_1
    @Condition eventAbility == Button.ABILITY_1
    @Condition victim.unaffected != true
    @Condition (victim.getHero() == Hero.ORISA and (victim.isUsingAbility1() or victim.isUsingUltimate())) == false
    @Condition (victim.getHero() == Hero.MAUGA and victim.isUsingAbility1()) == false
    
    eventPlayer.doom_buff += 25
    eventPlayer.hudText = "{0}".format(floor(eventPlayer.doom_buff))
    victim.applyImpulse(Vector.UP, 6, Relativity.TO_PLAYER)
    victim.applyImpulse(worldVector(Vector.BACKWARD, attacker, Transform.ROTATION), 3.5, Relativity.TO_WORLD)
    victim.startForcingThrottle(0, 0, 0, 0, 0, 0)
    waitUntil(victim.isOnGround() or victim.hasStatus(Status.PHASED_OUT), 1.2)
    victim.stopForcingThrottle()
rule "[Doomfist]: Power Block":
    @Event playerTookDamage
    @Team 1
    @Hero doomfist
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.doom_buff <= DoomBuff[1]
    
    eventPlayer.doom_buff += DoomBuff[1] - eventPlayer.doom_buff if eventPlayer.doom_buff + eventDamage * 5 > DoomBuff[1] else eventDamage * DoomBuff[0]
    wait()
rule "[Doomfist]: Power Block":
    @Event playerTookDamage
    @Team 2
    @Hero doomfist
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.doom_buff <= DoomBuff[1]
    
    eventPlayer.doom_buff += DoomBuff[1] - eventPlayer.doom_buff if eventPlayer.doom_buff + eventDamage * DoomBuff[0] > DoomBuff[1] else eventDamage * DoomBuff[0]
    eventPlayer.hudText = "{0}".format(floor(eventPlayer.doom_buff))
    wait()
#!include "shared/40-power-block-damage.opy"
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
    @Event playerTookDamage
    @Condition attacker.getHero() == Hero.DOOMFIST
    @Condition eventAbility in [Button.SECONDARY_FIRE, Button.ABILITY_1, Button.ULTIMATE] == true
    
    attacker.heart_steel[1] += 50
    if attacker.heart_steel[0] == null:
        goto lbl_0
    removeHealthPool(attacker.heart_steel[0])
    lbl_0:
    attacker.addHealthPool(Health.ARMOR, attacker.heart_steel[1], false, false)
    attacker.heart_steel[0] = getLastCreatedHealthPool()
    wait(WAIT_SHORT_FRAME)
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
rule "[Doomfist]: Meteor Strike":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setDamageDealt(175 if eventPlayer.getTeam() == Team.1 else 150)
    waitUntil(not eventPlayer.isUsingUltimate(), 10)
    eventPlayer.setDamageDealt(100)
