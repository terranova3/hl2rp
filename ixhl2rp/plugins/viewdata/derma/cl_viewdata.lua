--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN
local PANEL = {}

-- Called when the panel is first initialized.
function PANEL:Init()
    if(IsValid(ix.gui.menu)) then
		ix.gui.menu:Remove()
	end

    self:SetBackgroundBlur(true);
    self:Center()
    self:MakePopup()
    self:SetTitle("")
    self:SetAlpha(0)

    self.content = self:AddStage("Home")
    self.record = self:AddStage("Record")
    self.note = self:AddStage("Note")
    self.unitrecord = self:AddStage("UnitRecord")
    self.vars = self:AddStage("EditData")

    self:SetStage("Home")
end

function PANEL:Paint() 
    surface.SetMaterial(ix.util.GetMaterial("materials/terranova/ui/viewdata/background.png"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(0, 0, 512, 512)

    surface.SetMaterial(ix.util.GetMaterial("materials/terranova/ui/viewdata/combineoverlay.png"))
    surface.SetDrawColor(255, 255, 255, 150)
    surface.DrawTexturedRect(0, 0, 512, 512)
end

-- Called each frame of the panel being open.
function PANEL:Think()
	local scrW = ScrW()
	local scrH = ScrH()

	self:SetSize(512, 512)
	self:SetPos((scrW / 2) - (self:GetWide() / 2), (scrH / 2) - (self:GetTall() / 2))
end

function PANEL:AddStage(text)
    local panel = self:Add("DPanel")
    panel:Dock(FILL)
    panel:DockMargin(16,0,16,16)
    panel:SetVisible(false)

    if(!self.stages) then
        self.stages = {}
    end

    self.stages[text] = panel

    return panel
end

function PANEL:SetStage(text)
    if(!self.stages[text]) then
        return
    end

    for k, v in pairs(self.stages) do
        if(k != text) then
            v:SetVisible(false)
        else
            v:SetVisible(true)
        end
    end
end

-- Called when the panel is receiving data and will start to build.
function PANEL:Build(charID)
    self.character = ix.char.loaded[charID]
    self.target = self.character:GetPlayer()

    self:AlphaTo(255, 0.5)
    self.content:Add(self:BuildLabel("Civil Protection Datapad", true))

    self:BuildCID()
    self:BuildButtons()
end

function PANEL:BuildCID()
    self.cid = self.content:Add("DPanel")
    self.cid:Dock(TOP)
    self.cid:DockMargin(0,8,0,8)
    self.cid:SetTall(196)
    self.cid:SetDrawBackground(false)

    self.modelBackground = self.cid:Add("DPanel")
    self.modelBackground:Dock(LEFT)
    self.modelBackground:SetSize(180,180)
    self.modelBackground:DockMargin(16,16,16,16)
    
    function self.modelBackground:Paint(w, h)
        surface.SetDrawColor(25, 25, 25, 225)
        surface.DrawRect(0, 0, w, h)
    
        surface.SetMaterial(ix.util.GetMaterial("materials/terranova/ui/viewdata/datamugshot.png"))
        surface.SetDrawColor(255, 255, 255, 225)
        surface.DrawTexturedRect(0, 0, w, h)
    
        surface.SetDrawColor(90, 90, 90, 255)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    self.model = self.modelBackground:Add(self:DrawCharacter())

    self.rightDock = self.cid:Add("DPanel")
    self.rightDock:Dock(FILL)
    self.rightDock:DockMargin(8,16,16,16)
    self.rightDock:SetDrawBackground(false)

    self.name = self.rightDock:Add(self:BuildLabel("Citizen Name: " .. self.character:GetName(), false, 4))
    self.cid = self.rightDock:Add(self:BuildLabel("Citizen ID: #" .. self.character:GetData("cid"), false, 4))
    self.points = self.rightDock:Add(self:BuildLabel("Total Points: " ..  "seven", false, 4))
end

function PANEL:BuildButtons()
    self.buttonLayout = self.content:Add("DIconLayout")
    self.buttonLayout:Dock(FILL)
    self.buttonLayout:DockMargin(0, 4, 0, 4)
    self.buttonLayout:SetSpaceX(4)
    self.buttonLayout:SetSpaceY(4)
    self.buttonLayout:SetStretchWidth(true)
    self.buttonLayout:SetStretchHeight(true)
    self.buttonLayout:InvalidateLayout(true)

    self.buttonLayout:Add(self:AddStageButton("View Record", "Record", "ixCombineViewDataRecord"))
    self.buttonLayout:Add(self:AddStageButton("View Note", "Note", "ixCombineViewDataRecord"))
    self.buttonLayout:Add(self:AddStageButton("View Unit Record", "UnitRecord", "ixCombineViewDataRecord"))
    self.buttonLayout:Add(self:AddStageButton("Edit Data", "EditData", "ixCombineViewDataRecord"))
end

function PANEL:DrawCharacter()
    local model = vgui.Create("DModelPanel")
    model:Dock(FILL)
    model:DockMargin(2,2,2,2)
    model:SetModel(self.target:GetModel())

    function model:LayoutEntity( Entity ) return end

    local eyepos =  model.Entity:GetBonePosition(model.Entity:LookupBone("ValveBiped.Bip01_Head1"))
    eyepos:Add(Vector(0, 0, 2))	-- Move up slightly
    model:SetLookAt(eyepos)
    model:SetCamPos(eyepos-Vector(-12, 4, 0))	-- Move cam in front of eyes
    model.Entity:SetEyeTarget(eyepos-Vector(-12, 0, 0))

    return model
end

function PANEL:BuildLabel(text, title, align, overrideFont)
    local label = self:Add("DLabel")
    local font = "ixSmallFont"

    if(title) then
        font = "ixBigFont"
    end

    font = overrideFont or font

	label:SetContentAlignment(align or 5)
	label:SetFont(font)
	label:SetText(text)
	label:Dock(TOP)
	label:SizeToContents()
    label:SetExpensiveShadow(3)

	return label
end

function PANEL:AddStageButton(name, parent, elementName)
    local this = self
    local button = vgui.Create("DButton")
    button:SetSize(233, 108)
    button:SetText(name)
    button:SetFont("ixSmallFont")
    
    function button.DoClick()
        this:SetStage(parent)
        self.stages[parent]:Add(elementName)
    end

    return button
end

vgui.Register("ixCombineViewData", PANEL, "DFrame")