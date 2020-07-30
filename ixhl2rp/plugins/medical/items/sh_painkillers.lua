--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Pain Killers"
ITEM.model = Model("models/carlsmei/escapefromtarkov/medical/ibuprofen.mdl")
ITEM.description = "A bottle of painkiller tablets used to relieve immediate pain."
ITEM.category = "Medical"
ITEM.flag = "m"
ITEM.price = 20

ITEM.functions.Apply = {
    name = "Apply",
    icon = "icon16/pill.png",
	OnRun = function(itemTable)
		local client = itemTable.player

		client:SetHealth(math.min(client:Health() + 20, client:GetMaxHealth()))
	end
}
