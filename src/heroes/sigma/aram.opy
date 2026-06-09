#!mainFile "../../aramMain.opy"
#!optimizeStrict

playervar sigma_hyperspheres
playervar sigma_hyperspheres_hud

rule "[Sigma]: Hyperspheres Layer Damage":
    @Event playerDealtKnockback
    @Hero sigma
    @Condition SigmaBuff[0] != 0
    @Condition eventPlayer.sigma_hyperspheres < SigmaBuff[1] + 1
    @Condition eventAbility == Button.PRIMARY_FIRE

    eventPlayer.sigma_hyperspheres++
    eventPlayer.hudText = "{0}|{1}".format(eventPlayer.sigma_hyperspheres, 3)
    wait(0.6)

rule "[Sigma]: Hyperspheres Layer Damage":
    @Event playerDealtDamage
    @Hero sigma
    @Condition SigmaBuff[0] != 0
    @Condition eventPlayer.sigma_hyperspheres == SigmaBuff[1] + 1
    @Condition eventAbility == Button.PRIMARY_FIRE

    eventPlayer.sigma_hyperspheres = 0
    eventPlayer.hudText = "{0}|{1}".format(eventPlayer.sigma_hyperspheres, 3)
    damage(victim, attacker, attacker.getHealth() * SigmaBuff[0])
    wait(4)

#!include "ultimate.opy"
