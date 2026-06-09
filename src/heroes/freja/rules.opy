#!mainFile "../../main.opy"
#!optimizeStrict

playervar freja_buff
#!defineMember freja_mark_count      freja_buff[0]
#!defineMember freja_mark_snapshot   freja_buff[1]
#!defineMember freja_air_hud         freja_buff[2]
#!defineMember freja_target_mark_hud freja_buff[3]
#!defineMember freja_self_mark_hud   freja_buff[4]

rule "[Freja]: Revdraw Crossbow Stack":
    @Event playerDealtDamage
    @Hero freja
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition eventPlayer.hasStatus(Status.INVINCIBLE) != true

    victim.freja_mark_count++
    wait()

rule "[Freja]: Take Aim Damage":
    @Event playerDealtDamage
    @Hero freja
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition victim.untargetable() != true
    @Condition victim.has_nano != true
    @Condition victim.freja_mark_count > 0

    wait(0.5, Wait.ABORT_WHEN_FALSE)
    damage(victim, attacker, FrejaBuff[0] * victim.freja_mark_count)
    victim.freja_mark_count = 0
    victim.freja_mark_snapshot = 0

rule "[Freja]: HUD & Reset":
    @Event eachPlayer
    @Condition eventPlayer.freja_mark_count > 0

    if eventPlayer.freja_target_mark_hud != 0:
        goto lbl_0
    hudText(eventPlayer.reset_pvar[11], null, " \r\n\r\n\n", "  {0} 狩猎印记： {1}".format(heroIcon(eventPlayer.getHero()), eventPlayer.freja_mark_count), HudPosition.LEFT, 1, null, null, rgb(255, 255, 255, 200), HudReeval.STRING)
    eventPlayer.freja_target_mark_hud = getLastCreatedText()
    lbl_0:
    if eventPlayer.freja_self_mark_hud != 0:
        goto lbl_1
    hudText(eventPlayer, null, " \r\n\r\n\n", " {0} 印记： {1}".format(heroIcon(Hero.FREJA), eventPlayer.freja_mark_count), HudPosition.LEFT, 2, null, null, rgb(255, 255, 255, 200), HudReeval.STRING)
    eventPlayer.freja_self_mark_hud = getLastCreatedText()
    lbl_1:
    eventPlayer.freja_mark_snapshot = eventPlayer.freja_mark_count
    wait(5)
    if eventPlayer.freja_mark_count > eventPlayer.freja_mark_snapshot:
        loop()
    eventPlayer.freja_mark_count = 0
    eventPlayer.freja_mark_snapshot = 0
    destroyHudText(eventPlayer.freja_target_mark_hud)
    destroyHudText(eventPlayer.freja_self_mark_hud)
    eventPlayer.freja_target_mark_hud = 0
    eventPlayer.freja_self_mark_hud = 0

rule "[Freja]: Ex":
    @Event playerDealtKnockback
    @Hero freja
    @Condition eventAbility == null
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT) or not victim.has_nano) == false
    #@Condition victim.freja_mark_count > 0

    if not victim.isAlive() or victim.healthAbovePercent(FrejaBuff[2] * 100):
        goto lbl_0
    damage(victim, attacker, FREJA_RULES_EXECUTE_DAMAGE)
    smallMessage(eventPlayer, "  斩杀： {0} ".format(heroIcon(victim.getHero())))
    wait(1, Wait.ABORT_WHEN_FALSE)
    lbl_0:

rule "[Freja]: Ammo":
    @Event playerEarnedElimination
    @Hero freja
    @Disabled

    eventPlayer.setAmmo(0, eventPlayer.getAmmo() + 1)
#!include "ability2.opy"
#!include "ultimate.opy"
