--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

if(SERVER) then
    util.AddNetworkString("ixStorageOpenCharPanel")
	util.AddNetworkString("ixStorageCloseCharPanel")
	
    function ix.storage.OpenPlayer(client, inventory, charPanel, info)
		assert(IsValid(client) and client:IsPlayer(), "expected valid player")
        assert(getmetatable(inventory) == ix.meta.inventory, "expected valid inventory")
        assert(getmetatable(charPanel) == ix.meta.charPanel, "expected valid character panel")

        if (!inventory.storageInfo) then
			info = info or {}
			ix.storage.CreateContext(inventory, info)
		end

		-- add the client to the list of receivers if we're allowed to have multiple users
		-- or if nobody else is occupying this inventory, otherwise nag the player
		if (!ix.storage.InUse(inventory)) then
            ix.storage.AddCharPanelReceiver(client, inventory, charPanel)
		else
			client:NotifyLocalized("storageInUse")
			return
		end
    end

	function ix.storage.AddCharPanelReceiver(client, inventory, charPanel, bDontSync)
		local info = inventory.storageInfo

        if (info) then
			inventory:AddReceiver(client)
			charPanel:AddReceiver(client)

			client.realCharPanel = client:GetCharacter():GetCharPanel()
			client.realInventory = client:GetCharacter():GetInventory()

			client.ixOpenStorage = inventory
			client.ixOpenStorageCharPanel = charPanel

			-- update receivers for any bags this inventory might have
			for _, v in pairs(charPanel:GetItems()) do
				if (v.isBag and v:GetInventory()) then
					v:GetInventory():AddReceiver(client)
				end
			end
			
			for _, v in pairs(inventory:GetItems()) do
				if (v.isBag and v:GetInventory()) then
					v:GetInventory():AddReceiver(client)
				end
			end

            if (!bDontSync) then
				ix.storage.SyncCharPanel(client, inventory, charPanel)
			end
		end
	end

	function ix.storage.RemoveCharPanelReceiver(client, inventory, charPanel, bDontRemove)
		charPanel:RemoveReceiver(client)
		inventory:RemoveReceiver(client)

		client:GetCharacter():SetCharPanel(client.realCharPanel)
		client.realCharPanel:AddReceiver(client)
		client.realInventory:AddReceiver(client)

		for _, v in pairs(charPanel:GetItems()) do
			if (v.isBag and v:GetInventory()) then
				v:GetInventory():RemoveReceiver(client)
			end
		end

		-- update receivers for any bags this inventory might have
		for _, v in pairs(inventory:GetItems()) do
			if (v.isBag and v:GetInventory()) then
				v:GetInventory():RemoveReceiver(client)
			end
		end

		client.ixOpenStorage = nil
		client.ixOpenStorageCharPanel = nil
		client.realCharPanel = nil

		return true
	end
    
	function ix.storage.SyncCharPanel(client, inventory, charPanel)
		local info = inventory.storageInfo

		-- we'll retrieve the money value as we're syncing because it may have changed while
		-- we were waiting for the timer to finish
		if (info.entity.GetMoney) then
			info.data.money = info.entity:GetMoney()
		elseif (info.entity:IsPlayer() and info.entity:GetCharacter()) then
			info.data.money = info.entity:GetCharacter():GetMoney()
		end

		-- bags are automatically sync'd when the owning inventory is sync'd
        inventory:Sync(client)
        charPanel:Sync(client)

        if(info.entity:GetCharacter()) then
            net.Start("ixStorageOpenCharPanel")
                net.WriteUInt(info.id, 32)
                net.WriteUInt(info.entity:GetCharacter():GetCharPanel():GetID(), 32)
                net.WriteEntity(info.entity)
                net.WriteString(info.name)
                net.WriteTable(info.data)
			net.Send(client)
		end
	end

	net.Receive("ixStorageCloseCharPanel", function(length, client)
		local charPanel = client.ixOpenStorageCharPanel
		local inventory = client.ixOpenStorage
		
		if(charPanel or inventory) then
			ix.storage.RemoveCharPanelReceiver(client, inventory, charPanel)
		end
	end)
else
    net.Receive("ixStorageOpenCharPanel", function()
		if (IsValid(ix.gui.menu)) then
			net.Start("ixStorageCloseCharPanel")
			net.SendToServer()
			return
		end

        local id = net.ReadUInt(32)
        local charID = net.ReadUInt(32)
		local entity = net.ReadEntity()
		local name = net.ReadString()
		local data = net.ReadTable()

        local inventory = ix.item.inventories[id]
        local charPanel = ix.charPanels[charID]

		if (IsValid(entity) and inventory and inventory.slots and charPanel) then
			local localInventory = LocalPlayer():GetCharacter():GetInventory()
			local panel = vgui.Create("ixCharPanelStorageView")

			if (localInventory) then
				panel:SetLocalInventory(localInventory)
			end

			panel:SetStorageID(id)
			panel:SetStorageTitle(name)
            panel:SetStorageInventory(inventory)
            panel:SetStorageCharPanel(charPanel)

			if (data.money) then
				if (localInventory) then
					panel:SetLocalMoney(LocalPlayer():GetCharacter():GetMoney())
				end

				panel:SetStorageMoney(data.money)
			end
		end
	end)
end