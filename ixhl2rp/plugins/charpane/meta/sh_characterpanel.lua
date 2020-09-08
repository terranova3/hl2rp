--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]
local META = ix.meta.charPanel or {}
META.__index = META
META.slots = META.slots or {}
META.vars = META.vars or {}
META.receivers = META.receivers or {}

function META:__tostring()
	return "charpanel["..(self.id or 0).."]"
end

function META:GetID()
	return self.id or 0
end

function META:GetOwner()
	for _, v in ipairs(player.GetAll()) do
		if (v:GetCharacter() and v:GetCharacter().id == self.owner) then
			return v
		end
	end
end

function META:HasEquipped()
	for _, v in pairs(self.slots) do
		return true
	end

	return false
end

function META:GetItems()
	local items = {}

	for k, v in pairs(self.slots) do
		table.insert(items, v)
	end

	return items or {}
end

function META:SetOwner(owner, fullUpdate)
	if (type(owner) == "Player" and owner:GetNetVar("char")) then
		owner = owner:GetNetVar("char")
	elseif (!isnumber(owner)) then
		return
	end
	if (SERVER) then
		if (fullUpdate) then
			for _, v in ipairs(player.GetAll()) do
				if (v:GetNetVar("char") == owner) then
					self:Sync(v, true)

					break
				end
			end
		end

		local query = mysql:Update("ix_charpanels")
			query:Update("character_id", owner)
			query:Where("panel_id", self:GetID())
		query:Execute()
	end

	self.owner = owner
end

function META:OnCheckAccess(client)
	local bAccess = false

	for _, v in ipairs(self:GetReceivers()) do
		if (v == client) then
			bAccess = true
			break
		end
	end

	return bAccess
end

function META:GetItemAt(category)
	if (self.slots and self.slots[category]) then
		return self.slots[category]
	end
end

function META:Remove(id)
	for k, item in pairs(self.slots) do
		if(item and item.id == id) then
			self.slots[k] = nil
		end
	end

	if (SERVER) then
		local receivers = self:GetReceivers()

		if (istable(receivers)) then
			net.Start("ixCharPanelRemove")
				net.WriteUInt(id, 32)
				net.WriteUInt(self:GetID(), 32)
			net.Send(receivers)
		end
	end
end

function META:AddReceiver(client)
	self.receivers[client] = true
end

function META:RemoveReceiver(client)
	self.receivers[client] = nil
end

function META:GetReceivers()
	local result = {}

	if (self.receivers) then
		for k, _ in pairs(self.receivers) do
			if (IsValid(k) and k:IsPlayer()) then
				result[#result + 1] = k
			end
		end
	end

	return result
end

if (SERVER) then
	function META:SendSlot(category, item)
		local receivers = self:GetReceivers()
		local sendData = item and item.data and !table.IsEmpty(item.data) and item.data or {}

		net.Start("ixCharPanelSet")
			net.WriteUInt(self:GetID(), 32)
			net.WriteString(category)
			net.WriteString(item and item.uniqueID or "")
			net.WriteUInt(item and item.id or 0, 32)
			net.WriteUInt(self.owner or 0, 32)
			net.WriteTable(sendData)
		net.Send(receivers)
	end

	function META:Add(uniqueID, data, category)
		local client = self.GetOwner and self:GetOwner() or nil
		local item = isnumber(uniqueID) and ix.item.instances[uniqueID] or ix.item.list[uniqueID]

		local targetCharPanel = self

		if (!item) then
			return false, "invalidItem"
		end

		if (isnumber(uniqueID)) then
			if (category) then
				targetCharPanel.slots[category] = item

				item:Transfer(nil, nil, nil, item.player, nil, true, true)
				item.panelID = targetCharPanel:GetID()

				local query = mysql:Update("ix_items")
					query:Update("panel_id", targetCharPanel:GetID())
					query:Where("item_id", item.id)
				query:Execute()

				hook.Run("CharPanelItemEquipped", client, item)

				targetCharPanel:SendSlot(category, item)

				return category, targetCharPanel:GetID()
			else
				return false, "noFit"
			end
		end
	end

	function META:Transfer(uniqueID, invID, x, y)
		local item = isnumber(uniqueID) and ix.item.instances[uniqueID] or ix.item.list[uniqueID]
		local inventory = ix.item.inventories[invID]
		local charPanel = self
		local world = 0

		if (charPanel) then
			client = charPanel:GetOwner() or nil

			item.panelID = world

			hook.Run("CharPanelItemUnequipped", client, item)
			charPanel:Remove(item.id)
			
			if(invID == world) then
				item.invID = world

				inventory = ix.item.inventories[world]
				inventory[item:GetID()] = item

				local query = mysql:Update("ix_items")
					query:Update("inventory_id", world)
					query:Update("panel_id", world)
					query:Where("item_id", item.id)
				query:Execute()

				return item:Spawn(client)
			elseif(invID != world) then			 
				local targetInv = inventory
				local bagInv
		
				if (!item) then
					return false, "invalidItem"
				end
				
				if (isnumber(uniqueID)) then		
					if (!x and !y) then
						x, y, bagInv = inventory:FindEmptySlot(item.width, item.height)
					end
		
					if (bagInv) then
						targetInv = bagInv
					end
		
					-- we need to check for owner since the item instance already exists
					if (!item.bAllowMultiCharacterInteraction and IsValid(client) and client:GetCharacter() and
						item:GetPlayerID() == client:SteamID64() and item:GetCharacterID() != client:GetCharacter():GetID()) then
						return false, "itemOwned"
					end
		
					if (hook.Run("CanTransferItem", item, ix.item.inventories[0], targetInv) == false) then
						return false, "notAllowed"
					end
		
					if (x and y) then
						targetInv.slots[x] = targetInv.slots[x] or {}
						targetInv.slots[x][y] = true
		
						item.gridX = x
						item.gridY = y
						item.invID = targetInv:GetID()
		
						for x2 = 0, item.width - 1 do
							local index = x + x2
		
							for y2 = 0, item.height - 1 do
								targetInv.slots[index] = targetInv.slots[index] or {}
								targetInv.slots[index][y + y2] = item
							end
						end
		
						if (!noReplication) then
							targetInv:SendSlot(x, y, item)
						end
		
						if (!inventory.noSave) then
							local query = mysql:Update("ix_items")
								query:Update("inventory_id", targetInv:GetID())
								query:Update("panel_id", world)
								query:Update("x", x)
								query:Update("y", y)
								query:Where("item_id", item.id)
							query:Execute()
						end
		
						--hook.Run("InventoryItemAdded", ix.item.inventories[oldInvID], targetInv, item)
		
						return x, y, targetInv:GetID()
					end	

					return false, "noFit"
				end
			end
		else
			return false, "invalidInventory"
		end
	end

	function META:Sync(receiver, fullUpdate, func)
		local slots = {}

		for k, item in pairs(self.slots) do
			if (istable(item)) then
				slots[#slots + 1] = {item.uniqueID, item.id, item.outfitCategory, item.data}
			end
		end

		net.Start("ixCharPanelSync")
			net.WriteTable(slots)
			net.WriteUInt(self:GetID(), 32)
			net.WriteType((receiver == nil or fullUpdate) and self.owner or nil)
			net.WriteTable(self.vars or {})
		net.Send(receiver)

		for _, v in pairs(self:GetItems()) do
			v:Call("OnSendData", receiver)
		end

		if(func) then
			func()
		end
	end
end

ix.meta.charPanel = META