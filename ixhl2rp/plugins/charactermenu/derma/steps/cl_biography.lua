local PANEL = {}

local HIGHLIGHT = Color(255, 255, 255, 50)

function PANEL:Init()
	self.nameLabel = self:AddLabel("name")
	self.nameLabel:SetZPos(0)

	self.name = self:AddTextEntry("name")
	self.name:SetTall(48)
	self.name.onTabPressed = function()
		self.desc:RequestFocus()
	end
	self.name:SetZPos(1)

	self.descLabel = self:AddLabel("description")
	self.descLabel:SetZPos(2)

	self.desc = self:AddTextEntry("description")
	self.desc:SetTall(self.name:GetTall() * 3)
	self.desc.onTabPressed = function()
		self.name:RequestFocus()
	end
	self.desc:SetMultiline(true)
	self.desc:SetZPos(3)

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
	local info = ix.faction.indices[faction]
	local default, override

	if (info and info.GetDefaultName) then
		default, override = info:GetDefaultName(LocalPlayer())
	end

	if (override) then
		self:SetPayload("name", default)
		self.nameLabel:SetText(default)
		self.nameLabel:DockMargin(0, 0, 0, 10)
		self.name:SetVisible(false)
	else
		self:SetPayload("name", "")
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
