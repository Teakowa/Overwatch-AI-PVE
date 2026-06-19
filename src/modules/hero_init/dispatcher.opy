#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitDispatcher():
    @Name "[hero_init/dispatcher.opy]: heroInitDispatcher()"

    if eventPlayer._hero_setup_hero == Hero.REAPER:
        heroInitReaper()
    if eventPlayer._hero_setup_hero == Hero.TRACER:
        heroInitTracer()
    if eventPlayer._hero_setup_hero == Hero.MERCY:
        heroInitMercy()
    if eventPlayer._hero_setup_hero == Hero.HANZO:
        heroInitHanzo()
    if eventPlayer._hero_setup_hero == Hero.FREJA:
        heroInitFreja()
    if eventPlayer._hero_setup_hero == Hero.SHION:
        heroInitShion()
    if eventPlayer._hero_setup_hero == Hero.TORBJORN:
        heroInitTorbjorn()
    if eventPlayer._hero_setup_hero == Hero.VENTURE:
        heroInitVenture()
    if eventPlayer._hero_setup_hero == Hero.VENDETTA:
        heroInitVendetta()
    if eventPlayer._hero_setup_hero == Hero.WUYANG:
        heroInitWuyang()
    if eventPlayer._hero_setup_hero == Hero.REINHARDT:
        heroInitReinhardt()
    if eventPlayer._hero_setup_hero == Hero.HAZARD:
        heroInitHazard()
    if eventPlayer._hero_setup_hero == Hero.DOMINA:
        heroInitDomina()
    if eventPlayer._hero_setup_hero == Hero.ANRAN:
        heroInitAnran()
    if eventPlayer._hero_setup_hero == Hero.EMRE:
        heroInitEmre()
    if eventPlayer._hero_setup_hero == Hero.MIZUKI:
        heroInitMizuki()
    if eventPlayer._hero_setup_hero == Hero.JETPACK_CAT:
        heroInitJetpackCat()
    if eventPlayer._hero_setup_hero == Hero.PHARAH:
        heroInitPharah()
    if eventPlayer._hero_setup_hero == Hero.WINSTON:
        heroInitWinston()
    if eventPlayer._hero_setup_hero == Hero.WIDOWMAKER:
        heroInitWidowmaker()
    if eventPlayer._hero_setup_hero == Hero.BASTION:
        heroInitBastion()
    if eventPlayer._hero_setup_hero == Hero.SYMMETRA:
        heroInitSymmetra()
    if eventPlayer._hero_setup_hero == Hero.ZENYATTA:
        heroInitZenyatta()
    if eventPlayer._hero_setup_hero == Hero.GENJI:
        heroInitGenji()
    if eventPlayer._hero_setup_hero == Hero.ROADHOG:
        heroInitRoadhog()
    if eventPlayer._hero_setup_hero == Hero.CASSIDY:
        heroInitCassidy()
    if eventPlayer._hero_setup_hero == Hero.JUNKRAT:
        heroInitJunkrat()
    if eventPlayer._hero_setup_hero == Hero.ZARYA:
        heroInitZarya()
    if eventPlayer._hero_setup_hero == Hero.SOLDIER:
        heroInitSoldier76()
    if eventPlayer._hero_setup_hero == Hero.LUCIO:
        heroInitLucio()
    if eventPlayer._hero_setup_hero == Hero.DVA:
        heroInitDva()
    if eventPlayer._hero_setup_hero == Hero.MEI:
        heroInitMei()
    if eventPlayer._hero_setup_hero == Hero.SOMBRA:
        heroInitSombra()
    if eventPlayer._hero_setup_hero == Hero.ANA:
        heroInitAna()
    if eventPlayer._hero_setup_hero == Hero.ORISA:
        heroInitOrisa()
    if eventPlayer._hero_setup_hero == Hero.BRIGITTE:
        heroInitBrigitte()
    if eventPlayer._hero_setup_hero == Hero.MOIRA:
        heroInitMoira()
    if eventPlayer._hero_setup_hero == Hero.WRECKING_BALL:
        heroInitWreckingBall()
    if eventPlayer._hero_setup_hero == Hero.SOJOURN:
        heroInitSojourn()
    if eventPlayer._hero_setup_hero == Hero.ASHE:
        heroInitAshe()
    if eventPlayer._hero_setup_hero == Hero.ECHO:
        heroInitEcho()
    if eventPlayer._hero_setup_hero == Hero.BAPTISTE:
        heroInitBaptiste()
    if eventPlayer._hero_setup_hero == Hero.KIRIKO:
        heroInitKiriko()
    if eventPlayer._hero_setup_hero == Hero.JUNKER_QUEEN:
        heroInitJunkerQueen()
    if eventPlayer._hero_setup_hero == Hero.SIERRA:
        heroInitSierra()
    if eventPlayer._hero_setup_hero == Hero.SIGMA:
        heroInitSigma()
    if eventPlayer._hero_setup_hero == Hero.RAMATTRA:
        heroInitRamattra()
    if eventPlayer._hero_setup_hero == Hero.JUNO:
        heroInitJuno()
    if eventPlayer._hero_setup_hero == Hero.DOOMFIST:
        heroInitDoomfist()
    if eventPlayer._hero_setup_hero == Hero.LIFEWEAVER:
        heroInitLifeweaver()
    if eventPlayer._hero_setup_hero == Hero.MAUGA:
        heroInitMauga()
    if eventPlayer._hero_setup_hero == Hero.ILLARI:
        heroInitIllari()

rule "[hero_init/dispatcher.opy]: initialize hero":
    @Event eachPlayer
    @Condition eventPlayer._hero_switch_pending == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer._reset_requested != false
    @Condition eventPlayer.getCurrentHero() == eventPlayer._hero_setup_hero

    resetHero()
    heroInitDispatcher()
    eventPlayer._last_hero_played = eventPlayer._hero_setup_hero
    eventPlayer._hero_switch_pending = false
    eventPlayer._reset_requested = false
