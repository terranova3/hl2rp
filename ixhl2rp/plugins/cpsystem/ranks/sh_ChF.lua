--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author.
--]]

-- Name that could be used in the name of the player.
RANK.name = "ChF";

-- Name and description for user interface.
RANK.displayName = "Chief"
RANK.description = "The powerhouse and sole leader of the MCP ground forces. The embodiment of authority within the city."

-- Used for promotion/demotion in the hierarchy.
RANK.order = 2

-- The faction that this rank is tied to
RANK.faction = FACTION_MPF

-- Applied to the character when they are this rank
RANK.bodygroups = {
    [1] = 2,
    [2] = 6,
}

-- Overrides the bodygroup offest applied by specializations.
RANK.overrideBodygroup = true

-- Permissions the rank has access to.
RANK.permissions = {
    "Promote",
    "Demote",
    "Access Viewdata",
    "Dispatch",
    "Add cert",
    "Set spec",
    "Remove spec",
    "Remove cert",
    "Set CP ID",
    "Set CP Tagline",
    "Set sociostatus",
    "Edit viewobjectives",
    "Change wage"
}