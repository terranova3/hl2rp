local PANEL = {}


function PANEL:Init()
	self.title = self:AddLabel("Faction Selection")

	self.faction = self:Add("DComboBox")
	self.faction:SetFont("ixPluginCharButtonFont")
	self.faction:Dock(TOP)
	self.faction:DockMargin(0, 4, 0, 0)
	self.faction:SetTall(40)
	self.faction.Paint = function()
        surface.SetDrawColor(255,255,255,5)
        surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
	end
	self.faction.Think = function()
		if(IsValid(self.faction.Menu)) then
			self.faction.Menu:SetMaxHeight(256)
		end
	end
	self.faction:SetTextColor(color_white)
	self.faction.OnSelect = function(faction, index, value, id)
		self:OnFactionSelected(ix.faction.teams[id])
	end

	self.desc = self:AddLabel("desc")
	self.desc:DockMargin(8, 8, 0, 0)
	self.desc:SetFont("ixPluginCharSubTitleFont")
	self.desc:SetWrap(true)
	self.desc:SetAutoStretchVertical(true)

	self.skipFirstSelect = true

	local first = true
	for id, faction in SortedPairsByMemberValue(ix.faction.teams, "name") do
		if (not ix.faction.HasWhitelist(faction.index)) then continue end

		self.faction:AddChoice(L(faction.name), id, first)
		first = false
	end

	self:Register("Faction")
end

function PANEL:Display()
	self.skipFirstSelect = true

	local _, id = self.faction:GetSelected()
	local faction = ix.faction.teams[id]
	if (faction) then
		self:OnFactionSelected(faction)
	end
end

function PANEL:OnFactionSelected(faction)
	if (self:GetPayload("faction") == faction.index) then
		return
	end

	local models = ix.faction.indices[faction.index]:GetModels(LocalPlayer())

	self.desc:SetText(L(faction.description or "noDesc"))
	self.desc:SetTextColor(faction.color)

	self:ResetPayload()
	self:SetPayload("faction", faction.index)
	self:SetPayload("model", math.random(1, #models))

	-- Set the model for the preview.
	self:UpdateModelPanel()

	-- Update the tracker for the new faction.
	if(IsValid(ix.gui.charCreateTracker)) then
		ix.gui.charCreateTracker:Build(true)
	end

	-- Don't make the click sound when the faction is pre-selected.
	if (self.skipFirstSelect) then
		self.skipFirstSelect = false
		return
	end

	ix.gui.characterMenu:clickSound()
end

function PANEL:ShouldSkip()
	return #self.faction.Choices == 1
end

function PANEL:OnSkip()
	local _, id = self.faction:GetSelected()
	local faction = ix.faction.teams[id]
	self:SetPayload("faction", faction and faction.index or nil)
	self:SetPayload("model", self:GetPayload("model", 1))
end

vgui.Register("ixCharacterFaction", PANEL, "ixCharacterCreateStep")
