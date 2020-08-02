--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Antlion Meat"
ITEM.model = Model("models/gibs/antlion_gib_small_2.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "An uncooked small piece of a large burrowing alien insect. Definitely has a lot of protein."
ITEM.category = "Contraband Food Meats"

ITEM.functions.Eat = {
	OnRun = function(itemTable)
		local client = itemTable.player
		client:SetHealth(math.Clamp(client:Health() + 3, 0, client:GetMaxHealth()))
	end
}
