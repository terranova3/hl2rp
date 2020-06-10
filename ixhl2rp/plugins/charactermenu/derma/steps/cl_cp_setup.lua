local PANEL = {}

function PANEL:Init()
	local parent = self

	self.label = self:AddLabel("Unit Setup")
	self.sublabel = self:SubLabel("Customize your tagline and id number.")

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

	for k, v in pairs(ix.util.NewInstance(cpSystem.config.taglines)) do
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
