--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Bowl of Meat"
ITEM.model = Model("models/kek1ch/meat_pseudodog.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "A hot meal. It's mixed with assorted meats."
ITEM.category = "Contraband Food Meats"

ITEM.functions.Eat = {
	OnRun = function(itemTable)
		local client = itemTable.player
		client:SetHealth(math.Clamp(client:Health() + 17, 0, client:GetMaxHealth()))
	end
}
