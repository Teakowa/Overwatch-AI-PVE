#!optimizeStrict

rule "[Reaper]: Ability 2 Shadow Step cd":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingAbility2() == true

    waitUntil(not eventPlayer.isUsingAbility2(), 3.016)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.getAbilityCooldown(Button.ABILITY_2) - (50 * ReaperBuff[1] if eventPlayer.reaper_buff[0] > 50 else eventPlayer.reaper_buff[0] * ReaperBuff[1]))
    eventPlayer.dmg_reduction += 60 if ReaperBuff[4] + eventPlayer.reaper_buff[0] * ReaperBuff[5] >= 60 else ReaperBuff[4] + eventPlayer.reaper_buff[0] * ReaperBuff[5]

rule "[Reaper]: Ability 2 Shadow Step dmg reduction setup":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingAbility2() != true
    @Condition eventPlayer.dmg_reduction != 0

    destroyHudText(eventPlayer.reaper_buff[1])
    hudText(eventPlayer, null, " \r\n", "受到伤害减免：{0}%".format(ceil(eventPlayer.dmg_reduction)), HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.reaper_buff[1] = getLastCreatedText()
    eventPlayer.setDamageReceived(100 - eventPlayer.dmg_reduction)
    wait(5)
    eventPlayer.dmg_reduction = 0
    eventPlayer.setDamageReceived(100)
    destroyHudText(eventPlayer.reaper_buff[1])
    eventPlayer.reaper_buff[1] = 0
