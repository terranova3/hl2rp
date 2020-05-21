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

function META:Remove(id, bNoReplication, _, bTransferring)
    local category
    for k, v in pairs(self.slots) do
        local item = self.slots[k]

        if(item and item.id == id) then
            self.slots[k] = nil

            category = category or k;
        end;
    end;

	if (SERVER and !bNoReplication) then
		local receivers = self:GetReceivers()

        if (istable(receivers)) then
            --[[ TODO
			net.Start("ixInventoryRemove")
				net.WriteUInt(id, 32)
				net.WriteUInt(self:GetID(), 32)
            net.Send(receivers)
            --]]
		end

		-- we aren't removing the item - we're transferring it to another inventory
		if (!bTransferring) then
			--hook.Run("InventoryItemRemoved", self, ix.item.instances[id])
		end
	end

	return category
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
			local oldInvID = item.invID

			if (category) then
				targetCharPanel.slots[category] = item

				item:Transfer(nil, nil, nil, item.player, nil, true)
				item.panelID = targetCharPanel:GetID()

				targetCharPanel:SendSlot(category, item)

				local query = mysql:Update("ix_items")
					query:Update("panel_id", targetCharPanel:GetID())
					query:Where("item_id", item.id)
				query:Execute()


				hook.Run("CharPanelItemEquipped", client, ix.item.inventories[oldInvID], targetCharPanel, item)

				return category, targetCharPanel:GetID()
			else
				return false, "noFit"
			end
		end
	end

	function META:Sync(receiver, fullUpdate)
		local slots = {}

		for k, item in pairs(self.slots) do
			if (istable(item)) then
				slots[#slots + 1] = {item.uniqueID, item.id, item.outfitCategory, item.data}
			end
		end

		print("Syncing")
		PrintTable(slots)
		print("Syncing")

		net.Start("ixCharPanelSync")
			net.WriteTable(slots)
			net.WriteUInt(self:GetID(), 32)
			net.WriteType((receiver == nil or fullUpdate) and self.owner or nil)
			net.WriteTable(self.vars or {})
		net.Send(receiver)
	end
end

ix.meta.charPanel = META