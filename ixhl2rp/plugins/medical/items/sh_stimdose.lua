--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Stim-Dose Auto Injector"
ITEM.model = Model("models/ccr/props/syringe.mdl")
ITEM.description = "A synthetic mixture of antlion properties used to releive immediate pain"
ITEM.category = "Medical"
ITEM.flag = "m"
ITEM.price = 30

ITEM.functions.Apply = {
    name = "Apply",
    icon = "icon16/pill.png",
	sound = "items/medshot4.wav",
	OnRun = function(itemTable)
		local client = itemTable.player

		client:SetHealth(math.min(client:Health() + 30, client:GetMaxHealth()))
	end
}
