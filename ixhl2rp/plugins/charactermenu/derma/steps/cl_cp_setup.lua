local PANEL = {}

function PANEL:Init()
	local parent = self

	self.label = self:AddLabel("Unit Setup")
	self.sublabel = self:SubLabel("Customize your description, tagline and id number.")

	self.desc = self:AddTextEntry("cpdesc")
	self.desc:SetTall(128)
	self.desc:SetMultiline(true)

	self.taglineDropBox = self:Add("DComboBox")
	self.taglineDropBox:SetFont("ixPluginCharTraitFont")
	self.taglineDropBox:Dock(TOP)
	self.taglineDropBox:DockMargin(0, 10, 0, 0)
	self.taglineDropBox.OnSelect = function( self, index, value )
		parent.selectedTagline = value;
		parent:SetPayload("tagline", value)
		parent:RebuildIDs()
	end

	self.idDropBox = self:Add("DComboBox")
	self.idDropBox:SetFont("ixPluginCharTraitFont")
	self.idDropBox:Dock(TOP)
	self.idDropBox:DockMargin(0, 10, 0, 0)
	self.idDropBox.OnSelect = function( self, index, value )
		parent:SetPayload("cpid", value)
	end

	netstream.Start("RequestTaglineCache")
	self:Register("Unit Setup")
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

function PANEL:PaintTextEntry(w, h)
	ix.util.DrawBlur(self)
	surface.SetDrawColor(0, 0, 0, 100)
	surface.DrawRect(0, 0, w, h)
	self:DrawTextEntryText(color_white, HIGHLIGHT, HIGHLIGHT)
end

function PANEL:Display()
	self.taglines = self.taglines or self:GetTaglines()

	self.taglineDropBox:Clear()
	self.taglineDropBox:SetValue( "Taglines" )

	self.idDropBox:Clear()
	self.idDropBox:SetValue( "IDs" )

	for k, v in pairs(self.taglines) do 
		self.taglineDropBox:AddChoice(k)
	end
end

function PANEL:ShouldSkip()
	local faction = ix.faction.indices[self:GetPayload("faction")]

	if(faction.name != "Civil Protection") then
		return true
	end
end


function PANEL:RebuildIDs()
	self.idDropBox:Clear()
	
	for k, v in pairs(self.taglines[self.selectedTagline].id) do
		if(v == false) then
			self.idDropBox:AddChoice(k)
		end
	end
end

-- This is pretty expensive, keep the use of this to a minimal amount.
function PANEL:GetTaglines()
	local data = {}

	for k, v in pairs(cpSystem.config.taglines) do
		data[v] = {}
		data[v].id = {}

		for i = 1, 9 do
			table.insert(data[v].id, false)
		end
	end

	for k, v in pairs(cpSystem.cache.taglines or {}) do
		data[v.tagline].id[v.id] = true
	end

	return data
end

vgui.Register("ixCharacterCPSetup", PANEL, "ixCharacterCreateStep")
