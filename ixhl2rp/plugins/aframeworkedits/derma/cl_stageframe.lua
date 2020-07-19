--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PANEL = {}

function PANEL:Init()
    self.stagePanels = {}
    self.drawHeader = true
    
    self:SetTitle("");
    self:ShowCloseButton( false )
end

function PANEL:DrawHeader()
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
end

function PANEL:AddStagePanel(name, dType)
	local id = #self.stagePanels + 1;

	local panel = self:Add(dType or "DPanel");
	panel:Dock(FILL);
	panel:SetVisible(false);
	panel.OnSetActive = function() end

	self.stagePanels[id] = {}
	self.stagePanels[id].panel = panel;
	self.stagePanels[id].subpanelName = name;

	return panel;
end;

function PANEL:SetActivePanel(name)
    for i = 1, #self.stagePanels do
        local selectedPanel = self.stagePanels[i].subpanelName == name

        if(self.stagePanels[i].button) then
            self.stagePanels[i].button:Rebuild(selectedPanel)
        end

		if(selectedPanel) then
			self.stagePanels[i].panel:SetVisible(true);
            self.stagePanels[i].panel:OnSetActive();
		else
            self.stagePanels[i].panel:SetVisible(false);
        end;
	end;
end;

function PANEL:AddStageButton(text, stage)
    local index = 0

    for i = 1, #self.stagePanels do
        if(self.stagePanels[i].subpanelName == stage) then
            index = i    
            break
        end
    end

    if(index != 0) then
        local button = self:Add("DButton")
        button:Dock(LEFT)
        button:SetFont("ixSmallFont")
        button:SetText(text)
        button:SetVisible(true)
		button.DoClick = function()
            self:SetActivePanel(stage);
        end;

        function button:Rebuild(selected)
            if(selected) then
                button.PaintOver = function()
                    surface.SetDrawColor(button.selectedColor or Color(100, 170, 220, 80))
                    surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
                end
            else
                button.PaintOver = nil
            end
        end
        
        self.stagePanels[index].button = button

        return button
    end

    Error("Error creating stage button because the stage doesn't exist.")
    return nil
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

vgui.Register("ixStageFrame", PANEL, "DFrame")