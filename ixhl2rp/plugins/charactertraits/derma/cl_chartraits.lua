--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN

PANEL = {}

function PANEL:Init()
    self:SetBackgroundBlur(true);
	self:Center()
    self:MakePopup()
	self:SetAlpha(0)
	self:DrawHeader()
    self:ShowCloseButton(false)
end

function PANEL:DrawHeader()
    self.header = self:Add("DPanel")
    self.header:SetSize((ScrW() * 0.25) - 10, 32)
    self.header:SetPos(5, 4)  
    self.header.Paint = function() 
        derma.SkinFunc("DrawImportantBackground", 0, 0, self:GetWide(), self:GetTall(), Color(100, 170, 220, 80))
    end

    self.headerLabel = self.header:Add("DLabel")
    self.headerLabel:SetText("Property creation")
    self.headerLabel:SetFont("ixMediumFont")
    self.headerLabel:SetExpensiveShadow(3)
    self.headerLabel:Dock(FILL)

    self.exitButton = self.header:Add("DButton")
    self.exitButton:SetText("X")
    self.exitButton:SetWide(32)
    self.exitButton:Dock(RIGHT)
    self.exitButton:SetFont("ixSmallFont")
    self.exitButton.Paint = function()
    end
    self.exitButton.DoClick = function()
        self:Remove()
    end

    self.fakeSpacer = self:Add("DPanel")
    self.fakeSpacer:Dock(TOP)
    self.fakeSpacer:SetTall(10)
    self.fakeSpacer.Paint = function() end
end

-- Called each frame.
function PANEL:Think()
	local scrW = ScrW();
	local scrH = ScrH();

	self:SetSize(scrW * 0.25, scrH * 0.5)
	self:SetPos( (scrW / 2) - (self:GetWide() / 2), (scrH / 2) - (self:GetTall() / 2) );
end;

function PANEL:Build(target)
    self.target = target
	self:SetVisible(true)
end

function PANEL:OnRemove()
	self:Save()
end

function PANEL:AddLabel(text, colored, subtitle)
    local label = self:Add("DLabel")
    local font = "ixInfoPanelFont"

    if(subtitle) then
        font = "ixPluginCharTraitFont"
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

function PANEL:Paint()
    ix.util.DrawBlur(self, 10)

	surface.SetDrawColor(30, 30, 30, 150)
	surface.DrawRect(0, 0, self:GetWide(), self:GetTall())

	surface.SetDrawColor(Color(100, 170, 220, 80))
	surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
end

function PANEL:SetVisible(visible)
	if(visible) then
		self:AlphaTo(255, 0.5)
	else
		self:AlphaTo(0, 0.5)
	end
end

vgui.Register("ixCharTraits", PANEL, "DFrame")