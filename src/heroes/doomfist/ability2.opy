#!optimizeStrict

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
