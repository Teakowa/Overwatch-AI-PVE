#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Cassdy] Flashbang stun":
    @Event playerDealtDamage
    @Hero cassidy
    @Condition eventAbility == Button.ABILITY_2

    victim.setStatusEffect(attacker, Status.STUNNED, CassidyBuff[0])
