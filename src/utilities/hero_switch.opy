#!mainFile "../main.opy"

#!defineMember _last_hero_played hero_switch_pvar[0]
#!defineMember call_init hero_switch_pvar[1]
#!defineMember init_hero hero_switch_pvar[2]

rule "[utilities/hero_switch.opy]: detect hero switch":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() != eventPlayer._last_hero_played
    @Condition eventPlayer.call_init == false or eventPlayer.getCurrentHero() != eventPlayer.init_hero

    eventPlayer.init_hero = eventPlayer.getCurrentHero()
    eventPlayer.call_init = true
    eventPlayer._reset_requested = true
