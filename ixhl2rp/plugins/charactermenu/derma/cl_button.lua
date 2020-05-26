local PANEL = {}

function PANEL:Init()
	self:SetFont("ixPluginCharButtonFont")
	self:SizeToContentsY()
	self:SetTextColor(ix.gui.characterMenu.WHITE)
	self:SetDrawBackground(false)
end

function PANEL:OnCursorEntered()
	ix.gui.characterMenu:hoverSound()
	self:SetTextColor(ix.gui.characterMenu.HOVERED)
end

function PANEL:OnCursorExited()
	self:SetTextColor(ix.gui.characterMenu.WHITE)
end

function PANEL:OnMousePressed()
	ix.gui.characterMenu:clickSound()
	DButton.OnMousePressed(self)
end

vgui.Register("ixCharButton", PANEL, "DButton")
