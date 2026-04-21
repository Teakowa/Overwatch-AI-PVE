rule "[Doomfist] Seismic Slam upper":

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

    wait(0.16)

rule "[Doomfist] Seismic Slam upper":

    @Event eachPlayer

    @Hero doomfist

    @Condition eventPlayer.heart_steel[1] != 0

    wait(3)

    removeHealthPool(eventPlayer.heart_steel[0])

    eventPlayer.heart_steel[1] = 0

    eventPlayer.heart_steel[0] = 0

    wait(0.16)

    if ruleCondition:

        loop()

rule "[Doomfist] Seismic Slam upper":

    @Event playerDealtDamage

    @Hero doomfist

    @Condition eventAbility == Button.ABILITY_1

    @Condition victim.unaffected != true

    @Condition (victim.getHero() == Hero.ORISA and (victim.isUsingAbility1() or victim.isUsingUltimate())) == false

    @Condition (victim.getHero() == Hero.MAUGA and victim.isUsingAbility1()) == false

    eventPlayer.doom_buff += 50

    eventPlayer.hudText = "{0}".format(floor(eventPlayer.doom_buff))

    victim.applyImpulse(Vector.UP, 6, Relativity.TO_PLAYER)

    victim.applyImpulse(worldVector(Vector.BACKWARD, attacker, Transform.ROTATION), 3.5, Relativity.TO_WORLD)

    victim.startForcingThrottle(0, 0, 0, 0, 0, 0)

    waitUntil(victim.isOnGround(), 1.2)

    victim.stopForcingThrottle()

rule "[Doomfist] Seismic Slam upper":

    @Event playerDealtKnockback

    @Hero doomfist

    @Condition eventAbility == Button.MELEE

    eventPlayer.doom_buff += 50

    eventPlayer.hudText = "{0}".format(floor(eventPlayer.doom_buff))

rule "[Doomfist]: Meteor Strike":

    @Event playerDealtDamage

    @Hero doomfist

    @Condition eventAbility == Button.ULTIMATE

    @Condition victim.unaffected != true

    eventPlayer.doom_buff += 250

rule "[Doomfist]: Power Block":

    @Event playerTookDamage

    @Hero doomfist

    @Condition eventPlayer.isUsingAbility2() == true

    @Condition eventPlayer.doom_buff <= DoomBuff[1]

    eventPlayer.doom_buff += DoomBuff[1] - eventPlayer.doom_buff if eventPlayer.doom_buff + eventDamage * DoomBuff[0] > DoomBuff[1] else eventDamage * DoomBuff[0]

    eventPlayer.hudText = "{0}".format(floor(eventPlayer.doom_buff))

    wait()

rule "[Doomfist]: Power Block Damage":

    @Event playerDealtDamage

    @Hero doomfist

    @Condition eventAbility == Button.SECONDARY_FIRE

    @Condition eventPlayer.doom_buff != 0

    damage(victim, attacker, eventPlayer.doom_buff)

    eventPlayer.doom_buff = 0

rule "[Doomfist]: block HUD":

    @Event eachPlayer

    @Hero doomfist

    @Condition eventPlayer.doom_buff != 0

    @Condition eventPlayer.isInSpawnRoom() != true

    @Condition eventPlayer.reset_pvar[0] == false

    #hudText(eventPlayer, null, "\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r", "{0}".format(floor(eventPlayer.doom_buff)), HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)

    #eventPlayer.doom_buff_hud = getLastCreatedText()

    waitUntil(eventPlayer.doom_buff == 0 or eventPlayer.reset_pvar[0] or eventPlayer.isInSpawnRoom(), 999999986991104)

    eventPlayer.hudText = ""

    #destroyHudText(eventPlayer.doom_buff_hud)
