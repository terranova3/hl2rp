--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Bullsquid Meat"
ITEM.model = Model("models/gibs/xenians/mgib_02.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "An uncooked bit of a mean spirited creature."
ITEM.category = "Contraband Food Meats"

ITEM.functions.Eat = {
	OnRun = function(itemTable)
		local client = itemTable.player
		client:SetHealth(math.Clamp(client:Health() + 4, 0, client:GetMaxHealth()))
	end
}
