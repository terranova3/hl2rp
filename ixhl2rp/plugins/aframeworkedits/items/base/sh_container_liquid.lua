--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Liquid Container Base";
ITEM.model = "models/props_junk/garbage_coffeemug001a.mdl";
ITEM.width	= 1;
ITEM.height	= 1;
ITEM.description = "Liquid Container base";
ITEM.category = "Containers";
ITEM.capacity = 500
ITEM.isContainer = true
ITEM.flag = "g"
ITEM.functions.Drink = {
    icon = "icon16/drink.png",
    OnRun = function(itemTable)
        local client = itemTable.player
        local hasLiquid, amount = itemTable:GetLiquid()

        if(!hasLiquid) then
            client:Notify(string.format("%s is empty.", itemTable.name))
            return false
        end

        local _, liquidType = itemTable:GetLiquidType()
        local modifier = amount / itemTable.capacity
        local liquid = ix.item.list[liquidType]

        if(liquid) then
            itemTable:SetData("currentAmount", 0)
            itemTable:SetData("currentLiquid", nil)

            if(liquid.drinkEffects) then
                liquid.drinkEffects(itemTable, modifier)
                client:GetCharacter():PlaySound("terranova/ui/liquidtransfer.wav")
            end
        end

        return false
	end
}
ITEM.functions.Sip = {
    icon = "icon16/drink.png",
	OnRun = function(itemTable)
        local client = itemTable.player
        local hasLiquid, amount = itemTable:GetLiquid()

        if(!hasLiquid) then
            client:Notify(string.format("%s is empty.", itemTable.name))
            return false
        end

        local modifier = amount / itemTable.capacity

        if(modifier > 0.1) then
            modifier = 0.1
        end

        local _, liquidType = itemTable:GetLiquidType()
        local liquid = ix.item.list[liquidType]
        
        if(liquid) then
            local newAmount = itemTable:GetData("currentAmount") - (itemTable.capacity * modifier)

            itemTable:SetData("currentAmount", math.Clamp(newAmount, 0, 9999))

            if(itemTable:GetData("currentAmount") <= 0) then
                itemTable:SetData("currentLiquid", nil)
            end

            if(liquid.drinkEffects) then
                liquid.drinkEffects(itemTable, modifier)
                client:GetCharacter():PlaySound("terranova/ui/liquidtransfer.wav")
            end
        end

        return false
	end
}
ITEM.suppressed = function(itemTable, name)
    if(name == "drop") then
        return
    end

	if(itemTable:GetData("currentAmount", 0) <= 0) then
		return true, name, "This container is empty."
	end

	return false
end

-- Called when a new instance of this item has been made.
function ITEM:OnInstanced(invID, x, y)
    self:SetData("currentAmount", 0)
    self:SetData("currentLiquid", nil)
end

function ITEM:GetSpace()
    if(self:GetData("currentAmount") < self.capacity) then
        return true, self.capacity - self:GetData("currentAmount")
    end

    return false, 0
end

function ITEM:GetLiquid()
    if(self:GetData("currentAmount") > 0) then
        return true, self:GetData("currentAmount")
    end

    return false, nil
end

function ITEM:GetLiquidType()
    local currentLiquid = self:GetData("currentLiquid")

    if(currentLiquid) then
        return true, currentLiquid
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
        data:SetText("\nCapacity: " .. self.capacity .." mL\n" ..
        "Current Amount: " .. self:GetData("currentAmount") .. " mL\n" ..
        "Contains " .. ix.item.list[self:GetData("currentLiquid")].name .. ".")
    end

    data:SetFont("ixPluginCharSubTitleFont")
	data:SizeToContents()
end