rule "[Genji] Dragonblade Healing":
    @Event playerDealtDamage
    @Hero genji
    @Condition eventAbility == Button.ULTIMATE
    
    heal(eventPlayer, eventPlayer, eventDamage)
#!include "10-dragonblade-damage-fix.opy"
#!include "20-deflect.opy"
