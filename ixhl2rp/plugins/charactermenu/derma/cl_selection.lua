local PANEL = {}

function PANEL:Init()
	self:Dock(FILL)
	self:DockMargin(0, 64, 0, 0)
	self:InvalidateLayout(true)
	self.panels = {}

	self.scroll = self:Add("ixHorizontalScroll")
	self.scroll:Dock(FILL)

	local scrollBar = self.scroll:GetHBar()
	scrollBar:SetTall(8)
	scrollBar:SetHideButtons(true)
	scrollBar.Paint = function(scroll, w, h)
		surface.SetDrawColor(255, 255, 255, 10)
		surface.DrawRect(0, 0, w, h)
	end
	scrollBar.btnGrip.Paint = function(grip, w, h)
		local alpha = 50
		if (scrollBar.Dragging) then
			alpha = 150
		elseif (grip:IsHovered()) then
			alpha = 100
		end
		surface.SetDrawColor(255, 255, 255, alpha)
		surface.DrawRect(0, 0, w, h)
	end

	self:createCharacterSlots()
	hook.Add("CharacterListUpdated", self, function()
		self:createCharacterSlots()
		ix.gui.characterMenu:showContent()
	end)
end

-- Creates a ixCharacterSlot for each of the local player's characters.
function PANEL:createCharacterSlots()
	self.scroll:Clear()
	if (#ix.characters == 0) then
		return ix.gui.characterMenu:showContent()
	end
	for _, id in ipairs(ix.characters) do
		local character = ix.char.loaded[id]
		if (not character) then continue end

		local panel = self.scroll:Add("ixCharacterSlot")
		panel:Dock(LEFT)
		panel:DockMargin(0, 0, 8, 8)
		panel:setCharacter(character)
		panel.onSelected = function(panel)
			self:onCharacterSelected(character)
		end
	end
end

-- Called when a character slot has been selected. This actually loads the
-- character.
function PANEL:onCharacterSelected(character)
	if (self.choosing) then return end
	if (character == LocalPlayer():GetCharacter()) then
		return ix.gui.characterMenu:fadeOut()
	end

	self.choosing = true
	ix.gui.characterMenu:setFadeToBlack(true)
		:next(function()
			net.Start("ixCharacterChoose")
				net.WriteUInt(character:GetID(), 32)
			net.SendToServer()
		end)
		:next(function(err)
			self.choosing = false
			if (IsValid(ix.gui.characterMenu)) then
				timer.Simple(0.25, function()
					if (not IsValid(ix.gui.characterMenu)) then return end
					ix.gui.characterMenu:setFadeToBlack(false)
					ix.gui.characterMenu:Remove()
				end)
			end
		end, function(err)
			self.choosing = false
			ix.gui.characterMenu:setFadeToBlack(false)
			ix.util.NotifyLocalized(err)
		end)
end

vgui.Register("ixCharacterSelection", PANEL, "EditablePanel")
