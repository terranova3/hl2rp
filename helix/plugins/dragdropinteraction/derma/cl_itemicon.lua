local RECEIVER_NAME = "ixInventoryItem"

local function InventoryAction(action, itemID, invID, data)
	net.Start("ixInventoryAction")
		net.WriteString(action)
		net.WriteUInt(itemID, 32)
		net.WriteUInt(invID, 32)
		net.WriteTable(data or {})
	net.SendToServer()
end

local function DragCombine(itemID, targetID, invID)
	net.Start("ixInventoryDragCombine")
        net.WriteUInt(itemID, 32)
        net.WriteUInt(targetID, 32)
		net.WriteUInt(invID, 32)
	net.SendToServer()
end

local PANEL = {}

AccessorFunc(PANEL, "itemTable", "ItemTable")
AccessorFunc(PANEL, "inventoryID", "InventoryID")

function PANEL:Init()
	self:Droppable(RECEIVER_NAME)
end

function PANEL:OnMousePressed(code)
	if (code == MOUSE_LEFT and self:IsDraggable()) then
		self:MouseCapture(true)
		self:DragMousePress(code)

		self.clickX, self.clickY = input.GetCursorPos()
	elseif (code == MOUSE_RIGHT and self.DoRightClick) then
		self:DoRightClick()
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

function PANEL:DoRightClick()
	local itemTable = self.itemTable
	local inventory = self.inventoryID

	if (itemTable and inventory) then
		itemTable.player = LocalPlayer()

		local menu = DermaMenu()
		local override = hook.Run("CreateItemInteractionMenu", self, menu, itemTable, inventory)

		if (override == true) then
			if (menu.Remove) then
				menu:Remove()
			end

			return
		end

		for k, v in SortedPairs(itemTable.functions) do
			if (k == "drop" or (v.OnCanRun and v.OnCanRun(itemTable) == false)) then
				continue
			end

			-- is Multi-Option Function
			if (v.isMulti) then
				local subMenu, subMenuOption = menu:AddSubMenu(L(v.name or k), function()
					itemTable.player = LocalPlayer()
						local send = true

						if (v.OnClick) then
							send = v.OnClick(itemTable)
						end

						if (v.sound) then
							surface.PlaySound(v.sound)
						end

						if (send != false) then
							InventoryAction(k, itemTable.id, inventory)
						end
					itemTable.player = nil
				end)
				subMenuOption:SetImage(v.icon or "icon16/brick.png")

				if (v.multiOptions) then
					local options = isfunction(v.multiOptions) and v.multiOptions(itemTable, LocalPlayer()) or v.multiOptions

					for _, sub in pairs(options) do
						subMenu:AddOption(L(sub.name or "subOption"), function()
							itemTable.player = LocalPlayer()
								local send = true

								if (v.OnClick) then
									send = v.OnClick(itemTable)
								end

								if (v.sound) then
									surface.PlaySound(v.sound)
								end

								if (send != false) then
									InventoryAction(k, itemTable.id, inventory, sub.data)
								end
							itemTable.player = nil
						end)
					end
				end
			else
				menu:AddOption(L(v.name or k), function()
					itemTable.player = LocalPlayer()
						local send = true

						if (v.OnClick) then
							send = v.OnClick(itemTable)
						end

						if (v.sound) then
							surface.PlaySound(v.sound)
						end

						if (send != false) then
							InventoryAction(k, itemTable.id, inventory)
						end
					itemTable.player = nil
				end):SetImage(v.icon or "icon16/brick.png")
			end
		end

		-- we want drop to show up as the last option
		local info = itemTable.functions.drop

		if (info and info.OnCanRun and info.OnCanRun(itemTable) != false) then
			menu:AddOption(L(info.name or "drop"), function()
				itemTable.player = LocalPlayer()
					local send = true

					if (info.OnClick) then
						send = info.OnClick(itemTable)
					end

					if (info.sound) then
						surface.PlaySound(info.sound)
					end

					if (send != false) then
						InventoryAction("drop", itemTable.id, inventory)
					end
				itemTable.player = nil
			end):SetImage(info.icon or "icon16/brick.png")
		end

		menu:Open()
		itemTable.player = nil
	end
end

function PANEL:OnDrop(bDragging, inventoryPanel, inventory, gridX, gridY)
	local item = self.itemTable

	if (!item or !bDragging) then
		return
	end

	if (!IsValid(inventoryPanel)) then
		local inventoryID = self.inventoryID

		if (inventoryID) then
			InventoryAction("drop", item.id, inventoryID, {})
		end
	elseif (inventoryPanel:IsAllEmpty(gridX, gridY, item.width, item.height, self)) then
		local oldX, oldY = self.gridX, self.gridY

		if (oldX != gridX or oldY != gridY or self.inventoryID != inventoryPanel.invID) then
			if(item.dropSound and ix.option.Get("toggleInventorySound", false)) then
				if(istable(item.dropSound)) then
					local randomSound = item.dropSound[math.random(1, table.Count(item.dropSound))]
					surface.PlaySound(randomSound)
				else
					surface.PlaySound(item.dropSound)
				end
			end

			self:Move(gridX, gridY, inventoryPanel)
		end
	else
		local target = inventory:GetItemAt(gridX, gridY)

		if(target) then
			DragCombine(item.id, target.id, self.inventoryID)
		end
	end
end

function PANEL:Move(newX, newY, givenInventory, bNoSend)
	local iconSize = givenInventory.iconSize
	local oldX, oldY = self.gridX, self.gridY
	local oldParent = self:GetParent()

	if (givenInventory:OnTransfer(oldX, oldY, newX, newY, oldParent, bNoSend) == false) then
		return
	end

	local x = (newX - 1) * iconSize + 4
	local y = (newY - 1) * iconSize + givenInventory:GetPadding(2)

	self.gridX = newX
	self.gridY = newY

	self:SetParent(givenInventory)
	self:SetPos(x, y)

	if (self.slots) then
		for _, v in ipairs(self.slots) do
			if (IsValid(v) and v.item == self) then
				v.item = nil
			end
		end
	end

	self.slots = {}

	for currentX = 1, self.gridW do
		for currentY = 1, self.gridH do
			local slot = givenInventory.slots[self.gridX + currentX - 1][self.gridY + currentY - 1]

			slot.item = self
			self.slots[#self.slots + 1] = slot
		end
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
	surface.SetDrawColor(0, 0, 0, 85)
	surface.DrawRect(2, 2, width - 4, height - 4)

	--surface.SetDrawColor(Color(100, 100, 100, 60))
	--surface.DrawOutlinedRect(0, 0, width, height)

	surface.SetDrawColor(Color(25, 25, 25, 225))
	surface.DrawRect(2, 2, width - 4, height - 4)

	if(self.itemTable.backgroundColor) then
		surface.SetDrawColor(self.itemTable.backgroundColor)
		surface.DrawRect(2, 2, width - 4, height - 4)
	end

	self:ExtraPaint(width, height)
end

vgui.Register("ixItemIcon", PANEL, "SpawnIcon")