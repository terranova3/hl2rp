local PANEL = {}

local HIGHLIGHT = Color(255, 255, 255, 50)

function PANEL:Init()
	self.namePanel = self:Add("DPanel")
	self.namePanel:Dock(TOP)
	self.namePanel:SetTall(128)
	self.namePanel:DockMargin(0,0,0,32)
	self.namePanel.Paint = function(w, h)
		draw.RoundedBox(16, 0, 0, self:GetWide(), 128, Color( 150, 150, 150, 1))
	end

	self.nameLabel = self.namePanel:Add("DLabel")
	self.nameLabel:SetText("Name")
	self.nameLabel:SetTall(40)
	self.nameLabel:SetFont("ixPluginCharBackgroundTitleFont")
	self.nameLabel:Dock(TOP)
	self.nameLabel:SetContentAlignment(8)

	self.name = self.namePanel:Add("DTextEntry")
	self.name:Dock(TOP)
	self.name:SetFont("ixPluginCharBackgroundFont")
	self.name:SetTall(48)
	self.name:DockMargin(16, 16, 16, 16)
	self.name:SetUpdateOnType(true)
	self.name:SetZPos(1)
	self.name.Paint = self.PaintTextEntry
	self.name.OnValueChange = function(_, value)
		self:SetPayload("name", string.Trim(value))
	end
	self.name.OnKeyCodeTyped = function(name, keyCode)
		if (keyCode == KEY_TAB) then
			entry:onTabPressed()
			return true
		end
	end
	self.name.onTabPressed = function()
		self.desc:RequestFocus()
	end

	self.descPanel = self:Add("DPanel")
	self.descPanel:Dock(TOP)
	self.descPanel:SetTall(256)
	self.descPanel.Paint = function(w, h)
		draw.RoundedBox(16, 0, 0, self:GetWide(), 256, Color( 150, 150, 150, 1))
	end

	self.descLabel = self.descPanel:Add("DLabel")
	self.descLabel:SetText("Description")
	self.descLabel:SetTall(40)
	self.descLabel:SetFont("ixPluginCharBackgroundTitleFont")
	self.descLabel:Dock(TOP)
	self.descLabel:SetContentAlignment(8)

	self.desc = self.descPanel:Add("DTextEntry")
	self.desc:Dock(TOP)
	self.desc:SetFont("ixPluginCharBackgroundFont")
	self.desc:SetTall(self.name:GetTall() * 3)
	self.desc:DockMargin(16, 16, 16, 16)
	self.desc:SetUpdateOnType(true)
	self.desc:SetMultiline(true)
	self.desc:SetZPos(3)
	self.desc.Paint = self.PaintTextEntry
	self.desc.OnValueChange = function(_, value)
		self:SetPayload("description", string.Trim(value))
	end
	self.desc.OnKeyCodeTyped = function(name, keyCode)
		if (keyCode == KEY_TAB) then
			entry:onTabPressed()
			return true
		end
	end
	self.desc.onTabPressed = function()
		self.name:RequestFocus()
	end
	
	self:Register("Background")
end

function PANEL:AddTextEntry(payloadName)
	local entry = self:Add("DTextEntry")
	entry:Dock(TOP)
	entry:SetFont("ixPluginCharButtonFont")
	entry.Paint = self.PaintTextEntry
	entry:DockMargin(0, 4, 0, 16)
	entry.OnValueChange = function(_, value)
		self:SetPayload(payloadName, string.Trim(value))
	end
	entry.payloadName = payloadName
	entry.OnKeyCodeTyped = function(name, keyCode)
		if (keyCode == KEY_TAB) then
			entry:onTabPressed()
			return true
		end
	end
	entry:SetUpdateOnType(true)
	return entry
end

function PANEL:Display()
	local faction = self:GetPayload("faction")
	local default, override = hook.Run("GetDefaultCharName", LocalPlayer(), faction)

	if (override) then
		self.nameLabel:SetVisible(false)
		self.name:SetVisible(false)
	else
		if (default and not self:GetPayload("name")) then
			self:SetPayload("name", default)
		end
		self.nameLabel:SetVisible(true)
		self.name:SetVisible(true)
		self.name:SetText(self:GetPayload("name", ""))
	end

	self.desc:SetText(self:GetPayload("description", ""))

	-- Requesting focus same frame causes issues with docking.
	self.name:RequestFocus()
end

function PANEL:Validate()
	if (self.name:IsVisible()) then
		local res = {self:ValidateCharVar("name")}
		if (res[1] == false) then
			return unpack(res)
		end
	end
	return self:ValidateCharVar("description")
end

-- self refers to the text entry
function PANEL:PaintTextEntry(w, h)
	ix.util.DrawBlur(self)
	surface.SetDrawColor(0, 0, 0, 100)
	surface.DrawRect(0, 0, w, h)
	self:DrawTextEntryText(color_white, HIGHLIGHT, HIGHLIGHT)
end

vgui.Register("ixCharacterBiography", PANEL, "ixCharacterCreateStep")
