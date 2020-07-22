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

        if(!hasLiquid) then
            client:Notify(string.format("%s is empty.", itemTable.name))

            return false
        end

        local modifier = liquid / itemTable.capacity

        if(hasLiquid) then
            itemTable:SetData("currentAmount", 0)
            itemTable.drinkEffects(itemTable, modifier)
        end

        return false
	end
}
ITEM.functions.Sip = {
    icon = "icon16/drink.png",
	OnRun = function(itemTable)
        local client = itemTable.player
        local hasLiquid, liquid = itemTable:GetLiquid()

        if(!hasLiquid) then
            client:Notify(string.format("%s is empty.", itemTable.name))

            return false
        end

        local modifier = liquid / itemTable.capacity

        if(modifier > 0.1) then
            modifier = 0.1
        end

        if(hasLiquid) then
            local newAmount = itemTable:GetData("currentAmount") - (itemTable.capacity * modifier)

            itemTable:SetData("currentAmount", math.Clamp(newAmount, 0, 9999))
            itemTable.drinkEffects(itemTable, modifier)
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

    if(item2.capacity and item:GetLiquid() and item2.isContainer) then
        local hasSpace, spaceLeft = item2:GetSpace()
        local hasLiquid, liquid = item2:GetLiquidType()

        if(hasSpace) then
            if(!hasLiquid or liquid == item.uniqueID) then
                local amountToGive
                
                if(spaceLeft >= item:GetData("currentAmount", 0)) then
                    amountToGive = item:GetData("currentAmount", 0)
                else
                    amountToGive = spaceLeft
                end

                item2:SetData("currentAmount", item2:GetData("currentAmount") + amountToGive)
                item2:SetData("currentLiquid", item.uniqueID)
                item:SetData("currentAmount", math.Clamp(item:GetData("currentAmount") - amountToGive, 0, 9999))
            else
                client:Notify(string.format("%s currently is holding a different liquid! You cannot mix different liquids."))
            end
        else
            client:Notify(string.format("%s has reached its maximum capacity.", item2.name))
        end
    end
end
ITEM.suppressed = function(itemTable, name)
    if(name == "drop") then
        return
    end
    
	if(itemTable:GetData("currentAmount", 0) <= 0) then
		return true, name, "This drink is empty."
	end

	return false
end

-- Called when a new instance of this item has been made.
function ITEM:OnInstanced(invID, x, y)
    self:SetData("currentAmount", self.capacity)
end

function ITEM:GetLiquid()
    if(self:GetData("currentAmount") > 0) then
        return true, self:GetData("currentAmount")
    end

    return false, nil
end

if (CLIENT) then
    function ITEM:PaintOver(item, w, h)
        local amount = item:GetData("currentAmount", 0)

        if (amount) then
            surface.SetDrawColor(35, 35, 35, 225)
            surface.DrawRect(2, h-9, w-4, 7)

			local filledWidth = (w-5) * (item:GetData("currentAmount", 0) / item.capacity)
			
            surface.SetDrawColor(93, 122, 229, 255)
            surface.DrawRect(3, h-8, filledWidth, 5)

            --self.useLabel:SetText(item:GetData("currentAmount", 0) .. " mL")   
		end
	end
end

function ITEM:PopulateTooltip(tooltip)
    local data = tooltip:AddRow("data")

    if(self:GetData("currentAmount", 0) <= 0) then
        data:SetText("\nCapacity: " .. self.capacity .." mL\nEmpty")
    else 
	    data:SetText("Capacity: " .. self.capacity .." mL\nCurrent Amount: " .. self:GetData("currentAmount", self.capacity) .. " mL")
    end

    data:SetFont("ixPluginCharSubTitleFont")
	data:SizeToContents()
end