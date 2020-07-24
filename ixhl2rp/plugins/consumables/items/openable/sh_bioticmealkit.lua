--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Biotic-Grade Meal Kit"
ITEM.model = Model("models/mres/consumables/lag_mre.mdl")
ITEM.width = 1
ITEM.height = 2
ITEM.description = "This biotic-grade meal kit is in fact, a real meal, using leftover antlion grub bits."
ITEM.category = "Rations"
ITEM.functions.Eat = {
	OnRun = function(itemTable)
		local client = itemTable.player
		client:SetHealth(math.Clamp(client:Health() + 8, 0, client:GetMaxHealth()))
	end
}