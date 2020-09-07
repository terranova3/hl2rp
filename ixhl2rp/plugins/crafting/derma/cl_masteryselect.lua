--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

local PANEL = {};
local panelWidth = 1296
local panelHeight = 800

-- Called when the panel is initialized.
function PANEL:Init()
    self.professionButtons = {}

    ix.gui.masterySelect = self

    LocalPlayer().selectedMastery = nil

    self:SetTitle("Mastery Selection")
	self:SetBackgroundBlur(true);
	self:SetDeleteOnClose(false);
    self:SetSize(panelWidth, panelHeight)
    
	-- Called when the button is clicked.
	function self.btnClose.DoClick(button)
		self:Close(); 
		self:Remove();
		
		gui.EnableScreenClicker(false);
    end;
    
    self.topDock = self:Add("DPanel")
	self.topDock:Dock(TOP)
	self.topDock:DockMargin(4,4,4,4)
	self.topDock:SetTall(192)
	
	function self.topDock:Paint(w, h)
		surface.SetDrawColor(30, 30, 30, 150)
		surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
	
		local outlineColor = Color(100, 170, 220, 80)
	
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

		-- We have to hard code this value because of the way docking works.
		button.actualWidth = width / count

		-- This comes last because we need all the data previously, first.
		button:SetProfession(v)
		
		
		if(!v:IsEnabled()) then
			button:SetEnabled(false)
		end
		
		function button:PostClick()
			LocalPlayer().selectedMastery = v
			ix.gui.masterySelect:ShowRecipes(v)
		end

		table.insert(self.professionButtons, button)
    end
    
    for k, v in pairs(self.professionButtons) do
        v.otherButtons = self.professionButtons
    end

    self.topDock:SizeToContents()

    self.recipePanel = self:Add("DPanel")
    self.recipePanel:Dock(FILL)
    
    self.finishButton = self:Add("ixNewButton")
    self.finishButton:Dock(BOTTOM)
    self.finishButton:SetTall(64)
	self.finishButton:SetText("Choose mastery")
	
	function self.finishButton:DoClick()
		local mastery = LocalPlayer().selectedMastery

		if(mastery) then
			net.Start("ixMasterProfession")
				net.WriteString(mastery.uniqueID)
			net.SendToServer()
		end

		ix.gui.masterySelect:Remove()
	end
end;

function PANEL:ShowRecipes(profession)
	local recipes = {}

	for _, recipe in pairs(ix.recipe.stored) do
		if(recipe:GetProfession() == profession.uniqueID and recipe:GetMastery()) then
			table.insert(recipes, recipe)
		end
	end

	self.recipePanel:Clear()
	
	if(table.Count(recipes) < 1) then
		return
	end

	self.categoryList = self.recipePanel:Add("DScrollPanel")
	self.categoryList:Dock(FILL)
	self.categoryList:DockMargin(4,4,4,4)

	local category = vgui.Create("ixCollapsibleCategory", self);
	category:SetTitle("Unlocked Recipes")
	category:DockMargin(0, 0, 0, 8)
	category.crafting = true

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

	for k, v in pairs(recipes) do
		local recipe = vgui.Create("ixRecipePanel")
		recipe.actualWidth = width
		recipe:SetWide(width)
		recipe:SetRecipe(v)
		recipe:SetEnabled(false)

		layout:Add(recipe)
	end
	
	category:SetContents(layout)
end

-- Called each frame.
function PANEL:Think()
	local scrW = ScrW();
	local scrH = ScrH();
	
    self:SetSize(panelWidth, panelHeight)
	self:SetPos( (scrW / 2) - (self:GetWide() / 2), (scrH / 2) - (self:GetTall() / 2) );
end;

vgui.Register("ixMasterySelect", PANEL, "DFrame")