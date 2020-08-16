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

	self.header = self:Add("DPanel")
	self.header:Dock(TOP)
	self.header:DockMargin(4,4,4,4)
	self.header:Add(self:AddLabel("Crafting", true, true))
	self.header:Add(self:AddLabel("Placeholder description, this still needs to be set."))

	self.header:InvalidateLayout(true)
	self.header:SizeToChildren(false, true)

	self.topDock = self:Add("DPanel")
	self.topDock:Dock(TOP)
	self.topDock:DockMargin(4,4,4,4)
	self.topDock:SetTall(192)

	-- We can't grab the width of a docked panel without first invalidating it's parent.
	self:InvalidateParent(true)

	-- The width is that of the parent panel, with '56' being a static value that won't change with resolution.
	local width = self:GetWide() - 56
	local count = table.Count(ix.profession.GetDisplayable())

	-- Iterating through all of the displayable professions and adding them to the menu.
	for k, v in pairs(ix.profession.GetDisplayable()) do
		if(v:ShouldDisplay()) then
			local button = self.topDock:Add("ixProfessionButton")
			button:SetTall(128)
			button:SetWide(width / count)
			button:DockMargin(4, 4, 4, 4)
			button:Dock(LEFT)
			button:SetProfession(v)

			table.insert(self.professionButtons, button)
		end
	end

	self.topDock:SizeToContents()
end;

-- Adding all the recipes for the selected profession into a scroll list.
function PANEL:BuildRecipes(profession)
	if(self.categoryList) then
		self.categoryList:Remove()
	end

	self.categoryList = self:Add("DScrollPanel")
	self.categoryList:Dock(FILL)
	self.categoryList:DockMargin(4,4,4,4)

	-- Get all the recipes into their categories for the selected profession.
	local categories = ix.recipe.GetCategories(ix.profession.GetRecipes(profession.uniqueID))

	-- Iterate through all the categories within this profession
	for title, v in pairs(categories) do
		local category = vgui.Create("ixCraftingCategory", self);
		category:SetTitle(title)
		category:DockMargin(0, 0, 0, 16)

		self.categoryList:AddItem(category)

		for k, v in pairs(v.recipes) do
			local recipe = vgui.Create("ixRecipePanel")
			recipe:SetRecipe(v)

			category.list:AddItem(recipe)
		end
	end
end

-- Called every frame
function PANEL:Paint()
	surface.SetDrawColor(30, 30, 30, 150)
	surface.DrawRect(0, 0, self:GetWide(), self:GetTall())

	surface.SetDrawColor(Color(100, 170, 220, 80))
	surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
end

vgui.Register("ixCraftingPanel", PANEL, "ixStagePanel")