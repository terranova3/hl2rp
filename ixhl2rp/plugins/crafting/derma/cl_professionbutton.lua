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
    local professionButtons = self.otherButtons or ix.gui.crafting.professionButtons

    if(self:IsEnabled()) then
        LocalPlayer():EmitSound(unpack({"buttons/button14.wav", 35, 255}))
    end

    for k, v in pairs(professionButtons) do
        if(v != self) then
            v.isSelected = false
            v:HideHeader()
        end
    end

    self.isSelected = true
        if(IsValid(ix.gui.crafting)) then
        ix.gui.crafting:BuildRecipes(self.profession)
    end

    if(self.profession) then
        ix.gui.selectedProfession = self.profession
    end

    if(self.PostClick) then
        self:PostClick()
    end
end

-- Called when we need to attach a 'profession' object onto this derma.
function PANEL:SetProfession(profession)
    self.profession = profession

    if(!self.profession.image) then
        self:SetText(profession.name)
    else
        self:SetText("")
    end
    
    local professionText = profession.name

    if(LocalPlayer():GetCharacter():GetMastery() == profession.uniqueID) then
        professionText = professionText .. " (Mastered)"
    end

    self.header = self:Add("DButton")
	self.header:SetTall(30)
	self.header:SetFont("ixPluginCharSubTitleFont")
	self.header:SetText(professionText)
	self.header:SetWide(self.actualWidth)
	self.header.Paint = function(header, w, h)
		surface.SetDrawColor(profession:GetColor())
		surface.DrawRect(0, 0, w, h)
	end
    self.header:SetPos(0, -self.header:GetTall())
    
    -- Loading the selected category before panel close.
    if(ix.gui.selectedProfession == self.profession) then
        self.isSelected = true
        self:ShowHeader()  
        ix.gui.crafting:BuildRecipes(self.profession)
    end
end

function PANEL:GetProfession()
    if(self.profession) then
        return self.profession
    end

    return nil
end

-- Called when a player's cursor has entered the button.
function PANEL:OnCursorEntered()
    if(self:IsEnabled()) then
        LocalPlayer():EmitSound(unpack({"buttons/button15.wav", 35, 250}))
        self.drawColor = Color(40, 40, 40, 180)
        self:ShowHeader()
    end
end

-- Called when a player's cursor has exited the button.
function PANEL:OnCursorExited()
    if(self:IsEnabled()) then
        self.drawColor = Color(25, 25, 25, 180)
    end

    if(!self.isSelected) then
        self:HideHeader()
    end
end

-- Called when the header needs to be hidden.
function PANEL:HideHeader()
    if(IsValid(self.header)) then
        self.header:MoveTo(0, -self.header:GetTall(), 0.25)
    end
end

-- Called when the header must be shown.
function PANEL:ShowHeader()
    if(IsValid(self.header)) then
        self.header:MoveTo(0, 0, 0.25)
    end
end

-- Called every frame
function PANEL:Paint()
    if(self.profession and self.profession.image) then
        surface.SetMaterial(ix.util.GetMaterial("materials/" .. self.profession.image))
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(0, 0, self:GetWide(), self:GetTall())
    end

    if(self.isSelected and self.profession.color) then
        surface.SetDrawColor(self.profession:GetColor())
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