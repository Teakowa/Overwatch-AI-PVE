#!mainFile "../../main.opy"

macro INIT_WRECKING_BALL_WORKSHOP_SETTINGS():
    WreckingBallBuff[0] = createWorkshopSettingFloat("英雄：破坏球", "重踏：眩晕持续时间", WRECKING_BALL_RULES_STUNNED_DURATION, 0, 3, 150)
