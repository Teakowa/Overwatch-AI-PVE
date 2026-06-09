#!mainFile "../main.opy"

# Source: https://github.com/Overwatch-1-Emulator/ow1-emulator/blob/staging/src/utilities/macro_functions.opy

# Check if player is playing hero
macro isHero(player, hero):
    (player.getHero() == hero)

# Macro function for converting decimal to percent
macro percent(p):
    100*(p)

# Macro function for computing a percent of number
macro percentOf(p, n):
    (p)/100*(n)

macro Number.percentOf(p):
    self * (p) / 100

macro Number.scaledBy(factor):
    self * factor

macro Number.isAtMostPercentOf(p, base):
    self <= base.percentOf(p)

macro Number.isAbovePercentOf(p, base):
    self > base.percentOf(p)

macro Array.first():
    self[0]

macro ratioPercent(value, baseValue):
    percent((value) / (baseValue))

macro ultGenPercent(ow2UltCost, targetUltCost):
    percent((ow2UltCost) / (targetUltCost))
