#!mainFile "../../main.opy"
#!optimizeStrict


rule "[Sigma]: Hyperspheres Layer Damage":
    @Event playerDealtKnockback
    @Hero sigma
    @Condition SigmaBuff[0] != 0
    @Condition eventPlayer.sigma_hyperspheres < 3
    @Condition eventAbility == Button.PRIMARY_FIRE

    eventPlayer.sigma_hyperspheres++
    eventPlayer.hudText = "{0}|{1}".format(eventPlayer.sigma_hyperspheres, 3)
    wait(0.6)

rule "[Sigma]: Hyperspheres Layer Damage":
    @Event playerDealtKnockback
    @Hero sigma
    @Condition SigmaBuff[0] != 0
    @Condition eventPlayer.sigma_hyperspheres == 3
    @Condition eventAbility == Button.PRIMARY_FIRE

    eventPlayer.sigma_hyperspheres = 0
    eventPlayer.hudText = "{0}|{1}".format(eventPlayer.sigma_hyperspheres, 3)
    damage(victim, attacker, (attacker.getMaxHealthOfType(Health.NORMAL) + attacker.getMaxHealthOfType(Health.ARMOR) + attacker.getMaxHealthOfType(Health.SHIELDS)) * SigmaBuff[0])
    wait(4)
