--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author.
--]]

-- Name that could be used in the name of the player.
RANK.name = "AdJ";

-- Name and description for user interface.
RANK.displayName = "Adjutant"
RANK.description = "Commissioned Officers vetted through their years of service and dedication. Landing themselves in the luxuries of a logistics position for the MCP. Easily mistaken as bureaucrats while pulling the strings. "

-- Used for promotion/demotion in the hierarchy.
RANK.order = 1

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
    "Edit viewobjectives",
    "Set sociostatus",
    "Change wage"
}

