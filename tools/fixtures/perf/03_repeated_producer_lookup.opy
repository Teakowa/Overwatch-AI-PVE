#!mainFile "../../main.opy"
#!optimizeStrict

rule "[fixture]: repeated producer lookup":
    @Event eachPlayer
    @Condition getPlayersOnHero(Hero.KIRIKO, eventPlayer.getTeam())[0].isHoldingButton(Button.ABILITY_1) == true
    @Condition getPlayersOnHero(Hero.KIRIKO, eventPlayer.getTeam())[0].isUsingAbility1() == true

    eventPlayer.setHealth(100)
