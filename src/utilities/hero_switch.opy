#!mainFile "../main.opy"

#!defineMember _last_hero_played hero_switch_pvar[0]
#!defineMember _hero_switch_pending hero_switch_pvar[1]
#!defineMember _hero_setup_hero hero_switch_pvar[2]

macro shouldDetectHeroInit(player, hero):
    (player._hero_switch_pending == true
 and player._hero_setup_hero == hero
 and player.hasSpawned() == true)

rule "[utilities/hero_switch.opy]: detect hero switch":
    @Event eachPlayer
    @Condition eventPlayer._hero_switch_pending == false
    @Condition eventPlayer.getCurrentHero() != eventPlayer._last_hero_played

    eventPlayer._hero_switch_pending = true
    eventPlayer._hero_setup_hero = eventPlayer.getCurrentHero()


rule "[utilities/hero_switch.opy]: finalize hero switch":
    @Event eachPlayer
    @Condition eventPlayer._hero_switch_pending == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer._reset_requested == false

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._hero_switch_pending = false
