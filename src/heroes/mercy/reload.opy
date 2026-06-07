#!optimizeStrict

rule "[Mercy]: Flash Heal":
    @Event playerDealtHealing
    @Hero mercy
    @Condition eventAbility == Button.RELOAD

    heal(healee, healer, 25)
    wait()

rule "[Mercy]: Flash Heal cd":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.getAbilityCooldown(Button.RELOAD) != 0

    eventPlayer.setAbilityCooldown(Button.RELOAD, 2)