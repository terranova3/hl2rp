--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Kolbasa"
ITEM.model = Model("models/kek1ch/dev_kolbasa.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "A Russian variety of meats, ground and wrapped with animal intestines as its casing. Not very appetizing, huh?"
ITEM.category = "Contraband Food"

ITEM.functions.Eat = {
	OnRun = function(itemTable)
		local client = itemTable.player
		client:SetHealth(math.Clamp(client:Health() + 10, 0, client:GetMaxHealth()))
	end
}
