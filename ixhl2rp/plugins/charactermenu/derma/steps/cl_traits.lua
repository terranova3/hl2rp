local PANEL = {}

function PANEL:Init()
	local parent = self;

	self.traitPanels = {}
	self.titleLabel = self:AddLabel("Select traits")
	self.subLabel = self:SubLabel("You may select up to five traits that suit your character.")

	self.mainPanel = self:AddStagePanel("main")
	self.traitLayout = self.mainPanel:Add("DIconLayout")
	self.traitLayout:Dock( FILL )
	self.traitLayout:DockMargin(0, 10, 0, 0)
	self.traitLayout:SetSpaceY( 5 )
	self.traitLayout:SetSpaceX( 5 )

	for i = 1, 5 do
		self.trait = self.traitLayout:Add("DButton") 
		self.trait:SetSize(64, 64)
		self.trait:SetFont("ixPluginCharTraitFont")
		self.trait:SetText("+")
		self.trait.DoClick = function()
			parent.selectedtraitPanel = i;
			ix.gui.selector = parent.selectPanel:Add("ixCharacterTraitSelection")
			parent:SetActivePanel("select")
			self.subLabel:SetText("We use your trait information to tailor roleplay experiences for you.")
		end;

		self.icon = self.trait:Add("Material")
		self.icon:SetSize(32, 32)
		self.icon:SetPos(16, 16)
		self.icon.AutoSize = false

		table.insert(self.traitPanels, {panel = self.trait, icon = self.icon})
	end

	self.selectPanel = self:AddStagePanel("select")

	ix.gui.traitSelection = self
	self:Register("Traits")
end

function PANEL:Display()
	self:SetActivePanel("main");
end

function PANEL:OnHide()
	if(ix.gui.selector) then
		ix.gui.selector:Remove()
	end
end

function PANEL:GetTraitPanel()
	return self.traitPanels[self.selectedtraitPanel].panel
end

function PANEL:GetTraitPanelIcon()
	return self.traitPanels[self.selectedtraitPanel].icon
end

function PANEL:Validate()
	local res = {self:ValidateCharVar("traits")}

	if (res[1] == false) then
		return unpack(res)
	end
	
	return self:ValidateCharVar("traits")
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
		self.categoryLabel = self.scroll:Add("ixInfoText")
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
			self.trait:SetSize(216, 64)
			self.trait:InvalidateLayout(true)
			self.trait:SetText("")
			self.trait:SetFont("ixPluginCharTraitFont")
			self.trait.PaintOver = function() 
				ix.util.DrawText(value.name, 48, 24, color_white, 0, 0, "ixPluginTooltipDescFont")
			end

			self.icon = self.trait:Add("Material")
			self.icon:SetSize(32, 32)
			self.icon:SetPos(8, 16)
			self.icon:SetMaterial(value.icon)
			self.icon.AutoSize = false
		
			self.trait:SetHelixTooltip(function(tooltip)
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
				local panelIcon = ix.gui.traitSelection:GetTraitPanelIcon()

				if(panel.trait) then
					newTraits[panel.arrIndex] = value.uniqueID
				else
					table.insert(newTraits, value.uniqueID)
				end

				panel.arrIndex = ix.gui.traitSelection:GetPayloadSize("traits")
				panel.trait = value

				panelIcon:SetMaterial(value.icon)
				panel:SetText("")
				panel:SetHelixTooltip(function(tooltip)
					local title = tooltip:AddRow("name")
					title:SetText(value.name)
					title:SizeToContents()
					title:SetFont("ixPluginTooltipFont")
					title:SetMaxWidth(math.max(title:GetMaxWidth(), ScrW() * 0.5))

					local description = tooltip:AddRow("description")
					description:SetText(value.description)
					description:SetFont("ixPluginTooltipDescFont")
					description:SizeToContents()

					local exclusive = tooltip:AddRow("exclusive")
					exclusive:SetText("Mutually exclusive with " .. value.opposite)
					exclusive:SizeToContents()
					exclusive:SetFont("ixPluginTooltipSmallFont")
				end)

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
	local payload = ix.gui.traitSelection:GetPayload("traits")
	local traits = ix.util.NewInstance(ix.traits.stored)

	local categories = {}
	local opposite = ""
 
	if(ix.gui.traitSelection.traitPanels[index].panel.trait) then
		opposite = ix.gui.traitSelection.traitPanels[index].panel.trait.opposite
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

	for k, v in SortedPairsByMemberValue(traits, "order") do
		local category = "General"

		if(v.category == "Philosophy") then
			category = v.category
		end

		if (!categories[category]) then
			categories[category] = {}
		end

		table.insert(categories[category], v)
	end

	return categories
end

vgui.Register("ixCharacterTraitSelection", PANEL, "DPanel")

