local PANEL = {}

function PANEL:Init()
	self.parent = self:GetParent()
	self.previewPanel = nil;
	self.isEmpty = true;

	self.text = "N/A";
	self:SetSize(64,64);
	self:SetPos(0,0)
	self:Receiver("ixInventoryItem", self.ReceiveDrop)
end;

function PANEL:SetSlot(text)
	self.text = text;
end;

function PANEL:PaintDragPreview(width, height, mouseX, mouseY, itemPanel)
	local iconSize = 64
	local item = itemPanel:GetItemTable()

	if (item) then
		if (self.isEmpty) then
			surface.SetDrawColor(0, 255, 0, 10)
		else
			surface.SetDrawColor(255, 255, 0, 10)
		end

		surface.DrawRect(0, 0, 64, 64)
	end
end

function PANEL:PaintOver()
	surface.SetTextColor(color_white)
	surface.SetTextPos(5, 5)
	surface.DrawText(self.text)

	local panel = self.previewPanel

	if (IsValid(panel)) then
		local itemPanel = (dragndrop.GetDroppable() or {})[1]

		if (IsValid(itemPanel)) then
			self:PaintDragPreview(width, height, self.previewX, self.previewY, itemPanel)
		end
	end

	self.previewPanel = nil
end;

function PANEL:ReceiveDrop(panels, bDropped, menuIndex, x, y)
	local panel = panels[1]

	if (!IsValid(panel)) then
		self.previewPanel = nil
		return
	end

	if (bDropped) then
		local inventory = ix.item.inventories[self.invID]

		if (inventory and panel.OnDrop) then
			local dropX = math.ceil((x - 4 - (panel.gridW - 1) * 32) / self.iconSize)
			local dropY = math.ceil((y - self:GetPadding(2) - (panel.gridH - 1) * 32) / self.iconSize)

			panel:OnDrop(true, self, inventory, dropX, dropY)
		end

		self.previewPanel = nil
	else
		self.previewPanel = panel
		self.previewX = x
		self.previewY = y
	end
end

vgui.Register("ixCharacterEquipmentSlot", PANEL, "DPanel")

local PANEL = {}
local slots = {}

slots = {
	["Headgear"] = { 
		x = 5, 
		y = 100
	},
	["Headstrap"] = {
		x = 291,
		y = 100,
	},
	["Torso"] = {
		x = 5,
		y = 170,
	},
	["Kevlar"] = {
		x = 5,
		y = 240,
	},
	["Hands"] = {
		x = 291,
		y = 300,
	},
	["Legs"] = {
		x = 291,
		y = 370,
	},
}

function PANEL:Init()
	self:SetSize(360, 525)
	
	self.model = self:Add("ixModelPanel")
	self.model:Dock(FILL)
	self.model:SetModel(LocalPlayer():GetModel())
	self.model:SetFOV(50)
	self.model.follow = false;
	
	self.slots = {}

	for k, v in pairs(slots) do
		slot = self:Add("ixCharacterEquipmentSlot");
		slot:SetSlot(k);
		slot:SetPos(v.x, v.y);
		table.insert(self.slots, slot);
	end;
end

function PANEL:Paint()
	derma.SkinFunc("PaintCategoryPanel", self, "", ix.config.Get("color") or color_white)
	surface.SetDrawColor(0, 0, 0, 50);	

	surface.SetFont("ixMediumLightFontSmaller")
	surface.SetTextColor(Color(255,255,255,255))
	surface.SetTextPos(4, 4)
	surface.DrawText(LocalPlayer():GetName())
end;
function PANEL:Update(character)
	if (!character) then
		return
	end

	
end

vgui.Register("ixCharacterPane", PANEL, "DPanel")