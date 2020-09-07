--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of the author.
--]]

ITEM.name = "Kevlar";
ITEM.model = "models/props_junk/cardboard_box004a.mdl";
ITEM.outfitCategory = "kevlar";
ITEM.category = "Clothing - Armor";
ITEM.description = "Kevlar Base";
ITEM.width = 1;
ITEM.height = 1;
ITEM.maxArmor = 100;
ITEM.backgroundColor = Color(19, 72, 96, 100)
ITEM.price = 40
ITEM.dropSound = {
"terranova/ui/clothes1.wav",
"terranova/ui/clothes2.wav",
"terranova/ui/clothes3.wav",
}

if (CLIENT) then
	function ITEM:PopulateTooltip(tooltip)
		local panel = tooltip:AddRowAfter("name", "armor")
		panel:SetBackgroundColor(derma.GetColor("Info", tooltip))
		panel:SetText("Armor: " .. (self:GetData("equip") and LocalPlayer():Armor() or self:GetData("armor", self.maxArmor)))
		panel:SizeToContents()
	end
end

function ITEM:OnEquipped()
	self.player = client
	self.player:SetArmor(self:GetData("armor", self.maxArmor))
end

function ITEM:OnUnequipped()
	self.player = client
	self.player:SetArmor(0)
end

function ITEM:Repair(amount)
	self:SetData("armor", math.Clamp(self:GetData("armor") + amount, 0, self.maxArmor))
end

function ITEM:OnLoadout()
	self.player:SetArmor(self:GetData("armor", self.maxArmor))
end

function ITEM:OnSave()
	self:SetData("armor", math.Clamp(self.player:Armor(), 0, self.maxArmor))
end

ITEM.iconCam = {
	pos = Vector(0, -3, 241.83006286621),
	ang = Angle(90, -90, 0),
	fov = 7.6470588235294
}
ITEM.backgroundColor = Color(19, 72, 96, 100)