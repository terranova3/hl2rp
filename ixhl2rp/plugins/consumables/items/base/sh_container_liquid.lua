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
        data:SetBackgroundColor(derma.GetColor("Info", tooltip))
        data:SetText("Capacity: " .. self.capacity .." mL\nEmpty")
    else 
        data:SetBackgroundColor(derma.GetColor("Success", tooltip))
        data:SetText("Capacity: " .. self.capacity .." mL\nCurrent Amount: " .. self:GetData("currentAmount") .. " mL")
    end

	data:SetFont("BudgetLabel")
	data:SetExpensiveShadow(0.5)
	data:SizeToContents()
end