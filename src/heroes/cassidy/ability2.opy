rule "[Cassdy] Flashbang stun":
    @Event playerDealtDamage
    @Hero cassidy
    @Condition eventAbility == Button.ABILITY_2

    victim.setStatusEffect(attacker, Status.STUNNED, 0.8)
