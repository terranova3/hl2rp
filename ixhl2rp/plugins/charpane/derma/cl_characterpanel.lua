local PANEL = {}

local function CharPaneAction(action, itemID, data)
	local invID = LocalPlayer():GetCharacter():GetInventory():GetID();

	net.Start("ixCharPaneAction")
		net.WriteString(action)
		net.WriteUInt(itemID, 32)
		net.WriteUInt(invID, 32)
		net.WriteUInt(panelID, 32)
		net.WriteTable(data or {})
	net.SendToServer()
end

function PANEL:Init()
	self.parent = self:GetParent()
	self.previewPanel = nil;
	self.equipment = true;
	self.isEmpty = true;
	self.iconSize = 64;

	self.text = "N/A";
	self:SetSize(self.iconSize, self.iconSize);
	self:SetPos(0,0)
	self:Receiver("ixInventoryItem", self.ReceiveDrop)
end;

function PANEL:GetPadding()
	return 0
end;

function PANEL:PaintDragPreview(width, height, mouseX, mouseY, itemPanel)
	local iconSize = 64
	local item = itemPanel:GetItemTable()

	if (item) then
		if(item.outfitCategory == string.lower(self.category)) then
			if (self.isEmpty) then
				surface.SetDrawColor(0, 255, 0, 40)
			else
				surface.SetDrawColor(255, 255, 0, 40)
			end
		else
			surface.SetDrawColor(255, 0, 0, 40)
		end;

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
		if (panel.OnDrop) then
			local dropX = 0
			local dropY = 0

			panel:OnDrop(true, self, nil, dropX, dropY)
		end

		self.previewPanel = nil
	else
		self.previewPanel = panel
		self.previewX = x
		self.previewY = y
	end
end


function PANEL:OnTransfer(oldX, oldY, x, y, oldInventory, noSend)
	local inventories = ix.item.inventories
	local inventory = inventories[oldInventory.invID]
	local item

	if (inventory) then
		item = inventory:GetItemAt(oldX, oldY)

		if (!item) then
			return false
		end

		if(item.outfitCategory != string.lower(self.category)) then
			return false, "notAllowed"
		end

		if (hook.Run("CanTransferItem", item, inventories[oldInventory.invID], inventories[self.invID]) == false) then
			return false, "notAllowed"
		end

		if (item.CanTransfer and
			item:CanTransfer(inventory, inventory != inventory2 and inventory2 or nil) == false) then
			return false
		end
	end

	--self.parent.model:SetModel(LocalPlayer():GetModel(), nil, "00004")
end;

vgui.Register("ixCharacterEquipmentSlot", PANEL, "DPanel")

local PANEL = {}

function PANEL:Init()
	self:SetSize(360, 525)
	
	self.model = self:Add("ixModelPanel")
	self.model:Dock(FILL)
	self.model:SetModel(LocalPlayer():GetModel())
	self.model:SetFOV(50)
	self.model.follow = false;
	self.panels = {}
	self.slotPlacements = {
		["headgear"] = {x = 5, y = 100},
		["headstrap"] = {x = 291, y = 100},
		["torso"] = {x = 5, y = 170},
		["kevlar"] = {x = 5, y = 240},
		["hands"] = {x = 291, y = 300},
		["legs"] = {x = 291, y = 370},
	}

	ix.gui.charPanel = self;
end

function PANEL:SetCharPanel(charPanel, bFitParent)
	self.panelID = charPanel:GetID()
	self:BuildSlots();
end

function PANEL:BuildSlots()
	self.slots = self.slots or {}

	for k, v in pairs(self.slotPlacements) do
		local slot = self:Add("ixCharacterEquipmentSlot");
		slot.category = k;
		slot.text = k;
		slot:SetPos(v.x, v.y);

		self.slots[k] = slot
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

vgui.Register("ixCharacterPane", PANEL, "DPanel")

net.Receive("ixInventoryMove", function()

end)
