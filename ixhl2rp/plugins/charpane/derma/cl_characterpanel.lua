local RECEIVER_NAME = "ixInventoryItem"

-- The queue for the rendered icons.
ICON_RENDER_QUEUE = ICON_RENDER_QUEUE or {}

-- To make making inventory variant, This must be followed up.
local function RenderNewIcon(panel, itemTable)
	local model = itemTable:GetModel()

	-- re-render icons
	if ((itemTable.iconCam and !ICON_RENDER_QUEUE[string.lower(model)]) or itemTable.forceRender) then
		local iconCam = itemTable.iconCam
		iconCam = {
			cam_pos = iconCam.pos,
			cam_ang = iconCam.ang,
			cam_fov = iconCam.fov,
		}
		ICON_RENDER_QUEUE[string.lower(model)] = true

		panel.Icon:RebuildSpawnIconEx(
			iconCam
		)
	end
end

local PANEL = {}

AccessorFunc(PANEL, "itemTable", "ItemTable")
AccessorFunc(PANEL, "panelID", "PanelID")

function PANEL:Init()
	self:Droppable(RECEIVER_NAME)
end

function PANEL:OnMousePressed(code)
	if (code == MOUSE_LEFT and self:IsDraggable()) then
		self:MouseCapture(true)
		self:DragMousePress(code)

		self.clickX, self.clickY = input.GetCursorPos()
	end
end

function PANEL:OnMouseReleased(code)
	-- move the item into the world if we're dropping on something that doesn't handle inventory item drops
	if (!dragndrop.m_ReceiverSlot or dragndrop.m_ReceiverSlot.Name != RECEIVER_NAME) then
		self:OnDrop(dragndrop.IsDragging())
	end

	self:DragMouseRelease(code)
	self:SetZPos(99)
	self:MouseCapture(false)
end

function PANEL:OnDrop(bDragging, inventoryPanel, inventory, gridX, gridY)
	local item = self.itemTable

	if (!item or !bDragging) then
		return
	end

	local invID = 0

	if (IsValid(inventoryPanel) and inventoryPanel:IsAllEmpty(gridX, gridY, item.width, item.height, self)) then
		invID = inventoryPanel.invID
	end

	net.Start("ixCharPanelTransfer")
		net.WriteUInt(item.id, 32)
		net.WriteUInt(invID, 32)
		net.WriteUInt(self:GetPanelID(), 32)
		net.WriteUInt(gridX or 0, 6)
		net.WriteUInt(gridY or 0, 6)
	net.SendToServer()
end

function PANEL:PaintOver(width, height)
	local itemTable = self.itemTable

	if (itemTable and itemTable.PaintOver) then
		itemTable.PaintOver(self, itemTable, width, height)
	end
end

function PANEL:ExtraPaint(width, height)
end

function PANEL:Paint(width, height)
	surface.SetDrawColor(0, 0, 0, 85)
	surface.DrawRect(2, 2, width - 4, height - 4)
	
	self:ExtraPaint(width, height)
end

vgui.Register("ixCharPanelItemIcon", PANEL, "SpawnIcon")

local PANEL = {}

function PANEL:Init()
	self:SetSize(360, 525)
	self.model = self:Add("ixModelPanel")
	self.model:Dock(FILL)
	self.model:SetModel(LocalPlayer():GetModel())
	self.model:SetFOV(50)

	-- Don't display until we have the bodygroups loaded.
	self.model:SetVisible(false)

	self.panels = {}
	self.slotPlacements = {
		["headgear"] = {x = 5, y = 100},
		["headstrap"] = {x = 291, y = 100},
		["torso"] = {x = 5, y = 170},
		["kevlar"] = {x = 5, y = 240},
		["hands"] = {x = 291, y = 300},
		["legs"] = {x = 291, y = 370},
	}

	net.Receive("ixCharPanelLoadModel", function()
		local bodygroups = net.ReadTable()

		for k, v in pairs(bodygroups) do
			self.model.Entity:SetBodygroup(k, v)
		end

		self.model:SetVisible(true)
	end)

	net.Receive("ixCharPanelUpdateModel", function()
		local index = net.ReadUInt(8)
		local bodygroup = net.ReadUInt(8)

		self.model.Entity:SetBodygroup(index, bodygroup)
	end)
