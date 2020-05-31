local PANEL = {}

function PANEL:Init()
	self.loaded = false;
	self.titleLabel = self:AddLabel("Select traits")
	self.subLabel = self:SubLabel("You may select up to five traits that suit your character.")

	self.mainPanel = self:AddStagePanel("main")
	self.traitLayout = self.mainPanel:Add("DIconLayout")
	self.traitLayout:Dock( FILL )
	self.traitLayout:DockMargin(0, 10, 0, 0)
	self.traitLayout:SetSpaceY( 5 )
	self.traitLayout:SetSpaceX( 5 )

	self.selectPanel = self:AddStagePanel("select")

	ix.gui.traitSelection = self
end

function PANEL:Display()
	local parent = self;

	self.traitPanels = {}
	self.selectedtraitPanel = nil;

	if(!self.loaded) then
		for i = 1, 5 do
			self.trait = self.traitLayout:Add("DButton") 
			self.trait:SetSize(128, 64)
			self.trait:SetText("+")
			self.trait:SetFont("ixPluginCharTraitFont")
			self.trait.DoClick = function()
				parent.selectedtraitPanel = i;
				parent.selectPanel:Add("ixCharacterTraitSelection")
				parent:SetActivePanel("select")
				self.subLabel:SetText("We use your trait information to tailor roleplay experiences for you.")
			end;
			table.insert(self.traitPanels, self.trait)
		end

		self.loaded = true
	end

	self:SetActivePanel("main");
end

function PANEL:GetTraitPanel()
	return self.traitPanels[self.selectedtraitPanel]
end

vgui.Register("ixCharacterTraits", PANEL, "ixCharacterCreateStep")

local PANEL = {}

function PANEL:Init()
	self:Dock(FILL)
	self.Paint = function() end

	local selectableTraits = self:GetSelectableTraits(ix.gui.traitSelection.selectedtraitPanel);

	self.scroll = self:Add("DScrollPanel")
	self.scroll:Dock(FILL)
	self.scroll:DockMargin(0, 10, 0, 0)

	for k, v in pairs(selectableTraits) do	
		self.categoryLabel = self.scroll:Add("DLabel")
		self.categoryLabel:SetFont("ixPluginCharButtonSubFont")
		self.categoryLabel:SetText(k)
		self.categoryLabel:SizeToContents()
		self.categoryLabel:Dock(TOP)

		self.selectTraitsLayout = self.scroll:Add("DIconLayout")
		self.selectTraitsLayout:Dock(TOP)
		self.selectTraitsLayout:SetSpaceX(4)
		self.selectTraitsLayout:SetSpaceY(4)
		self.selectTraitsLayout:SetDrawBackground(false)
		self.selectTraitsLayout:SetStretchWidth(true)
		self.selectTraitsLayout:SetStretchHeight(true)
		self.selectTraitsLayout:DockMargin(0, 10, 0, 10)
		self.selectTraitsLayout:StretchToParent(0, 0, 0, 0)
		self.selectTraitsLayout:InvalidateLayout(true)

		for key, value in pairs(selectableTraits[k]) do 
			self.trait = self.selectTraitsLayout:Add("DButton")
			self.trait:SetSize(128, 64)
			self.trait:InvalidateLayout(true)
			self.trait:SetText(value.name)
			self.trait:SetFont("ixPluginCharTraitFont")
			self.trait.PaintOver = function(_, width, height)
				surface.SetDrawColor(ColorAlpha(ix.traits.GetColor(value.uniqueID), 3))
				surface.DrawRect(0, 0, width, height)
			end
			self.trait:SetHelixTooltip(function(tooltip)
				tooltip.PaintOver = function(_, width, height)
					surface.SetDrawColor(ColorAlpha(ix.traits.GetColor(value.uniqueID), 11))
					surface.DrawRect(0, 0, width, height)
				end

				local title = tooltip:AddRow("name")
				title:SetText(value.name)
				title:SizeToContents()
				title:SetFont("ixPluginTooltipFont")
				title:SetMaxWidth(math.max(title:GetMaxWidth(), ScrW() * 0.5))
				title.Paint = function(_, width, height)
					surface.SetDrawColor(ColorAlpha(ix.traits.GetColor(value.uniqueID), 11))
					surface.DrawRect(0, 0, width, height)
				end

				local description = tooltip:AddRow("description")
				description:SetText(value.description)
				description:SetFont("ixPluginTooltipDescFont")
				description:SizeToContents()

				local exclusive = tooltip:AddRow("exclusive")
				exclusive:SetText("Mutually exclusive with " .. value.opposite)
				exclusive:SizeToContents()
				exclusive:SetFont("ixPluginTooltipSmallFont")
			end)
			self.trait.DoClick = function()
				local newTraits = ix.gui.traitSelection:GetPayload("traits") or {}
				local panel = ix.gui.traitSelection:GetTraitPanel()

				if(panel.trait) then
					newTraits[panel.arrIndex] = value.uniqueID
				else
					table.insert(newTraits, value.uniqueID)
				end

				panel.arrIndex = ix.gui.traitSelection:GetPayloadSize("traits")
				panel.trait = value

				panel:SetText(panel.trait.name or "+");
				panel:SetHelixTooltip(function(tooltip)
					tooltip.PaintOver = function(_, width, height)
						surface.SetDrawColor(ColorAlpha(ix.traits.GetColor(value.uniqueID), 11))
						surface.DrawRect(0, 0, width, height)
					end

					local title = tooltip:AddRow("name")
					title:SetImportant()
					title:SetText(value.name)
					title:SizeToContents()
					title:SetFont("ixPluginTooltipFont")
					title:SetMaxWidth(math.max(title:GetMaxWidth(), ScrW() * 0.5))
					title.Paint = function(_, width, height)
						surface.SetDrawColor(ColorAlpha(ix.traits.GetColor(value.uniqueID), 11))
						surface.DrawRect(0, 0, width, height)
					end

					local description = tooltip:AddRow("description")
					description:SetText(value.description)
					description:SetFont("ixPluginTooltipDescFont")
					description:SizeToContents()

					local exclusive = tooltip:AddRow("exclusive")
					exclusive:SetText("Mutually exclusive with " .. value.opposite)
					exclusive:SizeToContents()
					exclusive:SetFont("ixPluginTooltipSmallFont")
				end)
				panel.PaintOver = function(_, width, height)
					surface.SetDrawColor(ColorAlpha(ix.traits.GetColor(value.uniqueID), 3))
					surface.DrawRect(0, 0, width, height)
				end

				ix.gui.traitSelection:SetPayload("traits", newTraits)
				ix.gui.traitSelection:SetActivePanel("main")
				ix.gui.traitSelection.subLabel:SetText("You may select up to five traits that suit your character.")

				self:Remove()
			end;
		end

		self.selectTraitsLayout:Layout()
		self.selectTraitsLayout:InvalidateLayout()
	end;
end

function PANEL:GetSelectableTraits(index)
	local function copy(obj, seen)
		if type(obj) ~= 'table' then return obj end
		if seen and seen[obj] then return seen[obj] end
		local s = seen or {}
		local res = setmetatable({}, getmetatable(obj))
		s[obj] = res
		for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
		return res
	end

	local payload = ix.gui.traitSelection:GetPayload("traits")
	local traits = copy(ix.traits.stored)

	local categories = {}
	local opposite = ""
 
	if(ix.gui.traitSelection.traitPanels[index].trait) then
		opposite = ix.gui.traitSelection.traitPanels[index].trait.opposite
	end

	if(payload) then 
		for i = 1, #payload do
			local trait = ix.traits.Get(payload[i])
			
			-- Remove any traits that we have and any opposite traits.
			for k, v in pairs(traits) do
				if(v.name == trait.opposite or v.name == trait.name) then
					if(v.name != opposite) then
						traits[k] = nil
					end
				end
			end		
		end
	end

	for k, v in pairs(traits) do
		if(!v.negative) then 
			local category = v.category or "Default"

			if (!categories[category]) then
				categories[category] = {}
			end

			table.insert(categories[category], v)
		end
	end

	for k, v in pairs(traits) do
		if(v.negative) then 
			local category = v.category or "Default"

			if (!categories[category]) then
				categories[category] = {}
			end

			table.insert(categories[category], v)
		end
	end

	return categories
end

function PANEL:Validate()
	if(self:GetPayloadSize("traits") < 5) then
		return false, "You must select 5 traits!"
	end

	return false
end

vgui.Register("ixCharacterTraitSelection", PANEL, "DPanel")

