--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Human Liver"
ITEM.model = Model("models/gibs/humans/liver_gib.mdl")
ITEM.width = 1
ITEM.height = 2
ITEM.description = "Used to be lively. Dead now."
ITEM.category = "Contraband Food Meats"

ITEM.functions.Eat = {
	OnRun = function(itemTable)
		local client = itemTable.player
		client:SetHealth(math.Clamp(client:Health() + 3, 0, client:GetMaxHealth()))
	end
}
