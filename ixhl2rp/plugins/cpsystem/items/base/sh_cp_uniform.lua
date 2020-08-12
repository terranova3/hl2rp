--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN;

ITEM.base = "base_outfit"
ITEM.name = "Uniform";
ITEM.model = "models/vj_props/duffle_bag.mdl";
ITEM.replacements = "models/ma/hla/terranovapolice.mdl";
ITEM.category = "Clothing";
ITEM.outfitCategory = "model"
ITEM.description = "A suitcase full of clothes.";
ITEM.backgroundColor = Color(19, 72, 96, 100)
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(300.84295654297, 251, 194.2449798584),
	ang = Angle(25, 220, 0),
	fov = 4.1176470588235
}
ITEM.maxArmor = 100;
ITEM.noBusiness = true
ITEM.suppressed = function(itemTable)
	local charPanel = itemTable.player:GetCharacter():GetCharPanel()

	if(charPanel:HasEquipped()) then
		return true, "Equip", "You can't equip a uniform with items in your character panel!"
	end

	return false
end

if (CLIENT) then
	function ITEM:PopulateTooltip(tooltip)
		local panel = tooltip:AddRowAfter("name", "armor")
		panel:SetBackgroundColor(derma.GetColor("Info", tooltip))
		panel:SetText("Armor: " .. (self:GetData("equip") and LocalPlayer():Armor() or self:GetData("armor", self.maxArmor)))
		panel:SizeToContents()

		if(self:GetData("name")) then
			local panelID = tooltip:AddRowAfter("name", "armor")
		
			panelID:SetBackgroundColor(derma.GetColor("Info", tooltip))
			panelID:SetText(string.format("This uniform is assigned to: %s", self:GetData("name")))
			panelID:SizeToContents()
		end;
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