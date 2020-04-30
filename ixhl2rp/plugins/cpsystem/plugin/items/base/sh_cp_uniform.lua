--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN;

ITEM.base = "base_outfit"
ITEM.name = "Uniform";
ITEM.model = "models/props_c17/suitcase_passenger_physics.mdl";
ITEM.replacements = "models/props_c17/suitcase_passenger_physics.mdl";
ITEM.category = "Clothing";
ITEM.description = "A suitcase full of clothes.";
ITEM.width = 2;
ITEM.height = 2;
ITEM.maxArmor = 100;
ITEM.invWidth = 1
ITEM.invHeight = 1

if (CLIENT) then
	function ITEM:PopulateTooltip(tooltip)
		local panel = tooltip:AddRowAfter("name", "armor")
		panel:SetBackgroundColor(derma.GetColor("Info", tooltip))
		panel:SetText("Armor: " .. (self:GetData("equip") and LocalPlayer():Armor() or self:GetData("armor", self.maxArmor)))
		panel:SizeToContents()

		local panelID = tooltip:AddRowAfter("name", "armor")
		panelID:SetBackgroundColor(derma.GetColor("DarkerBackground", tooltip))
		panelID:SetText("Assigned to: " .. (self:GetData("tagline") or "a"))
		panelID:SizeToContents()
	end
end

function ITEM:OnEquipped()
	self.player:SetArmor(self:GetData("armor", self.maxArmor))
	PLUGIN:AdjustPlayer("Equipped", self.player);
end

function ITEM:OnUnequipped()
	self:SetData("armor", math.Clamp(self.player:Armor(), 0, self.maxArmor))
	self.player:SetArmor(0)
	PLUGIN:AdjustPlayer("Unequipped", self.player);
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