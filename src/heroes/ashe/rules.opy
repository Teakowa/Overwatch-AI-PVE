rule "[Ash] ammo restored by kills":
    @Event playerDealtFinalBlow
    @Team 2
    @Hero ashe
    @Condition isGameInProgress() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAmmo() < eventPlayer.getMaxAmmo()

    eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())

rule "[Ashe]: headshot damage":
    @Event playerDealtDamage
    @Hero ashe
    @Condition HeadshotDamage[1] > 2
    @Condition eventWasCriticalHit == true
    @Condition eventAbility != Button.ABILITY_1
    @Condition eventAbility != Button.ABILITY_2
    @Condition eventAbility != Button.ULTIMATE

    damage(victim, attacker, ceil((eventDamage * (HeadshotDamage[1] - 2)) / 2))
#!include "ability1.opy"
