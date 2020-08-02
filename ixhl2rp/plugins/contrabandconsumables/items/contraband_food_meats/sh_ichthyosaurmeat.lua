--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Ichthyosaur Meat"
ITEM.model = Model("models/gibs/xenians/mgib_02.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Uncooked meat from a fish you would deserve a medal for killing, and many more awards for eating."
ITEM.category = "Contraband Food Meats"

ITEM.functions.Eat = {
	OnRun = function(itemTable)
		local client = itemTable.player
		client:SetHealth(math.Clamp(client:Health() + 4, 0, client:GetMaxHealth()))
	end
}
