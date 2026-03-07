#!include "wraith-form-shared-suite.opy"
#!include "kill-soul-buff-earned-elimination-shared.opy"
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
rule "[Reaper]: Ability Dire Triggers dot":
    @Event playerDealtDamage
    @Hero reaper
    @Condition eventAbility == Button.SECONDARY_FIRE
    
    #wait(WAIT_SHORT_FRAME)
    victim.startDamageOverTime(attacker, 1, eventPlayer.reaper_buff[0] * ReaperBuff[7])
    #victim.reaper_buff = getLastDamageOverTimeId()
    #wait(1)
    #victim.reaper_buff = 0
rule "[Reaper]: ultimate Death Blossom":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setDamageDealt(100 + eventPlayer.reaper_buff[0] * ReaperBuff[8])
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.setStatusEffect(eventPlayer, Status.UNKILLABLE, 2.5 if eventPlayer.reaper_buff[0] * 0.05 >= 2.5 else eventPlayer.reaper_buff[0] * 0.05)
    waitUntil(not eventPlayer.isUsingUltimate(), 3.016)
    eventPlayer.setDamageDealt(100)
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
rule "[Reaper]: Death Blossom remove Mov. speed penalty":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingUltimate() == true
    
    if abs(eventPlayer.mov_speed_buff) < abs(100):
        eventPlayer.mov_speed_buff = 100
        applySignedMoveSpeed()
    waitUntil(not eventPlayer.isUsingUltimate() or eventPlayer.isDead(), 3.5)
    if eventPlayer.isDead():
        goto lbl_0
    if eventPlayer.mov_speed_buff == 100:
        eventPlayer.mov_speed_buff = 0
        applySignedMoveSpeed()
    lbl_0:
