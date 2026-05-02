#!optimizeStrict

rule "[Reaper]: Wraith Form to fly":
    @Event eachPlayer
    @Hero reaper
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate()) == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true

    eventPlayer.applyImpulse(Vector.UP, 5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(0.1, Wait.ABORT_WHEN_FALSE)
    loop()

rule "[Reaper]: Wraith Form to fly":
    @Event eachPlayer
    @Hero reaper
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate()) == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true

    eventPlayer.applyImpulse(Vector.DOWN, 5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(0.1, Wait.ABORT_WHEN_FALSE)
    loop()

rule "[Reaper]: Ability 1 Wraith Form dmg increase setup":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.dmg_amplification != 0

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

    destroyHudText(eventPlayer.reaper_buff[1])
    hudText(eventPlayer, null, " \r\n", "伤害增幅：{0}%".format(ceil(eventPlayer.dmg_amplification)), HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.reaper_buff[1] = getLastCreatedText()
    waitUntil(eventPlayer.dmg_amplification == 0 and eventPlayer.isDead(), 3.5)
    destroyHudText(eventPlayer.reaper_buff[1])
    eventPlayer.reaper_buff[1] = 0

rule "[Reaper]: kill to gain soul buff":
    @Event playerEarnedElimination
    @Hero reaper
    #@Condition eventPlayer.reaper_buff[0] < 50
    @Condition ReaperBuff[0] != 0

    eventPlayer.reaper_buff[0] += ReaperBuff[0] + 1 if eventPlayer.getTeam() == Team.1 else ReaperBuff[0]

rule "[Reaper]: kill to gain soul buff":
    @Event playerDealtFinalBlow
    @Hero reaper
    #@Condition eventPlayer.reaper_buff[0] < 50

    eventPlayer.reaper_buff[0] += ReaperBuff[0] + 1 if eventPlayer.getTeam() == Team.1 else ReaperBuff[0]

rule "[Reaper]: Ability Dire Triggers":
    @Event eachPlayer
    @Hero reaper
    #@Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) > 1.5
    @Condition eventPlayer.isFiringSecondaryFire() == true

    waitUntil(not eventPlayer.isFiringSecondaryFire(), 0.6)
    eventPlayer.setAmmo(0, eventPlayer.getAmmo() + 1)
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
    waitUntil(eventPlayer.reaper_buff[0] == 0 or eventPlayer.reset_pvar[0], Math.INFINITY)
    destroyHudText(eventPlayer.reaper_buff[2])
    eventPlayer.reaper_buff[2] = 0
#!include "ability1.opy"
#!include "ability2.opy"
#!include "ultimate.opy"
