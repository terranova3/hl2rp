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
	if(targetItem.Light) then
		local error = targetItem:Light()

		if(error) then
			self:GetOwner():Notify(error)
		else
			self:GetOwner():GetCharacter():PlaySound("terranova/ui/smoke.wav")
		end
	end
end