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

	self:InvalidateParent(true)

	local width = self:GetWide() - 58
	local count = table.Count(ix.profession.GetDisplayable())

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

function PANEL:BuildRecipes(profession)
	if(self.scroll and IsValid(self.scroll)) then
		self.scroll:Remove()
	end

	PrintTable(profession)

	self.scroll = self:Add("DScrollPanel")
	self.scroll:Dock(FILL)
end

function PANEL:Paint()
	surface.SetDrawColor(30, 30, 30, 150)
	surface.DrawRect(0, 0, self:GetWide(), self:GetTall())

	surface.SetDrawColor(Color(100, 170, 220, 80))
	surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
end

vgui.Register("ixCraftingPanel", PANEL, "ixStagePanel")