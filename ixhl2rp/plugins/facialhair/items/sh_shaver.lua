--[[
	© 2021 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

local PLUGIN = PLUGIN

ITEM.name = "Razor"
ITEM.description = "An old worn out razor that you can use to trim unwanted hair."
ITEM.model = "models/razer/razer.mdl"
ITEM.category = "Other"
ITEM.flag = "g"
ITEM.price = 5;
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