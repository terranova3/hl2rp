--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

ITEM.name = "Stackable Item Base";
ITEM.description = "No description avaliable.";
ITEM.maxStack = 5;
ITEM.defaultStack = 1;

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