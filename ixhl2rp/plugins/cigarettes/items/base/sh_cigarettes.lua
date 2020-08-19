--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN

ITEM.name = "Cigarettes base"
ITEM.model = Model("models/polievka/cigar.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Cigarettes base"
ITEM.price = 20;
ITEM.time = 90
ITEM.functions.Smoke = {
	OnRun = function(itemTable)
		local client = itemTable.player

		if(!itemTable:HasTime()) then
			return false
		end

		if(itemTable:IsLit()) then
			PLUGIN:StartSmoking(client:GetCharacter(), itemTable)
		else
			client:Notify("You have to light your cigarette before you smoke it!")
		end

		return false
	end
}
ITEM.functions.PutOut = {
	OnRun = function(itemTable)
		local client = itemTable.player

		if(!itemTable:IsLit()) then
			return false
		end

		if(itemTable:IsLit()) then
			self:SetData("lit", false)
		end

		return false
	end
}


-- Called when a new instance of this item has been made.
function ITEM:OnInstanced(invID, x, y)
	self:SetData("time", self.time)
	self:SetData("smoking", false)
	self:SetData("lit", false)
end

-- Returns if the cigarette is lit.
function ITEM:IsLit()
	return self:GetData("lit", false)
end

-- Returns if the cigarette is being smoked.
function ITEM:IsSmoking()
	return self:GetData("smoking", false)
end

-- Returns if a cigarette has time left.
function ITEM:HasTime()
	return self:GetData("time", 0)
end
