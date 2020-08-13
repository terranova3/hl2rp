--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "CPF-Grade Meal Kit"
ITEM.model = Model("models/mres/consumables/zag_mre.mdl")
ITEM.width = 1
ITEM.height = 2
ITEM.description = "A high-grade, well packaged meal filled with various luxury, hearty meals, including real vegetables and meat. There's a CCA logo on the front."
ITEM.category = "Rations"
ITEM.noBusiness = true
ITEM.functions.Eat = {
	OnRun = function(itemTable)
		local client = itemTable.player
		client:SetHealth(math.Clamp(client:Health() + 18, 0, client:GetMaxHealth()))
	end
}
