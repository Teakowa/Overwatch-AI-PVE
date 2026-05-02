#!optimizeStrict

rule "[Reaper]: Wraith Form to fly":
    @Event eachPlayer
    @Hero reaper
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate()) == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true

    eventPlayer.applyImpulse(Vector.UP, 5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(0.2)
    if ruleCondition:
            loop()

rule "[Reaper]: Wraith Form to fly":
    @Event eachPlayer
    @Hero reaper
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate()) == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true

    eventPlayer.applyImpulse(Vector.DOWN, 5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(0.2)
    if ruleCondition:
            loop()

rule "[Reaper]: Ability 1 Wraith Form cd":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingAbility1() == true
    @Disabled

    waitUntil(not eventPlayer.isUsingAbility1(), 3.016)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, eventPlayer.getAbilityCooldown(Button.ABILITY_1) - (50 * ReaperBuff[1] if eventPlayer.reaper_buff[0] > 50 else eventPlayer.reaper_buff[0] * ReaperBuff[1]))
    eventPlayer.dmg_amplification += 150 if ReaperBuff[2] + eventPlayer.reaper_buff[0] * ReaperBuff[3] >= 150 else ReaperBuff[2] + eventPlayer.reaper_buff[0] * ReaperBuff[3]
    wait(3)
    #chaseOverTime(eventPlayer.dmg_amplification, 0, 3, ChaseTimeReeval.NONE)
    eventPlayer.dmg_amplification = 0
    @Disabled

rule "[Reaper]: Ability 2 Shadow Step cd":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingAbility2() == true
    @Disabled

    waitUntil(not eventPlayer.isUsingAbility2(), 3.016)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.getAbilityCooldown(Button.ABILITY_2) - (50 * ReaperBuff[1] if eventPlayer.reaper_buff[0] > 50 else eventPlayer.reaper_buff[0] * ReaperBuff[1]))
    eventPlayer.dmg_reduction += 60 if ReaperBuff[4] + eventPlayer.reaper_buff[0] * ReaperBuff[5] >= 60 else ReaperBuff[4] + eventPlayer.reaper_buff[0] * ReaperBuff[5]

rule "[Reaper]: Ability 1 Wraith Form dmg increase setup":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.dmg_amplification != 0
    @Disabled

    eventPlayer.setDamageDealt(100 + eventPlayer.dmg_amplification)
    wait(0.5)
    eventPlayer.dmg_amplification -= eventPlayer.dmg_amplification * 0.3
    if ruleCondition:
        loop()
    eventPlayer.setDamageDealt(100)

rule "[Reaper]: Ability 1 Wraith Form dmg increase set & hud":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.dmg_amplification != 0
    @Disabled

    destroyHudText(eventPlayer.reaper_buff[1])
    hudText(eventPlayer, null, " \r\n", "伤害增幅：{0}%".format(ceil(eventPlayer.dmg_amplification)), HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.reaper_buff[1] = getLastCreatedText()
    waitUntil(eventPlayer.dmg_amplification == 0 and eventPlayer.isDead(), 3.5)
    destroyHudText(eventPlayer.reaper_buff[1])
    eventPlayer.reaper_buff[1] = 0

rule "[Reaper]: Ability 2 Shadow Step dmg reduction setup":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingAbility2() != true
    @Condition eventPlayer.dmg_reduction != 0
    @Disabled

    destroyHudText(eventPlayer.reaper_buff[1])
    hudText(eventPlayer, null, " \r\n", "受到伤害减免：{0}%".format(ceil(eventPlayer.dmg_reduction)), HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.reaper_buff[1] = getLastCreatedText()
    eventPlayer.setDamageReceived(100 - eventPlayer.dmg_reduction)
    wait(5)
    eventPlayer.dmg_reduction = 0
    eventPlayer.setDamageReceived(100)
    destroyHudText(eventPlayer.reaper_buff[1])
    eventPlayer.reaper_buff[1] = 0

rule "[Reaper]: kill to gain soul buff":
    @Event playerEarnedElimination
    @Hero reaper
    #@Condition eventPlayer.reaper_buff[0] < 50
    @Condition ReaperBuff[0] != 0

    eventPlayer.reaper_buff[0] += ReaperBuff[0] + 1 if eventPlayer.getTeam() == Team.1 else ReaperBuff[0]

rule "[Reaper][ARAM]: kill to gain soul buff (final blow)":
    @Event playerDealtFinalBlow
    @Hero reaper
    #@Condition eventPlayer.reaper_buff[0] < 50

    eventPlayer.reaper_buff[0] += ReaperBuff[0] + 1 if eventPlayer.getTeam() == Team.1 else 0.5

rule "[Reaper]: Ability Dire Triggers":
    @Event eachPlayer
    @Hero reaper
    #@Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) > 1.5
    @Condition eventPlayer.isFiringSecondaryFire() == true

    waitUntil(not eventPlayer.isFiringSecondaryFire(), 0.6)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, ReaperBuff[6])

#!include "secondary.opy"

rule "[Reaper]: HUD & Reset":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isInSpawnRoom() != true
    @Condition eventPlayer.reset_pvar[0] == false
    @Condition eventPlayer.reaper_buff[0] > 0

    if eventPlayer.reaper_buff[2] != 0:
        goto lbl_0
    hudText(eventPlayer, null, " \r\n\r\n\n", "已收割灵魂： {0}".format(eventPlayer.reaper_buff[0]), HudPosition.LEFT, 3, null, null, rgb(255, 255, 255, 200), HudReeval.STRING)
    eventPlayer.reaper_buff[2] = getLastCreatedText()
    lbl_0:
    waitUntil(eventPlayer.reaper_buff[0] == 0 or eventPlayer.reset_pvar[0], 999999986991104)
    destroyHudText(eventPlayer.reaper_buff[2])
    eventPlayer.reaper_buff[2] = 0

rule "[Reaper]: ultimate Death Blossom":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.setDamageDealt(100 + eventPlayer.reaper_buff[0] * ReaperBuff[8])
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.setStatusEffect(eventPlayer, Status.INVINCIBLE, 2.5 if eventPlayer.reaper_buff[0] * 0.05 >= 2.5 else eventPlayer.reaper_buff[0] * 0.05)
    eventPlayer.setStatusEffect(eventPlayer, Status.PHASED_OUT, 2.5 if eventPlayer.reaper_buff[0] * 0.05 >= 2.5 else eventPlayer.reaper_buff[0] * 0.05)
    waitUntil(not eventPlayer.isUsingUltimate(), 3.016)
    eventPlayer.setDamageDealt(100)

rule "[Reaper]: Death Blossom remove Mov. speed penalty":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.mov_speed_buff += 100
    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff)
    waitUntil(not eventPlayer.isUsingUltimate(), 3.5)
    eventPlayer.mov_speed_buff = 0
    eventPlayer.setMoveSpeed(100)
