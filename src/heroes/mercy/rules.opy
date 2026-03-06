#!include "valkyrie.opy"
rule "[Mercy]: Flash Heal cd":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.getAbilityCooldown(Button.RELOAD) != 0
    
    eventPlayer.setAbilityCooldown(Button.RELOAD, 2)
