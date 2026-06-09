#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Mercy]: Flash Heal":
    @Event playerDealtHealing
    @Hero mercy
    @Condition eventAbility == Button.RELOAD

    heal(healee, healer, MERCY_RELOAD_HEAL)
    wait()

rule "[Mercy]: Flash Heal cd":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.getAbilityCooldown(Button.RELOAD) != 0

    eventPlayer.setAbilityCooldown(Button.RELOAD, MERCY_RELOAD_RELOAD_COOLDOWN_SET)