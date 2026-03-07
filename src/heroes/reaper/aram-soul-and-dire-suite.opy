#!include "kill-soul-buff-earned-elimination-shared.opy"

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

rule "[Reaper]: Ability Dire Triggers dot":
    @Event playerDealtDamage
    @Hero reaper
    @Condition eventAbility == Button.SECONDARY_FIRE

    #wait(0.16)
    victim.startDamageOverTime(attacker, 1, victim.getMaxHealth() * 0.1 + eventPlayer.reaper_buff[0] * ReaperBuff[7])
    #victim.reaper_buff = getLastDamageOverTimeId()
    #wait(1)
    #victim.reaper_buff = 0

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
