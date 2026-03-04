def storeOverhealth():
    @Name "[utilities/overhealth]: Store Overhealth"
    
    eventPlayer.storedOverhealth[0] = eventPlayer.getMaxHealth() - eventPlayer.getMaxHealthOfType(Health.NORMAL) - eventPlayer.getMaxHealthOfType(Health.ARMOR) - eventPlayer.getMaxHealthOfType(Health.SHIELDS)

