--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Rolling Tobaco"
ITEM.model = Model("models/kek1ch/dev_hand_rolling_tobacco.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Some old world tobacco set to be rolled into hand-made cigarettes."
ITEM.category = "Contraband"
ITEM.flag = "n"
ITEM.price = 4;

ITEM.combine = function(item, targetItem)
    local client = item:GetOwner()
	local inventory = client:GetCharacter():GetInventory()
	
    if(targetItem.uniqueID == "rollingpaper") then
	   inventory:Add("handmadecigarettes", 1)
	end
end

