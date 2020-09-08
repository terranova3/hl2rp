--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PANEL = {}
local PLUGIN = PLUGIN

-- This tells the UI where to render the slots in the panel.
PLUGIN.slotPlacements = {
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

-- Called when this panel has been created.
function PANEL:Init()
	ix.gui.charPanel = self

	self:SetSize(360, 525)
	self.panels = {}
	
	self:Receiver("ixInventoryItem", self.ReceiveDrop)
end

-- Called when we are setting the target of the character panel
function PANEL:SetCharacter(character)
	self.model = self:Add("ixModelPanel")
	self.model:Dock(FILL)
	self.model:SetFOV(50)
	self.model:SetAlpha(255)

	self.character = character

	self:UpdateModel()
	self:SetCharPanel(self:GetCharacter():GetCharPanel())
end

-- Returns the character tied to this character panel.
function PANEL:GetCharacter()
	if(self.character) then
		return self.character
	end

	return nil
end

-- Called when the panel receives a drop. Used to stop items from dropping to world if they are dropped on the panel's empty space.
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

	local character = self:GetCharacter()

	if(character and IsValid(self.model)) then
		if(character:GetPlayer():GetModel() != self.model:GetModel()) then
			self:UpdateModel()
		end

		local showSlots = hook.Run("CharPanelCanUse", character:GetPlayer())

		if(showSlots != false) then
			showSlots = true
		end

		self:ToggleSlots(showSlots)
	end
end

-- Helper function to set the visibility of the slots.
function PANEL:ToggleSlots(bShow)
	for k, v in pairs(self.slots) do
		if(IsValid(v)) then
			v:SetVisible(bShow)
		end
	end
end

-- Called when we need to update the model in the character panel.
function PANEL:UpdateModel()
	self.model:SetModel(self:GetCharacter():GetPlayer():GetModel(), self:GetCharacter():GetData("skin", 0))

	for k, v in pairs(self:GetCharacter():GetData("groups", {})) do
        self.model.Entity:SetBodygroup(k, v)
    end
end

-- Called when we are assigning all the character panel data to this panel.
function PANEL:SetCharPanel(charPanel)
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

-- Returns a slot's placement inside the panel.
function PANEL:GetIconPlacement(category)
	return PLUGIN.slotPlacements[category];
end;

-- Called when we need to build all the UI slots for the panel.
function PANEL:BuildSlots()
	self.slots = self.slots or {}

	for k, v in pairs(PLUGIN.slotPlacements) do
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

-- Called when we are adding items into their slots.
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

-- Called every frame.
function PANEL:Paint()
	derma.SkinFunc("PaintCategoryPanel", self, "", ix.config.Get("color") or color_white)
	surface.SetDrawColor(0, 0, 0, 50);	

	surface.SetFont("ixPluginTooltipFont")
	surface.SetTextColor(Color(255,255,255,255))
	surface.SetTextPos(4, 4)
	surface.DrawText("Equipment")
end;

vgui.Register("ixCharacterPane", PANEL, "DPanel")