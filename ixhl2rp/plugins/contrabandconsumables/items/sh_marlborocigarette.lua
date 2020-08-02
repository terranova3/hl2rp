--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Marlboro Cigarette"
ITEM.model = Model("models/phycinnew.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Delicious, authentic, lung-killing addiction sticks. There's a brand indent on the filter of the cigarette, reading 'MARLBORO'."
ITEM.category = "Contraband"
ITEM.functions.Smoke = {
	OnRun = function(itemTable)
		local client = itemTable.player
		client:RestoreStamina(12)
	end
}