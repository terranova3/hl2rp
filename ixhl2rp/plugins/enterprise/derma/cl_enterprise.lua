--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	if (IsValid(ix.gui.enterprise)) then
		ix.gui.enterprise:Remove()
	end

	self:SetWide(800);
	self:SetTall(400);
	self:Dock(LEFT);
	self.nextThink = 0
    self.maxWidth = ScrW() * 0.2

	ix.gui.enterprise = self;
	ix.gui.enterprise:Rebuild();
end;

-- A function to rebuild the panel.
function PANEL:Rebuild()
    self:Clear()

    local button = self:Add("DButton")
    button:Dock(LEFT)
    button:SetText("Leave enterprise")
end;

-- Called when the panel is painted.
function PANEL:Paint(w, h)
    surface.SetDrawColor(80, 80, 80, 80);	
end;

function PANEL:Think()
	self:InvalidateLayout(true);
end

function PANEL:AddLabel(text, colored, title)
    local label = self:Add("DLabel")
    local font = "ixInfoPanelFont"

    if(title) then
        font = "ixInfoPanelTitleFont"
        text = L(text):upper()
    end

    if(colored) then
        label:SetTextColor(ix.config.Get("color"))
    end

	label:SetFont(font)
	label:SetText(text)
	label:SizeToContents()
    label:Dock(TOP)
	label:DockMargin(4, 4, 4, 4)
	
	return label
end

vgui.Register("ixEnterprise", PANEL, "EditablePanel")

hook.Add("CreateMenuButtons", "ixEnterprise", function(tabs)
	tabs["enterprise"] = {
		Create = function(info, container)
			local panel = container:Add("ixEnterprise")	
		end,
		OnSelected = function(info, container)
			if(ix.gui.enterprise) then
				ix.gui.enterprise:Rebuild()
			end
		end
	}
end)