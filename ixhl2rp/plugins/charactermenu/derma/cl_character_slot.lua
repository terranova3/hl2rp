local PANEL = {}
local STRIP_HEIGHT = 4

function PANEL:isCursorWithinBounds()
	local x, y = self:LocalCursorPos()
	return x >= 0 and x <= self:GetWide() and y >= 0 and y < self:GetTall()
end

function PANEL:confirmDelete()
	local id = self.character:GetID()
	vgui.Create("ixCharacterConfirm")
		:setMessage(L("Deleting a character cannot be undone."))
		:onConfirm(function()
			net.Start("ixCharacterDelete")
				net.WriteUInt(id, 32)
			net.SendToServer()
		end)
end

function PANEL:Init()
	local WIDTH = 240

	self:SetWide(WIDTH)
	self:SetDrawBackground(false)

	self.faction = self:Add("DPanel")
	self.faction:Dock(TOP)
	self.faction:SetTall(STRIP_HEIGHT)
	self.faction:SetSkin("Default")
	self.faction:SetAlpha(100)
	self.faction.Paint = function(faction, w, h)
		surface.SetDrawColor(faction:GetBackgroundColor())
		surface.DrawRect(0, 0, w, h)
	end

	self.name = self:Add("DLabel")
	self.name:Dock(TOP)
	self.name:DockMargin(0, 16, 0, 0)
	self.name:SetContentAlignment(5)
	self.name:SetFont("ixPluginCharPanelTitleFont")
	self.name:SetTextColor(ix.gui.characterMenu.WHITE)
	self.name:SizeToContentsY()
	
	self.subname = self:Add("DLabel")
	self.subname:Dock(TOP)
	self.subname:SetText("")
	self.subname:DockMargin(0, 4, 0, 0)
	self.subname:SetContentAlignment(5)
	self.subname:SetFont("ixPluginCharPanelSubTitleFont")
	self.subname:SetTextColor(ix.gui.characterMenu.WHITE)
	self.subname:SizeToContentsY()

	self.model = self:Add("ixModelPanel")
	self.model:Dock(FILL)
	self.model:SetFOV(37)
	self.model.PaintOver = function(model, w, h)
		if (self.banned) then
			local centerX, centerY = w * 0.5, h * 0.5 - 24
			surface.SetDrawColor(250, 0, 0, 40)
			surface.DrawRect(0, centerY - 24, w, 48)

			draw.SimpleText(
				L("banned"):upper(),
				"ixPluginCharPanelSubTitleFont",
				centerX,
				centerY,
				color_white, 1, 1
			)
		end
	end

	self.button = self:Add("DButton")
	self.button:SetSize(WIDTH, ScrH())
	self.button:SetDrawBackground(false)
	self.button:SetText("")
	self.button.OnCursorEntered = function(button) self:OnCursorEntered() end
	self.button.DoClick = function(button)
		ix.gui.characterMenu:clickSound()
		if (not self.banned) then
			self:onSelected()
		end
	end

	self.delete = self:Add("DButton")
	self.delete:SetTall(30)
	self.delete:SetFont("ixPluginCharSubTitleFont")
	self.delete:SetText("✕ "..L("delete"):upper())
	self.delete:SetWide(self:GetWide())
	self.delete.Paint = function(delete, w, h)
		surface.SetDrawColor(255, 0, 0, 50)
		surface.DrawRect(0, 0, w, h)
	end
	self.delete.DoClick = function(delete)
		ix.gui.characterMenu:clickSound()
		self:confirmDelete()
	end
	self.delete.y = ScrH()
	self.delete.showY = self.delete.y - self.delete:GetTall()
end

function PANEL:onSelected()
end

function PANEL:setCharacter(character)
	self.character = character

	self.name:SetText(character:GetName():gsub("#", "\226\128\139#"):upper())
	self.model:SetModel(character:GetModel())
	self.faction:SetBackgroundColor(team.GetColor(character:GetFaction()))
	self:setBanned(character:GetData("banned"))

	self.subname:SetVisible(false)

	if(self.character:IsMetropolice() and self.character:IsUndercover()) then
		self.subname:SetVisible(true)
		self.subname:SetText(string.format("(%s)", self.character:GetCPName()))
	end

	local entity = self.model.Entity
	if (IsValid(entity)) then
		-- Match the skin and bodygroups.
		entity:SetSkin(character:GetData("skin") or character:GetSkin())
		for k, v in pairs(character:GetData("groups", {})) do
			entity:SetBodygroup(k, v)
		end

		-- Approximate the upper body position.
		local mins, maxs = entity:GetRenderBounds()
		local height = math.abs(mins.z) + math.abs(maxs.z)
		local scale = math.max((960 / ScrH()) * 0.5, 0.5)
		self.model:SetLookAt(entity:GetPos() + Vector(0, 0, height * scale))
	end
end

function PANEL:setBanned(banned)
	self.banned = banned
end

function PANEL:onHoverChanged(isHovered)
	local ANIM_SPEED = ix.gui.characterMenu.ANIM_SPEED
	if (self.isHovered == isHovered) then return end
	self.isHovered = isHovered

	local tall = self:GetTall()
	if (isHovered) then
		self.delete.y = tall
		self.delete:MoveTo(0, tall - self.delete:GetTall(), ANIM_SPEED)
		ix.gui.characterMenu:hoverSound()
	else
		self.delete:MoveTo(0, tall, ANIM_SPEED)
	end

	self.faction:AlphaTo(isHovered and 250 or 100, ANIM_SPEED)
end

function PANEL:Paint(w, h)
	ix.util.DrawBlur(self)
	surface.SetDrawColor(0, 0, 0, 50)
	surface.DrawRect(0, STRIP_HEIGHT, w, h)

	if (not self:isCursorWithinBounds() and self.isHovered) then
		self:onHoverChanged(false)
	end
end

function PANEL:OnCursorEntered()
	self:onHoverChanged(true)
end

vgui.Register("ixCharacterSlot", PANEL, "DPanel")
