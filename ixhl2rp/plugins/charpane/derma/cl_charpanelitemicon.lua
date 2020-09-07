--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local RECEIVER_NAME = "ixInventoryItem"
local PLUGIN = PLUGIN

-- The queue for the rendered icons.
ICON_RENDER_QUEUE = ICON_RENDER_QUEUE or {}

-- To make making inventory variant, This must be followed up.
function PLUGIN:RenderNewIcon(panel, itemTable)
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
	self:SetSize(64,64)
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

	if(item.dropSound and ix.option.Get("toggleInventorySound", false)) then
		if(istable(item.dropSound)) then
			local randomSound = item.dropSound[math.random(1, table.Count(item.dropSound))]
			surface.PlaySound(randomSound)
		else
			surface.PlaySound(item.dropSound)
		end
	end
	
	net.Start("ixCharPanelTransfer")
		net.WriteUInt(item.id, 32)
		net.WriteUInt(invID, 32)
		net.WriteUInt(self:GetPanelID(), 32)
		net.WriteUInt(gridX or 0, 6)
		net.WriteUInt(gridY or 0, 6)
	net.SendToServer()

	if(ix.gui.charPanel.slots[item.outfitCategory]) then
		ix.gui.charPanel.slots[item.outfitCategory].isEmpty = true
	end
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
	local background = Color(74, 74, 74, 130)

	surface.SetDrawColor(0, 0, 0, 85)
	surface.DrawRect(2, 2, width - 4, height - 4)

	surface.SetDrawColor(Color(100, 100, 100, 60))
	surface.DrawOutlinedRect(0, 0, width, height)

	if(self.itemTable and self.itemTable.backgroundColor) then
		background = self.itemTable.backgroundColor
	end

	surface.SetDrawColor(background)
	surface.DrawRect(2, 2, width - 4, height - 4)

	self:ExtraPaint(width, height)
end

vgui.Register("ixCharPanelItemIcon", PANEL, "SpawnIcon")
