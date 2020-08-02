--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Human Heart"
ITEM.model = Model("models/gibs/humans/heart_gib.mdl")
ITEM.width = 1
ITEM.height = 2
ITEM.description = "A human heart that could be edible, if you're desperate."
ITEM.category = "Contraband Food Meats"

ITEM.functions.Eat = {
	OnRun = function(itemTable)
		local client = itemTable.player
		client:SetHealth(math.Clamp(client:Health() + 5, 0, client:GetMaxHealth()))
	end
}
