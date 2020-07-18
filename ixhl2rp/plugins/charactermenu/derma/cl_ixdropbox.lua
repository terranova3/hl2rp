--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PANEL = {}

function PANEL:Init()
    self.listItems = {}
end

function PANEL:DoClick()
    local parent = self
    
    if(parent.listItems[1]) then 
        parent:BuildList()
    end
end

function PANEL:BuildList()
    local list = vgui.Create("DFrame")
    list:SetPos(self:GetPos())
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(25, 25, 25, 225)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(90, 90, 90, 255)
    surface.DrawOutlinedRect(0, 0, w, h)
end

vgui.Register("ixDropbox", PANEL, "DButton")