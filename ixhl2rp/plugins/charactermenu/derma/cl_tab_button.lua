local PANEL = {}

function PANEL:Init()
	self:Dock(LEFT)
	self:DockMargin(0, 0, 32, 0)
	self:SetContentAlignment(4)
end

function PANEL:setText(name)
	self:SetText(L(name):upper())
	self:InvalidateLayout(true)
	self:SizeToContentsX()
end

function PANEL:onSelected(callback)
	self.callback = callback
end

function PANEL:setSelected(isSelected)
	if (isSelected == nil) then isSelected = true end
	if (isSelected and self.isSelected) then return end

	local menu = ix.gui.characterMenu
	if (isSelected and IsValid(menu)) then
		if (IsValid(menu.lastTab)) then
			menu.lastTab:SetTextColor(ix.gui.characterMenu.WHITE)
			menu.lastTab.isSelected = false
		end
		menu.lastTab = self
	end

	self:SetTextColor(
		isSelected
		and ix.gui.characterMenu.SELECTED
		or ix.gui.characterMenu.WHITE
	)
	self.isSelected = isSelected
	if (isfunction(self.callback)) then
		self:callback()
	end
end

function PANEL:Paint(w, h)
	if (self.isSelected or self:IsHovered()) then
		surface.SetDrawColor(
			self.isSelected
			and ix.gui.characterMenu.WHITE
			or ix.gui.characterMenu.HOVERED
		)
		surface.DrawRect(0, h - 4, w, 4)
	end
end

vgui.Register("ixCharacterTabButton", PANEL, "ixCharButton")
