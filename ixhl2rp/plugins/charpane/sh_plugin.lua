--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

PLUGIN.name = "Character Panel";
PLUGIN.description = "Adds dynamic bodygroup support with an inventory character pane.";
PLUGIN.author = "Adolphus";
PLUGIN.slots = {
	["citizen"] = {
		["torso"] = 1,
		["legs"] = 2,
		["hands"] = 3,
		["headgear"] = 4,
		["bag"] = 5,
		["glasses"] = 6,
		["satchel"] = 7,
		["pouch"] = 8,
		["badge"] = 9,
		["headstrap"] = 10,
		["kevlar"] = 11
	},
	["mpf"] = {
		["gasmask"] = 1,
		["coat"] = 2
	}
}

ix.util.IncludeDirectory(PLUGIN, "meta");
ix.util.Include("sv_database.lua");

--- Returns this character's associated `CharPanel` object.
-- @function :GetCharPanel
ix.char.RegisterVar("CharPanel", {
	bNoNetworking = true,
	bNoDisplay = true,
	OnGet = function(character, index)
		return character.vars.charPanel
	end,
	alias = "charPanel"
})
