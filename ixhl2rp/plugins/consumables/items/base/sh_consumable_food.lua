--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Food Consumable Base";
ITEM.model = "models/mark2580/gtav/barstuff/Beer_AM.mdl";
ITEM.width	= 1;
ITEM.height	= 1;
ITEM.description = "Food Consumable base";
ITEM.category = "Food";
ITEM.flag = "F"
ITEM.functions.Eat = {
	OnRun = function(itemTable)
        local client = itemTable.player
        
        if(itemTable.restoreStamina) then
            client:RestoreStamina(itemTable.restoreStamina)
            client:SetHealth(math.Clamp(client:Health() + itemTable.restoreStamina, 0, client:GetMaxHealth()))
        end

        if(itemTable.restoreHealth) then
            client:SetHealth(math.Clamp(client:Health() + itemTable.restoreHealth, 0, client:GetMaxHealth()))
        end
	end
}