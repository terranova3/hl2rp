--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

PLUGIN.name = "Character Panel";
PLUGIN.description = "Adds dynamic bodygroup support with an inventory character pane.";
PLUGIN.author = "Adolphus";

ix.charPanel = ix.charPanel or {}
ix.charPanels = ix.charPanels or {
	[0] = {}
}

ix.util.Include("cl_hooks.lua")

do
	ix.util.Include("sv_database.lua");
	ix.util.Include("sv_hooks.lua");
	ix.util.IncludeDir(PLUGIN.folder .. "/meta", true);

	function ix.charPanel.CreatePanel(id)
		local panel = setmetatable({id = id, slots = {}, vars = {}, receivers = {}}, ix.meta.charPanel)
			ix.charPanels[id] = panel

		return panel
	end

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

						local charPanel = ix.charPanels[itemPanelID]
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

	if (CLIENT) then
		net.Receive("ixCharPanelSync", function()
			local slots = net.ReadTable()
			local id = net.ReadUInt(32)
			local owner = net.ReadType()
			local vars = net.ReadTable()

			local character = owner and ix.char.loaded[owner] or LocalPlayer():GetCharacter()

			if (character) then
				local charPanel = ix.charPanel.CreatePanel(id)
				charPanel:SetOwner(character:GetID())
				charPanel.slots = {}
				charPanel.vars = vars

				-- v: uniqueID, id, category, data
				for _, v in ipairs(slots) do
					charPanel.slots[v[3]] = {}

					local item = ix.item.New(v[1], v[2])

					item.data = {}
					if (v[4]) then
						item.data = v[4]
					end

					charPanel.slots[v[3]] = item
				end

				character.vars.charPanel = charPanel
			end
		end)

		net.Receive("ixCharPanelSet", function()
			local panelID = net.ReadUInt(32)
			local category = net.ReadString()
			local uniqueID = net.ReadString()
			local id = net.ReadUInt(32)
			local owner = net.ReadUInt(32)
			local data = net.ReadTable()

			local character = owner != 0 and ix.char.loaded[owner] or LocalPlayer():GetCharacter()

			if (character) then
				local charPanel = ix.charPanels[panelID]

				if (charPanel) then
					local item = (uniqueID != "" and id != 0) and ix.item.New(uniqueID, id) or nil
					item.panelID = panelID
					item.invID = 0
					item.data = {}

					if (data) then
						item.data = data
					end

					charPanel.slots[category] = item or {}

					panelID = panelID == LocalPlayer():GetCharacter():GetCharPanel():GetID() and 1 or panelID

					local panel = ix.gui.charPanel

					if (IsValid(ix.gui.charPanel)) then
						local icon = panel:AddIcon(
							item, item:GetModel() or "models/props_junk/popcan01a.mdl", category, item:GetSkin()
						)

						if (IsValid(icon)) then
							icon:SetHelixTooltip(function(tooltip)
								ix.hud.PopulateItemTooltip(tooltip, item)
							end)

							icon.itemID = item.id
							panel.panels[item.id] = icon
						end
					end
				end
			end
		end)

		net.Receive("ixCharPanelRemove", function()
			local id = net.ReadUInt(32)
			local panelID = net.ReadUInt(32)

			local charPanel = ix.charPanels[panelID]

			if (!charPanel) then
				return
			end

			charPanel:Remove(id)

			panelID = panelID == LocalPlayer():GetCharacter():GetCharPanel():GetID() and 1 or panelID

			local panel = ix.gui.charPanel

			if (IsValid(panel)) then
				local icon = panel.panels[id]

				if (IsValid(icon)) then
					for _, v in ipairs(icon.slots or {}) do
						if (v.item == icon) then
							v.item = nil
						end
					end

					icon:Remove()
				end
			end
		end)
	else
		util.AddNetworkString("ixCharPanelSync")
		util.AddNetworkString("ixCharPanelReceiveItem")
		util.AddNetworkString("ixCharPanelSet")
		util.AddNetworkString("ixCharPanelTransfer")
		util.AddNetworkString("ixCharPanelRemove")
		util.AddNetworkString("ixCharPanelUpdateModel")
		util.AddNetworkString("ixCharPanelLoadModel")

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
			local data = net.ReadTable()

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
	end
end

--- Returns this character's associated `CharPanel` object.
-- @function :GetCharPanel
ix.char.RegisterVar("CharPanel", {
	bNoNetworking = true,
	bNoDisplay = true,
	OnSet = function(character, value)
		character.vars.charPanel = value
	end,
	OnGet = function(character, index)
		return character.vars.charPanel
	end,
	alias = "charPanel"
})

