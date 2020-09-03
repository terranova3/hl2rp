--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Lighter"
ITEM.model = Model("models/se_ex/dev_lighter.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Handheld device designed to spark a flame to light things on fire."
ITEM.category = "Contraband"
ITEM.price = 4;
ITEM.flag = "G"

function ITEM:Combine(targetItem)
<<<<<<< HEAD
	if(targetItem.base == "base_cigarettes") then
		targetItem:SetData("lit", true)
=======
	if(targetItem.Light) then
		local error = targetItem:Light()

		if(error) then
			self:GetOwner():Notify(error)
		end
>>>>>>> parent of 80d9e45e... Revert "UPDATE: new trait icon for calm"
	end
end