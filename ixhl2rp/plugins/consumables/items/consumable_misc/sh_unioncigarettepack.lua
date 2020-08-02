--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.namem= "Union Cigarette Packet"
ITEM.model = Model("models/closedboxshit.mdl")
ITEM.width = 1
ITEM.height = 2
ITEM.description = "Packet of neatly packaged replications of the original death-stick flavoured smokeables."
ITEM.category = "Contraband Consumables Misc"
ITEM.items = {"unioncigarette", "unioncigarette", "unioncigarette", "unioncigarette"} -- Items to be unpacked/opened

ITEM.functions.Open = {
	OnRun = function(itemTable)
		local client = itemTable.player
		local character = client:GetCharacter()

		for k, v in ipairs(itemTable.items) do
			if (!character:GetInventory():Add(v)) then
				ix.item.Spawn(v, client)
			end
		end
	end
}

