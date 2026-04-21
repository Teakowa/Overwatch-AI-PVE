rule "[Freja]: Revdraw Crossbow Stack":
    @Event playerDealtDamage
    @Hero freja
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition eventPlayer.hasStatus(Status.INVINCIBLE) != true

    victim.freja_buff[0]++

rule "[Freja]: Take Aim Damage":
    @Event playerDealtDamage
    @Hero freja
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false
    @Condition victim.has_nano != true
    @Condition victim.freja_buff[0] > 0

    wait(0.5, Wait.ABORT_WHEN_FALSE)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.BLUE, victim, 0.8)
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.BLUE, victim, 10)
    damage(victim, attacker, FrejaBuff[0] * victim.freja_buff[0])
    victim.freja_buff[0] = 0
    victim.freja_buff[1] = 0

rule "[Freja]: HUD & Reset":
    @Event eachPlayer
    @Condition eventPlayer.freja_buff[0] > 0

    if eventPlayer.freja_buff[3] != 0:
        goto lbl_0
    hudText(eventPlayer.reset_pvar[11], null, " \r\n\r\n\n", "  {0} 狩猎印记： {1}".format(heroIcon(eventPlayer.getHero()), eventPlayer.freja_buff[0]), HudPosition.LEFT, 1, null, null, rgb(255, 255, 255, 200), HudReeval.STRING)
    eventPlayer.freja_buff[3] = getLastCreatedText()
    lbl_0:
    if eventPlayer.freja_buff[4] != 0:
        goto lbl_1
    hudText(eventPlayer, null, " \r\n\r\n\n", " {0} 印记： {1}".format(heroIcon(Hero.FREJA), eventPlayer.freja_buff[0]), HudPosition.LEFT, 2, null, null, rgb(255, 255, 255, 200), HudReeval.STRING)
    eventPlayer.freja_buff[4] = getLastCreatedText()
    lbl_1:
    eventPlayer.freja_buff[1] = eventPlayer.freja_buff[0]
    wait(5)
    if eventPlayer.freja_buff[0] > eventPlayer.freja_buff[1]:
        loop()
    eventPlayer.freja_buff[0] = 0
    eventPlayer.freja_buff[1] = 0
    destroyHudText(eventPlayer.freja_buff[3])
    destroyHudText(eventPlayer.freja_buff[4])
    eventPlayer.freja_buff[3] = 0
    eventPlayer.freja_buff[4] = 0

rule "[Freja]: Ex":
    @Event playerDealtKnockback
    @Hero freja
    @Condition eventAbility == null
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT) or not victim.has_nano) == false
    #@Condition victim.freja_buff[0] > 0

    if not victim.isAlive() or victim.getHealth() > victim.getMaxHealth() * FrejaBuff[2]:
        goto lbl_0
    damage(victim, attacker, 44444)
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
