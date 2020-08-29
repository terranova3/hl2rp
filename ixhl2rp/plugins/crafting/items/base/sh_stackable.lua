--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

ITEM.name = "Stackable Item Base";
ITEM.description = "No description avaliable.";
ITEM.model = "models/mark2580/gtav/barstuff/Beer_AM.mdl";
ITEM.width = 1;
ITEM.height = 1;
ITEM.maxStack = 5;
ITEM.defaultStack = 1;

-- Called when this item is dragged onto another one.
function ITEM:Combine(targetItem)
    if(targetItem.uniqueID == self.uniqueID) then
        local sentStacks = 0

        -- Evaluating how many stacks we need to transfer between the two items.
        if((targetItem:GetStacks() + self:GetStacks()) <= targetItem.maxStack) then
            sentStacks = self:GetStacks()
        else
            sentStacks = (targetItem.maxStack - targetItem:GetStacks())
        end

        -- Adding the stacks together.
        targetItem:SetData("stack", targetItem:GetStacks() + sentStacks)
        self:SetData("stack", math.Clamp(self:GetStacks() - sentStacks, 0, self.maxStack))

        -- If the original item has no more stacks, we need to delete it.
        if(self:GetStacks() <= 0) then
            self:Remove()
        end
    end
end

-- Called as a get method when we need to get the item stacks.
function ITEM:GetStacks()
    return self:GetData("stack", 1)
end

-- Called when a new instance of this item has been made.
function ITEM:OnInstanced(invID, x, y)
    self:SetData("stack", self.defaultStack)
end

-- Called when we need to check if the item can split it's stacks.
function ITEM:CanSplit()
    if(self:GetData("stack", 0) >= 2) then
        return true
    end

    return false
end

-- Use this as a debug to display our stacks.
function ITEM:PopulateTooltip(tooltip)
    local data = tooltip:AddRow("data")

    data:SetText("Stacks: " .. self:GetData("stack", self.defaultStack) .. "/" .. self.maxStack)
    data:SetFont("ixPluginCharSubTitleFont")
	data:SizeToContents()
end

-- Clientside inventory paintover
if (CLIENT) then
    function ITEM:PaintOver(item, w, h)
		ix.util.DrawText(item:GetStacks(), w-12, h-19, Color(218,171,3,255), 0, 0, "ixSmallFont")
	end
end