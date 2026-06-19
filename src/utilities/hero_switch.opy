#!mainFile "../main.opy"

#!defineMember _last_hero_played hero_switch_pvar[0]
#!defineMember _hero_switch_pending hero_switch_pvar[1]
#!defineMember _hero_setup_hero hero_switch_pvar[2]

rule "[utilities/hero_switch.opy]: detect hero switch":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() != eventPlayer._last_hero_played
    @Condition eventPlayer._hero_switch_pending == false or eventPlayer.getCurrentHero() != eventPlayer._hero_setup_hero

    eventPlayer._hero_setup_hero = eventPlayer.getCurrentHero()
    eventPlayer._hero_switch_pending = true
    eventPlayer._reset_requested = true
