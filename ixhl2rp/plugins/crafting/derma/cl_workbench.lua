--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN
local PANEL = {}

function PANEL:Init()
    ix.gui.workbenchPanel = self
    self:ShowCloseButton( false )
    self:SetBackgroundBlur(true);
	self:Center()
    self:MakePopup()
	self:SetAlpha(0)
	self:DrawHeader()
end

function PANEL:DrawHeader()
    self.header = self:Add("DPanel")
    self.header:SetSize((ScrW() * 0.5) - 10, 32)
    self.header:SetPos(5, 4)  
    self.header.Paint = function() 
        derma.SkinFunc("DrawImportantBackground", 0, 0, self:GetWide(), self:GetTall(), Color(100, 170, 220, 80))
    end

    self.headerLabel = self.header:Add("DLabel")
    self.headerLabel:SetText("Workbench")
    self.headerLabel:SetFont("ixMediumFont")
    self.headerLabel:SetExpensiveShadow(3)
    self.headerLabel:Dock(FILL)

    self.exitButton = self.header:Add("DButton")
    self.exitButton:SetText("X")
    self.exitButton:SetWide(32)
    self.exitButton:Dock(RIGHT)
    self.exitButton:SetFont("ixSmallFont")
    self.exitButton.Paint = function()
    end
    self.exitButton.DoClick = function()
        self:Remove()
    end

    self.fakeSpacer = self:Add("DPanel")
    self.fakeSpacer:Dock(TOP)
    self.fakeSpacer:SetTall(10)
    self.fakeSpacer.Paint = function() end
end

-- Called each frame.
function PANEL:Think()
	local scrW = ScrW();
	local scrH = ScrH();

	self:SetSize(scrW * 0.5, scrH * 0.5)
	self:SetPos( (scrW / 2) - (self:GetWide() / 2), (scrH / 2) - (self:GetTall() / 2) );
end;

function PANEL:Populate()
	self:SetVisible(true)

	self.leftDock = self:Add("ixStagePanel")
	self.leftDock:Dock(LEFT)
	self.leftDock:SetWide((ScrW() * 0.5) * 0.7)

	self.rightDock = self:Add("DPanel")
	self.rightDock:Dock(FILL)

	self.topDock = self.leftDock:Add("DPanel")
	self.topDock:Dock(TOP)
	self.topDock:DockMargin(4,4,4,4)
	self.topDock.Paint = function() end

	self:BuildInventory()
	self:BuildMaterials()
	self:BuildCrafting()
	self:BuildCraftPanel()
end

function PANEL:BuildInventory()
	self.leftDock.inventory = self.leftDock:AddStagePanel("inventory")
	self.invButton = self.topDock:Add(self.leftDock:AddStageButton("Inventory", "inventory"))
	self.invButton:SetSize(150, self:GetTall())

	local canvas = self.leftDock.inventory:Add("DTileLayout")

	local canvasLayout = canvas.PerformLayout
	canvas.PerformLayout = nil -- we'll layout after we add the panels instead of each time one is added
	canvas:SetBorder(0)
	canvas:SetSpaceX(2)
	canvas:SetSpaceY(2)
	canvas:Dock(FILL)

	ix.gui.menuInventoryContainer = canvas

	local panel = canvas:Add("ixInventory")
	panel:SetPos(0, 0)
	panel:SetDraggable(false)
	panel:SetSizable(false)
	panel:SetTitle(nil)
	panel.bNoBackgroundBlur = true
	panel.childPanels = {}

	local inventory = LocalPlayer():GetCharacter():GetInventory()

	if (inventory) then
		panel:SetInventory(inventory)
	end

	ix.gui.inv1 = panel

	self.leftDock:SetActivePanel("inventory");
end

