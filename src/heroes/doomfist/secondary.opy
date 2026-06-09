#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Doomfist]: Power Block Damage":
    @Event playerDealtKnockback
    @Hero doomfist
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition eventPlayer.doom_buff != 0

    damage(victim, attacker, eventPlayer.doom_buff)
    eventPlayer.doom_buff = 0