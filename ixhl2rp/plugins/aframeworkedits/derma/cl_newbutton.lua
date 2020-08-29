--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PANEL = {}

function PANEL:Init()
    self:SetFont("ixSmallFont")
    self:SetTextColor(Color(225,225,225,255))

    self.drawColor = Color(25, 25, 25, 180)
end

function PANEL:DoClick()
    if(self:IsEnabled()) then
        LocalPlayer():EmitSound(unpack({"buttons/button14.wav", 35, 255}))
    end
end

function PANEL:OnCursorEntered()
    if(self:IsEnabled()) then
        LocalPlayer():EmitSound(unpack({"buttons/button15.wav", 35, 250}))
        self.drawColor = Color(40, 40, 40, 180)
    end
end

function PANEL:OnCursorExited()
    if(self:IsEnabled()) then
        self.drawColor = Color(25, 25, 25, 180)
    end
end

function PANEL:Paint()
    if(self:IsEnabled()) then
        surface.SetDrawColor(90, 90, 90, 120)
        surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
        
        surface.SetDrawColor(self.drawColor)
    else
        surface.SetDrawColor(Color(25,25,25,80))
    end

    surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
end

vgui.Register("ixNewButton", PANEL, "DButton")