function PANEL:BuildMaterials()
	self.leftDock.materials = self.leftDock:AddStagePanel("materials")

	self.materialsButton = self.topDock:Add(self.leftDock:AddStageButton("Materials", "materials"))
	self.materialsButton:SetSize(150, self:GetTall())

	self.materialCategoryPanels = {}

	self.materialScroll = self.leftDock.materials:Add("DScrollPanel")
	self.materialScroll:Dock(FILL)

	local include = {
		"Convert",
		"Refine"
	}

	for k, v in pairs(PLUGIN.craft.recipes) do
		if (v:OnCanSee(LocalPlayer()) == false) then
			continue
		end

		local build = false

		for _, inclusion in pairs(include) do
			if(v.category == inclusion) then
				build = true
				break
			end
		end

		if (!self.materialCategoryPanels[v.category] and build) then
			self.materialCategoryPanels[v.category] = {}
		end
	end

	for k, v in SortedPairs(self.materialCategoryPanels) do
		local categoryLabel = self.materialScroll:Add("ixInfoText")
		categoryLabel:MakeBold()
		categoryLabel:SetText(k)
		categoryLabel:SizeToContents()
		categoryLabel:Dock(TOP)

		local layout = self.materialScroll:Add("DIconLayout")
		layout:Dock(TOP)
		layout:SetSpaceX(4)
		layout:SetSpaceY(4)
		layout:SetDrawBackground(false)
		layout:SetStretchWidth(true)
		layout:SetStretchHeight(true)
		layout:DockMargin(0, 10, 0, 10)
		layout:StretchToParent(0, 0, 0, 0)
		layout:InvalidateLayout(true)

		v.layout = layout
		self:LoadRecipes(k, self.materialCategoryPanels, self.materialScroll)
	end
end

function PANEL:BuildCrafting()
	self.leftDock.crafting = self.leftDock:AddStagePanel("crafting")

	self.craftingButton = self.topDock:Add(self.leftDock:AddStageButton("Crafting", "crafting"))
	self.craftingButton:SetSize(150, self:GetTall())

	self.categoryPanels = {}

	self.scroll = self.leftDock.crafting:Add("DScrollPanel")
	self.scroll:Dock(FILL)

	local exclude = {
		"Convert",
		"Refine"
	}

	for k, v in pairs(PLUGIN.craft.recipes) do
		if (v:OnCanSee(LocalPlayer()) == false) then
			continue
		end

		local build = true

		for _, exclusion in pairs(exclude) do
			if(v.category == exclusion) then
				build = false
				break
			end
		end

		if (!self.categoryPanels[v.category] and build) then
			self.categoryPanels[v.category] = {}
		end
	end

	for k, v in SortedPairs(self.categoryPanels) do
		local categoryLabel = self.scroll:Add("ixInfoText")
		categoryLabel:MakeBold()
		categoryLabel:SetText(k)
		categoryLabel:SizeToContents()
		categoryLabel:Dock(TOP)

		local layout = self.scroll:Add("DIconLayout")
		layout:Dock(TOP)
		layout:SetSpaceX(4)
		layout:SetSpaceY(4)
		layout:SetDrawBackground(false)
		layout:SetStretchWidth(true)
		layout:SetStretchHeight(true)
		layout:DockMargin(0, 10, 0, 10)
		layout:StretchToParent(0, 0, 0, 0)
		layout:InvalidateLayout(true)

		v.layout = layout
		self:LoadRecipes(k, self.categoryPanels, self.scroll)
	end
end

function PANEL:LoadRecipes(category, panels, scroll)
	local recipes = PLUGIN.craft.recipes

	scroll:InvalidateLayout(true)

	for uniqueID, recipeTable in SortedPairsByMemberValue(recipes, "name") do
		if (recipeTable:OnCanSee(LocalPlayer()) == false) then
			continue
		end

		if (recipeTable.category == category) then
			panels[category].layout:InvalidateLayout(true)

			local recipeButton = panels[category].layout:Add("ixCraftingRecipe")
			recipeButton:SetRecipe(recipeTable)
			recipeButton:SetSize(64, 64)
			recipeButton:SetHelixTooltip(function(tooltip)
				PLUGIN:PopulateRecipeTooltip(tooltip, recipeTable)
			end)
		end
	end

	panels[category].layout:Layout()
	panels[category].layout:InvalidateLayout()
end

function PANEL:BuildCraftPanel()
	self.topPanel = self.rightDock:Add("DPanel")
	self.topPanel:Dock(TOP)
	self.topPanel:SetTall((ScrW() * 0.5) * 0.3)
	self.topPanel:DockMargin(4,4,4,4)
	
	self.bottomPanel = self.rightDock:Add("DPanel")
	self.bottomPanel:Dock(FILL)
	self.bottomPanel:DockMargin(4,4,4,4)

	self.icon = self.topPanel:Add("SpawnIcon")
	self.icon:SetSize(self:GetWide(), self:GetWide())
	self.icon:Dock(FILL)
	self.icon:DockMargin(5, 5, 5, 5)
	self.icon:InvalidateLayout(true)
	self.icon:SetModel("models/props_junk/PopCan01a.mdl")
