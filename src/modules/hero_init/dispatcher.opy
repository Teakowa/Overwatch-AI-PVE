#!mainFile "../../main.opy"
#!optimizeStrict

subroutine heroInitDispatcher
subroutine heroInitReaper
subroutine heroInitTracer
subroutine heroInitMercy
subroutine heroInitHanzo
subroutine heroInitFreja
subroutine heroInitShion
subroutine heroInitTorbjorn
subroutine heroInitVenture
subroutine heroInitVendetta
subroutine heroInitWuyang
subroutine heroInitReinhardt
subroutine heroInitHazard
subroutine heroInitDomina
subroutine heroInitAnran
subroutine heroInitEmre
subroutine heroInitMizuki
subroutine heroInitJetpackCat
subroutine heroInitPharah
subroutine heroInitWinston
subroutine heroInitWidowmaker
subroutine heroInitBastion
subroutine heroInitSymmetra
subroutine heroInitZenyatta
subroutine heroInitGenji
subroutine heroInitRoadhog
subroutine heroInitCassidy
subroutine heroInitJunkrat
subroutine heroInitZarya
subroutine heroInitSoldier76
subroutine heroInitLucio
subroutine heroInitDva
subroutine heroInitMei
subroutine heroInitSombra
subroutine heroInitAna
subroutine heroInitOrisa
subroutine heroInitBrigitte
subroutine heroInitMoira
subroutine heroInitWreckingBall
subroutine heroInitSojourn
subroutine heroInitAshe
subroutine heroInitEcho
subroutine heroInitBaptiste
subroutine heroInitKiriko
subroutine heroInitJunkerQueen
subroutine heroInitSierra
subroutine heroInitSigma
subroutine heroInitRamattra
subroutine heroInitJuno
subroutine heroInitDoomfist
subroutine heroInitLifeweaver
subroutine heroInitMauga
subroutine heroInitIllari

def heroInitDispatcher():
    @Name "[hero_init/dispatcher.opy]: heroInitDispatcher()"

    switch eventPlayer.init_hero:
        case Hero.REAPER:
            heroInitReaper()
            break
        case Hero.TRACER:
            heroInitTracer()
            break
        case Hero.MERCY:
            heroInitMercy()
            break
        case Hero.HANZO:
            heroInitHanzo()
            break
        case Hero.FREJA:
            heroInitFreja()
            break
        case Hero.SHION:
            heroInitShion()
            break
        case Hero.TORBJORN:
            heroInitTorbjorn()
            break
        case Hero.VENTURE:
            heroInitVenture()
            break
        case Hero.VENDETTA:
            heroInitVendetta()
            break
        case Hero.WUYANG:
            heroInitWuyang()
            break
        case Hero.REINHARDT:
            heroInitReinhardt()
            break
        case Hero.HAZARD:
            heroInitHazard()
            break
        case Hero.DOMINA:
            heroInitDomina()
            break
        case Hero.ANRAN:
            heroInitAnran()
            break
        case Hero.EMRE:
            heroInitEmre()
            break
        case Hero.MIZUKI:
            heroInitMizuki()
            break
        case Hero.JETPACK_CAT:
            heroInitJetpackCat()
            break
        case Hero.PHARAH:
            heroInitPharah()
            break
        case Hero.WINSTON:
            heroInitWinston()
            break
        case Hero.WIDOWMAKER:
            heroInitWidowmaker()
            break
        case Hero.BASTION:
            heroInitBastion()
            break
        case Hero.SYMMETRA:
            heroInitSymmetra()
            break
        case Hero.ZENYATTA:
            heroInitZenyatta()
            break
        case Hero.GENJI:
            heroInitGenji()
            break
        case Hero.ROADHOG:
            heroInitRoadhog()
            break
        case Hero.CASSIDY:
            heroInitCassidy()
            break
        case Hero.JUNKRAT:
            heroInitJunkrat()
            break
        case Hero.ZARYA:
            heroInitZarya()
            break
        case Hero.SOLDIER:
            heroInitSoldier76()
            break
        case Hero.LUCIO:
            heroInitLucio()
            break
        case Hero.DVA:
            heroInitDva()
            break
        case Hero.MEI:
            heroInitMei()
            break
        case Hero.SOMBRA:
            heroInitSombra()
            break
        case Hero.ANA:
            heroInitAna()
            break
        case Hero.ORISA:
            heroInitOrisa()
            break
        case Hero.BRIGITTE:
            heroInitBrigitte()
            break
        case Hero.MOIRA:
            heroInitMoira()
            break
        case Hero.WRECKING_BALL:
            heroInitWreckingBall()
            break
        case Hero.SOJOURN:
            heroInitSojourn()
            break
        case Hero.ASHE:
            heroInitAshe()
            break
        case Hero.ECHO:
            heroInitEcho()
            break
        case Hero.BAPTISTE:
            heroInitBaptiste()
            break
        case Hero.KIRIKO:
            heroInitKiriko()
            break
        case Hero.JUNKER_QUEEN:
            heroInitJunkerQueen()
            break
        case Hero.SIERRA:
            heroInitSierra()
            break
        case Hero.SIGMA:
            heroInitSigma()
            break
        case Hero.RAMATTRA:
            heroInitRamattra()
            break
        case Hero.JUNO:
            heroInitJuno()
            break
        case Hero.DOOMFIST:
            heroInitDoomfist()
            break
        case Hero.LIFEWEAVER:
            heroInitLifeweaver()
            break
        case Hero.MAUGA:
            heroInitMauga()
            break
        case Hero.ILLARI:
            heroInitIllari()
            break

rule "[hero_init/dispatcher.opy]: initialize hero":
    @Event eachPlayer
    @Condition eventPlayer.call_init == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer._reset_requested != false
    @Condition eventPlayer.getCurrentHero() == eventPlayer.init_hero

    resetHero()
    heroInitDispatcher()
    eventPlayer._last_hero_played = eventPlayer.init_hero
    eventPlayer.call_init = false
    eventPlayer._reset_requested = false
