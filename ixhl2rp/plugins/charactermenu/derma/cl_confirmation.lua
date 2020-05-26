local PANEL = {}

function PANEL:Init()
	if (IsValid(ix.gui.charConfirm)) then
		ix.gui.charConfirm:Remove()
	end
	ix.gui.charConfirm = self

	self:SetAlpha(0)
	self:AlphaTo(255, ix.gui.characterMenu.ANIM_SPEED * 2)
	self:SetSize(ScrW(), ScrH())
	self:MakePopup()

	self.content = self:Add("DPanel")
	self.content:SetSize(ScrW(), 256)
	self.content:CenterVertical()
	self.content.Paint = function(content, w, h)
		surface.SetDrawColor(0, 0, 0, 200)
		surface.DrawRect(0, 0, w, h)
	end

	self.title = self.content:Add("DLabel")
	self.title:SetText(L("Are you sure?"):upper())
	self.title:SetFont("ixPluginCharButtonFont")
	self.title:SetTextColor(Color(255, 0, 0, 180))
	self.title:SizeToContents()
	self.title:CenterHorizontal()
	self.title.y = 64

	self.message = self.content:Add("DLabel")
	self.message:SetFont("ixPluginCharSubTitleFont")
	self.message:SetTextColor(color_white)
	self.message:SetSize(ScrW(), 32)
	self.message:CenterVertical()
	self.message:SetContentAlignment(5)

	local SPACING = 16

	self.confirm = self.content:Add("DButton")
	self.confirm:SetFont("ixPluginCharSmallButtonFont")
	self.confirm:SetText(L("yes"):upper())
	self.confirm:SetDrawBackground(false)
	self.confirm:SetSize(64, 32)
	self.confirm.OnCursorEntered = function() ix.gui.characterMenu:hoverSound() end
	self.confirm.OnCursorEntered = function(cancel)
		cancel.BaseClass.OnCursorEntered(cancel)
		ix.gui.characterMenu:hoverSound()
	end
	self.confirm:SetPos(
		ScrW() * 0.5 - (self.confirm:GetWide() + SPACING),
		self.message.y + 64
	)
	self.confirm.DoClick = function(cancel)
		ix.gui.characterMenu:clickSound()
		if (isfunction(self.onConfirmCallback)) then
			self.onConfirmCallback()
		end
		self:Remove()
	end

	self.cancel = self.content:Add("DButton")
	self.cancel:SetFont("ixPluginCharSmallButtonFont")
	self.cancel:SetText(L("no"):upper())
	self.cancel:SetDrawBackground(false)
	self.cancel:SetSize(64, 32)
	self.cancel.OnCursorEntered = function(cancel)
		cancel.BaseClass.OnCursorEntered(cancel)
		ix.gui.characterMenu:hoverSound()
	end
	self.cancel:SetPos(
		ScrW() * 0.5 + SPACING,
		self.message.y + 64
	)
	self.cancel.DoClick = function(cancel)
		ix.gui.characterMenu:clickSound()
		if (isfunction(self.onCancelCallback)) then
			self.onCancelCallback()
		end
		self:Remove()
	end

	timer.Simple(ix.gui.characterMenu.ANIM_SPEED * 0.5, function()
		ix.gui.characterMenu:warningSound()
	end)
end

function PANEL:OnMousePressed()
	self:Remove()
end

function PANEL:Paint(w, h)
	ix.util.DrawBlur(self)
	surface.SetDrawColor(0, 0, 0, 150)
	surface.DrawRect(0, 0, w, h)
end

function PANEL:setTitle(title)
	self.title:SetText(title)
	self.title:SizeToContentsX()
	self.title:CenterHorizontal()
	return self
end

function PANEL:setMessage(message)
	self.message:SetText(message:upper())
	return self
end

function PANEL:onConfirm(callback)
	self.onConfirmCallback = callback
	return self
end

function PANEL:onCancel(callback)
	self.onCancelCallback = callback
	return self
end

vgui.Register("ixCharacterConfirm", PANEL, "EditablePanel")
