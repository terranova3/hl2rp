--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Lighter"
ITEM.model = Model("models/se_ex/dev_lighter.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "[PH] Needs description."
ITEM.category = "Contraband"
ITEM.price = 4;
ITEM.flag = "G"
ITEM.combine = function(item, targetItem)
	local client = item:GetOwner()
	
	if(targetItem.base == "cigarettes") then
		targetItem:SetData("lit", true)
	end

    return false
end