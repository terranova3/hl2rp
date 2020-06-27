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
end

function ITEM:GetSpace()
    if(self:GetData("currentAmount") < self.capacity) then
        return true, self.capacity - self:GetData("currentAmount")
    end

    return false, 0
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