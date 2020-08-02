--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Boid Meat"
ITEM.model = Model("models/kek1ch/hide_burer.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "The uncooked meat from some passive airborne creature."
ITEM.category = "Contraband Food Meats"

ITEM.functions.Eat = {
	OnRun = function(itemTable)
		local client = itemTable.player
		client:SetHealth(math.Clamp(client:Health() + 3, 0, client:GetMaxHealth()))
	end
}
