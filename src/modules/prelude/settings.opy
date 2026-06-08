#!mainFile "../../main.opy"

#!include "../../constants/ow2_hero_defaults.opy"

settings {
    "main": {
        "description": "语音频道：kook.vip/EEC9UH\n\n企鹅聊天群：361913638\n\n更新日志：workshop.codes/77QS1 | v26.0304.1\n\n中途退永久BAN  |  玻璃心别玩  |  育碧平衡",
        "modeName": "真·困难人机 6v6 竞技 PVE"
    },
    "lobby": {
        "mapRotation": "afterGame",
        "swapTeamsAfterMatch": false,
        "team1Slots": 5,
        "team2Slots": 6,
        "spectatorSlots": 2,
        "returnToLobby": "never"
    },
    "gamemodes": {
        "assault": {
            "disabledMaps": [
                "hanamuraWinter"
            ],
        },
        "skirmish": {
            "disabledMaps": [
                "hanamuraWinter"
            ]
        },
        
        "general": {
            "gamemodeStartTrigger": "manual",
            "enableCompetitiveRules": true,
            "tankPassiveHealthBonus": "disabled"
        }
    },
    "heroes": {
        "team1": {
            "hanzo": {
                "ability2Quantity%": SETTINGS_TEAM1_HANZO_ABILITY2_QUANTITY_PERCENT,
                "ability3Cooldown%": SETTINGS_TEAM1_HANZO_ABILITY3_COOLDOWN_PERCENT,
                "damageDealt%": SETTINGS_TEAM1_HANZO_DAMAGE_DEALT_PERCENT,
                "projectileSpeed%": SETTINGS_TEAM1_HANZO_PROJECTILE_SPEED_PERCENT,
                "projectileGravity%": SETTINGS_TEAM1_HANZO_PROJECTILE_GRAVITY_PERCENT,
                "ultGen%": ultGenPercent(HANZO_ULT_COST, SET_AI_HANZO_ULT_COST_TARGET)
            },
            "cassidy": {
                "damageDealt%": SETTINGS_TEAM1_CASSIDY_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_CASSIDY_DAMAGE_RECEIVED_PERCENT,
                "ability2Cooldown%": ratioPercent(SET_AI_CASSIDY_ABILITY2_COOLDOWN_TARGET, MCCREE_FLASHBANG_COOLDOWN)
            },
            "lucio": {
                "damageDealt%": SETTINGS_TEAM1_LUCIO_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_LUCIO_DAMAGE_RECEIVED_PERCENT,
                "healingReceived%": SETTINGS_TEAM1_LUCIO_HEALING_RECEIVED_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM1_LUCIO_ABILITY2_COOLDOWN_PERCENT,
                "enableInfiniteAmmo": true,
                "healingDealt%": SETTINGS_TEAM1_LUCIO_HEALING_DEALT_PERCENT,
                "ultGen%": ultGenPercent(LUCIO_ULT_COST, SET_AI_LUCIO_ULT_COST_TARGET)
            },
            "soldier": {
                "damageDealt%": SETTINGS_TEAM1_SOLDIER_DAMAGE_DEALT_PERCENT,
                "enableInfiniteAmmo": true,
                "ability2Cooldown%": ratioPercent(SET_AI_SOLDIER_ABILITY2_COOLDOWN_TARGET, SOLDIER_BIOTIC_FIELD_COOLDOWN),

                "ultDuration%": SETTINGS_TEAM1_SOLDIER_ULT_DURATION_PERCENT,
                "secondaryFireCooldown%": SETTINGS_TEAM1_SOLDIER_SECONDARY_FIRE_COOLDOWN_PERCENT,
                "secondaryFireKb%": SETTINGS_TEAM1_SOLDIER_SECONDARY_FIRE_KB_PERCENT
            },
            "mercy": {
                "damageDealt%": SETTINGS_TEAM1_MERCY_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_MERCY_DAMAGE_RECEIVED_PERCENT,
                "projectileSpeed%": SETTINGS_TEAM1_MERCY_PROJECTILE_SPEED_PERCENT,
                "ability1Cooldown%": SETTINGS_TEAM1_MERCY_ABILITY1_COOLDOWN_PERCENT,
                "enableInfiniteAmmo": true,
                "healingDealt%": SETTINGS_TEAM1_MERCY_HEALING_DEALT_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM1_MERCY_ABILITY2_COOLDOWN_PERCENT
            },
            "orisa": {
                "damageReceived%": SETTINGS_TEAM1_ORISA_DAMAGE_RECEIVED_PERCENT,
                "projectileSpeed%": SETTINGS_TEAM1_ORISA_PROJECTILE_SPEED_PERCENT,
                "ability1Cooldown%": ratioPercent(SET_AI_ORISA_ABILITY1_COOLDOWN_TARGET, ORISA_FORTIFY_COOLDOWN),

                "secondaryFireCooldown%": SETTINGS_TEAM1_ORISA_SECONDARY_FIRE_COOLDOWN_PERCENT,
                "projectileGravity%": SETTINGS_TEAM1_ORISA_PROJECTILE_GRAVITY_PERCENT,
                "enableInfiniteAmmo": true,
                "ability2Cooldown%": SETTINGS_TEAM1_ORISA_ABILITY2_COOLDOWN_PERCENT,
                "health%": SETTINGS_TEAM1_ORISA_HEALTH_PERCENT,
                "movementSpeed%": SETTINGS_TEAM1_ORISA_MOVEMENT_SPEED_PERCENT,
                "ultGen%": ultGenPercent(ORISA_ULT_COST, SET_AI_ORISA_ULT_COST_TARGET)
            },
            "ana": {
                "enableInfiniteAmmo": true,
                "healingDealt%": SETTINGS_TEAM1_ANA_HEALING_DEALT_PERCENT,
                "ultGen%": ultGenPercent(ANA_ULT_COST, SET_AI_ANA_ULT_COST_TARGET),

                "enableSpawningWithUlt": true,
                "ability1Cooldown%": ratioPercent(SET_AI_ANA_ABILITY1_COOLDOWN_TARGET, ANA_SLEEP_DART_COOLDOWN_TIME)
            },
            "baptiste": {
                "damageDealt%": SETTINGS_TEAM1_BAPTISTE_DAMAGE_DEALT_PERCENT,
                "ability1Cooldown%": ratioPercent(SET_AI_BAPTISTE_ABILITY1_COOLDOWN_TARGET, BAPTISTE_REGEN_BURST_COOLDOWN),

                "enableInfiniteAmmo": true,
                "healingDealt%": SETTINGS_TEAM1_BAPTISTE_HEALING_DEALT_PERCENT,
                "ultDuration%": SETTINGS_TEAM1_BAPTISTE_ULT_DURATION_PERCENT,
                "ability2Cooldown%": ratioPercent(SET_AI_BAPTISTE_ABILITY2_COOLDOWN_TARGET, BAPTISTE_LAMP_COOLDOWN_TIME)
            },
            "brigitte": {
                "damageDealt%": SETTINGS_TEAM1_BRIGITTE_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_BRIGITTE_DAMAGE_RECEIVED_PERCENT,
                "healingReceived%": SETTINGS_TEAM1_BRIGITTE_HEALING_RECEIVED_PERCENT,
                "ability1Kb%": SETTINGS_TEAM1_BRIGITTE_ABILITY1_KB_PERCENT,
                "secondaryFireRechargeRate%": SETTINGS_TEAM1_BRIGITTE_SECONDARY_FIRE_RECHARGE_RATE_PERCENT,
                "secondaryFireCooldown%": SETTINGS_TEAM1_BRIGITTE_SECONDARY_FIRE_COOLDOWN_PERCENT,
                "healingDealt%": SETTINGS_TEAM1_BRIGITTE_HEALING_DEALT_PERCENT,
                "health%": SETTINGS_TEAM1_BRIGITTE_HEALTH_PERCENT,
                "ultGen%": ultGenPercent(BRIGITTE_ULT_COST, SET_AI_BRIGITTE_ULT_COST_TARGET),

                "shieldBashKb%": ratioPercent(SET_AI_BRIGITTE_SHIELD_BASH_KB_TARGET, BRIGITTE_SHIELD_BASH_KNOCKBACK)
            },
            "freja": {
                "damageDealt%": SETTINGS_TEAM1_FREJA_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_FREJA_DAMAGE_RECEIVED_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM1_FREJA_ABILITY2_COOLDOWN_PERCENT,
                "ability2Height%": SETTINGS_TEAM1_FREJA_ABILITY2_HEIGHT_PERCENT,
                "ability1Cooldown%": SETTINGS_TEAM1_FREJA_ABILITY1_COOLDOWN_PERCENT,
                "ability1Distance%": SETTINGS_TEAM1_FREJA_ABILITY1_DISTANCE_PERCENT,
                "secondaryFireCooldown%": SETTINGS_TEAM1_FREJA_SECONDARY_FIRE_COOLDOWN_PERCENT,
                "secondaryFireDuration%": SETTINGS_TEAM1_FREJA_SECONDARY_FIRE_DURATION_PERCENT
            },
            "torbjorn": {
                "damageDealt%": SETTINGS_TEAM1_TORBJORN_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_TORBJORN_DAMAGE_RECEIVED_PERCENT,
                "projectileSpeed%": SETTINGS_TEAM1_TORBJORN_PROJECTILE_SPEED_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM1_TORBJORN_ABILITY2_COOLDOWN_PERCENT,
                "ability2Duration%": SETTINGS_TEAM1_TORBJORN_ABILITY2_DURATION_PERCENT,
                "ability1Cooldown%": SETTINGS_TEAM1_TORBJORN_ABILITY1_COOLDOWN_PERCENT,
                "combatUltGen%": SETTINGS_TEAM1_TORBJORN_COMBAT_ULT_GEN_PERCENT,
                "ultGen%": ultGenPercent(TORBJORN_ULT_COST, SET_AI_TORBJORN_ULT_COST_TARGET),

                "ultDuration%": SETTINGS_TEAM1_TORBJORN_ULT_DURATION_PERCENT,
                "passiveUltGen%": SETTINGS_TEAM1_TORBJORN_PASSIVE_ULT_GEN_PERCENT,
                "enableInfiniteAmmo": true
            },
            "ramattra": {
                "damageDealt%": SETTINGS_TEAM1_RAMATTRA_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_RAMATTRA_DAMAGE_RECEIVED_PERCENT,
                "ability2Cooldown%": ratioPercent(SET_AI_RAMATTRA_ABILITY2_COOLDOWN_TARGET, RAMATTRA_VORTEX_COOLDOWN),

                "ability1Cooldown%": ratioPercent(SET_AI_RAMATTRA_ABILITY1_COOLDOWN_TARGET, RAMATTRA_NEMESIS_COOLDOWN),

                "enableInfiniteAmmo": true,
                "ultGen%": ultGenPercent(RAMATTRA_ULT_COST, SET_AI_RAMATTRA_ULT_COST_TARGET),

                "ultDuration%": SETTINGS_TEAM1_RAMATTRA_ULT_DURATION_PERCENT,
                "secondaryFireCooldown%": ratioPercent(SET_AI_RAMATTRA_SECONDARY_FIRE_COOLDOWN_TARGET, RAMATTRA_VOID_BARRIER_COOLDOWN)
            },
            "venture": {
                "damageDealt%": SETTINGS_TEAM1_VENTURE_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_VENTURE_DAMAGE_RECEIVED_PERCENT,
                "ultGen%": ultGenPercent(VENTURE_ULT_COST, SET_AI_VENTURE_ULT_COST_TARGET),

                "ability1Duration%": SETTINGS_TEAM1_VENTURE_ABILITY1_DURATION_PERCENT,
                "secondaryFireCooldown%": SETTINGS_TEAM1_VENTURE_SECONDARY_FIRE_COOLDOWN_PERCENT
            },
            "emre": {
                "damageDealt%": SETTINGS_TEAM1_EMRE_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_EMRE_DAMAGE_RECEIVED_PERCENT,
                "ability1Cooldown%": SETTINGS_TEAM1_EMRE_ABILITY1_COOLDOWN_PERCENT,
                "ability1Duration%": SETTINGS_TEAM1_EMRE_ABILITY1_DURATION_PERCENT,
                "ability1Heat%": SETTINGS_TEAM1_EMRE_ABILITY1_HEAT_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM1_EMRE_ABILITY2_COOLDOWN_PERCENT
            },
            "vendetta": {
                "damageDealt%": SETTINGS_TEAM1_VENDETTA_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_VENDETTA_DAMAGE_RECEIVED_PERCENT,
                "healingReceived%": SETTINGS_TEAM1_VENDETTA_HEALING_RECEIVED_PERCENT,
                "ultGen%": SETTINGS_TEAM1_VENDETTA_ULT_GEN_PERCENT
            },
            "anran": {
                "damageDealt%": SETTINGS_TEAM1_ANRAN_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_ANRAN_DAMAGE_RECEIVED_PERCENT,
                "ability1Cooldown%": percent((ANRAN_AI_ABILITY1_COOLDOWN_TARGET) / (ANRAN_INFERNO_RUSH_COOLDOWN)),
                "ability2Cooldown%": percent((ANRAN_AI_ABILITY2_COOLDOWN_TARGET) / (ANRAN_DANCING_BLAZE_COOLDOWN))
            },
            "wuyang": {
                "passiveHealthRegen": false,
                "secondaryFireRechargeRate%": SETTINGS_TEAM1_WUYANG_SECONDARY_FIRE_RECHARGE_RATE_PERCENT,
                "secondaryFireCost%": SETTINGS_TEAM1_WUYANG_SECONDARY_FIRE_COST_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM1_WUYANG_ABILITY2_COOLDOWN_PERCENT,
                "ability1Cooldown%": SETTINGS_TEAM1_WUYANG_ABILITY1_COOLDOWN_PERCENT
            },
            "illari": {
                "damageDealt%": SETTINGS_TEAM1_ILLARI_DAMAGE_DEALT_PERCENT,
                "healingDealt%": SETTINGS_TEAM1_ILLARI_HEALING_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_ILLARI_DAMAGE_RECEIVED_PERCENT,
                "solarEnergyRecharge%": SETTINGS_TEAM1_ILLARI_SOLAR_ENERGY_RECHARGE_PERCENT,
                "projectileSpeed%": SETTINGS_TEAM1_ILLARI_PROJECTILE_SPEED_PERCENT,
                "ability2Cooldown%": ratioPercent(SET_AI_ILLARI_ABILITY2_COOLDOWN_TARGET, ILLARI_PYLON_COOLDOWN),

                "enableInfiniteAmmo": true
            },
            "juno": {
                "healingDealt%": SETTINGS_TEAM1_JUNO_HEALING_DEALT_PERCENT,
                "damageDealt%": SETTINGS_TEAM1_JUNO_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_JUNO_DAMAGE_RECEIVED_PERCENT,
                "ultGen%": ultGenPercent(JUNO_ULT_COST, SET_AI_JUNO_ULT_COST_TARGET),

                "secondaryFireCooldown%": SETTINGS_TEAM1_JUNO_SECONDARY_FIRE_COOLDOWN_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM1_JUNO_ABILITY2_COOLDOWN_PERCENT
            },
            "doomfist": {
                "damageDealt%": SETTINGS_TEAM1_DOOMFIST_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_DOOMFIST_DAMAGE_RECEIVED_PERCENT,
                "ammoRegenerationTime%": ratioPercent(SET_AI_DOOMFIST_AMMO_REGENERATION_TIME_TARGET, DOOMFIST_AMMO_REGEN),

                "enableInfiniteAmmo": true
            },
            "zarya": {
                "damageDealt%": SETTINGS_TEAM1_ZARYA_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_ZARYA_DAMAGE_RECEIVED_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM1_ZARYA_ABILITY2_COOLDOWN_PERCENT,
                "enableInfiniteAmmo": true,
                "ability1Cooldown%": SETTINGS_TEAM1_ZARYA_ABILITY1_COOLDOWN_PERCENT,
                "ultGen%": ultGenPercent(ZARYA_ULT_COST, SET_AI_ZARYA_ULT_COST_TARGET)
            },
            "reaper": {
                "damageDealt%": SETTINGS_TEAM1_REAPER_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_REAPER_DAMAGE_RECEIVED_PERCENT,
                "enableInfiniteAmmo": true,
                "healingDealt%": SETTINGS_TEAM1_REAPER_HEALING_DEALT_PERCENT
            },
            "mauga": {
                "damageDealt%": SETTINGS_TEAM1_MAUGA_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_MAUGA_DAMAGE_RECEIVED_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM1_MAUGA_ABILITY2_COOLDOWN_PERCENT,
                "ability2Healing%": SETTINGS_TEAM1_MAUGA_ABILITY2_HEALING_PERCENT,
                "enableInfiniteAmmo": true,
                "ultDuration%": SETTINGS_TEAM1_MAUGA_ULT_DURATION_PERCENT,
                "primaryFireIgniteDuration": SETTINGS_TEAM1_MAUGA_PRIMARY_FIRE_IGNITE_DURATION,
                "primaryFireIgniteRate": SETTINGS_TEAM1_MAUGA_PRIMARY_FIRE_IGNITE_RATE
            },
            "pharah": {
                "damageDealt%": SETTINGS_TEAM1_PHARAH_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_PHARAH_DAMAGE_RECEIVED_PERCENT,
                "passiveExtraFuel%": SETTINGS_TEAM1_PHARAH_PASSIVE_EXTRA_FUEL_PERCENT,
                "ability1Cooldown%": ratioPercent(SET_AI_PHARAH_ABILITY1_COOLDOWN_TARGET, PHARAH_JUMP_JET_COOLDOWN),

                "ability1RefuelScalar": SETTINGS_TEAM1_PHARAH_ABILITY1_REFUEL_SCALAR,
                "secondaryFireCooldown%": SETTINGS_TEAM1_PHARAH_SECONDARY_FIRE_COOLDOWN_PERCENT,
                "ability2Cooldown%": ratioPercent(SET_AI_PHARAH_ABILITY2_COOLDOWN_TARGET, PHARAH_CONCUSSIVE_BLAST_COOLDOWN)
            },
            "jetpackCat": {
                "damageDealt%": SETTINGS_TEAM1_JETPACK_CAT_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_JETPACK_CAT_DAMAGE_RECEIVED_PERCENT,
                "healingDealt%": SETTINGS_TEAM1_JETPACK_CAT_HEALING_DEALT_PERCENT,
                "ability1Cooldown%": SETTINGS_TEAM1_JETPACK_CAT_ABILITY1_COOLDOWN_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM1_JETPACK_CAT_ABILITY2_COOLDOWN_PERCENT
            },
            "junkerQueen": {
                "damageDealt%": SETTINGS_TEAM1_JUNKER_QUEEN_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_JUNKER_QUEEN_DAMAGE_RECEIVED_PERCENT,
                "ability1Cooldown%": SETTINGS_TEAM1_JUNKER_QUEEN_ABILITY1_COOLDOWN_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM1_JUNKER_QUEEN_ABILITY2_COOLDOWN_PERCENT,
                "secondaryFireCooldown%": SETTINGS_TEAM1_JUNKER_QUEEN_SECONDARY_FIRE_COOLDOWN_PERCENT
            },
            "winston": {
                "damageDealt%": SETTINGS_TEAM1_WINSTON_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_WINSTON_DAMAGE_RECEIVED_PERCENT,
                "ability1Cooldown%": ratioPercent(SET_AI_WINSTON_ABILITY1_COOLDOWN_TARGET, WINSTON_JUMP_PACK_COOLDOWN_TIME),

                "ability2Cooldown%": ratioPercent(SET_AI_WINSTON_ABILITY2_COOLDOWN_TARGET, WINSTON_BARRIER_COOLDOWN),

                "enableInfiniteAmmo": true
            },
            "genji": {
                "damageDealt%": SETTINGS_TEAM1_GENJI_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_GENJI_DAMAGE_RECEIVED_PERCENT,
                "healingReceived%": SETTINGS_TEAM1_GENJI_HEALING_RECEIVED_PERCENT,
                "enableInfiniteAmmo": true,
                "ultDuration%": SETTINGS_TEAM1_GENJI_ULT_DURATION_PERCENT,
                "ultGen%": ultGenPercent(GENJI_ULT_COST, SET_AI_GENJI_ULT_COST_TARGET)
            },
            "junkrat": {
                "damageDealt%": SETTINGS_TEAM1_JUNKRAT_DAMAGE_DEALT_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM1_JUNKRAT_ABILITY2_COOLDOWN_PERCENT,
                "enableInfiniteAmmo": true,
                "ability1Cooldown%": ratioPercent(SET_AI_JUNKRAT_ABILITY1_COOLDOWN_TARGET, JUNKRAT_CONCUSSION_MINE_COOLDOWN)
            },
            "tracer": {
                "damageDealt%": SETTINGS_TEAM1_TRACER_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_TRACER_DAMAGE_RECEIVED_PERCENT,
                "projectileSpeed%": SETTINGS_TEAM1_TRACER_PROJECTILE_SPEED_PERCENT,
                "ultGen%": ultGenPercent(TRACER_ULT_COST, SET_AI_TRACER_ULT_COST_TARGET),

                "ability2Cooldown%": ratioPercent(SET_AI_TRACER_ABILITY2_COOLDOWN_TARGET, TRACER_RECALL_COOLDOWN),

                "ability1Cooldown%": SETTINGS_TEAM1_TRACER_ABILITY1_COOLDOWN_PERCENT
            },
            "zenyatta": {
                "damageDealt%": SETTINGS_TEAM1_ZENYATTA_DAMAGE_DEALT_PERCENT,
                "healingReceived%": SETTINGS_TEAM1_ZENYATTA_HEALING_RECEIVED_PERCENT,
                "ultGen%": ultGenPercent(ZENYATTA_ULT_COST, SET_AI_ZENYATTA_ULT_COST_TARGET),

                "projectileSpeed%": SETTINGS_TEAM1_ZENYATTA_PROJECTILE_SPEED_PERCENT,
                "enableInfiniteAmmo": true,
                "healingDealt%": SETTINGS_TEAM1_ZENYATTA_HEALING_DEALT_PERCENT
            },
            "symmetra": {
                "projectileSpeed%": SETTINGS_TEAM1_SYMMETRA_PROJECTILE_SPEED_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM1_SYMMETRA_ABILITY2_COOLDOWN_PERCENT,
                "damageDealt%": SETTINGS_TEAM1_SYMMETRA_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_SYMMETRA_DAMAGE_RECEIVED_PERCENT,
                "ability1Cooldown%": SETTINGS_TEAM1_SYMMETRA_ABILITY1_COOLDOWN_PERCENT,
                "enableInfiniteAmmo": true
            },
            "sojourn": {
                "secondaryFireEnergyChargeRate%": SETTINGS_TEAM1_SOJOURN_SECONDARY_FIRE_ENERGY_CHARGE_RATE_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_SOJOURN_DAMAGE_RECEIVED_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM1_SOJOURN_ABILITY2_COOLDOWN_PERCENT,
                "projectileSpeed%": SETTINGS_TEAM1_SOJOURN_PROJECTILE_SPEED_PERCENT
            },
            "mei": {
                "damageDealt%": SETTINGS_TEAM1_MEI_DAMAGE_DEALT_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM1_MEI_ABILITY2_COOLDOWN_PERCENT,
                "primaryFireFreezeDuration%": SETTINGS_TEAM1_MEI_PRIMARY_FIRE_FREEZE_DURATION_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_MEI_DAMAGE_RECEIVED_PERCENT,
                "ability1Cooldown%": SETTINGS_TEAM1_MEI_ABILITY1_COOLDOWN_PERCENT,
                "enableInfiniteAmmo": true,
                "healingDealt%": SETTINGS_TEAM1_MEI_HEALING_DEALT_PERCENT
            },
            "ashe": {
                "damageDealt%": SETTINGS_TEAM1_ASHE_DAMAGE_DEALT_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM1_ASHE_ABILITY2_COOLDOWN_PERCENT,
                "ability2FuseTime%": SETTINGS_TEAM1_ASHE_ABILITY2_FUSE_TIME_PERCENT,
                "enableInfiniteAmmo": true,
                "ability1Cooldown%": SETTINGS_TEAM1_ASHE_ABILITY1_COOLDOWN_PERCENT,
                "ultDuration%": SETTINGS_TEAM1_ASHE_ULT_DURATION_PERCENT
            },
            "moira": {
                "damageDealt%": SETTINGS_TEAM1_MOIRA_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_MOIRA_DAMAGE_RECEIVED_PERCENT,
                "healingReceived%": SETTINGS_TEAM1_MOIRA_HEALING_RECEIVED_PERCENT,
                "healingDealt%": SETTINGS_TEAM1_MOIRA_HEALING_DEALT_PERCENT,
                "ability2MaxDamage%": SETTINGS_TEAM1_MOIRA_ABILITY2_MAX_DAMAGE_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM1_MOIRA_ABILITY2_COOLDOWN_PERCENT,
                "ability2MaxHealing%": SETTINGS_TEAM1_MOIRA_ABILITY2_MAX_HEALING_PERCENT,
                "primaryFireRechargeRate%": SETTINGS_TEAM1_MOIRA_PRIMARY_FIRE_RECHARGE_RATE_PERCENT,
                "ultGen%": ultGenPercent(MOIRA_ULT_COST, SET_AI_MOIRA_ULT_COST_TARGET)
            },
            "reinhardt": {
                "ability1Cooldown%": ratioPercent(SET_AI_REINHARDT_ABILITY1_COOLDOWN_TARGET, REINHARDT_CHARGE_COOLDOWN_TIME),

                "damageReceived%": SETTINGS_TEAM1_REINHARDT_DAMAGE_RECEIVED_PERCENT,
                "secondaryFireRechargeRate%": ratioPercent(SET_AI_REINHARDT_SECONDARY_FIRE_RECHARGE_RATE_TARGET, REINHARDT_BARRIER_REGEN),

                "combatUltGen%": SETTINGS_TEAM1_REINHARDT_COMBAT_ULT_GEN_PERCENT,
                "health%": ratioPercent(SET_AI_REINHARDT_HEALTH_TARGET, REINHARDT_BARRIER_HEALTH)
            },
            "sigma": {
                "ability1Cooldown%": SETTINGS_TEAM1_SIGMA_ABILITY1_COOLDOWN_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_SIGMA_DAMAGE_RECEIVED_PERCENT,
                "secondaryFireRechargeRate%": SETTINGS_TEAM1_SIGMA_SECONDARY_FIRE_RECHARGE_RATE_PERCENT,
                "health%": ratioPercent(SET_AI_SIGMA_HEALTH_TARGET, SIGMA_BARRIER_HEALTH),

                "ability2Cooldown%": SETTINGS_TEAM1_SIGMA_ABILITY2_COOLDOWN_PERCENT
            },
            "roadhog": {
                "damageReceived%": SETTINGS_TEAM1_ROADHOG_DAMAGE_RECEIVED_PERCENT,
                "secondaryFireRechargeRate%": SETTINGS_TEAM1_ROADHOG_SECONDARY_FIRE_RECHARGE_RATE_PERCENT,
                "enableInfiniteAmmo": true,
                "healingDealt%": SETTINGS_TEAM1_ROADHOG_HEALING_DEALT_PERCENT,
                "movementSpeed%": SETTINGS_TEAM1_ROADHOG_MOVEMENT_SPEED_PERCENT
            },
            "kiriko": {
                "ability1Distance%": SETTINGS_TEAM1_KIRIKO_ABILITY1_DISTANCE_PERCENT,
                "damageDealt%": SETTINGS_TEAM1_KIRIKO_DAMAGE_DEALT_PERCENT,
                "projectileSpeed%": SETTINGS_TEAM1_KIRIKO_PROJECTILE_SPEED_PERCENT,
                "healingDealt%": SETTINGS_TEAM1_KIRIKO_HEALING_DEALT_PERCENT,
                "ability2Cooldown%": ratioPercent(SET_AI_KIRIKO_ABILITY2_COOLDOWN_TARGET, KIRIKO_SUZU_COOLDOWN),

                "ultGen%": ultGenPercent(KIRIKO_ULT_COST, SET_AI_KIRIKO_ULT_COST_TARGET)
            },
            "mizuki": {
                "damageDealt%": SETTINGS_TEAM1_MIZUKI_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_MIZUKI_DAMAGE_RECEIVED_PERCENT,
                "ability1Cooldown%": SETTINGS_TEAM1_MIZUKI_ABILITY1_COOLDOWN_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM1_MIZUKI_ABILITY2_COOLDOWN_PERCENT,
                "secondaryFireCooldown%": SETTINGS_TEAM1_MIZUKI_SECONDARY_FIRE_COOLDOWN_PERCENT,
                "ultGen%": SETTINGS_TEAM1_MIZUKI_ULT_GEN_PERCENT
            },
            "hazard": {
                "damageDealt%": SETTINGS_TEAM1_HAZARD_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_HAZARD_DAMAGE_RECEIVED_PERCENT,
                "secondaryFireRegen%": SETTINGS_TEAM1_HAZARD_SECONDARY_FIRE_REGEN_PERCENT,
                "secondaryFireCost%": SETTINGS_TEAM1_HAZARD_SECONDARY_FIRE_COST_PERCENT,
                "combatUltGen%": SETTINGS_TEAM1_HAZARD_COMBAT_ULT_GEN_PERCENT,
                "passiveUltGen%": SETTINGS_TEAM1_HAZARD_PASSIVE_ULT_GEN_PERCENT
            },
            "domina": {
                "damageDealt%": DOMINA_DAMAGE_DEALT_PERCENT,
                "damageReceived%": DOMINA_AI_DAMAGE_RECEIVED_PERCENT,
                "ability1Cooldown%": ratioPercent(DOMINA_SONIC_REPULSORS_COOLDOWN, OW2_DOMINA_SONIC_REPULSORS_COOLDOWN),
                "ability2Cooldown%": ratioPercent(DOMINA_CRYSTAL_CHARGE_COOLDOWN, OW2_DOMINA_CRYSTAL_CHARGE_COOLDOWN),
                "secondaryFireCooldown%": ratioPercent(DOMINA_BARRIER_ARRAY_COOLDOWN, OW2_DOMINA_BARRIER_ARRAY_COOLDOWN)
            },
            "sombra": {
                "damageDealt%": SETTINGS_TEAM1_SOMBRA_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_SOMBRA_DAMAGE_RECEIVED_PERCENT,
                "healingReceived%": SETTINGS_TEAM1_SOMBRA_HEALING_RECEIVED_PERCENT,
                "enableInfiniteAmmo": false,
                "passiveUltGen%": SETTINGS_TEAM1_SOMBRA_PASSIVE_ULT_GEN_PERCENT,
                "secondaryFireCooldown%": ratioPercent(SET_AI_SOMBRA_SECONDARY_FIRE_COOLDOWN_TARGET, SOMBRA_HACK_COOLDOWN_TIME),

                "ammoClipSize%": SETTINGS_TEAM1_SOMBRA_AMMO_CLIP_SIZE_PERCENT
            },
            "widowmaker": {
                "damageDealt%": SETTINGS_TEAM1_WIDOWMAKER_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM1_WIDOWMAKER_DAMAGE_RECEIVED_PERCENT,
                "enableInfiniteAmmo": true,
                "movementSpeed%": SETTINGS_TEAM1_WIDOWMAKER_MOVEMENT_SPEED_PERCENT,
                "ultGen%": ultGenPercent(WIDOWMAKER_ULT_COST, SET_AI_WIDOWMAKER_ULT_COST_TARGET)
            },
            "general": {
                "damageReceived%": SETTINGS_TEAM1_GENERAL_DAMAGE_RECEIVED_PERCENT,
                "abilityCooldown%": SETTINGS_TEAM1_GENERAL_ABILITY_COOLDOWN_PERCENT,
                "ultGen%": SETTINGS_TEAM1_GENERAL_ULT_GEN_PERCENT
            }
        },
        "team2": {
            "hanzo": {
                "damageDealt%": SETTINGS_TEAM2_HANZO_DAMAGE_DEALT_PERCENT,
                "ability2Cooldown%": ratioPercent(SET_PLAYER_HANZO_ABILITY2_COOLDOWN_TARGET, HANZO_STORM_COOLDOWN),

                "ultGen%": ultGenPercent(HANZO_ULT_COST, SET_PLAYER_HANZO_ULT_COST_TARGET),

                "projectileSpeed%": SETTINGS_TEAM2_HANZO_PROJECTILE_SPEED_PERCENT,
                "ability1Cooldown%": SETTINGS_TEAM2_HANZO_ABILITY1_COOLDOWN_PERCENT
            },
            "cassidy": {
                "damageDealt%": SETTINGS_TEAM2_CASSIDY_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_CASSIDY_DAMAGE_RECEIVED_PERCENT,
                "ultGen%": ultGenPercent(MCCREE_ULT_COST, SET_PLAYER_CASSIDY_ULT_COST_TARGET),

                "ability2Cooldown%": ratioPercent(SET_PLAYER_CASSIDY_ABILITY2_COOLDOWN_TARGET, MCCREE_FLASHBANG_COOLDOWN)
            },
            "lucio": {
                "passiveHealthRegen": false,
                "damageDealt%": SETTINGS_TEAM2_LUCIO_DAMAGE_DEALT_PERCENT,
                "healingDealt%": SETTINGS_TEAM2_LUCIO_HEALING_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_LUCIO_DAMAGE_RECEIVED_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM2_LUCIO_ABILITY2_COOLDOWN_PERCENT
            },
            "echo": {
                "damageDealt%": SETTINGS_TEAM2_ECHO_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_ECHO_DAMAGE_RECEIVED_PERCENT,
                "passiveUltGen%": SETTINGS_TEAM2_ECHO_PASSIVE_ULT_GEN_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM2_ECHO_ABILITY2_COOLDOWN_PERCENT,
                "secondaryFireCooldown%": SETTINGS_TEAM2_ECHO_SECONDARY_FIRE_COOLDOWN_PERCENT
            },
            "bastion": {
                "secondaryFireCooldown%": SETTINGS_TEAM2_BASTION_SECONDARY_FIRE_COOLDOWN_PERCENT,
                "damageDealt%": SETTINGS_TEAM2_BASTION_DAMAGE_DEALT_PERCENT,
                "ability1Cooldown%": ratioPercent(SET_PLAYER_BASTION_ABILITY1_COOLDOWN_TARGET, BASTION_RECONFIGURE_COOLDOWN),

                "damageReceived%": SETTINGS_TEAM2_BASTION_DAMAGE_RECEIVED_PERCENT
            },
            "soldier": {
                "damageDealt%": SETTINGS_TEAM2_SOLDIER_DAMAGE_DEALT_PERCENT,
                "ability2Cooldown%": ratioPercent(SET_PLAYER_SOLDIER_ABILITY2_COOLDOWN_TARGET, SOLDIER_BIOTIC_FIELD_COOLDOWN),

                "ultDuration%": SETTINGS_TEAM2_SOLDIER_ULT_DURATION_PERCENT,
                "secondaryFireKb%": SETTINGS_TEAM2_SOLDIER_SECONDARY_FIRE_KB_PERCENT
            },
            "mercy": {
                "passiveHealthRegen": false,
                "damageReceived%": SETTINGS_TEAM2_MERCY_DAMAGE_RECEIVED_PERCENT,
                "healingDealt%": SETTINGS_TEAM2_MERCY_HEALING_DEALT_PERCENT,
                "enablePassive": false,
                "ability1Cooldown%": SETTINGS_TEAM2_MERCY_ABILITY1_COOLDOWN_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM2_MERCY_ABILITY2_COOLDOWN_PERCENT
            },
            "orisa": {
                "damageReceived%": SETTINGS_TEAM2_ORISA_DAMAGE_RECEIVED_PERCENT,
                "projectileSpeed%": SETTINGS_TEAM2_ORISA_PROJECTILE_SPEED_PERCENT,
                "ability1Cooldown%": ratioPercent(SET_PLAYER_ORISA_ABILITY1_COOLDOWN_TARGET, ORISA_FORTIFY_COOLDOWN),

                "secondaryFireCooldown%": SETTINGS_TEAM2_ORISA_SECONDARY_FIRE_COOLDOWN_PERCENT,
                "enableInfiniteAmmo": true,
                "health%": SETTINGS_TEAM2_ORISA_HEALTH_PERCENT,
                "movementSpeed%": SETTINGS_TEAM2_ORISA_MOVEMENT_SPEED_PERCENT,
                "ultGen%": ultGenPercent(ORISA_ULT_COST, SET_PLAYER_ORISA_ULT_COST_TARGET)
            },
            "ana": {
                "passiveHealthRegen": false,
                "damageDealt%": SETTINGS_TEAM2_ANA_DAMAGE_DEALT_PERCENT,
                "healingDealt%": SETTINGS_TEAM2_ANA_HEALING_DEALT_PERCENT,
                "ability2Cooldown%": ratioPercent(SET_PLAYER_ANA_ABILITY2_COOLDOWN_TARGET, ANA_BIOTIC_GRENADE_COOLDOWN),

                "ultGen%": ultGenPercent(ANA_ULT_COST, SET_PLAYER_ANA_ULT_COST_TARGET),

                "ability1Cooldown%": ratioPercent(SET_PLAYER_ANA_ABILITY1_COOLDOWN_TARGET, ANA_SLEEP_DART_COOLDOWN_TIME)
            },
            "baptiste": {
                "passiveHealthRegen": false,
                "damageDealt%": SETTINGS_TEAM2_BAPTISTE_DAMAGE_DEALT_PERCENT,
                "ammoClipSize%": SETTINGS_TEAM2_BAPTISTE_AMMO_CLIP_SIZE_PERCENT,
                "ability1Cooldown%": ratioPercent(SET_PLAYER_BAPTISTE_ABILITY1_COOLDOWN_TARGET, BAPTISTE_REGEN_BURST_COOLDOWN),

                "healingDealt%": SETTINGS_TEAM2_BAPTISTE_HEALING_DEALT_PERCENT,
                "ultDuration%": SETTINGS_TEAM2_BAPTISTE_ULT_DURATION_PERCENT,
                "ability2Cooldown%": ratioPercent(SET_PLAYER_BAPTISTE_ABILITY2_COOLDOWN_TARGET, BAPTISTE_LAMP_COOLDOWN_TIME)
            },
            "brigitte": {
                "passiveHealthRegen": false,
                "damageDealt%": SETTINGS_TEAM2_BRIGITTE_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_BRIGITTE_DAMAGE_RECEIVED_PERCENT,
                "ability1Kb%": SETTINGS_TEAM2_BRIGITTE_ABILITY1_KB_PERCENT,
                "secondaryFireRechargeRate%": SETTINGS_TEAM2_BRIGITTE_SECONDARY_FIRE_RECHARGE_RATE_PERCENT,
                "secondaryFireCooldown%": SETTINGS_TEAM2_BRIGITTE_SECONDARY_FIRE_COOLDOWN_PERCENT,
                "ability2Cooldown%": ratioPercent(SET_PLAYER_BRIGITTE_ABILITY2_COOLDOWN_TARGET, BRIGITTE_REPAIR_PACK_COOLDOWN),

                "health%": SETTINGS_TEAM2_BRIGITTE_HEALTH_PERCENT,
                "healingDealt%": SETTINGS_TEAM2_BRIGITTE_HEALING_DEALT_PERCENT,
                "ultGen%": ultGenPercent(BRIGITTE_ULT_COST, SET_PLAYER_BRIGITTE_ULT_COST_TARGET),

                "shieldBashCooldown%": ratioPercent(SET_PLAYER_BRIGITTE_SHIELD_BASH_COOLDOWN_TARGET, BRIGITTE_SHIELD_BASH_COOLDOWN),

                "shieldBashKb%": ratioPercent(SET_PLAYER_BRIGITTE_SHIELD_BASH_KB_TARGET, BRIGITTE_SHIELD_BASH_KNOCKBACK)
            },
            "freja": {
                "damageDealt%": SETTINGS_TEAM2_FREJA_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_FREJA_DAMAGE_RECEIVED_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM2_FREJA_ABILITY2_COOLDOWN_PERCENT,
                "ability1Cooldown%": SETTINGS_TEAM2_FREJA_ABILITY1_COOLDOWN_PERCENT,
                "secondaryFireCooldown%": SETTINGS_TEAM2_FREJA_SECONDARY_FIRE_COOLDOWN_PERCENT,
                "secondaryFireDuration%": SETTINGS_TEAM2_FREJA_SECONDARY_FIRE_DURATION_PERCENT
            },
            "torbjorn": {
                "damageDealt%": SETTINGS_TEAM2_TORBJORN_DAMAGE_DEALT_PERCENT,
                "ammoClipSize%": SETTINGS_TEAM2_TORBJORN_AMMO_CLIP_SIZE_PERCENT,
                "combatUltGen%": SETTINGS_TEAM2_TORBJORN_COMBAT_ULT_GEN_PERCENT,
                "ultGen%": ultGenPercent(TORBJORN_ULT_COST, SET_PLAYER_TORBJORN_ULT_COST_TARGET),

                "ultDuration%": SETTINGS_TEAM2_TORBJORN_ULT_DURATION_PERCENT,
                "passiveUltGen%": SETTINGS_TEAM2_TORBJORN_PASSIVE_ULT_GEN_PERCENT
            },
            "ramattra": {
                "damageDealt%": SETTINGS_TEAM2_RAMATTRA_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_RAMATTRA_DAMAGE_RECEIVED_PERCENT,
                "ability2Cooldown%": ratioPercent(SET_PLAYER_RAMATTRA_ABILITY2_COOLDOWN_TARGET, RAMATTRA_VORTEX_COOLDOWN),

                "ability1Cooldown%": ratioPercent(SET_PLAYER_RAMATTRA_ABILITY1_COOLDOWN_TARGET, RAMATTRA_NEMESIS_COOLDOWN),

                "ultGen%": ultGenPercent(RAMATTRA_ULT_COST, SET_PLAYER_RAMATTRA_ULT_COST_TARGET),

                "ultDuration%": SETTINGS_TEAM2_RAMATTRA_ULT_DURATION_PERCENT,
                "secondaryFireCooldown%": ratioPercent(SET_PLAYER_RAMATTRA_SECONDARY_FIRE_COOLDOWN_TARGET, RAMATTRA_VOID_BARRIER_COOLDOWN)
            },
            "venture": {
                "damageDealt%": SETTINGS_TEAM2_VENTURE_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_VENTURE_DAMAGE_RECEIVED_PERCENT,
                "ability1Duration%": SETTINGS_TEAM2_VENTURE_ABILITY1_DURATION_PERCENT,
                "secondaryFireCooldown%": SETTINGS_TEAM2_VENTURE_SECONDARY_FIRE_COOLDOWN_PERCENT,
                "ultGen%": ultGenPercent(VENTURE_ULT_COST, SET_PLAYER_VENTURE_ULT_COST_TARGET)
            },
            "emre": {
                "damageDealt%": SETTINGS_TEAM2_EMRE_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_EMRE_DAMAGE_RECEIVED_PERCENT,
                "ability1Cooldown%": SETTINGS_TEAM2_EMRE_ABILITY1_COOLDOWN_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM2_EMRE_ABILITY2_COOLDOWN_PERCENT
            },
            "vendetta": {
                "damageDealt%": SETTINGS_TEAM2_VENDETTA_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_VENDETTA_DAMAGE_RECEIVED_PERCENT,
                "ability1Cooldown%": SETTINGS_TEAM2_VENDETTA_ABILITY1_COOLDOWN_PERCENT,
                "ultGen%": SETTINGS_TEAM2_VENDETTA_ULT_GEN_PERCENT
            },
            "anran": {
                "damageDealt%": SETTINGS_TEAM2_ANRAN_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_ANRAN_DAMAGE_RECEIVED_PERCENT,
                "ability1Cooldown%": percent((ANRAN_PLAYER_ABILITY1_COOLDOWN_TARGET) / (ANRAN_INFERNO_RUSH_COOLDOWN)),
                "ability2Cooldown%": percent((ANRAN_PLAYER_ABILITY2_COOLDOWN_TARGET) / (ANRAN_DANCING_BLAZE_COOLDOWN))
            },
            "illari": {
                "passiveHealthRegen": false,
                "damageDealt%": SETTINGS_TEAM2_ILLARI_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_ILLARI_DAMAGE_RECEIVED_PERCENT,
                "solarEnergyRecharge%": SETTINGS_TEAM2_ILLARI_SOLAR_ENERGY_RECHARGE_PERCENT,
                "projectileSpeed%": SETTINGS_TEAM2_ILLARI_PROJECTILE_SPEED_PERCENT,
                "ability2Cooldown%": ratioPercent(SET_PLAYER_ILLARI_ABILITY2_COOLDOWN_TARGET, ILLARI_PYLON_COOLDOWN)
            },
            "juno": {
                "passiveHealthRegen": false,
                "healingDealt%": SETTINGS_TEAM2_JUNO_HEALING_DEALT_PERCENT,
                "ultGen%": ultGenPercent(JUNO_ULT_COST, SET_PLAYER_JUNO_ULT_COST_TARGET),

                "secondaryFireCooldown%": SETTINGS_TEAM2_JUNO_SECONDARY_FIRE_COOLDOWN_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM2_JUNO_ABILITY2_COOLDOWN_PERCENT
            },
            "doomfist": {
                "damageDealt%": SETTINGS_TEAM2_DOOMFIST_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_DOOMFIST_DAMAGE_RECEIVED_PERCENT,
                "ammoRegenerationTime%": ratioPercent(SET_PLAYER_DOOMFIST_AMMO_REGENERATION_TIME_TARGET, DOOMFIST_AMMO_REGEN),

                "ability1Cooldown%": ratioPercent(SET_PLAYER_DOOMFIST_ABILITY1_COOLDOWN_TARGET, DOOMFIST_POWER_BLOCK_COOLDOWN),

                "secondaryFireCooldown%": SETTINGS_TEAM2_DOOMFIST_SECONDARY_FIRE_COOLDOWN_PERCENT,
                "ability2Cooldown%": ratioPercent(SET_PLAYER_DOOMFIST_ABILITY2_COOLDOWN_TARGET, DOOMFIST_SEISMIC_SLAM_COOLDOWN)
            },
            "zarya": {
                "damageDealt%": SETTINGS_TEAM2_ZARYA_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_ZARYA_DAMAGE_RECEIVED_PERCENT,
                "ammoClipSize%": SETTINGS_TEAM2_ZARYA_AMMO_CLIP_SIZE_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM2_ZARYA_ABILITY2_COOLDOWN_PERCENT,
                "ability1Cooldown%": SETTINGS_TEAM2_ZARYA_ABILITY1_COOLDOWN_PERCENT,
                "ultGen%": ultGenPercent(ZARYA_ULT_COST, SET_PLAYER_ZARYA_ULT_COST_TARGET)
            },
            "reaper": {
                "damageDealt%": SETTINGS_TEAM2_REAPER_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_REAPER_DAMAGE_RECEIVED_PERCENT,
                "healingDealt%": SETTINGS_TEAM2_REAPER_HEALING_DEALT_PERCENT
            },
            "mauga": {
                "damageDealt%": SETTINGS_TEAM2_MAUGA_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_MAUGA_DAMAGE_RECEIVED_PERCENT,
                "ammoClipSize%": SETTINGS_TEAM2_MAUGA_AMMO_CLIP_SIZE_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM2_MAUGA_ABILITY2_COOLDOWN_PERCENT,
                "ability2Healing%": SETTINGS_TEAM2_MAUGA_ABILITY2_HEALING_PERCENT,
                "ultDuration%": SETTINGS_TEAM2_MAUGA_ULT_DURATION_PERCENT
            },
            "pharah": {
                "damageDealt%": SETTINGS_TEAM2_PHARAH_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_PHARAH_DAMAGE_RECEIVED_PERCENT,
                "passiveExtraFuel%": SETTINGS_TEAM2_PHARAH_PASSIVE_EXTRA_FUEL_PERCENT,
                "ability1Cooldown%": ratioPercent(SET_PLAYER_PHARAH_ABILITY1_COOLDOWN_TARGET, PHARAH_JUMP_JET_COOLDOWN),

                "ability1RefuelScalar": SETTINGS_TEAM2_PHARAH_ABILITY1_REFUEL_SCALAR,
                "ability2Cooldown%": ratioPercent(SET_PLAYER_PHARAH_ABILITY2_COOLDOWN_TARGET, PHARAH_CONCUSSIVE_BLAST_COOLDOWN)
            },
            "jetpackCat": {
                "damageDealt%": SETTINGS_TEAM2_JETPACK_CAT_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_JETPACK_CAT_DAMAGE_RECEIVED_PERCENT,
                "healingDealt%": SETTINGS_TEAM2_JETPACK_CAT_HEALING_DEALT_PERCENT,
                "ability1Cooldown%": SETTINGS_TEAM2_JETPACK_CAT_ABILITY1_COOLDOWN_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM2_JETPACK_CAT_ABILITY2_COOLDOWN_PERCENT
            },
            "junkerQueen": {
                "damageDealt%": SETTINGS_TEAM2_JUNKER_QUEEN_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_JUNKER_QUEEN_DAMAGE_RECEIVED_PERCENT,
                "ability1Cooldown%": SETTINGS_TEAM2_JUNKER_QUEEN_ABILITY1_COOLDOWN_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM2_JUNKER_QUEEN_ABILITY2_COOLDOWN_PERCENT,
                "secondaryFireCooldown%": SETTINGS_TEAM2_JUNKER_QUEEN_SECONDARY_FIRE_COOLDOWN_PERCENT,
                "ultGen%": SETTINGS_TEAM2_JUNKER_QUEEN_ULT_GEN_PERCENT
            },
            "winston": {
                "damageDealt%": SETTINGS_TEAM2_WINSTON_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_WINSTON_DAMAGE_RECEIVED_PERCENT,
                "ability2Cooldown%": ratioPercent(SET_PLAYER_WINSTON_ABILITY2_COOLDOWN_TARGET, WINSTON_BARRIER_COOLDOWN)
            },
            "genji": {
                "damageDealt%": SETTINGS_TEAM2_GENJI_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_GENJI_DAMAGE_RECEIVED_PERCENT,
                "ability1Cooldown%": SETTINGS_TEAM2_GENJI_ABILITY1_COOLDOWN_PERCENT,
                "enableInfiniteAmmo": true,
                "ultDuration%": SETTINGS_TEAM2_GENJI_ULT_DURATION_PERCENT,
                "ultGen%": ultGenPercent(GENJI_ULT_COST, SET_PLAYER_GENJI_ULT_COST_TARGET),

                "ability2Cooldown%": ratioPercent(SET_PLAYER_GENJI_ABILITY2_COOLDOWN_TARGET, GENJI_DEFLECT_COOLDOWN)
            },
            "junkrat": {
                "damageDealt%": SETTINGS_TEAM2_JUNKRAT_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_JUNKRAT_DAMAGE_RECEIVED_PERCENT,
                "combatUltGen%": SETTINGS_TEAM2_JUNKRAT_COMBAT_ULT_GEN_PERCENT,
                "primaryFireKb%": SETTINGS_TEAM2_JUNKRAT_PRIMARY_FIRE_KB_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM2_JUNKRAT_ABILITY2_COOLDOWN_PERCENT,
                "ultGen%": ultGenPercent(JUNKRAT_ULT_COST, SET_PLAYER_JUNKRAT_ULT_COST_TARGET),

                "ultDuration%": SETTINGS_TEAM2_JUNKRAT_ULT_DURATION_PERCENT,
                "passiveUltGen%": SETTINGS_TEAM2_JUNKRAT_PASSIVE_ULT_GEN_PERCENT,
                "ability1Kb%": SETTINGS_TEAM2_JUNKRAT_ABILITY1_KB_PERCENT
            },
            "tracer": {
                "damageDealt%": SETTINGS_TEAM2_TRACER_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_TRACER_DAMAGE_RECEIVED_PERCENT,
                "ultGen%": ultGenPercent(TRACER_ULT_COST, SET_PLAYER_TRACER_ULT_COST_TARGET),

                "ability2Cooldown%": ratioPercent(SET_PLAYER_TRACER_ABILITY2_COOLDOWN_TARGET, TRACER_RECALL_COOLDOWN),

                "ability1Cooldown%": SETTINGS_TEAM2_TRACER_ABILITY1_COOLDOWN_PERCENT
            },
            "zenyatta": {
                "passiveHealthRegen": false,
                "damageDealt%": SETTINGS_TEAM2_ZENYATTA_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_ZENYATTA_DAMAGE_RECEIVED_PERCENT,
                "ultGen%": ultGenPercent(ZENYATTA_ULT_COST, SET_PLAYER_ZENYATTA_ULT_COST_TARGET),

                "projectileSpeed%": SETTINGS_TEAM2_ZENYATTA_PROJECTILE_SPEED_PERCENT
            },
            "symmetra": {
                "ability2Cooldown%": SETTINGS_TEAM2_SYMMETRA_ABILITY2_COOLDOWN_PERCENT,
                "damageDealt%": SETTINGS_TEAM2_SYMMETRA_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_SYMMETRA_DAMAGE_RECEIVED_PERCENT,
                "ability1Cooldown%": SETTINGS_TEAM2_SYMMETRA_ABILITY1_COOLDOWN_PERCENT,
                "ammoClipSize%": SETTINGS_TEAM2_SYMMETRA_AMMO_CLIP_SIZE_PERCENT
            },
            "sojourn": {
                "damageDealt%": SETTINGS_TEAM2_SOJOURN_DAMAGE_DEALT_PERCENT,
                "secondaryFireEnergyChargeRate%": SETTINGS_TEAM2_SOJOURN_SECONDARY_FIRE_ENERGY_CHARGE_RATE_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM2_SOJOURN_ABILITY2_COOLDOWN_PERCENT
            },
            "mei": {
                "damageDealt%": SETTINGS_TEAM2_MEI_DAMAGE_DEALT_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM2_MEI_ABILITY2_COOLDOWN_PERCENT,
                "primaryFireFreezeDuration%": SETTINGS_TEAM2_MEI_PRIMARY_FIRE_FREEZE_DURATION_PERCENT,
                "primaryFireFreezeRate%": SETTINGS_TEAM2_MEI_PRIMARY_FIRE_FREEZE_RATE_PERCENT,
                "primaryFireFreezeMinimum%": SETTINGS_TEAM2_MEI_PRIMARY_FIRE_FREEZE_MINIMUM_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_MEI_DAMAGE_RECEIVED_PERCENT,
                "ammoClipSize%": SETTINGS_TEAM2_MEI_AMMO_CLIP_SIZE_PERCENT,
                "ability1Cooldown%": SETTINGS_TEAM2_MEI_ABILITY1_COOLDOWN_PERCENT
            },
            "ashe": {
                "damageDealt%": SETTINGS_TEAM2_ASHE_DAMAGE_DEALT_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM2_ASHE_ABILITY2_COOLDOWN_PERCENT,
                "ammoClipSize%": SETTINGS_TEAM2_ASHE_AMMO_CLIP_SIZE_PERCENT,
                "ability1Cooldown%": SETTINGS_TEAM2_ASHE_ABILITY1_COOLDOWN_PERCENT,
                "ultDuration%": SETTINGS_TEAM2_ASHE_ULT_DURATION_PERCENT
            },
            "moira": {
                "passiveHealthRegen": false,
                "damageDealt%": SETTINGS_TEAM2_MOIRA_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_MOIRA_DAMAGE_RECEIVED_PERCENT,
                "healingDealt%": SETTINGS_TEAM2_MOIRA_HEALING_DEALT_PERCENT,
                "ability2MaxDamage%": SETTINGS_TEAM2_MOIRA_ABILITY2_MAX_DAMAGE_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM2_MOIRA_ABILITY2_COOLDOWN_PERCENT,
                "ability2MaxHealing%": SETTINGS_TEAM2_MOIRA_ABILITY2_MAX_HEALING_PERCENT,
                "primaryFireMaximumTime%": SETTINGS_TEAM2_MOIRA_PRIMARY_FIRE_MAXIMUM_TIME_PERCENT,
                "ultGen%": ultGenPercent(MOIRA_ULT_COST, SET_PLAYER_MOIRA_ULT_COST_TARGET)
            },
            "reinhardt": {
                "damageDealt%": SETTINGS_TEAM2_REINHARDT_DAMAGE_DEALT_PERCENT,
                "ability1Cooldown%": ratioPercent(SET_PLAYER_REINHARDT_ABILITY1_COOLDOWN_TARGET, REINHARDT_CHARGE_COOLDOWN_TIME),
                "damageReceived%": SETTINGS_TEAM2_REINHARDT_DAMAGE_RECEIVED_PERCENT,
                "secondaryFireRechargeRate%": ratioPercent(SET_PLAYER_REINHARDT_SECONDARY_FIRE_RECHARGE_RATE_TARGET, REINHARDT_BARRIER_REGEN),
                "combatUltGen%": SETTINGS_TEAM2_REINHARDT_COMBAT_ULT_GEN_PERCENT,
                "health%": ratioPercent(SET_PLAYER_REINHARDT_HEALTH_TARGET, REINHARDT_BARRIER_HEALTH),
                "ultGen%": ultGenPercent(REINHARDT_ULT_COST, SET_PLAYER_REINHARDT_ULT_COST_TARGET),
                "passiveUltGen%": SETTINGS_TEAM2_REINHARDT_PASSIVE_ULT_GEN_PERCENT
            },
            "sierra": {
                "damageDealt%": SETTINGS_TEAM2_SIERRA_DAMAGE_DEALT_PERCENT,
                "ability1Cooldown%": SETTINGS_TEAM2_SIERRA_ABILITY1_COOLDOWN_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_SIERRA_DAMAGE_RECEIVED_PERCENT,
                "secondaryFireCooldown%": SETTINGS_TEAM2_SIERRA_SECONDARY_FIRE_COOLDOWN_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM2_SIERRA_ABILITY2_COOLDOWN_PERCENT
            },
            "sigma": {
                "damageDealt%": SETTINGS_TEAM2_SIGMA_DAMAGE_DEALT_PERCENT,
                "ability1Cooldown%": SETTINGS_TEAM2_SIGMA_ABILITY1_COOLDOWN_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_SIGMA_DAMAGE_RECEIVED_PERCENT,
                "secondaryFireRechargeRate%": SETTINGS_TEAM2_SIGMA_SECONDARY_FIRE_RECHARGE_RATE_PERCENT,
                "health%": ratioPercent(SET_PLAYER_SIGMA_HEALTH_TARGET, SIGMA_BARRIER_HEALTH),

                "ultGen%": ultGenPercent(SIGMA_ULT_COST, SET_PLAYER_SIGMA_ULT_COST_TARGET),

                "ability2Cooldown%": SETTINGS_TEAM2_SIGMA_ABILITY2_COOLDOWN_PERCENT
            },
            "roadhog": {
                "damageDealt%": SETTINGS_TEAM2_ROADHOG_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_ROADHOG_DAMAGE_RECEIVED_PERCENT,
                "secondaryFireCooldown%": SETTINGS_TEAM2_ROADHOG_SECONDARY_FIRE_COOLDOWN_PERCENT,
                "ability1Cooldown%": ratioPercent(SET_PLAYER_ROADHOG_ABILITY1_COOLDOWN_TARGET, ROADHOG_HOOK_COOLDOWN_TIME)
            },
            "kiriko": {
                "passiveHealthRegen": false,
                "ability1Distance%": SETTINGS_TEAM2_KIRIKO_ABILITY1_DISTANCE_PERCENT,
                "damageDealt%": SETTINGS_TEAM2_KIRIKO_DAMAGE_DEALT_PERCENT,
                "healingDealt%": SETTINGS_TEAM2_KIRIKO_HEALING_DEALT_PERCENT,
                "ability2Cooldown%": ratioPercent(SET_PLAYER_KIRIKO_ABILITY2_COOLDOWN_TARGET, KIRIKO_SUZU_COOLDOWN),

                "ultGen%": ultGenPercent(KIRIKO_ULT_COST, SET_PLAYER_KIRIKO_ULT_COST_TARGET)
            },
            "mizuki": {
                "damageDealt%": SETTINGS_TEAM2_MIZUKI_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_MIZUKI_DAMAGE_RECEIVED_PERCENT,
                "ability1Cooldown%": SETTINGS_TEAM2_MIZUKI_ABILITY1_COOLDOWN_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM2_MIZUKI_ABILITY2_COOLDOWN_PERCENT,
                "secondaryFireCooldown%": SETTINGS_TEAM2_MIZUKI_SECONDARY_FIRE_COOLDOWN_PERCENT,
                "ultGen%": SETTINGS_TEAM2_MIZUKI_ULT_GEN_PERCENT
            },
            "hazard": {
                "damageDealt%": SETTINGS_TEAM2_HAZARD_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_HAZARD_DAMAGE_RECEIVED_PERCENT,
                "secondaryFireCost%": SETTINGS_TEAM2_HAZARD_SECONDARY_FIRE_COST_PERCENT,
                "combatUltGen%": SETTINGS_TEAM2_HAZARD_COMBAT_ULT_GEN_PERCENT,
                "passiveUltGen%": SETTINGS_TEAM2_HAZARD_PASSIVE_ULT_GEN_PERCENT
            },
            "domina": {
                "damageDealt%": DOMINA_DAMAGE_DEALT_PERCENT,
                "damageReceived%": DOMINA_PLAYER_DAMAGE_RECEIVED_PERCENT,
                "ability1Cooldown%": ratioPercent(DOMINA_SONIC_REPULSORS_COOLDOWN, OW2_DOMINA_SONIC_REPULSORS_COOLDOWN),
                "ability2Cooldown%": ratioPercent(DOMINA_CRYSTAL_CHARGE_COOLDOWN, OW2_DOMINA_CRYSTAL_CHARGE_COOLDOWN),
                "secondaryFireCooldown%": ratioPercent(DOMINA_BARRIER_ARRAY_COOLDOWN, OW2_DOMINA_BARRIER_ARRAY_COOLDOWN)
            },
            "sombra": {
                "damageDealt%": SETTINGS_TEAM2_SOMBRA_DAMAGE_DEALT_PERCENT,
                "ability2Cooldown%": SETTINGS_TEAM2_SOMBRA_ABILITY2_COOLDOWN_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_SOMBRA_DAMAGE_RECEIVED_PERCENT,
                "passiveUltGen%": SETTINGS_TEAM2_SOMBRA_PASSIVE_ULT_GEN_PERCENT,
                "secondaryFireCooldown%": ratioPercent(SET_PLAYER_SOMBRA_SECONDARY_FIRE_COOLDOWN_TARGET, SOMBRA_HACK_COOLDOWN_TIME)
            },
            "widowmaker": {
                "damageDealt%": SETTINGS_TEAM2_WIDOWMAKER_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_TEAM2_WIDOWMAKER_DAMAGE_RECEIVED_PERCENT,
                "ammoClipSize%": SETTINGS_TEAM2_WIDOWMAKER_AMMO_CLIP_SIZE_PERCENT,
                "ultGen%": ultGenPercent(WIDOWMAKER_ULT_COST, SET_PLAYER_WIDOWMAKER_ULT_COST_TARGET)
            },
            "general": {
                "ultGen%": SETTINGS_TEAM2_GENERAL_ULT_GEN_PERCENT,
            }
        },
        "allTeams": {
            "dva": {
                "damageDealt%": SETTINGS_ALL_TEAMS_DVA_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_ALL_TEAMS_DVA_DAMAGE_RECEIVED_PERCENT,
                "ability1Cooldown%": ratioPercent(DVA_BOOSTER_COOLDOWN_TIME, DVA_BOOSTER_COOLDOWN_TIME_RAW),

                "ability2Cooldown%": ratioPercent(DVA_MICRO_MISSILES_COOLDOWN_TIME, DVA_MICRO_MISSILES_COOLDOWN_TIME_RAW),

                "secondaryFireRechargeRate%": SETTINGS_ALL_TEAMS_DVA_SECONDARY_FIRE_RECHARGE_RATE_PERCENT,
                "secondaryFireMaximumTime%": ratioPercent(DVA_MATRIX_DURATION, DVA_MATRIX_DURATION_RAW)
            },
            "lifeweaver": {
                "healingDealt%": SETTINGS_ALL_TEAMS_LIFEWEAVER_HEALING_DEALT_PERCENT,
                "passiveHealthRegen": false,
                "enableInfiniteAmmo": false,
                "ability2Cooldown%": SETTINGS_ALL_TEAMS_LIFEWEAVER_ABILITY2_COOLDOWN_PERCENT,
                "primaryFireRange%": SETTINGS_ALL_TEAMS_LIFEWEAVER_PRIMARY_FIRE_RANGE_PERCENT,
                "secondaryFireCooldown%": SETTINGS_ALL_TEAMS_LIFEWEAVER_SECONDARY_FIRE_COOLDOWN_PERCENT
            },
            "wreckingBall": {
                "damageDealt%": SETTINGS_ALL_TEAMS_WRECKING_BALL_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SETTINGS_ALL_TEAMS_WRECKING_BALL_DAMAGE_RECEIVED_PERCENT,
                "secondaryFireCooldown%": SETTINGS_ALL_TEAMS_WRECKING_BALL_SECONDARY_FIRE_COOLDOWN_PERCENT,
                "ability2Cooldown%": SETTINGS_ALL_TEAMS_WRECKING_BALL_ABILITY2_COOLDOWN_PERCENT,
                "ability3Cooldown%": SETTINGS_ALL_TEAMS_WRECKING_BALL_ABILITY3_COOLDOWN_PERCENT
            },
            "disabledHeroes": [
                "bastion"
            ]
        }
    },
    "workshop": {
        "诛 （终极技能）额外造成伤害 %": 0,
        "半藏：暴击倍率": 275.000,
		"巴蒂斯特：暴击倍率": 250.000,
		"帕拉蒂尼之牙：暴击对护甲造成额外最大生命值伤害 %": 20,
		"帕拉蒂尼之牙：暴击造成额外最大生命值伤害 %": 10,
		"心脏过载：额外伤害减免": 25.000,
		"恐怖扳机：冷却时间": 1.500,
		"恐怖扳机：基于灵魂层数造成流血伤害": 1.000,
		"悍猛格挡：伤害吸收倍率": 4.000,
		"收割：每层灵魂减少技能冷却": 0.100,
		"斩地巨剑：击倒持续时间": 3.500,
		"无影脚击退距离": 15.500,
		"桎梏灼日 额外伤害增幅 %": 5.000,
		"激活持续时间": 8.000,
		"灾厄馈赠（被动）：基于受到伤害获得终极技能充能 %": 4.000,
		"禅雅塔：暴击倍率（以下实际数值将被除以100）": 250.000,
		"自定义 AI": [3],
		"艾什：暴击倍率": 275.000,
		"雾子：暴击倍率": 250.000
    }
}
