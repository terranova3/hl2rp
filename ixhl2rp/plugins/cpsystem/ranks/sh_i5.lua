--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author.
--]]

-- Name that could be used in the name of the player.
RANK.name = "i5";

-- Name and description for user interface.
RANK.displayName = "Intention 5"
RANK.description = "The first rank, which shows a unit just having been deployed and at the beginning of their Veterancy status. This is the standard boot of the force, with willing volunteers and less skilled units making up its numbers."

-- Used for promotion/demotion in the hierarchy.
RANK.order = 7
RANK.isDefault = true

-- The faction that this rank is tied to
RANK.faction = FACTION_MPF

-- Applied to the character when they are this rank
RANK.bodygroups = {
    [1] = 0,
    [2] = 1,
}

-- Permissions the rank has access to.
RANK.permissions = {
    "Access Viewdata",
}

