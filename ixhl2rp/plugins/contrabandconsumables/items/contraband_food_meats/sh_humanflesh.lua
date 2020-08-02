--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Human Flesh"
ITEM.model = Model("models/kek1ch/raw_dog.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "A meat that can be cooked and eaten."
ITEM.category = "Contraband Food Meats"

ITEM.functions.Eat = {
	OnRun = function(itemTable)
		local client = itemTable.player
		client:SetHealth(math.Clamp(client:Health() + 4, 0, client:GetMaxHealth()))
	end
}
