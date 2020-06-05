
local PLUGIN = PLUGIN

local color_green = Color(50,150,100)
local color_red = Color(150, 50, 50)

local PANEL = {}

function PANEL:Init()
	self:Dock(TOP)
	self:SetTall(64)

	self:SetText("")
end

function PANEL:SetRecipe(recipeTable)
	self.recipeTable = recipeTable

	self.icon = self:Add("SpawnIcon")
	self.icon:InvalidateLayout(true)
	self.icon:Dock(LEFT)
	self.icon:DockMargin(0, 0, 8, 0)
	self.icon:SetMouseInputEnabled(false)
	self.icon:SetModel(recipeTable:GetModel(), recipeTable:GetSkin())
	self.icon.PaintOver = function(this) end

	self.name = self:Add("DLabel")
	self.name:Dock(FILL)
	self.name:SetContentAlignment(4)
	self.name:SetTextColor(color_white)
	self.name:SetFont("ixMenuButtonFont")
	self.name:SetExpensiveShadow(1, Color(0, 0, 0, 200))
	self.name:SetText(recipeTable.GetName and recipeTable:GetName() or L(recipeTable.name))

	self:SetBackgroundColor(recipeTable:OnCanCraft(LocalPlayer()) and color_green or color_red)
end

function PANEL:DoClick()
	if (self.recipeTable) then
		net.Start("ixCraftRecipe")
			net.WriteString(self.recipeTable.uniqueID)
		net.SendToServer()
	end
end

function PANEL:PaintBackground(width, height)
	local alpha = self.currentBackgroundAlpha

	derma.SkinFunc("DrawImportantBackground", 0, 0, width, height, ColorAlpha(self.backgroundColor, alpha))
end

vgui.Register("ixCraftingRecipe", PANEL, "ixMenuButton")

PANEL = {}

function PANEL:Init()
	ix.gui.crafting = self

	self:SetSize(self:GetParent():GetSize())

	self.categories = self:Add("DScrollPanel")
	self.categories:Dock(LEFT)
	self.categories:SetWide(260)
	self.categories.Paint = function(this, w, h)
		surface.SetDrawColor(0, 0, 0, 66)
		surface.DrawRect(0, 0, w, h)
	end
	self.categoryPanels = {}

	self.scroll = self:Add("DScrollPanel")
	self.scroll:Dock(FILL)

	self.search = self:Add("ixIconTextEntry")
	self.search:SetEnterAllowed(false)
	self.search:Dock(TOP)

	local leftMargin = self.search:GetDockMargin()
	self.search:DockMargin(leftMargin, 0, 0, 0)

	self.search.OnChange = function(this)
		local text = self.search:GetText():lower()

		if (self.selected) then
			self:LoadRecipes(self.selected.category, text:find("%S") and text or nil)
			self.scroll:InvalidateLayout()
		end
	end

	local first = true

	for k, v in pairs(PLUGIN.craft.recipes) do
		if (v:OnCanSee(LocalPlayer()) == false) then
			continue
		end

		if (!self.categoryPanels[L(v.category)]) then
			self.categoryPanels[L(v.category)] = v.category
		end
	end

	for category, realName in SortedPairs(self.categoryPanels) do
		local button = self.categories:Add("ixMenuButton")
		button:Dock(TOP)
		button:SetText(category)
		button:SizeToContents()
		button.Paint = function(this, w, h)
			surface.SetDrawColor(self.selected == this and ix.config.Get("color") or color_transparent)
			surface.DrawRect(0, 0, w, h)
		end
		button.DoClick = function(this)
			if (self.selected != this) then
				self.selected = this
				self:LoadRecipes(realName)
				timer.Simple(0.01, function()
					self.scroll:InvalidateLayout()
				end)
			end
		end
		button.category = realName

		if (first) then
			self.selected = button
			first = false
		end

		self.categoryPanels[realName] = button
	end

	if (self.selected) then
		self:LoadRecipes(self.selected.category)
	end
end

function PANEL:LoadRecipes(category, search)
	category = category	or "Crafting"
	local recipes = PLUGIN.craft.recipes

	self.scroll:Clear()
	self.scroll:InvalidateLayout(true)

	for uniqueID, recipeTable in SortedPairsByMemberValue(recipes, "name") do
		if (recipeTable:OnCanSee(LocalPlayer()) == false) then
			continue
		end

		if (recipeTable.category == category) then
			if (search and search != "" and !L(recipeTable.name):lower():find(search, 1, true)) then
				continue
			end

			local recipeButton = self.scroll:Add("ixCraftingRecipe")
			recipeButton:SetRecipe(recipeTable)
			recipeButton:SetHelixTooltip(function(tooltip)
				PLUGIN:PopulateRecipeTooltip(tooltip, recipeTable)
			end)
		end
	end
end

vgui.Register("ixCrafting", PANEL, "EditablePanel")

hook.Add("CreateMenuButtons", "ixCrafting", function(tabs)
	if (hook.Run("BuildCraftingMenu") != false) then
		tabs["inv"] = {
			bDefault = true,
			Create = function(info, container)
				local inventoryPanel = container:Add("DPanel");
				inventoryPanel.Paint = function() end;
				inventoryPanel:SetSize(container:GetWide() / 3, container:GetTall());
				inventoryPanel:Dock(LEFT)
	
				local characterPanel = container:Add("DPanel")
				characterPanel.Paint = function() end;
				characterPanel:SetSize(container:GetWide() / 2, container:GetTall());
				characterPanel:Dock(FILL)	

				netstream.Start("CharacterPanelUpdate")
				netstream.Hook("ShowCharacterPanel", function(show)
					if(IsValid(ix.gui.charPanel)) then
						ix.gui.charPanel:Remove()
					end
					
					if(show) then 
						local cPanel = characterPanel:Add("ixCharacterPane")
						local charPanel = LocalPlayer():GetCharacter():GetCharPanel()
	
						if (charPanel) then
							cPanel:SetCharPanel(charPanel)
						end
	
						ix.gui.charPanel = cPanel
					end
				end)
	
				local canvas = inventoryPanel:Add("DTileLayout")

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

				if (ix.option.Get("openBags", true)) then
					for _, v in pairs(inventory:GetItems()) do
						if (!v.isBag) then
							continue
						end

						v.functions.View.OnClick(v)
					end
				end

				canvas.PerformLayout = canvasLayout
				canvas:Layout()
			end,
			Sections = {
				crafting = {
					Create = function(info, container)
						ix.gui.craftingMenu = container:Add("ixCrafting")
					end,
				}
			}
		}	
	end
end)

net.Receive("ixCraftRefresh", function()
	local craftPanel = ix.gui.crafting

	if (IsValid(craftPanel)) then
		craftPanel.search:OnChange()
	end
end)
