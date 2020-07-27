--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Loyalist-Grade Supplement Packet"
ITEM.model = Model("models/foodnhouseholdaaaaa/combirationc.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "This supplement packet contains a few little pills filled with various necessary vitamins and minerals, alongside a myriad of flavourful chewable bars."
ITEM.category = "Rations"
ITEM.noBusiness = true
ITEM.functions.Eat = {
	OnRun = function(itemTable)
		local client = itemTable.player
		client:SetHealth(math.Clamp(client:Health() + 10, 0, client:GetMaxHealth()))
	end
}
