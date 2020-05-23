--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Drink Consumable Base";
ITEM.model = "models/mark2580/gtav/barstuff/Beer_AM.mdl";
ITEM.width	= 1;
ITEM.height	= 1;
ITEM.description = "Drink Consumable base";
ITEM.category = "Drinks";
ITEM.functions.Drink = {
	OnRun = function(itemTable)
        local client = itemTable.player
        
        if(itemTable.restoreStamina) then
            client:RestoreStamina(itemTable.restoreStamina)
        end

        if(itemTable.restoreHealth) then
            client:SetHealth(math.Clamp(client:Health() + itemTable.restoreHealth, 0, client:GetMaxHealth()))
        end
	end
}