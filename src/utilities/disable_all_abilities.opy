def disableAllAbilities():
    @Name "[utilities/reset.opy]: disableAllAbilities()"
    
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.disallowButton(Button.MELEE)
    RESET_DISABLE_ALL_ABILITIES_EXTRA()
