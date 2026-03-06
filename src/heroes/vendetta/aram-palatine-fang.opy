# vendetta aram-only palatine fang

rule "[Vendetta] Palatine Fang":
    @Event playerDealtDamage
    @Hero vendetta
    @Condition eventAbility != null
    
    heal(eventPlayer, eventPlayer, eventDamage * 0.4)
    wait()
