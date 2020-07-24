--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author.
--]]

-- Name that could be used in the name of the player.
RANK.name = "i4";

-- Name and description for user interface.
RANK.displayName = "Intention 4"
RANK.description = "A substantial chunk of the CPF, often the standard grunt to carry out operations they've been tasked with. No longer experiencing the potential leniency one might've found as an i5."

-- Used for promotion/demotion in the hierarchy.
RANK.order = 6

-- The faction that this rank is tied to
RANK.faction = FACTION_MPF

-- Applied to the character when they are this rank
RANK.bodygroups = {
    [1] = 0,
    [2] = 2,
}

-- Permissions the rank has access to.
RANK.permissions = {
    "Access Viewdata",
}

