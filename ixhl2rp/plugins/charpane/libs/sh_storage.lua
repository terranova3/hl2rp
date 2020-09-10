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

		local target = info.entity:GetCharacter()
		
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

		info.data = info.data or {}
		info.data.money = target:GetMoney()

		-- bags are automatically sync'd when the owning inventory is sync'd
        inventory:Sync(client)
		charPanel:Sync(client)
		
		local charData = {
			groups = target:GetData("groups", {}),
			skin = target:GetData("skin", 0)
		}

        if(target) then
            net.Start("ixStorageOpenCharPanel")
                net.WriteUInt(inventory:GetID(), 32)
                net.WriteUInt(charPanel:GetID(), 32)
                net.WriteEntity(target:GetPlayer())
				net.WriteString(info.name)
				net.WriteTable(info.data)
				net.WriteTable(charData)
			net.Send(client)
		end
    end

	net.Receive("ixStorageCloseCharPanel", function(length, client)
		local charPanel = client.ixOpenStorageCharPanel
		local inventory = client.ixOpenStorage
		
		ix.storage.RemoveCharPanelReceiver(client, inventory, charPanel)
	end)

	function ix.storage.RemoveCharPanelReceiver(client, inventory, charPanel, bDontRemove)
		charPanel:RemoveReceiver(client)
		inventory:RemoveReceiver(client)

		client:GetCharacter():SetCharPanel(client.realCharPanel)

		client.realCharPanel:AddReceiver(client)
		client.realInventory:AddReceiver(client)

		client.realCharPanel:Sync(client)
		client.realInventory:Sync(client)

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
else
    net.Receive("ixStorageOpenCharPanel", function()
		if (IsValid(ix.gui.menu)) then
			net.Start("ixStorageCloseCharPanel")
			net.SendToServer()
			return
		end

        local id = net.ReadUInt(32)
        local charID = net.ReadUInt(32)
		local target = net.ReadEntity()
		local name = net.ReadString()
		local data = net.ReadTable()
		local charData = net.ReadTable()

        local inventory = ix.item.inventories[id]
		local charPanel = ix.charPanels[charID]
		
		local character = target:GetCharacter()
		character.vars.groups = charData.groups
		character.vars.skin = charData.skin

		if (IsValid(target) and inventory and inventory.slots and charPanel) then
			local localInventory = LocalPlayer():GetCharacter():GetInventory()
			local panel = vgui.Create("ixCharPanelStorageView")

			if (localInventory) then
				panel:SetLocalInventory(localInventory)
			end

			panel:SetStorageID(id)
			panel:SetStorageTitle(name)
            panel:SetStorageInventory(inventory)
            panel:SetStorageCharPanel(character, charPanel)

			if (data.money) then
				if (localInventory) then
					panel:SetLocalMoney(LocalPlayer():GetCharacter():GetMoney())
				end

				panel:SetStorageMoney(data.money)
			end
		end
	end)
end