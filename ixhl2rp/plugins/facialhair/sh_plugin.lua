--[[
	© 2021 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

PLUGIN.name = "Facial Hair"
PLUGIN.description = "Adds facial hair growth and razors for HL2 RP"
PLUGIN.author = "Adolphus"

ix.util.IncludeDir(PLUGIN.folder .. "/meta", true)
ix.util.Include("sv_hooks.lua")

ix.config.Add("facialHairChangeTime", 30, "The time between being allowed to change facial hair, in minutes.", nil, {
	data = {min = 1, max = 1440},
	category = "Cosmetics"
})

PLUGIN.facialHair = {
    [1] = {
        name = "Shaved",
        description = "[PH] needs description"
    },
    [2] = {
        name = "Handlebar",
        description = "[PH] needs description"
    },
    [3] = {
        name = "Lampshade",
        description = "[PH] needs description"
    },
    [4] = {
        name = "Chevron",
        description = "[PH] needs description"
    },
    [5] = {
        name = "Dali",
        description = "[PH] needs description"
    },
    [6] = {
        name = "Beard",
        description = "[PH] needs description"
    },
    [7] = {
        name = "Goatee",
        description = "[PH] needs description"
    },
    [8] = {
        name = "Full Goatee",
        description = "[PH] needs description"
    },
    [9] = {
        name = "Patchy Beard",
        description = "[PH] needs description"
    },
}