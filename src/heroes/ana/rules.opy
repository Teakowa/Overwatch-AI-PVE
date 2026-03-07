rule "[Ana]: Headhunter":
    @Event playerDealtDamage
    @Team 2
    @Hero ana
    @Condition eventWasCriticalHit == true
    @Disabled
    
    if eventPlayer.getNormalizedHealth() != 1:
        eventPlayer.startHealingOverTime(eventPlayer, 0.625, ceil(eventDamage * 31.25 * 0.75))
    else:
        ([player for player in getLivingPlayers(eventPlayer.getTeam()) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) == true and player != eventPlayer]).startHealingOverTime(eventPlayer, 0.625, ceil(eventDamage * 31.25 * Ana_GrenadeDamage[1]) / (len([player for player in getLivingPlayers(eventPlayer.getTeam()) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) == true and player != eventPlayer])))
    wait(0.625)
#!include "biotic-grenade-hit-shared.opy"
#!include "nano-full-health-trigger-shared.opy"
rule "Has Nano":
    @Event playerReceivedHealing
    #This checks that the ability used to deal the healing is the ultimate.
    @Condition eventAbility == Button.ULTIMATE
    #This checks if the player who dealt the healing is Ana or an Echo duplicating an Ana.
    @Condition healer.getHero() == Hero.ANA
    
    eventPlayer.has_nano = true
    waitUntil(eventPlayer.isDead(), 8)
    eventPlayer.has_nano = false
rule "[Ana] Nano Boost Healing":
    @Event playerDealtHealing
    @Hero ana
    @Condition eventAbility == Button.ULTIMATE
    @Condition healer.getHero() == Hero.ANA == true
    
    heal(healee, healer, 99999)
rule "[Ana]: Sleep tanks for longer duration":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.ABILITY_1
    @Condition victim.unaffected == false
    
    victim.clearStatusEffect(Status.ASLEEP)
    #waitUntil(victim.hasStatus(Status.ASLEEP), Math.INFINITY)
    victim.setStatusEffect(attacker, Status.KNOCKED_DOWN, 4)
