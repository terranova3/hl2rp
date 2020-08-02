--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Kebab"
ITEM.model = Model("models/kek1ch/meat_tushkano.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "A freshly made kebab. Smells amazing and tastes even better."
ITEM.category = "Contraband Food"

ITEM.functions.Eat = {
	OnRun = function(itemTable)
		local client = itemTable.player
		client:SetHealth(math.Clamp(client:Health() + 10, 0, client:GetMaxHealth()))
	end
}
