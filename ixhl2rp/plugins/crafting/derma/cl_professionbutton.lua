--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

local PANEL = {};

function PANEL:Init()
    self:SetFont("ixSmallFont")
    self:SetTextColor(Color(225,225,225,255))

    self.drawColor = Color(25, 25, 25, 180)
end

function PANEL:DoClick()
    if(self:IsEnabled()) then
        LocalPlayer():EmitSound(unpack({"buttons/button14.wav", 35, 255}))
    end

    if(ix.gui.crafting) then
        for k, v in pairs(ix.gui.crafting.professionButtons) do
            v.isSelected = false
        end

        self.isSelected = true

        ix.gui.crafting:BuildRecipes(self.profession)
    end
end

function PANEL:SetProfession(profession)
    self.profession = profession
    self:SetText(profession.name)
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
    if(self.isSelected) then
        surface.SetDrawColor(90, 90, 90, 180)
        surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
        
        surface.SetDrawColor(Color(40, 40, 40, 180))

        return
    end

    if(self:IsEnabled()) then
        surface.SetDrawColor(90, 90, 90, 120)
        surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
        
        surface.SetDrawColor(self.drawColor)
    else
        surface.SetDrawColor(Color(25,25,25,80))
    end

    surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
end

vgui.Register("ixProfessionButton", PANEL, "DButton")