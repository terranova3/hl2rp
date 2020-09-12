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
ITEM.time = 300
ITEM.pacData = PLUGIN.pacData.unlit
ITEM.pacDataAlternate = PLUGIN.pacData.lit
ITEM.functions.Equip = {
	icon = "icon16/tick.png",
	OnRun = function(item)
		local character = item.player:GetCharacter()

		for k, v in pairs(character:GetInventory():GetItems()) do
			if(v.Light and v:GetData("equip", false) == true) then
				return "You already have a cigarette equipped."
			end
		end 

		if(ix.plugin.list.toxicgas:IsGasImmune(item.player)) then
			return "You can't equip a cigarette right now."
		end

		item:SetData("equip", true)
		item.player:AddPart(item.uniqueID, item)

		return false
	end
}
ITEM.functions.EquipUn = {
	icon = "icon16/cross.png",
	name = "Unequip",
	OnRun = function(item)
		item:SetData("equip", false)
		item:SetData("lit", false)
		
		item.player:RemovePart(item.uniqueID)
		PLUGIN:DestroyTimer(item.player:GetCharacter())

		return false
	end
}

function ITEM:Light()
	if(!self:GetData("equip")) then
		return "You must equip this item first before lighting it."
	end

	if(!self:GetData("lit")) then 
		local client = self:GetOwner()

		self:SetData("lit", true)

		-- Removes the unlit pacData.
		client:RemovePart(self.uniqueID)
		client:AddPart(self.uniqueID, self, { self:GetData("lit") })

		PLUGIN:StartSmoking(client:GetCharacter(), self)
	else
		return "This item is already lit!"
	end
end

function ITEM:pacAdjust(pacData, client, data)
	if(data and data[1]) then
		return self.pacDataAlternate
	end

	return self.pacData
end

-- Called when a new instance of this item has been made.
function ITEM:OnInstanced(invID, x, y)
	self:SetData("time", self.time)
	self:SetData("lit", false)
end

-- Returns if the cigarette is lit.
function ITEM:IsLit()
	return self:GetData("lit", false)
end

-- Returns if a cigarette has time left.
function ITEM:HasTime()
	return self:GetData("time", 0)
end

if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("equip")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 20, 8, 8)
		end

		local time = item:GetData("time")

		if (time) then
			surface.SetDrawColor(35, 35, 35, 225)
			surface.DrawRect(2, h-9, w-4, 7)

			local filledWidth = (w-5) * (item:GetData("time", 0) / item.time)
			local barColor = Color(255, 255, 255, 160)

			if(item:GetData("lit")) then
				barColor = Color(235, 85, 52, 255)
			end

			surface.SetDrawColor(barColor)
			surface.DrawRect(3, h-8, filledWidth, 5)
		end
	end
end

function ITEM:OnRemoved()
	local client = self:GetOwner()
	
	client:RemovePart(self.uniqueID)
end