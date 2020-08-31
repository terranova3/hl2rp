--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author.
--]]

-- Name that could be used in the name of the player.
RANK.name = "i2";

-- Name and description for user interface.
RANK.displayName = "Intention 2"
RANK.description = "Veterans of the MCP accumulating the skills necessary to become masters of their specialisations. True aces to have in the force, a position to showcase expertise."

-- Used for promotion/demotion in the hierarchy.
RANK.order = 4

-- The faction that this rank is tied to
RANK.faction = FACTION_MPF

-- Applied to the character when they are this rank
RANK.bodygroups = {
    [1] = 1,
    [2] = 4
}

-- Permissions the rank has access to.
RANK.permissions = {
    "Promote",
    "Access Viewdata",
	"Add cert",
    "Set spec",
    "Remove spec",
    "Remove cert",
}

