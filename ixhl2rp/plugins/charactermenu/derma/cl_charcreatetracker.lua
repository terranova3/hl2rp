--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PANEL = {}

function PANEL:Init()
    ix.gui.charCreateTracker = self

    self.panels = {}
    self.index = 1

    self:Dock(TOP)
    self:SetTall(256)
    self.Paint = function() end

    self.content = self:Add("DPanel")
    self.content:SetTall(128)
    self.content:Dock(TOP)
    self.content:SetContentAlignment(5)

    for i = 1, 5 do
        local stepText = self.content:Add("DLabel")

        if(i == 3) then
            stepText:SetFont("ixPluginCharTitleFont")
            stepText:SetColor(Color(203,203,204))
        elseif(i == 5 or i == 1) then
            stepText:SetFont("ixPluginCharDescMiniFont")
            stepText:SetColor(Color(39, 39, 39))
        else
            stepText:SetFont("ixPluginCharDescFont")
            stepText:SetColor(Color(69, 68, 68))
        end

        stepText:Dock(LEFT)
        stepText:SetWide(ScrW() / 5)
        stepText:SetContentAlignment(5)
        stepText:SetText("")

        table.insert(self.panels, stepText)
    end
end

-- Called whenever the panel needs to rethink to accomodate a character create change.
function PANEL:Build()
    local data = {}
    local strings = {}

    -- Validates the steps and only shows the steps that a player can access.
    for k, v in pairs(ix.gui.charCreate.steps) do
        if(v.stepName and self:Validate(v.stepName)) then
            table.insert(data, v.stepName)
        end
    end

    -- Displacing the strings relative to our index
    for i = self.index-2, self.index+2 do
        table.insert(strings, data[i] or "")
    end

    -- Change our old strings to the new displaced ones.
    for i = 1, 5 do
        self.panels[i]:SetText(strings[i])
    end
end

-- Updates the tracker panel, shifting it to the right one index and then rebuilding.
function PANEL:MoveRight()
    if(self.panels[self.index+1]) then
        self.index = self.index + 1
    end

    if(self.panels) then 
        self:Build()
    end
end

-- Updates the tracker panel, shifting it to the left one index and then rebuilding.
function PANEL:MoveLeft()
    if(self.panels[self.index-1]) then 
        self.index = self.index - 1
    end

    if(self.panels) then 
        self:Build()
    end
end

-- Returns the set character variable corresponding to key. If it does not
-- exist, then default (which is nil if not set) is returned.
function PANEL:GetPayload(key, default)
	if (key == nil) then
		return ix.gui.charCreate.payload
	end
	local value = ix.gui.charCreate.payload[key]
	if (value == nil) then
		return default
	end
	return value
end

function PANEL:Validate(name)
    if(name == "Customization") then
        local skins = ix.gui.charCreate.model.Entity:SkinCount()

        if(skins < 2) then
            return false
        end
    elseif(name == "CP Setup") then
        local faction = ix.faction.indices[self:GetPayload("faction")].name
        
        if(faction != "Metropolice Force") then
            return false
        end
    end

    return true
end

vgui.Register("ixCharCreateTracker", PANEL, "DPanel")
