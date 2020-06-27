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
ITEM.capacity = 500
ITEM.functions.Drink = {
	OnRun = function(itemTable)
        local client = itemTable.player
        
        -- TODO
        -- Add a drunk effect
        if(itemTable.alcoholPercentage) then

        end

        if(itemTable.restoreStamina) then
            client:RestoreStamina(itemTable.restoreStamina)
        end

        if(itemTable.restoreHealth) then
            client:SetHealth(math.Clamp(client:Health() + itemTable.restoreHealth, 0, client:GetMaxHealth()))
        end
	end
}
ITEM.dragged = function(item)
    if(item.capacity and self:HasLiquid()) then
        local space, spaceLeft = item:GetSpace()

        if(space and spaceLeft < self:GetData("currentAmount")) then
            item:SetData("currentAmount", item:GetData("currentAmount") + spaceLeft)
            self:SetData("currentAmount", self:GetData("currentAmount") - spaceLeft)
        end
    end
end

-- Called when a new instance of this item has been made.
function ITEM:OnInstanced(invID, x, y)
    self:SetData("currentAmount", self.capacity)
end

function ITEM:HasLiquid()
    if(self:GetData("currentAmount") > 0) then
        return true
    end

    return false
end

function ITEM:PopulateTooltip(tooltip)
	local data = tooltip:AddRow("data")
	data:SetBackgroundColor(derma.GetColor("Success", tooltip))
	data:SetText("It's still sealed.\n" .. "Capacity: " .. self.capacity .." mL\nCurrent Amount: " .. self:GetData("currentAmount") or self.capacity .. " mL")
	data:SetFont("BudgetLabel")
	data:SetExpensiveShadow(0.5)
	data:SizeToContents()
end