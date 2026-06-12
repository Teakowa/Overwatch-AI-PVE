#!mainFile "../../main.opy"

macro INIT_JUNKER_QUEEN_WORKSHOP_SETTINGS():
    JunkerQueenBuff[0] = createWorkshopSettingInt("英雄：渣客女王", "号令怒吼：每名被嘲讽敌人提供额外生命值", 500, 0, 1000, 166)
    JunkerQueenBuff[1] = createWorkshopSettingInt("英雄：渣客女王", "锯齿利刃：斩杀伤害", JUNKER_QUEEN_ABILITY2_EXECUTE_DAMAGE, 0, 50000, 167)
