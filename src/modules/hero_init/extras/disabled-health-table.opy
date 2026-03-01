rule "[echo/init.opy]: Table of all heroes with custom hp":
    @Disabled
    
    #tanks
    health_pool[getAllHeroes().index(Hero.ORISA)] = [250, 200, 0]
    health_pool[getAllHeroes().index(Hero.REINHARDT)] = [250, 250, 0]
    health_pool[getAllHeroes().index(Hero.DOOMFIST)] = [300, 100, 0]
    health_pool[getAllHeroes().index(Hero.ROADHOG)] = [600, 0, 0]
    health_pool[getAllHeroes().index(Hero.SIGMA)] = [200, 0, 200]
    health_pool[getAllHeroes().index(Hero.WINSTON)] = [300, 200, 0]
    health_pool[getAllHeroes().index(Hero.ZARYA)] = [200, 0, 200]
    health_pool[getAllHeroes().index(Hero.RAMATTRA)] = [275, 100, 0]
    health_pool[getAllHeroes().index(Hero.MAUGA)] = [250, 200, 0]
    health_pool[getAllHeroes().index(Hero.JUNKER_QUEEN)] = [400, 0, 0]
    #dps
    health_pool[getAllHeroes().index(Hero.ASHE)] = [200, 0, 0]
    health_pool[getAllHeroes().index(Hero.BASTION)] = [200, 50, 0]
    health_pool[getAllHeroes().index(Hero.CASSIDY)] = [225, 0, 0]
    health_pool[getAllHeroes().index(Hero.GENJI)] = [200, 0, 0]
    health_pool[getAllHeroes().index(Hero.HANZO)] = [200, 0, 0]
    health_pool[getAllHeroes().index(Hero.JUNKRAT)] = [200, 0, 0]
    health_pool[getAllHeroes().index(Hero.MEI)] = [250, 0, 0]
    health_pool[getAllHeroes().index(Hero.PHARAH)] = [200, 0, 0]
    health_pool[getAllHeroes().index(Hero.REAPER)] = [250, 0, 0]
    health_pool[getAllHeroes().index(Hero.SOLDIER)] = [200, 0, 0]
    health_pool[getAllHeroes().index(Hero.SOMBRA)] = [200, 0, 0]
    health_pool[getAllHeroes().index(Hero.SYMMETRA)] = [125, 0, 100]
    health_pool[getAllHeroes().index(Hero.TORBJORN)] = [200, 50, 0]
    health_pool[getAllHeroes().index(Hero.TRACER)] = [125, 25, 0]
    health_pool[getAllHeroes().index(Hero.WIDOWMAKER)] = [175, 0, 0]
    health_pool[getAllHeroes().index(Hero.SOJOURN)] = [200, 0, 0]
    #supports
    health_pool[getAllHeroes().index(Hero.ANA)] = [200, 0, 0]
    health_pool[getAllHeroes().index(Hero.BAPTISTE)] = [200, 0, 0]
    health_pool[getAllHeroes().index(Hero.BRIGITTE)] = [200, 50, 0]
    health_pool[getAllHeroes().index(Hero.LUCIO)] = [200, 0, 0]
    health_pool[getAllHeroes().index(Hero.MERCY)] = [225, 0, 0]
    health_pool[getAllHeroes().index(Hero.MOIRA)] = [225, 0, 0]
    health_pool[getAllHeroes().index(Hero.ZENYATTA)] = [50, 0, 150]


