--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Standard-Grade Supplement Packet"
ITEM.model = Model("models/foodnhouseholdaaaaa/combirationb.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "This supplement packet contains some pills for necessary vitamins and minerals, along with some alright tasting chewy grey bits."
ITEM.category = "Rations"
ITEM.noBusiness = true
ITEM.functions.Eat = {
	OnRun = function(itemTable)
		local client = itemTable.player
		client:SetHealth(math.Clamp(client:Health() + 8, 0, client:GetMaxHealth()))
	end
}
