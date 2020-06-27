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
    icon = "icon16/drink.png",
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
ITEM.functions.Sip = ITEM.functions.Drink

ITEM.dragged = function(item, item2)
    if(item2.capacity and item:HasLiquid()) then
        local space, spaceLeft = item2:GetSpace()

        if(space) then
            item2:SetData("currentAmount", item2:GetData("currentAmount") + spaceLeft)

            local newAmount = item:GetData("currentAmount") - spaceLeft

            -- We cant have a negative amount.
            if(newAmount <= 0) then
                newAmount = 0
            end

            item:SetData("currentAmount", newAmount)
        end
    end
end

-- Called when a new instance of this item has been made.
function ITEM:OnInstanced(invID, x, y)
    self:SetData("currentAmount", self.capacity)
end

if (CLIENT) then
    function ITEM:PaintOver(item, w, h)
        local amount = item:GetData("currentAmount", 0)

		if (amount) then
			surface.SetDrawColor(0, 0, 0, 100)
            surface.DrawRect(w - 14, h - 14, 8, 8)
            
            surface.SetDrawColor(25, 197, 255, 125)
            surface.DrawRect(w - 14, h - 14, 8, (amount / item.capacity) * 8)
		end
	end
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
	data:SetText("Capacity: " .. self.capacity .." mL\nCurrent Amount: " .. self:GetData("currentAmount", self.capacity) .. " mL")
	data:SetFont("BudgetLabel")
	data:SetExpensiveShadow(0.5)
	data:SizeToContents()
end