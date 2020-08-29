--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PANEL = {}

function PANEL:Init()
    self.stagePanels = {}
end

function PANEL:AddStagePanel(name, dType)
	local id = #self.stagePanels + 1;

	local panel = self:Add(dType or "DPanel");
	panel:Dock(FILL);
    panel:SetVisible(false);
    panel:DockMargin(4,4,4,4)
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

function PANEL:AddLabel(text, colored, title)
    local label = self:Add("DLabel")
    local font = "ixInfoPanelFont"

    if(title) then
        font = "ixInfoPanelTitleFont"
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

function PANEL:AddTextEntry(payloadName)
	local entry = self:Add("DTextEntry")
	entry:Dock(TOP)
	entry:SetFont("ixPluginCharButtonFont")
	entry.Paint = self.PaintTextEntry
	entry:DockMargin(0, 4, 0, 16)
	entry.OnValueChange = function(_, value)
	end
	entry.payloadName = payloadName
	entry.OnKeyCodeTyped = function(name, keyCode)
		if (keyCode == KEY_TAB) then
			entry:onTabPressed()
			return true
		end
	end
	entry:SetUpdateOnType(true)
	return entry
end

-- self refers to the text entry
function PANEL:PaintTextEntry(w, h)
	surface.SetDrawColor(0, 0, 0, 100)
	surface.DrawRect(0, 0, w, h)
	self:DrawTextEntryText(color_white, HIGHLIGHT, HIGHLIGHT)
end

vgui.Register("ixStagePanel", PANEL, "DPanel")