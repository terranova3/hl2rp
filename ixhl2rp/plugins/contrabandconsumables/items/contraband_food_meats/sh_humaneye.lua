--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Human Eye"
ITEM.model = Model("models/gibs/humans/eye_gib.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Optical illusion. It's chicken."
ITEM.category = "Contraband Food Meats"

ITEM.functions.Eat = {
	OnRun = function(itemTable)
		local client = itemTable.player
		client:SetHealth(math.Clamp(client:Health() + 2, 0, client:GetMaxHealth()))
	end
}
