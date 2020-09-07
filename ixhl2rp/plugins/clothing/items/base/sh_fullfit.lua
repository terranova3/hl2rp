--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

ITEM.base = "base_outfit"
ITEM.name = "Uniform";
ITEM.model = "models/mark2580/gtav/garage_stuff/smallplasticbox.mdl";
ITEM.replacements = "models/hlvr/characters/worker/npc/worker_citizen.mdl";
ITEM.category = "Clothing";
ITEM.description = "A suitcase full of clothes.";
ITEM.width = 2
ITEM.height = 2
ITEM.backgroundColor = Color(19, 72, 96, 100)
ITEM.outfitCategory = "model"
ITEM.maxArmor = 10;
ITEM.dropSound = {
"terranova/ui/clothes1.wav",
"terranova/ui/clothes2.wav",
"terranova/ui/clothes3.wav",
}

ITEM.noBusiness = true
ITEM.suppressed = function(itemTable)
	local character = itemtable.player:GetCharacter()
	local charPanel = character:GetCharPanel()

	if(charPanel:HasEquipped()) then
		return true, "Equip", "You can't equip a uniform with items in your character panel!"
	end

	return false
end

function ITEM:OnEquipped()
	self.player:SetArmor(self:GetData("armor", self.maxArmor))
	self.player:ResetBodygroups()
	ix.charPanel.Update(self.player) 
end

function ITEM:OnUnequipped()
	self:SetData("armor", math.Clamp(self.player:Armor(), 0, self.maxArmor))
	self.player:SetArmor(0)

	self.player:ResetBodygroups()
	ix.charPanel.Update(self.player)
	ix.plugin.list.facialhair:RestoreFacialHair(self.player:GetCharacter())
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