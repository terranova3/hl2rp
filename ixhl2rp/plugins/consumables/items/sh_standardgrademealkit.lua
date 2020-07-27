--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Standard-Grade Meal Kit"
ITEM.model = Model("models/mres/consumables/tag_mre.mdl")
ITEM.width = 1
ITEM.height = 2
ITEM.description = "A standard-grade meal kit with a weird combination of various meats and a sludge that's just mashed up vegetables."
ITEM.category = "Rations"
ITEM.noBusiness = true
ITEM.functions.Eat = {
	OnRun = function(itemTable)
		local client = itemTable.player
		client:SetHealth(math.Clamp(client:Health() + 14, 0, client:GetMaxHealth()))
	end
}