end

function PANEL:SetCharPanel(charPanel, bFitParent)
	self.panelID = charPanel:GetID()

	self:BuildSlots();

	for k, items in pairs(charPanel.slots) do
		if (!items.id) then continue end

		local item = ix.item.instances[items.id]

		if (item and !IsValid(self.panels[item.id])) then
			local icon = self:AddIcon(
				item, item:GetModel() or "models/props_junk/popcan01a.mdl", item.outfitCategory, item:GetSkin()
			)

			if (IsValid(icon)) then
				icon:SetHelixTooltip(function(tooltip)
					ix.hud.PopulateItemTooltip(tooltip, item)
				end)

				icon.itemID = item.id
				self.panels[item.id] = icon
			end
		end
	end
end

function PANEL:GetIconPlacement(category)
	return self.slotPlacements[category];
end;

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

function PANEL:AddIcon(item, model, category, skin)
	local panel = self:Add("ixCharPanelItemIcon")
	local pos = self:GetIconPlacement(category);

	if(!category) then
		category = item.outfitCategory
	end;

	panel:SetSize(64, 64)
	panel:SetZPos(999)
	panel:InvalidateLayout(true)
	panel:SetModel(model, skin)
	panel:SetPos(pos.x, pos.y)
	panel.gridW = 1
	panel.gridH = 1

	local charPanel = ix.charPanels[self.panelID]

	if (!charPanel) then
		return
	end

	panel:SetPanelID(charPanel:GetID())
	panel:SetItemTable(item)

	if (self.panels[item:GetID()]) then
		self.panels[item:GetID()]:Remove()
	end

	if (item.exRender) then
		panel.Icon:SetVisible(false)
		panel.ExtraPaint = function(this, panelX, panelY)
			local exIcon = ikon:GetIcon(item.uniqueID)
			if (exIcon) then
				surface.SetMaterial(exIcon)
				surface.SetDrawColor(color_white)
				surface.DrawTexturedRect(0, 0, panelX, panelY)
			else
				ikon:renderIcon(
					item.uniqueID,
					item.width,
					item.height,
					item:GetModel(),
					item.iconCam
				)
			end
		end
	else
		RenderNewIcon(panel, item)
	end

	local slot = self.slots[category]

	if(IsValid(slot)) then
		slot.item = panel;
	end;

	return panel
end;

function PANEL:Paint()
	derma.SkinFunc("PaintCategoryPanel", self, "", ix.config.Get("color") or color_white)
	surface.SetDrawColor(0, 0, 0, 50);	

	surface.SetFont("ixMediumLightFontSmaller")
	surface.SetTextColor(Color(255,255,255,255))
	surface.SetTextPos(4, 4)
	surface.DrawText(LocalPlayer():GetName())
end;

vgui.Register("ixCharacterPane", PANEL, "DPanel")

local PANEL = {}

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
	--surface.SetTextColor(color_white)
	--surface.SetTextPos(5, 5)
	--surface.DrawText(self.text)

	local picture = string.format("materials/terranova/ui/charpane/slot_%s.png", self.category)

	self.mat = vgui.Create("Material", self)
    self.mat:SetPos(0, 0)
    self.mat:SetSize(64, 64)
    self.mat:SetMaterial(picture)
	self.mat.AutoSize = false

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
			local item = panels[1].itemTable;
			local invID = LocalPlayer():GetCharacter():GetInventory():GetID();
			local panelID = self.parent.panelID;

			if (!item) then
				return false
			end
	
			if(item.outfitCategory != string.lower(self.category)) then
				return false, "notAllowed"
			end

			net.Start("ixCharPanelReceiveItem")
				net.WriteUInt(item.id, 32)
				net.WriteUInt(invID, 32)
				net.WriteUInt(panelID, 32)
				net.WriteTable({})
			net.SendToServer()
		end

		self.previewPanel = nil
	else
		self.previewPanel = panel
		self.previewX = x
		self.previewY = y
	end
end
--self.parent.model:SetModel(LocalPlayer():GetModel(), nil, "00004")
vgui.Register("ixCharacterEquipmentSlot", PANEL, "DPanel")