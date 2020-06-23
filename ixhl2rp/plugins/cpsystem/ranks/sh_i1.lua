--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author.
--]]

-- Name that could be used in the name of the player.
RANK.name = "i1";

-- Name and description for user interface.
RANK.displayName = "Intention 1"
RANK.description = "todo"

-- Used for promotion/demotion in the hierarchy.
RANK.order = 3

-- The faction that this rank is tied to
RANK.faction = FACTION_MPF

-- Permissions the rank has access to.
RANK.permissions = {
    "Promote",
    "Demote",
    "Access Viewdata",
    "Dispatch"
}

