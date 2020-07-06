--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author.
--]]

-- Name that could be used in the name of the player.
RANK.name = "OWS";

-- Name and description for user interface.
RANK.displayName = "Overwatch Soldier"
RANK.description = "For when the protection units don't cut it. Quality insurance that the job will go on without a hitch. Cutting edge full body protection without a known weakness.

-- Used for promotion/demotion in the hierarchy.
RANK.order = 2
RANK.isDefault = true

-- The faction that this rank is tied to
RANK.faction = FACTION_OTA

-- Permissions the rank has access to.
RANK.permissions = {
    "Promote",
    "Demote"
}

