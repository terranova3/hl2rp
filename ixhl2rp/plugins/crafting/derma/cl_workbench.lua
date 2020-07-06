--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

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
    self.headerLabel:SetText("Station")
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
	self:BuildRecipes()
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

	ix.gui.craftingInv = panel

	self.leftDock:SetActivePanel("inventory");
end

function PANEL:BuildRecipes()
	self.leftDock.recipes = self.leftDock:AddStagePanel("recipes")

	self.recipeButton = self.topDock:Add(self.leftDock:AddStageButton("Recipes", "recipes"))
	self.recipeButton:SetSize(150, self:GetTall())
end

function PANEL:BuildCraftPanel()

end

function PANEL:OnRemove()
	ix.gui.workbenchPanel = nil
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

vgui.Register("ixWorkbenchPanel", PANEL, "DFrame")

netstream.Hook("ixworkbench", function(data)
	local armory = vgui.Create("ixWorkbenchPanel");
	armory:Populate();
end)