local PANEL = {}

function PANEL:Init()
	local parent = self;

	self.traitPanels = {}
	self.selectedtraitPanel = nil;
	self.newTrait = nil;

	self.titleLabel = self:AddLabel("Select traits")
	self.subLabel = self:SubLabel("You may select up to five traits that suit your character.")

	self.mainPanel = self:AddStagePanel("main")
	self.mainPanel.OnSetActive = function()
		if(self.selectedtraitPanel) then
			self.traitPanels[self.selectedtraitPanel]:SetText(self.newTrait);
		end
	end
	self.traitLayout = self.mainPanel:Add("DIconLayout")
	self.traitLayout:Dock( FILL )
	self.traitLayout:DockMargin(0, 10, 0, 0)
	self.traitLayout:SetSpaceY( 5 )
	self.traitLayout:SetSpaceX( 5 )
	
	for i = 1, 5 do
		self.trait = self.traitLayout:Add("DButton") 
		self.trait:SetSize(128, 64)
		self.trait:SetText("+")
		self.trait:SetFont("ixPluginCharTraitFont")
		self.trait.DoClick = function()
			parent.selectedtraitPanel = i;
			print(parent.selectedtraitPanel)
			parent:SetActivePanel("select")
			self.subLabel:SetText("We use your trait information to tailor roleplay experiences for you.")
		end;

		table.insert(self.traitPanels, self.trait)
	end

	self.selectPanel = self:AddStagePanel("select")
	self.scroll = self.selectPanel:Add("DScrollPanel")
	self.scroll:Dock(FILL)
	self.scroll:DockMargin(0, 10, 0, 0)

	local traitArray = ix.traits.GetCategories()

	for k, v in pairs(traitArray) do
		
		local label = self.scroll:Add("DLabel")
		label:SetFont("ixPluginCharButtonSubFont")
		label:SetText(k)
		label:SizeToContents()
		label:Dock(TOP)

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

		for key, value in pairs(traitArray[k]) do 
			self.trait = self.selectTraitsLayout:Add("DButton")
			self.trait:SetSize(128, 64)
			self.trait:InvalidateLayout(true)
			self.trait:SetText(value.name)
			self.trait:SetFont("ixPluginCharTraitFont")
			self.trait:SetHelixTooltip(function(tooltip)
				local title = tooltip:AddRow("name")
				--title:SetImportant()
				title:SetText(value.name)
				title:SizeToContents()
				title:SetMaxWidth(math.max(title:GetMaxWidth(), ScrW() * 0.5))

				local description = tooltip:AddRow("description")
				description:SetText(value.description)
				description:SizeToContents()

				local exclusive = tooltip:AddRow("exclusive")
				exclusive:SetText("Mutually exclusive with " .. value.opposite)
				exclusive:SizeToContents()
				exclusive.bMinimal = true;
			end)
			self.trait.DoClick = function()
				local newTraits = self:GetPayload("traits") or {}

				table.insert(newTraits, value.uniqueID)
				self:SetPayload("traits", newTraits)
				parent.newTrait = value.name;

				parent:SetActivePanel("main")
				self.subLabel:SetText("You may select up to five traits that suit your character.")
			end;
		end

		self.selectTraitsLayout:Layout()
		self.selectTraitsLayout:InvalidateLayout()
	end;
end

function PANEL:Display()
	self:SetActivePanel("main");
end;

vgui.Register("ixCharacterTraits", PANEL, "ixCharacterCreateStep")
