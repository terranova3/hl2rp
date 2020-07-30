--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Medical Base"
ITEM.model = Model("models/bloocobalt/l4d/items/w_eq_pills.mdl")
ITEM.description = "A bottle of antibiotics used to treat bacterial complications."
ITEM.category = "Medical"
ITEM.flag = "m"
ITEM.price = 20
ITEM.restoreHealth = 0
ITEM.functions.Apply = {
    name = "Apply",
    icon = "icon16/pill.png",
	sound = "items/medshot4.wav",
	OnRun = function(itemTable)
		local client = itemTable.player

		client:SetHealth(math.min(client:Health() + itemTable.restoreHealth, client:GetMaxHealth()))
	end
}
ITEM.functions.Give = {
    name = "Apply",
    icon = "icon16/pill.png",
	sound = "items/medshot4.wav",
	OnRun = function(itemTable)
        local client = itemTable.player   
		local target = client:GetEyeTraceNoCursor().Entity;

        if (!target or target:GetPos():Distance(client:GetShootPos() ) >= 192) then
            return false
		end

		target:SetHealth(math.min(target:Health() + itemTable.restoreHealth, target:GetMaxHealth()))
	end
}
