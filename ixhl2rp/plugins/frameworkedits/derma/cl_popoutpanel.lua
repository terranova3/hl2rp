local PANEL = {}

function PANEL:Init()
    self:SetSize(ScrW() / 6, ScrH() / 3)
    self:MakePopup()
    self:Center()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.5)

    self:SetTitle("");
    self:ShowCloseButton( false )
    
    self.header = self:Add("DPanel")
    self.header:SetSize((ScrW() / 6) - 10, 32)
    self.header:SetPos(5, 4)  
    self.header.Paint = function() 
        derma.SkinFunc("DrawImportantBackground", 0, 0, self:GetWide(), self:GetTall(), Color(100, 170, 220, 80))
    end
    
    self.headerLabel = self.header:Add("DLabel")
    self.headerLabel:SetText("This is a test title")
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

    self:Populate()
end

function PANEL:SetHeaderText(text)
    self.headerLabel:SetText(text)
end

function PANEL:Populate()
    self.scroll = self:Add("DScrollPanel")
    self.scroll:Dock(FILL)

    self.infoLabel = self.scroll:Add("ixInfoText")
    self.infoLabel:SetText("No description set.")
    self.infoLabel:Dock(TOP)
    self.infoLabel:DockMargin(0, 0, 0, 4)
    self.infoLabel:SetInfoColor("blue")
end

function PANEL:SetInfoText(text, color)
    self.infoLabel:SetText(text)

    if(color) then
        self.infoLabel:SetInfoColor(color)
    end
end

function PANEL:AddBigButton(text, permitIcon)
    local button = self.scroll:Add("DButton")
    button:Dock(TOP)
    button:SetTall(64)
    button:InvalidateLayout(true)
    button:SetText("")
    button:SetFont("ixPluginCharTraitFont")
    button.PaintOver = function() 
        ix.util.DrawText(text, 48, 24, color_white, 0, 0, "ixPluginTooltipDescFont")
    end

    local icon = button:Add("Material")
    icon:SetSize(32, 32)
    icon:SetPos(8, 16)
    icon:SetMaterial(permitIcon or "materials/terranova/ui/traits/honest.png")
    icon.AutoSize = false

    return button
end

function PANEL:Paint()
    ix.util.DrawBlur(self, 10)

	surface.SetDrawColor(30, 30, 30, 150)
	surface.DrawRect(0, 0, self:GetWide(), self:GetTall())

	surface.SetDrawColor(Color(100, 170, 220, 80))
	surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
end

vgui.Register("ixPopoutPanel", PANEL, "DFrame")