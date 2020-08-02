--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "CWU Manufactured Cigarette"
ITEM.model = Model("models/phycitnew.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Something resembling the original deliciously flavoured death-sticks of time past. It's okay."
ITEM.category = "Contraband Consumables Misc"

ITEM.functions.Use = {
	OnRun = function(itemTable)
		local client = itemTable.player
		client:RestoreStamina(12)
	end
}

