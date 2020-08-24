--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

util.AddNetworkString("ixCharPanelSync")
util.AddNetworkString("ixCharPanelReceiveItem")
util.AddNetworkString("ixCharPanelSet")
util.AddNetworkString("ixCharPanelTransfer")
util.AddNetworkString("ixCharPanelRemove")
util.AddNetworkString("ixCharPanelUpdateModel")
util.AddNetworkString("ixCharPanelLoadModel")
util.AddNetworkString("ixCharPanelLoadBag")

function ix.charPanel.RestoreCharPanel(panelID, callback)
    if (!isnumber(panelID) or panelID < 0) then
        error("Attempt to restore character panel with an invalid ID!")
    end

    ix.charPanel.CreatePanel(panelID)

    local query = mysql:Select("ix_items")
        query:Select("item_id")
        query:Select("inventory_id")
        query:Select("panel_id")
        query:Select("unique_id")
        query:Select("data")
        query:Select("character_id")
        query:Select("player_id")
        query:Where("panel_id", panelID)
        query:Callback(function(result)	
            if (istable(result) and #result > 0) then
                local equippedSlots = {}

                for _, item in ipairs(result) do
                    local itemPanelID = tonumber(item.panel_id)

                    -- don't restore items with an invalid inventory id or type
                    if (!itemPanelID) then
                        continue
                    end

                    local itemID = tonumber(item.item_id)
                    local data = util.JSONToTable(item.data or "[]")
                    local characterID, playerID = tonumber(item.character_id), tostring(item.player_id)

                    if (itemID) then
                        local restoredItem = ix.item.New(item.unique_id, itemID)

                        if (restoredItem) then
                            restoredItem.data = {}

                            if (data) then
                                restoredItem.data = data
                            end

                            restoredItem.invID = 0
                            restoredItem.panelID = panelID
                            restoredItem.characterID = characterID
                            restoredItem.playerID = (playerID == "" or playerID == "NULL") and nil or playerID

                            equippedSlots[restoredItem.outfitCategory] = restoredItem;
                        end
                    end
                end

                if(equippedSlots) then
                    ix.charPanels[panelID].slots = equippedSlots
                end
            end

            if (callback) then
                callback(ix.charPanels[panelID])
            end
        end)
    query:Execute()
end

function ix.charPanel.HasIntegrity(client, item, invID, panelID, checkInventory)
	local inventory = ix.item.inventories[invID or 0]
	local charPanel = ix.charPanels[panelID or 0]

	if (!client:GetCharacter()) then
		return false
	end

	if (!inventory:OnCheckAccess(client) and !charPanel:OnCheckAccess(client)) then
		return false
	end

	if (isnumber(item)) then
		item = ix.item.instances[item]

		if (!item) then
			return false
		end
	end

	if(checkInventory) then 
		if (!inventory:GetItemByID(item.id)) then
			return false
		end
	end;

	return true
end

net.Receive("ixCharPanelReceiveItem", function(length, client)
	local item = net.ReadUInt(32)
	local invID = net.ReadUInt(32)
	local panelID = net.ReadUInt(32)

	if(ix.charPanel.HasIntegrity(client, item, invID, panelID, true)) then
		local charPanel = ix.charPanels[panelID];
		item = ix.item.instances[item]
		charPanel:Add(item.id, {}, item.outfitCategory)
	else
		return
	end
end)

net.Receive("ixCharPanelTransfer", function(length, client)
	local item = net.ReadUInt(32)
	local invID = net.ReadUInt(32)
	local panelID = net.ReadUInt(32)
	local x, y = net.ReadUInt(6), net.ReadUInt(6)

	if(ix.charPanel.HasIntegrity(client, item, invID, panelID, false)) then
		local charPanel = ix.charPanels[panelID];
        item = ix.item.instances[item]
        
		charPanel:Transfer(item.id, invID, x, y)
	else
		return
	end
end)