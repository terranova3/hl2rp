--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Rolling Papers"
ITEM.model = Model("models/props_lab/box01a.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Some papers set for some tobacco to be rolled into hand-made cigarettes."
ITEM.category = "Contraband"
ITEM.flag = "F"
ITEM.price = 4;

function ITEM:Combine(targetItem)
	local client = item.player
    local inventory = client:GetCharacter():GetInventory()

	if(targetItem.uniqueID == "rollingtobaco") then
	   inventory:Add("handmadecigarettes", 1)
	   return true
	end
end