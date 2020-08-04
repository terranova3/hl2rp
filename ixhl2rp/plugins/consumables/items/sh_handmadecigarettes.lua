--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Handmade Cigarettes"
ITEM.model = Model("models/phycinnew.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Handmade with love cigarettes with real, lethal tobacco."
ITEM.category = "Other"
ITEM.flag = "n"
ITEM.functions.Smoke = {
	OnRun = function(itemTable)
		local client = itemTable.player
		client:RestoreStamina(15)
	end
}

