rule "[Genji] Dragonblade Healing":
    @Event playerDealtDamage
    @Hero genji
    @Condition eventAbility == Button.ULTIMATE
    
    heal(eventPlayer, eventPlayer, eventDamage)
#!include "dragonblade-damage-fix.opy"
#!include "deflect.opy"
