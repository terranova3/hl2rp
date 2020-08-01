--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN;

ITEM.base = "base_outfit"
ITEM.name = "Uniform";
ITEM.model = "models/mark2580/gtav/garage_stuff/smallplasticbox.mdl";
ITEM.replacements = "models/hlvr/characters/worker/npc/worker_citizen.mdl";
ITEM.category = "Clothing";
ITEM.description = "A suitcase full of clothes.";
ITEM.width = 2
ITEM.height = 2
ITEM.maxArmor = 10;
ITEM.noBusiness = true
ITEM.suppressed = function(itemTable)
	local charPanel = itemTable.player:GetCharacter():GetCharPanel()

	if(charPanel:HasEquipped()) then
		return true, "Equip", "You can't equip a uniform with items in your character panel!"
	end

	return false
end

function ITEM:OnEquipped()
	self.player:SetArmor(self:GetData("armor", self.maxArmor))
end

function ITEM:OnUnequipped()
	self:SetData("armor", math.Clamp(self.player:Armor(), 0, self.maxArmor))
	self.player:SetArmor(0)

end

function ITEM:Repair(amount)
	self:SetData("armor", math.Clamp(self:GetData("armor") + amount, 0, self.maxArmor))
end

function ITEM:OnLoadout()
	if (self:GetData("equip")) then
		self.player:SetArmor(self:GetData("armor", self.maxArmor))
	end
end

function ITEM:OnSave()
	if (self:GetData("equip")) then
		self:SetData("armor", math.Clamp(self.player:Armor(), 0, self.maxArmor))
	end
end