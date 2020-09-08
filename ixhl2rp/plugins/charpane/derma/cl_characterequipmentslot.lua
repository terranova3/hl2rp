--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PANEL = {}

function PANEL:Init()
	self.parent = self:GetParent()
	self.previewPanel = nil;
	self.equipment = true;
	self.isEmpty = true;
	self.iconSize = 64;

	self.text = "N/A";
	self:SetSize(self.iconSize, self.iconSize);
	self:SetPos(0,0)
	self:Receiver("ixInventoryItem", self.ReceiveDrop)
end;

function PANEL:Populate()
	local picture = string.format("materials/terranova/ui/charpane/slot_%s.png", self.category)

	self.mat = vgui.Create("Material", self)
	self.mat:SetPos(0, 0)
	self.mat:SetSize(64, 64)
	self.mat:SetMaterial(picture)
	self.mat.AutoSize = false
end

function PANEL:PaintDragPreview(width, height, mouseX, mouseY, itemPanel)
	local item = itemPanel:GetItemTable()
	local canUse = hook.Run("CharPanelCanUse", self.parent:GetCharacter():GetPlayer())

	if (item) then
		if(item.outfitCategory == string.lower(self.category) and canUse != false) then
			if(self.isEmpty) then
				surface.SetDrawColor(0, 255, 0, 40)
			else
				surface.SetDrawColor(255, 255, 0, 10)
			end
		else
			surface.SetDrawColor(255, 0, 0, 40)
		end;

		surface.DrawRect(0, 0, 64, 64)
	end
end

function PANEL:Think()
	if(self.isEmpty) then
		self.mat:SetVisible(true)
	else
		self.mat:SetVisible(false)
	end
end

function PANEL:PaintOver(width, height)
	local panel = self.previewPanel

	if (IsValid(panel)) then
		local itemPanel = (dragndrop.GetDroppable() or {})[1]

		if (IsValid(itemPanel)) then
			self:PaintDragPreview(width, height, self.previewX, self.previewY, itemPanel)
		end
	end

	self.previewPanel = nil
end;

function PANEL:Paint(w, h)
	surface.SetDrawColor(25, 25, 25, 225)
	surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(90, 90, 90, 125)
    surface.DrawOutlinedRect(0, 0, w, h)
end

function PANEL:ReceiveDrop(panels, bDropped, menuIndex, x, y)
	local panel = panels[1]

	if (!IsValid(panel)) then
		self.previewPanel = nil
		return
	end

	if (bDropped) then
		if (panel.OnDrop) then
			local item = panels[1].itemTable;
			local invID = LocalPlayer():GetCharacter():GetInventory():GetID();
			local panelID = self.parent.panelID;

			if (!item) then
				return false
			end
	
			if(item.outfitCategory != string.lower(self.category)) then
				return false, "notAllowed"
			end
			
			if(hook.Run("CharPanelCanUse", self.parent:GetCharacter():GetPlayer()) == false) then
				return false, "You cannot currently use the character panel!"
			end

			if(item.dropSound and ix.option.Get("toggleInventorySound", false)) then
				if(istable(item.dropSound)) then
					local randomSound = item.dropSound[math.random(1, table.Count(item.dropSound))]
					surface.PlaySound(randomSound)
				else
					surface.PlaySound(item.dropSound)
				end
			end

			net.Start("ixCharPanelReceiveItem")
				net.WriteUInt(item.id, 32)
				net.WriteUInt(invID, 32)
				net.WriteUInt(panelID, 32)
				net.WriteTable({})
			net.SendToServer()

			self.isEmpty = false
		end

		self.previewPanel = nil
	else
		self.previewPanel = panel
		self.previewX = x
		self.previewY = y
	end
end

vgui.Register("ixCharacterEquipmentSlot", PANEL, "DPanel")