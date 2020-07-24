--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author.
--]]

-- Name that could be used in the name of the player.
RANK.name = "i3";

-- Name and description for user interface.
RANK.displayName = "Intention 3"
RANK.description = "An average joe, on MCP standards. Capable and developed, the model protection unit. Now is the time to shine."

-- Used for promotion/demotion in the hierarchy.
RANK.order = 5

-- The faction that this rank is tied to
RANK.faction = FACTION_MPF

-- Applied to the character when they are this rank
RANK.bodygroups = {
    [1] = 0,
    [2] = 3,
}

-- Permissions the rank has access to.
RANK.permissions = {
    "Access Viewdata",
}

