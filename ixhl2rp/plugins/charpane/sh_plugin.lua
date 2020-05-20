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

do
	ix.util.Include("sv_database.lua");
	ix.util.Include("sv_hooks.lua");
	ix.util.IncludeDirectory(PLUGIN, "meta");

	function ix.charPanel.CreatePanel(id)
		local panel = setmetatable({id = id, slots = {}, vars = {}, receivers = {}}, ix.meta.charPanel)
			ix.charPanels[id] = panel

		return panel
	end

	function ix.charPanel.RestoreCharPanel(panelID, callback)
		print("RestoreCharPanel" .. panelID)
		if (!isnumber(panelID) or panelID < 0) then
			error("Attempt to restore inventory with an invalid ID!")
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
					local invSlots = {}

					for _, item in ipairs(result) do
						local itemPanelID = tonumber(item.panel_id)

						if (itemPanelID != panelID) then
							continue
						end

						local inventory = ix.charPanels[panelID]
						local itemID = tonumber(item.item_id)
						local data = util.JSONToTable(item.data or "[]")
						local characterID, playerID = tonumber(item.character_id), tostring(item.player_id)

						if (itemID) then
							local item2 = ix.item.New(item.unique_id, itemID)

							if (item2) then
								invSlots[itemPanelID] = invSlots[itemPanelID] or {}
								local slots = invSlots[itemPanelID]

								item2.data = {}

								if (data) then
									item2.data = data
								end

								item2.invID = itemInvID
								item2.characterID = characterID
								item2.playerID = (playerID == "" or playerID == "NULL") and nil or playerID


								if (item2.OnRestored) then
									--item2:OnRestored(item2, itemInvID)
								end
							end
						end
					end

					for k, v in pairs(invSlots) do
						ix.charPanels[k].slots = v
					end
				end

				if (callback) then
					callback(ix.charPanels[panelID], badItemsUniqueID)
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
						print("IsValid charPanel")
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
	else
		util.AddNetworkString("ixCharPanelSync")
		util.AddNetworkString("ixCharPanelReceiveItem")
		util.AddNetworkString("ixCharPanelSet")

		function ix.charPanel.HasIntegrity(client, item, invID, panelID)
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

			if (!inventory:GetItemByID(item.id)) then
				return false
			end

			return true
		end

		net.Receive("ixCharPanelReceiveItem", function(length, client)
			local item = net.ReadUInt(32)
			local invID = net.ReadUInt(32)
			local panelID = net.ReadUInt(32)
			local data = net.ReadTable()

			if(ix.charPanel.HasIntegrity(client, item, invID, panelID)) then
				local charPanel = ix.charPanels[panelID];
				item = ix.item.instances[item]
				charPanel:Add(item.id, {}, item.outfitCategory)
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

