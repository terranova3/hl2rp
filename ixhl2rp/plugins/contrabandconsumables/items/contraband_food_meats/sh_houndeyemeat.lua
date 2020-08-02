--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Houndeye Meat"
ITEM.model = Model("models/gibs/houndeye/back_leg.mdl")
ITEM.width = 1
ITEM.height = 2
ITEM.description = "An uncooked piece of a screaming four-legged creature."
ITEM.category = "Contraband Food Meats"

ITEM.functions.Eat = {
	OnRun = function(itemTable)
		local client = itemTable.player
		client:SetHealth(math.Clamp(client:Health() + 4, 0, client:GetMaxHealth()))
	end
}
