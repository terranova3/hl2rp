--[[
	© 2021 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

local PLUGIN = PLUGIN

ITEM.name = "Razor"
ITEM.description = "Useful for fixing up your facial hair."
ITEM.model = "models/props_c17/TrapPropeller_Lever.mdl"
ITEM.noBusiness = true
ITEM.functions.Style = {
	name = "Style",
	icon = "icon16/book_edit.png",
	OnRun = function(item)
		local client = item.player
		
		local canChange, error = PLUGIN:CanChangeFacialHair(client:GetCharacter())
		
		if(canChange) then
			netstream.Start(client, "ixFacialHair")
		else
			client:Notify(error)
		end
        
		return false
	end,

	OnCanRun = function(item)
		return !item.player:IsFemale() or item.invID != item.player:GetCharacter():GetInventory():GetID()
	end
}