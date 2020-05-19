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
	function META:Sync(receiver, fullUpdate)
		local slots = {}

		net.Start("ixCharPanelSync")
			net.WriteTable(slots)
			net.WriteUInt(self:GetID(), 32)
			net.WriteType((receiver == nil or fullUpdate) and self.owner or nil)
			net.WriteTable(self.vars or {})
		net.Send(receiver)
	end
end

ix.meta.charPanel = META