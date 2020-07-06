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
        local hasLiquid, liquid = itemTable:GetLiquid()
        local modifier = liquid / itemTable.capacity

        if(hasLiquid) then
            itemTable:SetData("currentAmount", 0)
            itemTable.drinkEffects(itemTable, modifier)
        else
            client:Notify(string.format("%s is empty.", itemTable.name))
        end

        return false
	end
}
ITEM.functions.Sip = {
    icon = "icon16/drink.png",
	OnRun = function(itemTable)
        local client = itemTable.player
        local hasLiquid, liquid = itemTable:GetLiquid()
        local modifier = liquid / itemTable.capacity

        if(modifier > 0.1) then
            modifier = 0.1
        end

        if(hasLiquid) then
            local newAmount = itemTable:GetData("currentAmount") - (itemTable.capacity * modifier)

            itemTable:SetData("currentAmount", math.Clamp(newAmount, 0, 9999))
            itemTable.drinkEffects(itemTable, modifier)
        else
            client:Notify(string.format("%s is empty.", itemTable.name))
        end

        return false
	end
}
ITEM.drinkEffects = function(itemTable, modifier)
    local client = itemTable.player
    
    if(itemTable.alcoholPercentage) then end

    if(itemTable.restoreStamina) then
        client:RestoreStamina(itemTable.restoreStamina * modifier)
    end

    if(itemTable.restoreHealth) then
        client:SetHealth(math.Clamp(client:Health() + (itemTable.restoreHealth * modifier), 0, client:GetMaxHealth()))
    end
end
ITEM.dragged = function(item, item2)
    local client = item:GetOwner()

    if(item2.capacity and item:GetLiquid()) then
        local hasSpace, spaceLeft = item2:GetSpace()
        local hasLiquid, liquid = item2:GetLiquid()

        if(hasSpace) then
            if(!hasLiquid) then 
                item2:SetData("currentAmount", item2:GetData("currentAmount") + spaceLeft)
                item2:SetData("currentLiquid", item.uniqueID)

                local newAmount = item:GetData("currentAmount") - spaceLeft

                item:SetData("currentAmount", math.Clamp(newAmount, 0, 9999))
            else
                client:Notify(string.format("%s currently is holding a different liquid! You cannot mix different liquids."))
            end
        else
            client:Notify(string.format("%s has reached its maximum capacity.", item2.name))
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
            if(!self.useLabel) then
                self.useLabel = self:Add("DLabel")
                self.useLabel:SetPos(w - 60, h - 20)
                self.useLabel:SetColor(Color(25, 197, 255, 125))
                self.useLabel:SetExpensiveShadow(3)       
            end

            self.useLabel:SetText(item:GetData("currentAmount", 0) .. " mL")   
		end
	end
end

function ITEM:GetLiquid()
    if(self:GetData("currentAmount") > 0) then
        return true, self:GetData("currentAmount")
    end

    return false, nil
end

function ITEM:PopulateTooltip(tooltip)
	local data = tooltip:AddRow("data")
	data:SetBackgroundColor(derma.GetColor("Success", tooltip))
	data:SetText("Capacity: " .. self.capacity .." mL\nCurrent Amount: " .. self:GetData("currentAmount", self.capacity) .. " mL")
	data:SetFont("BudgetLabel")
	data:SetExpensiveShadow(0.5)
	data:SizeToContents()
end