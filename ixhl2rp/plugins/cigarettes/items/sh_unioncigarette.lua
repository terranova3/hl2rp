--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Approved Cigarette"
ITEM.model = Model("models/phycitnew.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Something resembling the original deliciously flavoured death-sticks of time past. It's okay."
ITEM.category = "Other"
ITEM.flag = "n"
ITEM.functions.Smoke = {
	OnRun = function(itemTable)
		local client = itemTable.player
		client:RestoreStamina(12)
	end
}

