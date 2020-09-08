--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Liquid Base";
ITEM.model = "models/mark2580/gtav/barstuff/Beer_AM.mdl";
ITEM.width	= 1;
ITEM.height	= 1;
ITEM.description = "liquid base";
ITEM.category = "Liquid";
ITEM.noBusiness = true
ITEM.capacity = 500
ITEM.bAllowContainer = false

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