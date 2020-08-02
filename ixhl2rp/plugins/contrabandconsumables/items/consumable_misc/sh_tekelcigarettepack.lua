--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.namem= "Tekel Cigarette Pack"
ITEM.model = Model("models/closedboxshin.mdl")
ITEM.width = 1
ITEM.height = 2
ITEM.description = "Authentic, neatly presented package of delicious addiction sticks."
ITEM.category = "Contraband Consumables Misc"
ITEM.items = {"tekelcigarette", "tekelcigarette", "tekelcigarette", "tekelcigarette"} -- Items to be unpacked/opened

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

