--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author.
--]]

-- Name that could be used in the name of the player.
RANK.name = "AdJ";

-- Name and description for user interface.
RANK.displayName = "Adjutant"
RANK.description = "todo"

-- Used for promotion/demotion in the hierarchy.
RANK.order = 2

-- The faction that this rank is tied to
RANK.faction = FACTION_MPF

-- Applied to the character when they are this rank
RANK.bodygroups = {
    [2] = 0,
}

-- Permissions the rank has access to.
RANK.permissions = {
    "Promote",
    "Demote",
    "Access Viewdata",
    "Dispatch"
}

