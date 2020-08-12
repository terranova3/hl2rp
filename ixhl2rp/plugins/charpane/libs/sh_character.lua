--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

--- Returns this character's associated `CharPanel` object.
-- @function :GetCharPanel
ix.char.RegisterVar("CharPanel", {
	bNoNetworking = true,
	bNoDisplay = true,
	OnSet = function(character, value)
		character.vars.charPanel = value
	end,
	OnGet = function(character, index)
		return character.vars.charPanel
	end,
	alias = "charPanel"
})

