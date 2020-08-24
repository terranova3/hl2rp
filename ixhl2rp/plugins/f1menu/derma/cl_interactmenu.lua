--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PANEL = {}

function PANEL:Init()
    if(IsValid(ix.gui.interactMenu)) then
        ix.gui.interactMenu:Destroy()
    end

    ix.gui.interactMenu = self

    self.options = {}
end

function PANEL:Build()
    self:SetWide(128)
    self:SetTall(12)

    local newHeight = self:GetTall()
    
    for k, v in pairs(self.options) do
       newHeight = newHeight+24
    end

    self:SetTall(newHeight)
end

function PANEL:AddOption(k, v)
    local textColor = color_white
    local option = self:Add("DButton")
    option:SetText("")
    option:Dock(TOP)
    option:SetTall(24)
    option.Paint = function() 
        if(option:IsHovered()) then
            surface.SetDrawColor(90, 90, 90, 150)
            surface.DrawRect(0, 0, option:GetWide(), option:GetTall())
        end
    
        ix.util.DrawText(v.name, 24, 4, textColor, 0, 0, "ixSmallFont")
    end
    option.DoClick = function()
        if(v.callback) then
            v.callback()
        end

        self:Destroy()
    end

    if(#self.options < 1) then
        option:DockMargin(6, 6, 6, 0)
    else
        option:DockMargin(6, 0, 6, 0)
    end
    
    if(v.icon) then
        self.icon = option:Add("DImage")
        self.icon:SetSize(12, 12)   
        self.icon:SetPos(4, 6)
        self.icon:SetMaterial(v.icon)
        self.icon.AutoSize = false
    end

    table.insert(self.options, option)
end

function PANEL:Destroy()
    self:Remove()
    ix.gui.interactMenu = nil
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(25, 25, 25, 225)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(90, 90, 90, 255)
    surface.DrawOutlinedRect(0, 0, w, h)
end

vgui.Register("ixInteractMenu", PANEL, "DPanel")