end

function PANEL:OnRemove()
	ix.gui.workbenchPanel = nil
	ix.gui.inv1 = nil
end

function PANEL:Paint()
    ix.util.DrawBlur(self, 10)

	surface.SetDrawColor(30, 30, 30, 150)
	surface.DrawRect(0, 0, self:GetWide(), self:GetTall())

	surface.SetDrawColor(Color(100, 170, 220, 80))
	surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
end

function PANEL:SetVisible(visible)
	if(visible) then
		self:AlphaTo(255, 0.5)
	else
		self:AlphaTo(0, 0.5)
	end
end

function PLUGIN:PopulateRecipeTooltip(tooltip, recipe)
	local canCraft, failString, c, d, e, f = recipe:OnCanCraft(LocalPlayer())

	local name = tooltip:AddRow("name")
	name:SetImportant()
	name:SetText(recipe.category..": "..(recipe.GetName and recipe:GetName() or L(recipe.name)))
	name:SetMaxWidth(math.max(name:GetMaxWidth(), ScrW() * 0.5))
	name:SizeToContents()

	if (!canCraft) then
		if (failString:sub(1, 1) == "@") then
			failString = L(failString:sub(2), c, d, e, f)
		end

		local errorRow = tooltip:AddRow("errorRow")
		errorRow:SetText(L(failString))
		errorRow:SetBackgroundColor(Color(255,24,0))
		errorRow:SizeToContents()
	end

	local description = tooltip:AddRow("description")
	description:SetText(recipe.GetDescription and recipe:GetDescription() or L(recipe.description))
	description:SizeToContents()

	if (recipe.tools) then
		local tools = tooltip:AddRow("tools")
		tools:SetText(L("CraftTools"))
		tools:SetBackgroundColor(Color(150,150,25))
		tools:SizeToContents()

		local toolString = ""

		for _, v in pairs(recipe.tools) do
			local itemTable = ix.item.Get(v)
			local itemName = v

			if (itemTable) then
			    itemName = itemTable.name
			end

			toolString = toolString..itemName..", "
		end

		if (toolString != "") then
			local tools = tooltip:AddRow("toolList")
			tools:SetText("- "..string.sub(toolString, 0, #toolString-2))
			tools:SizeToContents()
		end
	end

	local requirements = tooltip:AddRow("requirements")
	requirements:SetText(L("CraftRequirements"))
	requirements:SetBackgroundColor(Color(25,150,150))
	requirements:SizeToContents()

	local requirementString = ""

	for k, v in pairs(recipe.requirements) do
		local itemTable = ix.item.Get(k)
		local itemName = k

		if (itemTable) then
		    itemName = itemTable.name
		end

		requirementString = requirementString..v.."x "..itemName..", "
	end

	if (requirementString != "") then
		local requirement = tooltip:AddRow("ingredientList")
		requirement:SetText("- "..string.sub(requirementString, 0, #requirementString-2))
		requirement:SizeToContents()
	end

	local result = tooltip:AddRow("result")
	result:SetText(L("CraftResults"))
	result:SetBackgroundColor(derma.GetColor("Warning", tooltip))
	result:SizeToContents()

	local resultString = ""

	for k, v in pairs(recipe.results) do
		local itemTable = ix.item.Get(k)
		local itemName = k
		local amount = v

		if (itemTable) then
		    itemName = itemTable.name
		end

		if (type(v) == "table") then
			if (v["min"] and v["max"]) then
				amount = v["min"].."-"..v["max"]
			else
				amount = v[1].."-"..v[#v]
			end
		end

		resultString = resultString..amount.."x "..itemName..", "
	end

	if (resultString != "") then
		local result = tooltip:AddRow("resultList")
		result:SetText("- "..string.sub(resultString, 0, #resultString-2))
		result:SizeToContents()
	end

	if (recipe.PopulateTooltip) then
		recipe:PopulateTooltip(tooltip)
	end
end

vgui.Register("ixWorkbenchPanel", PANEL, "DFrame")

netstream.Hook("ixworkbench", function(data)
	local armory = vgui.Create("ixWorkbenchPanel");
	armory:Populate();
end)