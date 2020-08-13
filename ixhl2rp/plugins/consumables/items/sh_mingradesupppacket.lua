--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Minimal-Grade Supplement Packet"
ITEM.model = Model("models/gibs/props_canteen/vm_sneckol.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "This supplement packet is just filled with a nutritional mushy mass without flavour."
ITEM.category = "Rations"
ITEM.noBusiness = true
ITEM.functions.Eat = {
	OnRun = function(itemTable)
		local client = itemTable.player
		client:SetHealth(math.Clamp(client:Health() + 5, 0, client:GetMaxHealth()))
	end
}
