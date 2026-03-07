rule "[utilities/reset]: reset when died":
    @Event playerDied
    
    #!include "player-death-reset-common.opy"
    stopAllHealingModifications()
    #!include "player-death-reset-cleanup.opy"
