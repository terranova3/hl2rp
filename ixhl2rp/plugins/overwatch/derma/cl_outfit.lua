--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PANEL = {}
local PLUGIN = PLUGIN

function PANEL:Init()
    local parent = self
    
    self.updateButton = self:Add("ixNewButton")
    self.updateButton:Dock(BOTTOM)
    self.updateButton:SetTall(64)
    self.updateButton:DockMargin(2,2,2,2)
    self.updateButton:SetText("Update Model")

    self.character = LocalPlayer():GetCharacter()

    self:Dock(FILL)
    
    self.modelDock = self:Add("DPanel")
    self.modelDock:Dock(FILL)
    self.modelDock:DockMargin(2,2,2,2)

    function self.modelDock:Paint()
        surface.SetDrawColor(30, 30, 30, 150)
        surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
    
        surface.SetDrawColor(Color(100, 170, 220, 80))
        surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
    end

    self.model = self.modelDock:Add("ixModelPanel")
    self.model:Dock(FILL)
    self.model:SetFOV(55)

    self.buttonDock = self:Add("DScrollPanel")
    self.buttonDock:Dock(LEFT)
    self.buttonDock:SetWide(512)
    self.buttonDock:DockMargin(2,2,2,2)

    local buttons = {}
    
    for k, v in ipairs(PLUGIN.config.otaTypes) do
        local button = self.buttonDock:Add("ixNewButton")
        button.model = v.model
        button.arrayIndex = k
        button:Dock(TOP)
        button:SetHeight(64)
        button:DockMargin(2,2,2,2)
        button.selected = false
        button:SetText(v.name)
        button:SetHelixTooltip(function(tooltip)
            local name = tooltip:AddRow("description")
            name:SetText(v.name)
            name:SetImportant()
            name:SetFont("ixMediumFont")
            name:SizeToContents()

            local description = tooltip:AddRow("description")
            description:SetText(v.description)
            description:SetFont("ixPluginTooltipDescFont")
            description:SizeToContents()

            if(v.voiceType) then
                local division = tooltip:AddRow("description")
                division:SetText(string.format("\nThis will set your voice type to '%s'.", v.voiceType))
                division:SetFont("ixPluginTooltipDescFont")
                division:SizeToContents()
            end
        end)

        function button:DoClick()    
            for k, v in pairs(buttons) do
                v.selected = false
            end

            parent.arrayIndex = self.arrayIndex
            parent.model:SetModel(self.model)

            self.selected = true
        end

        function button:PaintOver()
            if(self.selected) then
                surface.SetDrawColor(255, 255, 255, 25)
                surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
            end
        end

        table.insert(buttons, button)
    end
    
    function self.updateButton:DoClick()        
        if(parent.arrayIndex) then
            net.Start("ixUpdateOverwatchModel")
                net.WriteInt(parent.arrayIndex, 8)
            net.SendToServer()
        end

        if(IsValid(ix.gui.menu)) then
            ix.gui.menu:Remove()
        end
    end
end

function PANEL:Paint()
	surface.SetDrawColor(30, 30, 30, 150)
	surface.DrawRect(0, 0, self:GetWide(), self:GetTall())

	surface.SetDrawColor(Color(100, 170, 220, 80))
	surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
end

-- Basically a fix to remove the janky model staying on the screen when the menu is closing
function PANEL:Think()
    if(ix.gui.menu and ix.gui.menu.bClosing) then
        self.model:Remove()
    end
end

vgui.Register("ixOutfitMenu", PANEL, "DPanel")

-- Called when all of the tabs are being created.
hook.Add("CreateMenuButtons", "ixOutfitMenu", function(tabs)
    if(LocalPlayer():GetCharacter():GetFaction() == FACTION_OTA) then
        tabs["outfit"] = {
            Create = function(info, container)				
                ix.gui.outfitMenu = container:Add("ixOutfitMenu")
            end,
        }	
    end
end)