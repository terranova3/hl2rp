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
    self.header:SetSize((ScrW() * 0.5) - 10, 32)
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

function PANEL:Populate()
    self.infoLabel = self:Add("ixInfoText")
    self.infoLabel:SetText("No description set.")
    self.infoLabel:Dock(TOP)
    self.infoLabel:SetInfoColor("blue")

    self.finishButton = self:Add("DButton")
    self.finishButton:Dock(BOTTOM)
    self.finishButton:SetFont("ixSmallFont")
    self.finishButton:SetText("Finish")
    self.finishButton.DoClick = function()
        self:Remove()
    end

    ix.gui.viewdata:SetVisible(false)
end

function PANEL:SetInfoText()
    self.infoLabel:SetText(text)

    if(color) then
        self.infoLabel:SetInfoColor(color)
    end
end

function PANEL:OnRemove()
    ix.gui.viewdata:SetVisible(true)
end

function PANEL:Paint()
    ix.util.DrawBlur(self, 10)

	surface.SetDrawColor(30, 30, 30, 150)
	surface.DrawRect(0, 0, self:GetWide(), self:GetTall())

	surface.SetDrawColor(Color(100, 170, 220, 80))
	surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
end

vgui.Register("ixPopoutPanel", PANEL, "DFrame")