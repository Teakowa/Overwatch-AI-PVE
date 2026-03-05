#Global variables

globalvar Mark 0
globalvar Collaborator 1
globalvar ANTI_CRASH_ACTIVATE_PERCENT 2
globalvar ANTI_CRASH_HOLD_TIME 3
globalvar ANTI_CRASH_DEACTIVATE_PERCENT 4
globalvar Debug_UltimateGain 5
globalvar Genji 6
globalvar Heros 8
globalvar Hero_BAN 9
globalvar Orisa_Fortify 11
globalvar HeadshotDamage 12
globalvar ZaryaBuff 14
globalvar IllariBuff 15
globalvar MercyBuff 16
globalvar SombraBuff 17
globalvar Tracer_Ability 18
globalvar ReaperBuff 19
globalvar MaugaBuff 21
globalvar HanzoBuff 22
globalvar S76Buff 23
globalvar SojournBuff 24
globalvar HazardBuff 25
globalvar FrejaBuff 26
globalvar WuyangBuff 27
globalvar VendettaBuff 28
globalvar Brigitte 31
globalvar LifeweaverBuff 32
globalvar SigmaBuff 33
globalvar JunoBuff 34
globalvar Ana_GrenadeDamage 35
globalvar DoomBuff 36
globalvar health_pool 38
globalvar Zen_KnockupStrength 45
globalvar Counters 46
globalvar Counter_Bot 47
globalvar random_size 50
globalvar size_pool 51
globalvar Ram_Annihilation 52
globalvar Blacklist 55
globalvar FalloffMin 56
globalvar ProjectileSpeed 57
globalvar CustomAI 58
globalvar CustomAIArray 59


#Player variables

playervar custom_hp_pvar 0
playervar reset_pvar 1
playervar heroNum 2
playervar botTemp 3
playervar botTarget 4
playervar Strafe 5
playervar third_person 6
playervar unaffected 7
playervar heros 8
playervar extra_hero 9
playervar mov_speed_penalty 10
playervar mov_speed_buff 11
playervar ram_block_damage 12
playervar ram_block_damage_hud 13
playervar ram_dmg_reduc 14
playervar hack_timer 15
playervar mauga_berserker_soul 16
playervar mauga_berserker_soul_id 17
playervar brigitte_buff 18
playervar zarya_barrier_shields 19
playervar zarya_graviton_buff 20
playervar brig_repair_pack 21
playervar brig_repair_pack_id 22
playervar brig_rally_armor_id 23
playervar brig_rally_dmg_redc 24
playervar isKnocked 25
playervar KnockbackDirection 26
playervar wuyang_buff 27
playervar orisa_fortify_armor_id 28
playervar N 29
playervar junkrat_buff 30
playervar ChangelogText1 31
playervar ChangelogText2 32
playervar hazard_buff 33
playervar hazard_hp_id 34
playervar reaper_buff 35
playervar zarya_buff 36
playervar moira_buff 37
playervar hanzo_buff 38
playervar sigma_hyperspheres_hud 39
playervar sigma_hyperspheres 40
playervar doom_buff 41
playervar doom_buff_hud 42
playervar juno_buff 43
playervar freja_buff 44
playervar reinhardt_buff 45
playervar heart_steel 46
playervar orisa_buff 47
playervar kiriko_buff 48
playervar hero_id_duplicated 49
playervar nano_full_health 50
playervar has_nano 51
playervar sombra_buff 52
playervar healing_increase 53
playervar healing_decrease 54
playervar dmg_amplification 55
playervar dmg_decrease 56
playervar dmg_reduction 57
playervar hudText 58
playervar hazard_using_ability_sec 60
playervar rein_health_id 61
playervar rein_charge_fix 62
playervar vendetta_hud 63
playervar scoped_shot_distance 106
playervar scoped_damage_base 107
playervar ow2_scoped_damage_falloff_scalar 108
playervar ow1_scoped_damage_falloff_scalar 109
playervar expected_scoped_damage 110


#Subroutine names

subroutine Knockback 0
subroutine applyCustomHp 1
subroutine clearCustomHp 2
subroutine resetFrenemies 3
subroutine resetStats 4
subroutine resetStatuses 5
subroutine executeUppercut 6
subroutine enableAllAbilities 7
subroutine disableAllAbilities 8
subroutine changelogText 9
subroutine resetHero 10
subroutine removeTankPassive 11
subroutine setPlayerHeros 12
subroutine setThirdPerson 13
subroutine botAim2Target 14


# Reset Utility Behavior Profile (ARAM)

macro RESET_DISABLE_ALL_ABILITIES_EXTRA():
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.JUMP)
    eventPlayer.disallowButton(Button.CROUCH)
    eventPlayer.disallowButton(Button.RELOAD)
    eventPlayer.disallowButton(Button.INTERACT)
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setJumpEnabled(false)
    eventPlayer.setCrouchEnabled(false)
    eventPlayer.setReloadEnabled(false)

macro RESET_STATS_EXTRA():
    eventPlayer.setDamageDealt(100)
    eventPlayer.setHealingDealt(100)

macro RESET_STATUSES_EXTRA():
    eventPlayer.brigitte_buff[0] = false
    eventPlayer.orisa_buff = false
    eventPlayer.zarya_graviton_buff[0] = false

macro RESET_HERO_EXTRA_BEFORE_CLEAR():
    destroyEffect(eventPlayer.heart_steel[4])
    eventPlayer.third_person = false
    eventPlayer.stopCamera()

macro RESET_HERO_WAIT():
    wait(WAIT_SHORT_FRAME)

macro RESET_REMOVE_TANK_PASSIVE_ENABLED():
    true
