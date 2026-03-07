rule "[Cassidy.opy]: Revert sniper damage falloff":
    @Event playerDealtDamage
    @Hero cassidy
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition distance(attacker.getEyePosition(), victim) >= 25.1
    
    #!include "falloff-common.opy"
