--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Antiviral Drugs"
ITEM.model = Model("models/phalanx/item_phalanx.mdl")
ITEM.description = "A small bottle of Antiviral drugs used to treat viral infections, it advises you take the whole course."
ITEM.category = "Medical"
ITEM.flag = "m"
ITEM.price = 40

ITEM.functions.Apply = {
    name = "Apply",
    icon = "icon16/pill.png",
	OnRun = function(itemTable)
		local client = itemTable.player

		client:SetHealth(math.min(client:Health() + 10, client:GetMaxHealth()))
	end
}
