--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "CPF-Grade Supplement Packet"
ITEM.model = Model("models/probs_misc/tobccco_box-1.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "This supplement packet contains some decent gum, some tasty bars, and a handful of various pills for necessary minerals and vitamins."
ITEM.category = "Rations"
ITEM.noBusiness = true
ITEM.functions.Eat = {
	OnRun = function(itemTable)
		local client = itemTable.player
		client:SetHealth(math.Clamp(client:Health() + 10, 0, client:GetMaxHealth()))
	end
}
