# bastion aram-only artillery

rule "[Bastion]: Configuration: Artillery":

    @Event playerDealtDamage

    @Hero bastion

    @Condition eventAbility == Button.ULTIMATE

    damage(victim, attacker, victim.getHealth() * 0.25)

    wait(0.25)
