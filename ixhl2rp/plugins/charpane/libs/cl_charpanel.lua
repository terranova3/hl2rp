--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

net.Receive("ixCharPanelSync", function()
	local slots = net.ReadTable()
	local id = net.ReadUInt(32)
	local owner = net.ReadType()
	local vars = net.ReadTable()

	local character = owner and ix.char.loaded[owner] or LocalPlayer():GetCharacter()

	if (character) then
		local charPanel = ix.charPanel.CreatePanel(id)

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

				panel:UpdateModel()
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

		panel:UpdateModel()
	end
end)