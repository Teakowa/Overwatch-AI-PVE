def Knockback():
    @Name "[Zenyatta] Sub Knockback"
    
    wait()
    eventPlayer.applyImpulse(eventPlayer.KnockbackDirection, Zen_KnockupStrength, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.applyImpulse(Vector.UP, Zen_KnockupStrength * 0.3, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
