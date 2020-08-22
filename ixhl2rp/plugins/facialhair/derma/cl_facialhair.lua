--[[
	© 2021 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

local PANEL = {}
local PLUGIN = PLUGIN

function PANEL:Init()
    local parent = self
    self.character = LocalPlayer():GetCharacter()
    self.group = 0

	self:SetSize(600, 400)
	self:Center()
	self:SetTitle("")
	self:MakePopup()
	self:SetBackgroundBlur(true)
    
    self.leftDock = self:Add("DPanel")
    self.leftDock:Dock(LEFT)
    self.leftDock:SetWide(256)

    self.model = self.leftDock:Add("ixModelPanel")
    self.model:Dock(FILL)
    self.model:SetModel(LocalPlayer():GetModel())
    self.model.Entity:SetSkin(self.character:GetData("skin", 0))

    for k, v in pairs(self.character:GetData("groups", {})) do
        self.model.Entity:SetBodygroup(k, v)
    end

    function self.model:LayoutEntity( Entity ) return end

    local eyepos =  self.model.Entity:GetBonePosition(self.model.Entity:LookupBone("ValveBiped.Bip01_Head1"))
    eyepos:Add(Vector(0, 0, 2))	-- Move up slightly
    self.model:SetLookAt(eyepos)
    self.model:SetCamPos(eyepos-Vector(-12, 4, 0))	-- Move cam in front of eyes
    self.model.Entity:SetEyeTarget(eyepos-Vector(-12, 0, 0))

    self.rightDock = self:Add("DScrollPanel")
    self.rightDock:Dock(FILL)

    local buttons = {}

    for k, v in pairs(PLUGIN.facialHair) do
        local button = self.rightDock:Add("ixNewButton")
        button.group = (k-1) or 0
        button:Dock(TOP)
        button:SetHeight(64)
        button:DockMargin(2,2,2,2)
        button.selected = false
        button:SetText(v.name)
        --[[
        button:SetHelixTooltip(function(tooltip)
            local name = tooltip:AddRow("description")
            name:SetText(v.name)
            name:SetFont("ixPluginTooltipDescFont")
            name:SizeToContents()

            local description = tooltip:AddRow("description")
            description:SetText(v.description)
            description:SetFont("ixPluginTooltipDescFont")
            description:SizeToContents()
        end)--]]

        function button:DoClick()
            parent.model.Entity:SetBodygroup(LocalPlayer():FindBodygroupByName("facialhair"), self.group)
            
            for k, v in pairs(buttons) do
                v.selected = false
            end

            parent.group = self.group
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
end

function PANEL:Remove()
    net.Start("ixUpdateFacialHair")
        net.WriteInt(self.group or 0, 16)
    net.SendToServer()
end

vgui.Register("ixFacialHair", PANEL, "DFrame")

netstream.Hook("ixFacialHair", function()
    if(IsValid(ix.gui.menu)) then
        ix.gui.menu:Remove()
    end

    vgui.Create("ixFacialHair")
end)