#!mainFile "../../main.opy"
#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, A or "", "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "【布丽吉塔】盾击":
    @Event playerDealtKnockback
    @Hero brigitte
    # @Condition attacker.isFiringSecondaryFire() == true
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition attacker.isUsingUltimate() != true
    
    victim.setStatusEffect(attacker, Status.STUNNED, BRIGITTE_BASH_STUNNED_DURATION)
