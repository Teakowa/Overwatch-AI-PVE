#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, A or "", "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "[JunkerQueen]: ability2":
    @Event playerDealtDamage
    @Hero junkerQueen
    @Condition eventAbility == Button.ABILITY_2
    @Condition eventDamage > 3
    @Condition victim.getHealth() <= victim.getMaxHealth() * 0.1
    
    damage(victim, attacker, JUNKER_QUEEN_ABILITY2_EXECUTE_DAMAGE)
    attacker.setAbilityCooldown(Button.ABILITY_2, 0)
    wait(0.25)


