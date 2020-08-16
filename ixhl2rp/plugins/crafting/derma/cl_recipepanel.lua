--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

local PANEL = {};

-- Called when this derma is first created.
function PANEL:Init()
    self:SetFont("ixSmallFont")
    self:SetTextColor(Color(225,225,225,255))

    self.drawColor = Color(25, 25, 25, 180)
end

-- Called when the button is clicked.
function PANEL:DoClick()
    if(self:IsEnabled()) then
        LocalPlayer():EmitSound(unpack({"buttons/button14.wav", 35, 255}))
    end
end

-- Called when we need to attach a 'recipe' object onto this derma.
function PANEL:SetRecipe(recipe)
    self.profession = recipe
    self:SetText(recipe.name)
end

-- Called when a player's cursor has entered the button.
function PANEL:OnCursorEntered()
    if(self:IsEnabled()) then
        LocalPlayer():EmitSound(unpack({"buttons/button15.wav", 35, 250}))
        self.drawColor = Color(40, 40, 40, 180)
    end
end

-- Called when a player's cursor has exited the button.
function PANEL:OnCursorExited()
    if(self:IsEnabled()) then
        self.drawColor = Color(25, 25, 25, 180)
    end
end

-- Called every frame
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

vgui.Register("ixRecipePanel", PANEL, "DButton")