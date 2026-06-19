#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitShion():
    @Name "[shion/init.opy]: heroInitShion()"

    eventPlayer.shion_buff[0] = 0
    eventPlayer.shion_buff[1] = false
    eventPlayer.shion_buff[2] = false
    eventPlayer.shion_buff[3] = 0
    eventPlayer.shion_buff[4] = false
    eventPlayer.setDamageDealt(100)
    eventPlayer.setDamageReceived(100)
