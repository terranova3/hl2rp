local PLUGIN = PLUGIN
--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local color_green = Color(50,150,100)
local color_red = Color(150, 50, 50)

local PANEL = {}

function PANEL:Init()
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

	--self:SetBackgroundColor(recipeTable:OnCanCraft(LocalPlayer()) and color_green or color_red)
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

vgui.Register("ixCraftingRecipe", PANEL, "DButton")