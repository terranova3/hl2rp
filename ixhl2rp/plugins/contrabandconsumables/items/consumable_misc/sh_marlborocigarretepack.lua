--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Marlboro Cigarette Pack"
ITEM.model = Model("models/kek1ch/drink_cigar0.mdl")
ITEM.width = 1
ITEM.height = 2
ITEM.description = "A pre-war pack of authentic Malboro cigarette's. The smell of nicotine wafts from the pack; it's definitely real tobbacco."
ITEM.category = "Contraband Consumables Misc"
ITEM.items = {"marlborocigarette", "marlborocigarette", "marlborocigarette", "marlborocigarette"} -- Items to be unpacked/opened

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

