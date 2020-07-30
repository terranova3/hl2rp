--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Medi Gel"
ITEM.model = Model("models/healthvial.mdl")
ITEM.description = "A small vial of medicinal antlion liquids, combined with synthetic materials to accelerate mitosis."
ITEM.category = "Medical"
ITEM.flag = "m"
ITEM.price = 30

ITEM.functions.Apply = {
    name = "Apply",
    icon = "icon16/pill.png",
	sound = "items/medshot4.wav",
	OnRun = function(itemTable)
		local client = itemTable.player

		client:SetHealth(math.min(client:Health() + 25, client:GetMaxHealth()))
	end
}
