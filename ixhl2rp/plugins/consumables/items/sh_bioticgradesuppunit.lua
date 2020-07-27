--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Biotic-Grade Supplement Unit"
ITEM.model = Model("models/probs_misc/tobbcco_box-1.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "This supplement unit is just a few little pills filled with various necessary vitamins and minerals."
ITEM.category = "Rations"
ITEM.noBusiness = true
ITEM.functions.Eat = {
	OnRun = function(itemTable)
		local client = itemTable.player
		client:SetHealth(math.Clamp(client:Health() + 6, 0, client:GetMaxHealth()))
	end
}
