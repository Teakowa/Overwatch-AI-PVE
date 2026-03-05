

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
                "ability2Quantity%": 6,
                "ability3Cooldown%": 50,
                "damageDealt%": 110,
                "projectileSpeed%": 135,
                "projectileGravity%": 0,
                "ultGen%": ultGenPercent(HANZO_ULT_COST, SET_AI_HANZO_ULT_COST_TARGET)
            },
            "cassidy": {
                "damageDealt%": 110,
                "damageReceived%": 70,
                "ability2Cooldown%": ratioPercent(SET_AI_CASSIDY_ABILITY2_COOLDOWN_TARGET, MCCREE_FLASHBANG_COOLDOWN)
            },
            "lucio": {
                "damageDealt%": 105,
                "damageReceived%": 70,
                "healingReceived%": 140,
                "ability2Cooldown%": 65,
                "enableInfiniteAmmo": true,
                "healingDealt%": 233,
                "ultGen%": ultGenPercent(LUCIO_ULT_COST, SET_AI_LUCIO_ULT_COST_TARGET)
            },
            "soldier": {
                "damageDealt%": 115,
                "enableInfiniteAmmo": true,
                "ability2Cooldown%": ratioPercent(SET_AI_SOLDIER_ABILITY2_COOLDOWN_TARGET, SOLDIER_BIOTIC_FIELD_COOLDOWN),

                "ultDuration%": 134,
                "secondaryFireCooldown%": 67,
                "secondaryFireKb%": 120
            },
            "mercy": {
                "damageDealt%": 200,
                "damageReceived%": 35,
                "projectileSpeed%": 150,
                "ability1Cooldown%": 0,
                "enableInfiniteAmmo": true,
                "healingDealt%": 193,
                "ability2Cooldown%": 0
            },
            "orisa": {
                "damageReceived%": 60,
                "projectileSpeed%": 130,
                "ability1Cooldown%": ratioPercent(SET_AI_ORISA_ABILITY1_COOLDOWN_TARGET, ORISA_FORTIFY_COOLDOWN),

                "secondaryFireCooldown%": 117,
                "projectileGravity%": 0,
                "enableInfiniteAmmo": true,
                "ability2Cooldown%": 75,
                "health%": 100,
                "movementSpeed%": 105,
                "ultGen%": ultGenPercent(ORISA_ULT_COST, SET_AI_ORISA_ULT_COST_TARGET)
            },
            "ana": {
                "enableInfiniteAmmo": true,
                "healingDealt%": 190,
                "ultGen%": ultGenPercent(ANA_ULT_COST, SET_AI_ANA_ULT_COST_TARGET),

                "enableSpawningWithUlt": true,
                "ability1Cooldown%": ratioPercent(SET_AI_ANA_ABILITY1_COOLDOWN_TARGET, ANA_SLEEP_DART_COOLDOWN_TIME)
            },
            "baptiste": {
                "damageDealt%": 125,
                "ability1Cooldown%": ratioPercent(SET_AI_BAPTISTE_ABILITY1_COOLDOWN_TARGET, BAPTISTE_REGEN_BURST_COOLDOWN),

                "enableInfiniteAmmo": true,
                "healingDealt%": 175,
                "ultDuration%": 200,
                "ability2Cooldown%": ratioPercent(SET_AI_BAPTISTE_ABILITY2_COOLDOWN_TARGET, BAPTISTE_LAMP_COOLDOWN_TIME)
            },
            "brigitte": {
                "damageDealt%": 115,
                "damageReceived%": 50,
                "healingReceived%": 140,
                "ability1Kb%": 125,
                "secondaryFireRechargeRate%": 118,
                "secondaryFireCooldown%": 100,
                "healingDealt%": 165,
                "health%": 100,
                "ultGen%": ultGenPercent(BRIGITTE_ULT_COST, SET_AI_BRIGITTE_ULT_COST_TARGET),

                "shieldBashKb%": ratioPercent(SET_AI_BRIGITTE_SHIELD_BASH_KB_TARGET, BRIGITTE_SHIELD_BASH_KNOCKBACK)
            },
            "freja": {
                "damageDealt%": 120,
                "damageReceived%": 80,
                "ability2Cooldown%": 62,
                "ability2Height%": 120,
                "ability1Cooldown%": 78,
                "ability1Distance%": 120,
                "secondaryFireCooldown%": 75,
                "secondaryFireDuration%": 200
            },
            "torbjorn": {
                "damageDealt%": 115,
                "damageReceived%": 60,
                "projectileSpeed%": 200,
                "ability2Cooldown%": 50,
                "ability2Duration%": 150,
                "ability1Cooldown%": 0,
                "combatUltGen%": 148,
                "ultGen%": ultGenPercent(TORBJORN_ULT_COST, SET_AI_TORBJORN_ULT_COST_TARGET),

                "ultDuration%": 150,
                "passiveUltGen%": 148,
                "enableInfiniteAmmo": true
            },
            "ramattra": {
                "damageDealt%": 105,
                "damageReceived%": 65,
                "ability2Cooldown%": ratioPercent(SET_AI_RAMATTRA_ABILITY2_COOLDOWN_TARGET, RAMATTRA_VORTEX_COOLDOWN),

                "ability1Cooldown%": ratioPercent(SET_AI_RAMATTRA_ABILITY1_COOLDOWN_TARGET, RAMATTRA_NEMESIS_COOLDOWN),

                "enableInfiniteAmmo": true,
                "ultGen%": ultGenPercent(RAMATTRA_ULT_COST, SET_AI_RAMATTRA_ULT_COST_TARGET),

                "ultDuration%": 500,
                "secondaryFireCooldown%": ratioPercent(SET_AI_RAMATTRA_SECONDARY_FIRE_COOLDOWN_TARGET, RAMATTRA_VOID_BARRIER_COOLDOWN)
            },
            "venture": {
                "damageDealt%": 125,
                "damageReceived%": 55,
                "ultGen%": ultGenPercent(VENTURE_ULT_COST, SET_AI_VENTURE_ULT_COST_TARGET),

                "ability1Duration%": 300,
                "secondaryFireCooldown%": 63
            },
            "emre": {
                "damageDealt%": 125,
                "damageReceived%": 90,
                "ability1Cooldown%": 73,
                "ability1Duration%": 160,
                "ability1Heat%": 200,
                "ability2Cooldown%": 60
            },
            "vendetta": {
                "damageDealt%": 135,
                "damageReceived%": 45,
                "healingReceived%": 165,
                "ultGen%": 126
            },
            "anran": {
                "damageDealt%": 125,
                "damageReceived%": 70,
                "ability1Cooldown%": 75,
                "ability2Cooldown%": 75
            },
            "wuyang": {
                "passiveHealthRegen": false,
                "secondaryFireRechargeRate%": 80,
                "secondaryFireCost%": 136,
                "ability2Cooldown%": 83,
                "ability1Cooldown%": 86
            },
            "illari": {
                "damageDealt%": 250,
                "healingDealt%": 125,
                "damageReceived%": 70,
                "solarEnergyRecharge%": 200,
                "projectileSpeed%": 200,
                "ability2Cooldown%": ratioPercent(SET_AI_ILLARI_ABILITY2_COOLDOWN_TARGET, ILLARI_PYLON_COOLDOWN),

                "enableInfiniteAmmo": true
            },
            "juno": {
                "healingDealt%": 145,
                "damageDealt%": 125,
                "damageReceived%": 60,
                "ultGen%": ultGenPercent(JUNO_ULT_COST, SET_AI_JUNO_ULT_COST_TARGET),

                "secondaryFireCooldown%": 80,
                "ability2Cooldown%": 86
            },
            "doomfist": {
                "damageDealt%": 120,
                "damageReceived%": 40,
                "ammoRegenerationTime%": ratioPercent(SET_AI_DOOMFIST_AMMO_REGENERATION_TIME_TARGET, DOOMFIST_AMMO_REGEN),

                "enableInfiniteAmmo": true
            },
            "zarya": {
                "damageDealt%": 115,
                "damageReceived%": 50,
                "ability2Cooldown%": 67,
                "enableInfiniteAmmo": true,
                "ability1Cooldown%": 55,
                "ultGen%": ultGenPercent(ZARYA_ULT_COST, SET_AI_ZARYA_ULT_COST_TARGET)
            },
            "reaper": {
                "damageDealt%": 110,
                "damageReceived%": 50,
                "enableInfiniteAmmo": true,
                "healingDealt%": 350
            },
            "mauga": {
                "damageDealt%": 110,
                "damageReceived%": 50,
                "ability2Cooldown%": 59,
                "ability2Healing%": 400,
                "enableInfiniteAmmo": true,
                "ultDuration%": 188,
                "primaryFireIgniteDuration": 150,
                "primaryFireIgniteRate": 150
            },
            "pharah": {
                "damageDealt%": 125,
                "damageReceived%": 75,
                "passiveExtraFuel%": 200,
                "ability1Cooldown%": ratioPercent(SET_AI_PHARAH_ABILITY1_COOLDOWN_TARGET, PHARAH_JUMP_JET_COOLDOWN),

                "ability1RefuelScalar": 300,
                "secondaryFireCooldown%": 67,
                "ability2Cooldown%": ratioPercent(SET_AI_PHARAH_ABILITY2_COOLDOWN_TARGET, PHARAH_CONCUSSIVE_BLAST_COOLDOWN)
            },
            "jetpackCat": {
                "damageDealt%": 125,
                "damageReceived%": 65,
                "healingDealt%": 150,
                "ability1Cooldown%": 50,
                "ability2Cooldown%": 50
            },
            "junkerQueen": {
                "damageDealt%": 110,
                "damageReceived%": 60,
                "ability1Cooldown%": 57,
                "ability2Cooldown%": 75,
                "secondaryFireCooldown%": 67
            },
            "winston": {
                "damageDealt%": 150,
                "damageReceived%": 20,
                "ability1Cooldown%": ratioPercent(SET_AI_WINSTON_ABILITY1_COOLDOWN_TARGET, WINSTON_JUMP_PACK_COOLDOWN_TIME),

                "ability2Cooldown%": ratioPercent(SET_AI_WINSTON_ABILITY2_COOLDOWN_TARGET, WINSTON_BARRIER_COOLDOWN),

                "enableInfiniteAmmo": true
            },
            "genji": {
                "damageDealt%": 105,
                "damageReceived%": 60,
                "healingReceived%": 150,
                "enableInfiniteAmmo": true,
                "ultDuration%": 134,
                "ultGen%": ultGenPercent(GENJI_ULT_COST, SET_AI_GENJI_ULT_COST_TARGET)
            },
            "junkrat": {
                "damageDealt%": 125,
                "ability2Cooldown%": 50,
                "enableInfiniteAmmo": true,
                "ability1Cooldown%": ratioPercent(SET_AI_JUNKRAT_ABILITY1_COOLDOWN_TARGET, JUNKRAT_CONCUSSION_MINE_COOLDOWN)
            },
            "tracer": {
                "damageDealt%": 115,
                "damageReceived%": 50,
                "projectileSpeed%": 120,
                "ultGen%": ultGenPercent(TRACER_ULT_COST, SET_AI_TRACER_ULT_COST_TARGET),

                "ability2Cooldown%": ratioPercent(SET_AI_TRACER_ABILITY2_COOLDOWN_TARGET, TRACER_RECALL_COOLDOWN),

                "ability1Cooldown%": 60
            },
            "zenyatta": {
                "damageDealt%": 110,
                "healingReceived%": 150,
                "ultGen%": ultGenPercent(ZENYATTA_ULT_COST, SET_AI_ZENYATTA_ULT_COST_TARGET),

                "projectileSpeed%": 150,
                "enableInfiniteAmmo": true,
                "healingDealt%": 200
            },
            "symmetra": {
                "projectileSpeed%": 200,
                "ability2Cooldown%": 0,
                "damageDealt%": 120,
                "damageReceived%": 50,
                "ability1Cooldown%": 30,
                "enableInfiniteAmmo": true
            },
            "sojourn": {
                "secondaryFireEnergyChargeRate%": 200,
                "damageReceived%": 68,
                "ability2Cooldown%": 54,
                "projectileSpeed%": 130
            },
            "mei": {
                "damageDealt%": 115,
                "ability2Cooldown%": 50,
                "primaryFireFreezeDuration%": 138,
                "damageReceived%": 50,
                "ability1Cooldown%": 57,
                "enableInfiniteAmmo": true,
                "healingDealt%": 150
            },
            "ashe": {
                "damageDealt%": 115,
                "ability2Cooldown%": 66,
                "ability2FuseTime%": 35,
                "enableInfiniteAmmo": true,
                "ability1Cooldown%": 80,
                "ultDuration%": 200
            },
            "moira": {
                "damageDealt%": 145,
                "damageReceived%": 50,
                "healingReceived%": 200,
                "healingDealt%": 200,
                "ability2MaxDamage%": 500,
                "ability2Cooldown%": 75,
                "ability2MaxHealing%": 500,
                "primaryFireRechargeRate%": 500,
                "ultGen%": ultGenPercent(MOIRA_ULT_COST, SET_AI_MOIRA_ULT_COST_TARGET)
            },
            "reinhardt": {
                "ability1Cooldown%": ratioPercent(SET_AI_REINHARDT_ABILITY1_COOLDOWN_TARGET, REINHARDT_CHARGE_COOLDOWN_TIME),

                "damageReceived%": 60,
                "secondaryFireRechargeRate%": ratioPercent(SET_AI_REINHARDT_SECONDARY_FIRE_RECHARGE_RATE_TARGET, REINHARDT_BARRIER_REGEN),

                "combatUltGen%": 165,
                "health%": ratioPercent(SET_AI_REINHARDT_HEALTH_TARGET, REINHARDT_BARRIER_HEALTH)
            },
            "sigma": {
                "ability1Cooldown%": 67,
                "damageReceived%": 60,
                "secondaryFireRechargeRate%": 350,
                "health%": ratioPercent(SET_AI_SIGMA_HEALTH_TARGET, SIGMA_BARRIER_HEALTH),

                "ability2Cooldown%": 80
            },
            "roadhog": {
                "damageReceived%": 30,
                "secondaryFireRechargeRate%": 150,
                "enableInfiniteAmmo": true,
                "healingDealt%": 150,
                "movementSpeed%": 105
            },
            "kiriko": {
                "ability1Distance%": 300,
                "damageDealt%": 120,
                "projectileSpeed%": 115,
                "healingDealt%": 180,
                "ability2Cooldown%": ratioPercent(SET_AI_KIRIKO_ABILITY2_COOLDOWN_TARGET, KIRIKO_SUZU_COOLDOWN),

                "ultGen%": ultGenPercent(KIRIKO_ULT_COST, SET_AI_KIRIKO_ULT_COST_TARGET)
            },
            "mizuki": {
                "damageDealt%": 125,
                "damageReceived%": 80,
                "ability1Cooldown%": 80,
                "ability2Cooldown%": 60,
                "secondaryFireCooldown%": 50,
                "ultGen%": 129
            },
            "hazard": {
                "damageDealt%": 115,
                "damageReceived%": 50,
                "secondaryFireRegen%": 150,
                "secondaryFireCost%": 50,
                "combatUltGen%": 0,
                "passiveUltGen%": 0
            },
            "domina": {
                "damageDealt%": SET_DOMINA_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SET_AI_DOMINA_DAMAGE_RECEIVED_PERCENT,
                "ability1Cooldown%": ratioPercent(SET_AI_DOMINA_ABILITY1_COOLDOWN_TARGET, DOMINA_CRYSTAL_CHARGE_COOLDOWN),
                "ability2Cooldown%": ratioPercent(SET_AI_DOMINA_ABILITY2_COOLDOWN_TARGET, DOMINA_BARRIER_ARRAY_COOLDOWN),
                "secondaryFireCooldown%": ratioPercent(SET_AI_DOMINA_SECONDARY_FIRE_COOLDOWN_TARGET, DOMINA_SONIC_REPULSORS_COOLDOWN)
            },
            "sombra": {
                "damageDealt%": 110,
                "damageReceived%": 70,
                "healingReceived%": 125,
                "enableInfiniteAmmo": false,
                "passiveUltGen%": 149,
                "secondaryFireCooldown%": ratioPercent(SET_AI_SOMBRA_SECONDARY_FIRE_COOLDOWN_TARGET, SOMBRA_HACK_COOLDOWN_TIME),

                "ammoClipSize%": 125
            },
            "widowmaker": {
                "damageDealt%": 165,
                "damageReceived%": 70,
                "enableInfiniteAmmo": true,
                "movementSpeed%": 102,
                "ultGen%": ultGenPercent(WIDOWMAKER_ULT_COST, SET_AI_WIDOWMAKER_ULT_COST_TARGET)
            },
            "general": {
                "damageReceived%": 80,
                "abilityCooldown%": 70,
                "ultGen%": 115
            }
        },
        "team2": {
            "hanzo": {
                "damageDealt%": 125,
                "ability2Cooldown%": ratioPercent(SET_PLAYER_HANZO_ABILITY2_COOLDOWN_TARGET, HANZO_STORM_COOLDOWN),

                "ultGen%": ultGenPercent(HANZO_ULT_COST, SET_PLAYER_HANZO_ULT_COST_TARGET),

                "projectileSpeed%": 135,
                "ability1Cooldown%": 75
            },
            "cassidy": {
                "damageDealt%": 125,
                "damageReceived%": 92,
                "ultGen%": ultGenPercent(MCCREE_ULT_COST, SET_PLAYER_CASSIDY_ULT_COST_TARGET),

                "ability2Cooldown%": ratioPercent(SET_PLAYER_CASSIDY_ABILITY2_COOLDOWN_TARGET, MCCREE_FLASHBANG_COOLDOWN)
            },
            "lucio": {
                "passiveHealthRegen": false,
                "damageDealt%": 120,
                "healingDealt%": 130,
                "damageReceived%": 70,
                "ability2Cooldown%": 100
            },
            "echo": {
                "damageDealt%": 135,
                "damageReceived%": 65,
                "passiveUltGen%": 105,
                "ability2Cooldown%": 75,
                "secondaryFireCooldown%": 100
            },
            "bastion": {
                "secondaryFireCooldown%": 75,
                "damageDealt%": 125,
                "ability1Cooldown%": ratioPercent(SET_PLAYER_BASTION_ABILITY1_COOLDOWN_TARGET, BASTION_RECONFIGURE_COOLDOWN),

                "damageReceived%": 70
            },
            "soldier": {
                "damageDealt%": 130,
                "ability2Cooldown%": ratioPercent(SET_PLAYER_SOLDIER_ABILITY2_COOLDOWN_TARGET, SOLDIER_BIOTIC_FIELD_COOLDOWN),

                "ultDuration%": 134,
                "secondaryFireKb%": 100
            },
            "mercy": {
                "passiveHealthRegen": false,
                "damageReceived%": 100,
                "healingDealt%": 135,
                "enablePassive": false,
                "ability1Cooldown%": 50,
                "ability2Cooldown%": 26
            },
            "orisa": {
                "damageReceived%": 55,
                "projectileSpeed%": 130,
                "ability1Cooldown%": ratioPercent(SET_PLAYER_ORISA_ABILITY1_COOLDOWN_TARGET, ORISA_FORTIFY_COOLDOWN),

                "secondaryFireCooldown%": 117,
                "enableInfiniteAmmo": true,
                "health%": 100,
                "movementSpeed%": 100,
                "ultGen%": ultGenPercent(ORISA_ULT_COST, SET_PLAYER_ORISA_ULT_COST_TARGET)
            },
            "ana": {
                "passiveHealthRegen": false,
                "damageDealt%": 115,
                "healingDealt%": 150,
                "ability2Cooldown%": ratioPercent(SET_PLAYER_ANA_ABILITY2_COOLDOWN_TARGET, ANA_BIOTIC_GRENADE_COOLDOWN),

                "ultGen%": ultGenPercent(ANA_ULT_COST, SET_PLAYER_ANA_ULT_COST_TARGET),

                "ability1Cooldown%": ratioPercent(SET_PLAYER_ANA_ABILITY1_COOLDOWN_TARGET, ANA_SLEEP_DART_COOLDOWN_TIME)
            },
            "baptiste": {
                "passiveHealthRegen": false,
                "damageDealt%": 150,
                "ammoClipSize%": 100,
                "ability1Cooldown%": ratioPercent(SET_PLAYER_BAPTISTE_ABILITY1_COOLDOWN_TARGET, BAPTISTE_REGEN_BURST_COOLDOWN),

                "healingDealt%": 150,
                "ultDuration%": 150,
                "ability2Cooldown%": ratioPercent(SET_PLAYER_BAPTISTE_ABILITY2_COOLDOWN_TARGET, BAPTISTE_LAMP_COOLDOWN_TIME)
            },
            "brigitte": {
                "passiveHealthRegen": false,
                "damageDealt%": 125,
                "damageReceived%": 43,
                "ability1Kb%": 125,
                "secondaryFireRechargeRate%": 118,
                "secondaryFireCooldown%": 100,
                "ability2Cooldown%": ratioPercent(SET_PLAYER_BRIGITTE_ABILITY2_COOLDOWN_TARGET, BRIGITTE_REPAIR_PACK_COOLDOWN),

                "health%": 100,
                "healingDealt%": 145,
                "ultGen%": ultGenPercent(BRIGITTE_ULT_COST, SET_PLAYER_BRIGITTE_ULT_COST_TARGET),

                "shieldBashCooldown%": ratioPercent(SET_PLAYER_BRIGITTE_SHIELD_BASH_COOLDOWN_TARGET, BRIGITTE_SHIELD_BASH_COOLDOWN),

                "shieldBashKb%": ratioPercent(SET_PLAYER_BRIGITTE_SHIELD_BASH_KB_TARGET, BRIGITTE_SHIELD_BASH_KNOCKBACK)
            },
            "freja": {
                "damageDealt%": 110,
                "damageReceived%": 90,
                "ability2Cooldown%": 67,
                "ability1Cooldown%": 89,
                "secondaryFireCooldown%": 75,
                "secondaryFireDuration%": 200
            },
            "torbjorn": {
                "damageDealt%": 105,
                "ammoClipSize%": 100,
                "combatUltGen%": 92,
                "ultGen%": ultGenPercent(TORBJORN_ULT_COST, SET_PLAYER_TORBJORN_ULT_COST_TARGET),

                "ultDuration%": 100,
                "passiveUltGen%": 92
            },
            "ramattra": {
                "damageDealt%": 115,
                "damageReceived%": 65,
                "ability2Cooldown%": ratioPercent(SET_PLAYER_RAMATTRA_ABILITY2_COOLDOWN_TARGET, RAMATTRA_VORTEX_COOLDOWN),

                "ability1Cooldown%": ratioPercent(SET_PLAYER_RAMATTRA_ABILITY1_COOLDOWN_TARGET, RAMATTRA_NEMESIS_COOLDOWN),

                "ultGen%": ultGenPercent(RAMATTRA_ULT_COST, SET_PLAYER_RAMATTRA_ULT_COST_TARGET),

                "ultDuration%": 320,
                "secondaryFireCooldown%": ratioPercent(SET_PLAYER_RAMATTRA_SECONDARY_FIRE_COOLDOWN_TARGET, RAMATTRA_VOID_BARRIER_COOLDOWN)
            },
            "venture": {
                "damageDealt%": 140,
                "damageReceived%": 70,
                "ability1Duration%": 250,
                "secondaryFireCooldown%": 75,
                "ultGen%": ultGenPercent(VENTURE_ULT_COST, SET_PLAYER_VENTURE_ULT_COST_TARGET)
            },
            "emre": {
                "damageDealt%": 135,
                "damageReceived%": 90,
                "ability1Cooldown%": 80,
                "ability2Cooldown%": 75
            },
            "vendetta": {
                "damageDealt%": 135,
                "damageReceived%": 55,
                "ability1Cooldown%": 80,
                "ultGen%": 126
            },
            "anran": {
                "damageDealt%": 135,
                "damageReceived%": 70,
                "ability1Cooldown%": 75,
                "ability2Cooldown%": 75
            },
            "illari": {
                "passiveHealthRegen": false,
                "damageDealt%": 160,
                "damageReceived%": 105,
                "solarEnergyRecharge%": 125,
                "projectileSpeed%": 100,
                "ability2Cooldown%": ratioPercent(SET_PLAYER_ILLARI_ABILITY2_COOLDOWN_TARGET, ILLARI_PYLON_COOLDOWN)
            },
            "juno": {
                "passiveHealthRegen": false,
                "healingDealt%": 145,
                "ultGen%": ultGenPercent(JUNO_ULT_COST, SET_PLAYER_JUNO_ULT_COST_TARGET),

                "secondaryFireCooldown%": 80,
                "ability2Cooldown%": 86
            },
            "doomfist": {
                "damageDealt%": 115,
                "damageReceived%": 65,
                "ammoRegenerationTime%": ratioPercent(SET_PLAYER_DOOMFIST_AMMO_REGENERATION_TIME_TARGET, DOOMFIST_AMMO_REGEN),

                "ability1Cooldown%": ratioPercent(SET_PLAYER_DOOMFIST_ABILITY1_COOLDOWN_TARGET, DOOMFIST_POWER_BLOCK_COOLDOWN),

                "secondaryFireCooldown%": 100,
                "ability2Cooldown%": ratioPercent(SET_PLAYER_DOOMFIST_ABILITY2_COOLDOWN_TARGET, DOOMFIST_SEISMIC_SLAM_COOLDOWN)
            },
            "zarya": {
                "damageDealt%": 135,
                "damageReceived%": 75,
                "ammoClipSize%": 100,
                "ability2Cooldown%": 70,
                "ability1Cooldown%": 89,
                "ultGen%": ultGenPercent(ZARYA_ULT_COST, SET_PLAYER_ZARYA_ULT_COST_TARGET)
            },
            "reaper": {
                "damageDealt%": 135,
                "damageReceived%": 65,
                "healingDealt%": 300
            },
            "mauga": {
                "damageDealt%": 125,
                "damageReceived%": 65,
                "ammoClipSize%": 150,
                "ability2Cooldown%": 84,
                "ability2Healing%": 200,
                "ultDuration%": 188
            },
            "pharah": {
                "damageDealt%": 135,
                "damageReceived%": 85,
                "passiveExtraFuel%": 125,
                "ability1Cooldown%": ratioPercent(SET_PLAYER_PHARAH_ABILITY1_COOLDOWN_TARGET, PHARAH_JUMP_JET_COOLDOWN),

                "ability1RefuelScalar": 300,
                "ability2Cooldown%": ratioPercent(SET_PLAYER_PHARAH_ABILITY2_COOLDOWN_TARGET, PHARAH_CONCUSSIVE_BLAST_COOLDOWN)
            },
            "jetpackCat": {
                "damageDealt%": 135,
                "damageReceived%": 60,
                "healingDealt%": 150,
                "ability1Cooldown%": 50,
                "ability2Cooldown%": 50
            },
            "junkerQueen": {
                "damageDealt%": 130,
                "damageReceived%": 60,
                "ability1Cooldown%": 125,
                "ability2Cooldown%": 75,
                "secondaryFireCooldown%": 67,
                "ultGen%": 87
            },
            "winston": {
                "damageDealt%": 110,
                "damageReceived%": 65,
                "ability2Cooldown%": ratioPercent(SET_PLAYER_WINSTON_ABILITY2_COOLDOWN_TARGET, WINSTON_BARRIER_COOLDOWN)
            },
            "genji": {
                "damageDealt%": 145,
                "damageReceived%": 50,
                "ability1Cooldown%": 75,
                "enableInfiniteAmmo": true,
                "ultDuration%": 134,
                "ultGen%": ultGenPercent(GENJI_ULT_COST, SET_PLAYER_GENJI_ULT_COST_TARGET),

                "ability2Cooldown%": ratioPercent(SET_PLAYER_GENJI_ABILITY2_COOLDOWN_TARGET, GENJI_DEFLECT_COOLDOWN)
            },
            "junkrat": {
                "damageDealt%": 95,
                "damageReceived%": 130,
                "combatUltGen%": 70,
                "primaryFireKb%": 50,
                "ability2Cooldown%": 100,
                "ultGen%": ultGenPercent(JUNKRAT_ULT_COST, SET_PLAYER_JUNKRAT_ULT_COST_TARGET),

                "ultDuration%": 40,
                "passiveUltGen%": 70,
                "ability1Kb%": 50
            },
            "tracer": {
                "damageDealt%": 160,
                "damageReceived%": 35,
                "ultGen%": ultGenPercent(TRACER_ULT_COST, SET_PLAYER_TRACER_ULT_COST_TARGET),

                "ability2Cooldown%": ratioPercent(SET_PLAYER_TRACER_ABILITY2_COOLDOWN_TARGET, TRACER_RECALL_COOLDOWN),

                "ability1Cooldown%": 60
            },
            "zenyatta": {
                "passiveHealthRegen": false,
                "damageDealt%": 160,
                "damageReceived%": 100,
                "ultGen%": ultGenPercent(ZENYATTA_ULT_COST, SET_PLAYER_ZENYATTA_ULT_COST_TARGET),

                "projectileSpeed%": 125
            },
            "symmetra": {
                "ability2Cooldown%": 67,
                "damageDealt%": 95,
                "damageReceived%": 100,
                "ability1Cooldown%": 100,
                "ammoClipSize%": 100
            },
            "sojourn": {
                "damageDealt%": 130,
                "secondaryFireEnergyChargeRate%": 125,
                "ability2Cooldown%": 54
            },
            "mei": {
                "damageDealt%": 100,
                "ability2Cooldown%": 84,
                "primaryFireFreezeDuration%": 200,
                "primaryFireFreezeRate%": 200,
                "primaryFireFreezeMinimum%": 10,
                "damageReceived%": 100,
                "ammoClipSize%": 100,
                "ability1Cooldown%": 100
            },
            "ashe": {
                "damageDealt%": 140,
                "ability2Cooldown%": 66,
                "ammoClipSize%": 125,
                "ability1Cooldown%": 80,
                "ultDuration%": 150
            },
            "moira": {
                "passiveHealthRegen": false,
                "damageDealt%": 100,
                "damageReceived%": 90,
                "healingDealt%": 160,
                "ability2MaxDamage%": 100,
                "ability2Cooldown%": 100,
                "ability2MaxHealing%": 100,
                "primaryFireMaximumTime%": 100,
                "ultGen%": ultGenPercent(MOIRA_ULT_COST, SET_PLAYER_MOIRA_ULT_COST_TARGET)
            },
            "reinhardt": {
                "damageDealt%": 105,
                "ability1Cooldown%": ratioPercent(SET_PLAYER_REINHARDT_ABILITY1_COOLDOWN_TARGET, REINHARDT_CHARGE_COOLDOWN_TIME),

                "damageReceived%": 75,
                "secondaryFireRechargeRate%": ratioPercent(SET_PLAYER_REINHARDT_SECONDARY_FIRE_RECHARGE_RATE_TARGET, REINHARDT_BARRIER_REGEN),

                "combatUltGen%": 135,
                "health%": ratioPercent(SET_PLAYER_REINHARDT_HEALTH_TARGET, REINHARDT_BARRIER_HEALTH),

                "ultGen%": ultGenPercent(REINHARDT_ULT_COST, SET_PLAYER_REINHARDT_ULT_COST_TARGET),

                "passiveUltGen%": 115
            },
            "sigma": {
                "damageDealt%": 125,
                "ability1Cooldown%": 67,
                "damageReceived%": 75,
                "secondaryFireRechargeRate%": 300,
                "health%": ratioPercent(SET_PLAYER_SIGMA_HEALTH_TARGET, SIGMA_BARRIER_HEALTH),

                "ultGen%": ultGenPercent(SIGMA_ULT_COST, SET_PLAYER_SIGMA_ULT_COST_TARGET),

                "ability2Cooldown%": 80
            },
            "roadhog": {
                "damageDealt%": 90,
                "damageReceived%": 110,
                "secondaryFireCooldown%": 480,
                "ability1Cooldown%": ratioPercent(SET_PLAYER_ROADHOG_ABILITY1_COOLDOWN_TARGET, ROADHOG_HOOK_COOLDOWN_TIME)
            },
            "kiriko": {
                "passiveHealthRegen": false,
                "ability1Distance%": 243,
                "damageDealt%": 135,
                "healingDealt%": 135,
                "ability2Cooldown%": ratioPercent(SET_PLAYER_KIRIKO_ABILITY2_COOLDOWN_TARGET, KIRIKO_SUZU_COOLDOWN),

                "ultGen%": ultGenPercent(KIRIKO_ULT_COST, SET_PLAYER_KIRIKO_ULT_COST_TARGET)
            },
            "mizuki": {
                "damageDealt%": 135,
                "damageReceived%": 80,
                "ability1Cooldown%": 80,
                "ability2Cooldown%": 60,
                "secondaryFireCooldown%": 50,
                "ultGen%": 129
            },
            "hazard": {
                "damageDealt%": 125,
                "damageReceived%": 55,
                "secondaryFireCost%": 75,
                "combatUltGen%": 0,
                "passiveUltGen%": 0
            },
            "domina": {
                "damageDealt%": SET_DOMINA_DAMAGE_DEALT_PERCENT,
                "damageReceived%": SET_PLAYER_DOMINA_DAMAGE_RECEIVED_PERCENT,
                "ability1Cooldown%": ratioPercent(SET_PLAYER_DOMINA_ABILITY1_COOLDOWN_TARGET, DOMINA_CRYSTAL_CHARGE_COOLDOWN),
                "ability2Cooldown%": ratioPercent(SET_PLAYER_DOMINA_ABILITY2_COOLDOWN_TARGET, DOMINA_BARRIER_ARRAY_COOLDOWN),
                "secondaryFireCooldown%": ratioPercent(SET_PLAYER_DOMINA_SECONDARY_FIRE_COOLDOWN_TARGET, DOMINA_SONIC_REPULSORS_COOLDOWN)
            },
            "sombra": {
                "damageDealt%": 135,
                "ability2Cooldown%": 100,
                "damageReceived%": 78,
                "passiveUltGen%": 107,
                "secondaryFireCooldown%": ratioPercent(SET_PLAYER_SOMBRA_SECONDARY_FIRE_COOLDOWN_TARGET, SOMBRA_HACK_COOLDOWN_TIME)
            },
            "widowmaker": {
                "damageDealt%": 135,
                "damageReceived%": 115,
                "ammoClipSize%": 86,
                "ultGen%": ultGenPercent(WIDOWMAKER_ULT_COST, SET_PLAYER_WIDOWMAKER_ULT_COST_TARGET)
            },
            "general": {
                "ultGen%": 115,
                "passiveHealthRegen": true
            }
        },
        "allTeams": {
            "dva": {
                "damageDealt%": 135,
                "damageReceived%": 75,
                "ability1Cooldown%": ratioPercent(DVA_BOOSTER_COOLDOWN_TIME, DVA_BOOSTER_COOLDOWN_TIME_RAW),

                "ability2Cooldown%": ratioPercent(DVA_MICRO_MISSILES_COOLDOWN_TIME, DVA_MICRO_MISSILES_COOLDOWN_TIME_RAW),

                "secondaryFireRechargeRate%": 200,
                "secondaryFireMaximumTime%": ratioPercent(DVA_MATRIX_DURATION, DVA_MATRIX_DURATION_RAW)
            },
            "lifeweaver": {
                "healingDealt%": 160,
                "passiveHealthRegen": false,
                "enableInfiniteAmmo": false,
                "ability2Cooldown%": 39,
                "primaryFireRange%": 200,
                "secondaryFireCooldown%": 75
            },
            "wreckingBall": {
                "damageDealt%": 135,
                "damageReceived%": 85,
                "secondaryFireCooldown%": 80,
                "ability2Cooldown%": 80,
                "ability3Cooldown%": 75
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
