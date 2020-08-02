--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author.
--]]

-- Name that could be used in the name of the player.
RANK.name = "i1";

-- Name and description for user interface.
RANK.displayName = "Intention 1"
RANK.description = "A leader carrying nearly identical authority to the Chief, handpicked and tasked directly from the Chief. A step beyond exceptional."

-- Used for promotion/demotion in the hierarchy.
RANK.order = 3

-- The faction that this rank is tied to
RANK.faction = FACTION_MPF

-- Applied to the character when they are this rank
RANK.bodygroups = {
    [1] = 1,
    [2] = 5,
}

-- Permissions the rank has access to.
RANK.permissions = {
    "Promote",
    "Demote",
    "Access Viewdata",
	"Add cert",
    "Set spec",
    "Remove spec",
    "Remove cert",
    "Edit viewobjectives",
	"Set sociostatus",
}

