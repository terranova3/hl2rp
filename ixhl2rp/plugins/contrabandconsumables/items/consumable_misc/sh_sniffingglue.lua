--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Glue"
ITEM.model = Model("models/kek1ch/glue_a.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "A stick of pre-Union glue. Please do not eat, or sniff."
ITEM.category = "Contraband Consumables Misc"

ITEM.functions.Use = {
	OnRun = function(itemTable)
		local client = itemTable.player
		client:RestoreStamina(2)
	end
}
