--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PANEL = {}
local PLUGIN = PLUGIN

function PANEL:Init()
	ix.gui.charpanel = self

	self:SetSize(360, 525)
	self.showModel = true
	self.isOwn = true

	local character = LocalPlayer():GetCharacter()

	if(self.showModel) then
		self.model = self:Add("ixModelPanel")
		self.model:Dock(FILL)
		self.model:SetModel(LocalPlayer():GetModel(), character:GetData("skin", 0))
		self.model:SetFOV(50)
		self.model.alpha = 255
		self.model:SetAlpha(255)
	end

	self.panels = {}
	self.slotPlacements = {
		["headgear"] = {x = 5, y = 100},
		["headstrap"] = {x = 291, y = 170},
		["glasses"] = {x = 291, y = 100},
		["torso"] = {x = 5, y = 170},
		["kevlar"] = {x = 5, y = 240},
		["hands"] = {x = 291, y = 300},
		["legs"] = {x = 291, y = 370},
		["bag"] = {x = 5, y = 310},
		["satchel"] = {x = 5, y = 380},
	}

	net.Receive("ixCharPanelLoadModel", function()
		local model = net.ReadString(16)
		local bodygroups = net.ReadTable()
		
		if(IsValid(self.model)) then
			self.model:SetModel(model, character:GetData("skin", 0))

			if(bodygroups) then 
				for k, v in pairs(bodygroups) do
					self.model.Entity:SetBodygroup(k, v)
				end
			end
		end
	end)

	net.Receive("ixCharPanelUpdateModel", function()
		local index = net.ReadUInt(8)
		local bodygroup = net.ReadUInt(8)

		if(IsValid(self.model) and self.model.Entity) then
			self.model.Entity:SetBodygroup(index, bodygroup)
		end

		Legs.LegEnt:SetBodygroup(index, bodygroup)
	end)
	
	self:Receiver("ixInventoryItem", self.ReceiveDrop)
end

function PANEL:Validate()
	netstream.Start("CharacterPanelUpdate", self.isOwn)
end

function PANEL:ReceiveDrop(panels, bDropped, menuIndex, x, y)
	return 
end

-- Fixes model panel not fading out when the gui menu is closed.
function PANEL:Think()
	if(IsValid(ix.gui.menu) and ix.gui.menu.bClosing) then
		if(self.model) then
			self.model:Remove()
		end
	end

	if(IsValid(self.model) and !self.isOwn) then
		self.model:Remove()
	end
end

function PANEL:SetCharPanel(charPanel, bFitParent)
	self.panelID = charPanel:GetID()

	self:BuildSlots();

	for k, items in pairs(charPanel.slots) do
		if (!items.id) then continue end

		local item = ix.item.instances[items.id]

		if (item and !IsValid(self.panels[item.id])) then
			local icon = self:AddIcon(
				item, item:GetModel() or "models/props_junk/popcan01a.mdl", item.outfitCategory, item:GetSkin()
			)

			if (IsValid(icon)) then
				icon:SetHelixTooltip(function(tooltip)
					ix.hud.PopulateItemTooltip(tooltip, item)
				end)

				icon.itemID = item.id
				self.panels[item.id] = icon
			end

			self.slots[item.outfitCategory].isEmpty = false
		end
	end
end

function PANEL:GetIconPlacement(category)
	return self.slotPlacements[category];
end;

function PANEL:BuildSlots()
	self.slots = self.slots or {}

	for k, v in pairs(self.slotPlacements) do
		if(v.condition or v.condition == nil) then
			local slot = self:Add("ixCharacterEquipmentSlot");
			slot.category = k;
			slot.text = k;
			slot:SetPos(v.x, v.y);

			self.slots[k] = slot
			slot:Populate()
		end
	end;
end

function PANEL:AddIcon(item, model, category, skin)
	local panel = self:Add("ixCharPanelItemIcon")
	local pos = self:GetIconPlacement(category);

	if(!category) then
		category = item.outfitCategory
	end;

	panel:SetSize(64, 64)
	panel:SetZPos(999)
	panel:InvalidateLayout(true)
	panel:SetModel(model, skin)
	panel:SetPos(pos.x, pos.y)
	panel.gridW = 1
	panel.gridH = 1

	local charPanel = ix.charPanels[self.panelID]

	if (!charPanel) then
		return
	end

	panel:SetPanelID(charPanel:GetID())
	panel:SetItemTable(item)

	if (self.panels[item:GetID()]) then
		self.panels[item:GetID()]:Remove()
	end

	if (item.exRender) then
		panel.Icon:SetVisible(false)
		panel.ExtraPaint = function(this, panelX, panelY)
			local exIcon = ikon:GetIcon(item.uniqueID)
			if (exIcon) then
				surface.SetMaterial(exIcon)
				surface.SetDrawColor(color_white)
				surface.DrawTexturedRect(0, 0, panelX, panelY)
			else
				ikon:renderIcon(
					item.uniqueID,
					item.width,
					item.height,
					item:GetModel(),
					item.iconCam
				)
			end
		end
	else
		PLUGIN:RenderNewIcon(panel, item)
	end

	local slot = self.slots[category]

	if(IsValid(slot)) then
		slot.item = panel;
	end;

	return panel
end;

function PANEL:Paint()
	derma.SkinFunc("PaintCategoryPanel", self, "", ix.config.Get("color") or color_white)
	surface.SetDrawColor(0, 0, 0, 50);	

	surface.SetFont("ixPluginTooltipFont")
	surface.SetTextColor(Color(255,255,255,255))
	surface.SetTextPos(4, 4)
	surface.DrawText("Equipment")
end;

vgui.Register("ixCharacterPane", PANEL, "DPanel")

netstream.Hook("ShowCharacterPanel", function(show)
	local charPanel = LocalPlayer():GetCharacter():GetCharPanel()

	if(!show) then
		if(IsValid(ix.gui.charPanel)) then
			ix.gui.charPanel:Remove()
		end

		return
	end

	if(!IsValid(ix.gui.charPanel) and IsValid(ix.gui.containerCharPanel)) then
		local cPanel = ix.gui.containerCharPanel:Add("ixCharacterPane")

		ix.gui.charPanel = cPanel
	end

	if (charPanel and ix.gui.charPanel and IsValid(ix.gui.charPanel)) then
		ix.gui.charPanel:SetCharPanel(charPanel)
	end
end)