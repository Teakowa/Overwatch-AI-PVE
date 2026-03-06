rule "[Genji] Dragonblade Healing":
    @Event playerDealtDamage
    @Hero genji
    @Condition eventAbility == Button.ULTIMATE
    
    heal(eventPlayer, eventPlayer, eventDamage)
#!include "shared/10-dragonblade-damage-fix.opy"
#!include "shared/20-deflect.opy"
