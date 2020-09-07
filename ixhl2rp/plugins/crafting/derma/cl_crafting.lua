--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	if (IsValid(ix.gui.crafting)) then
		ix.gui.crafting:Remove()
	end

	-- Put this on a global so other files can index this instance.
	ix.gui.crafting = self;

	self.professionButtons = {}
	self.character = LocalPlayer():GetCharacter()
	self:Dock(FILL);
	self:DockPadding(4 ,4, 4, 4)

	self.notificationDock = self:Add("DPanel")
	self.notificationDock:Dock(TOP)
	self.notificationDock:DockMargin(4,4,4,4)
	self.notificationDock:SetTall(40)
	self.notificationDock.Paint = function() end
	self.notificationDock:SetVisible(false)

	if(!self.character:GetMastery()) then
		self:CreateNotification("You don't have a mastery selected. Click this notification to select one.")
	end

	self.topDock = self:Add("DPanel")
	self.topDock:Dock(TOP)
	self.topDock:DockMargin(4,4,4,4)
	self.topDock:SetTall(192)
	
	function self.topDock:Paint(w, h)
		surface.SetDrawColor(30, 30, 30, 150)
		surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
	
		local outlineColor = Color(100, 170, 220, 80)
	
		if(ix.gui.selectedProfession) then
			outlineColor = ix.gui.selectedProfession:GetColor()
		end
	
		surface.SetDrawColor(outlineColor)
		surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
	end

	-- We can't grab the width of a docked panel without first invalidating it's parent.
	self:InvalidateParent(true)

	-- The width is that of the parent panel, with '56' being a static value that won't change with resolution.
	local width = self:GetWide() - 56
	self.actualWidth = self:GetWide()

	local count = table.Count(ix.profession.stored)

	-- Iterating through all of the displayable professions and adding them to the menu.
	for k, v in pairs(ix.profession.stored) do
		local button = self.topDock:Add("ixProfessionButton")
		button:SetTall(128)
		button:SetWide(width / count)
		button:DockMargin(4, 4, 4, 4)
		button:Dock(LEFT)

		if(!v:IsEnabled()) then
			button:SetEnabled(false)
		end

		-- We have to hard code this value because of the way docking works.
		button.actualWidth = width / count

		-- This comes last because we need all the data previously, first.
		button:SetProfession(v)

		table.insert(self.professionButtons, button)
	end

	self.topDock:SizeToContents()
end;

function PANEL:CreateNotification(text)
	self.notificationDock:SetVisible(true)
	self.notificationDock:Clear()

	local message = self.notificationDock:Add("ixNewButton")
	message:SetText("")
	message:Dock(FILL)

	local icon = message:Add("Material")
	icon:Dock(LEFT)
	icon:DockMargin(4, 4, 4, 4)
	icon:SetWide(36)
    icon:SetMaterial("materials/terranova/ui/traits/passive.png")
	icon.AutoSize = false
	
	local label = message:Add("DLabel")
	label:SetFont("ixInfoPanelFont")
	label:SetText(text)
	label:SizeToContents()
    label:Dock(FILL)
	label:DockMargin(4, 4, 4, 4)

	function message:DoClick()
		if(IsValid(ix.gui.menu)) then
			ix.gui.menu:Remove()
		end

		local selector = vgui.Create("ixMasterySelect")
		selector:MakePopup()
	end
end

-- Adding all the recipes for the selected profession into a scroll list.
function PANEL:BuildRecipes(profession)
	if(self.selectedRecipe) then
		self.selectedRecipe:Remove()
	end

	if(self.categoryList) then
		self.categoryList:Remove()
	end

	self.selectedRecipe = self:Add("ixSelectedRecipe")

	self.categoryList = self:Add("DScrollPanel")
	self.categoryList:Dock(FILL)
	self.categoryList:DockMargin(4,4,4,4)

	-- Get all the recipes into their categories for the selected profession.
	local categories = ix.recipe.GetCategories(ix.profession.GetRecipes(profession.uniqueID))

	-- Iterate through all the categories within this profession
	for title, v in pairs(categories) do
		local category = vgui.Create("ixCollapsibleCategory", self);
		category.crafting = true
		category:SetTitle(title)
		category:DockMargin(0, 0, 0, 8)

		self.categoryList:Add(category)

		local layout = vgui.Create("DIconLayout")
		layout:Dock(TOP)
		layout:DockMargin(4, 14, 4, 4) -- We need this to offset because the title of the collapsible category is bigger than normal
		layout:DockPadding(2,2,2,2)
		layout:SetSpaceX(4)
		layout:SetSpaceY(4)
		layout:SetDrawBackground(false)

		-- Subtracting because of the hard coded margin
		local width = (self.actualWidth - 50) / 3

		for k, v in pairs(v.recipes) do
			local recipe = vgui.Create("ixRecipePanel")
			recipe.actualWidth = width
			recipe:SetWide(width)
			recipe:SetRecipe(v)

			layout:Add(recipe)
		end
		
		category:SetContents(layout)
	end

	self:ResumeScroll()
end

-- Called every frame
function PANEL:Paint()
	surface.SetDrawColor(30, 30, 30, 150)
	surface.DrawRect(0, 0, self:GetWide(), self:GetTall())

	local outlineColor = Color(100, 170, 220, 80)

	if(ix.gui.selectedProfession) then
		outlineColor = ix.gui.selectedProfession:GetColor()
	end

	surface.SetDrawColor(outlineColor)
	surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
end

function PANEL:ResumeScroll()
	local scrollValue = ix.gui.craftScrollValue or 0 -- Localise this value instead of referencing a value that'll change
	local scrollbar = self.categoryList:GetVBar()

	-- AnimateTo is the only method that'll consistantly reach its destination because of InvalidateLayout
	scrollbar:AnimateTo(scrollValue, 0.01, 0)
end

function PANEL:Think()
	if(IsValid(self.categoryList)) then
		ix.gui.craftScrollValue = self.categoryList:GetVBar():GetScroll()
	end
end

vgui.Register("ixCraftingPanel", PANEL, "ixStagePanel")