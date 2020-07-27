--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Loyalist-Grade Meal Kit"
ITEM.model = Model("models/mres/consumables/pag_mre.mdl")
ITEM.width = 1
ITEM.height = 2
ITEM.description = "This is a loyalist-grade meal kit. Each meal kit has something different, but they're all filled with real meat and an assortment of vegetables."
ITEM.category = "Rations"
ITEM.noBusiness = true
ITEM.functions.Eat = {
	OnRun = function(itemTable)
		local client = itemTable.player
		client:SetHealth(math.Clamp(client:Health() + 17, 0, client:GetMaxHealth()))
	end
}
