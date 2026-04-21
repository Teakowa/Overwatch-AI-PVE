rule "[Echo] Duplicate fast ultimate charge":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.isDuplicatingAHero() == true
    @Condition eventPlayer.getUltCharge() < 50 == true

    eventPlayer.setUltCharge(10)
#!include "ability2.opy"
