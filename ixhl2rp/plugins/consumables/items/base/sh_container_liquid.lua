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
            if(!self.useLabel) then
                self.useLabel = self:Add("DLabel")
                self.useLabel:SetPos(w - 60, h - 20)
                self.useLabel:SetColor(Color(25, 197, 255, 125))
                self.useLabel:SetExpensiveShadow(2)
            end

            self.useLabel:SetText(item:GetData("currentAmount", 0) .. " mL")   
        end
        
        surface.SetDrawColor(25,25,25,20)
		surface.DrawRect(0,h-20, self:GetWide(), 2)
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