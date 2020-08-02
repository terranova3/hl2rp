--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Headcrab Meat"
ITEM.model = Model("models/gibs/humans/sgib_03.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "An uncooked piece of a head-hugging creature."
ITEM.category = "Contraband Food Meats"

ITEM.functions.Eat = {
	OnRun = function(itemTable)
		local client = itemTable.player
		client:SetHealth(math.Clamp(client:Health() + 2, 0, client:GetMaxHealth()))
	end
}
