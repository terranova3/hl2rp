--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
    self:SetPadding(4);
    self:SetLabel("");
    self:Dock(TOP)
end

-- Called every frame.
function PANEL:Think()
    if(!self:GetExpanded()) then
        self.Header:SetSize(30, 30)
    else
        self.Header:SetSize(20, 20)
    end
end

-- Called when we need to set the title of this category
function PANEL:SetTitle(title)
    self.title = title
end

-- Called every frame
function PANEL:Paint(w, h)
    local outlineColor = nil

	if(ix.gui.selectedProfession) then
		outlineColor = ix.gui.selectedProfession:GetColor()
    end
    
    derma.SkinFunc("PaintCategoryPanel", self, "", outlineColor)
    surface.SetDrawColor(0, 0, 0, 50);	
    surface.DrawRect(0, 0, w, h)

    surface.SetTextColor(Color(255,255,255,255))
    surface.SetTextPos(4, 4)
    surface.DrawText(self.title or "")
end;

vgui.Register("ixCraftingCategory", PANEL, "DCollapsibleCategory")