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

	self.character = LocalPlayer():GetCharacter()
	self:Dock(FILL);
	self:DockPadding(4 ,4, 4, 4)

	self:AddLabel("Crafting", true, true)
	self:AddLabel("Chemical Mastery")
end;

function PANEL:Paint()
	surface.SetDrawColor(30, 30, 30, 150)
	surface.DrawRect(0, 0, self:GetWide(), self:GetTall())

	surface.SetDrawColor(Color(100, 170, 220, 80))
	surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
end

vgui.Register("ixCraftingPanel", PANEL, "ixStagePanel")