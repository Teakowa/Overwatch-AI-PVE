#!optimizeStrict

#!include "primary.opy"
#!include "ability1.opy"
#!include "ultimate.opy"

# vendetta aram-only palatine fang

rule "[Vendetta] Palatine Fang":
    @Event playerDealtDamage
    @Hero vendetta
    @Condition eventAbility != null

    heal(eventPlayer, eventPlayer, eventDamage * VENDETTA_ARAM_EVENT_DAMAGE_HEAL_SCALAR)
    wait()
