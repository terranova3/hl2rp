--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN
local HIGHLIGHT = Color(255, 255, 255, 50)

net.Receive("ixPropertyAddDerma", function()
    local doors = net.ReadTable()
    local sections = net.ReadTable()

    if(IsValid(ix.gui.propertyCreate)) then
        ix.gui.propertyCreate:Remove()
    end

    ix.gui.propertyCreate = vgui.Create("ixPropertyCreate")
    ix.gui.propertyCreate:Build(doors, sections)

    LocalPlayer().selectedDoors = nil
end)

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

function PANEL:Build(doors, sections)
    self.doors = doors
    self.sections = sections

    PrintTable(self.sections)
    self:AddLabel("Select property type")

    self.typeDropBox = self:AddComboBox("Property type")
    self.typeDropBox.OnSelect = function( self, index, value )
        self:GetParent():SetType(value)
    end

    for k, v in pairs(ix.property.types) do 
        self.typeDropBox:AddChoice(v)
    end

    self.property = self:Add("DPanel")
	self.property:Dock(FILL)
    self.property:DockMargin(4,4,4,4)
    
    self.complete = self:Add("DButton")
    self.complete:Dock(BOTTOM)
    self.complete:DockMargin(4,4,4,4)
    self.complete:SetText("Complete")
    self.complete:SetFont("ixPluginCharTraitFont")
    self.complete:SetTall(32)
    self.complete.DoClick = function()
        self:Save()
    end

	self:SetVisible(true)
end

function PANEL:SetType(propertyType)
    local parent = self

    self.type = propertyType
    self.property:Clear()

    self.property:Add(self:AddLabel(propertyType))

    if(propertyType == "Residential") then
        self.property:Add(self:AddLabel("Select section", false, true))

        self.apartmentBlock = self.property:Add(self:AddComboBox("Select section"))
        self.apartmentBlock.OnSelect = function( self, index, value )
            parent.section = value
        end

        for k, v in pairs(self.sections[propertyType] or {}) do
            self.apartmentBlock:AddChoice(v.name)
        end
    elseif(propertyType == "Business") then
        self.property:Add(self:AddLabel("Business"))
    end

    self.property:Add(self:AddLabel("Rent", false, true))

    self.rent = self.property:Add("DNumberWang");
    self.rent:Dock(TOP)
    self.rent:DockMargin(4,4,4,4)
    self.rent:SetMinMax(1, 500);
    self.rent:SetValue(35);
    self.rent.Paint = function()
        surface.SetDrawColor(255,255,255,5)
        surface.DrawRect(0, 0, self:GetWide(), self:GetTall())

        ix.util.DrawText(self.rent:GetValue(), 0, 0, color_white, 0, 0, "ixPluginCharTraitFont")
    end
end

function PANEL:Save()
    if(self.type == "Residential") then
        data = {
            section = self.section,
            doors = self.doors
        }

        net.Start("ixPropertyNew")
            net.WriteTable(data)
        net.SendToServer()
    end

    self:Remove()
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

function PANEL:AddComboBox(text)
    local dropbox = self:Add("DComboBox")
    dropbox:SetFont("ixPluginCharTraitFont")
    dropbox:SetText(text)
	dropbox:Dock(TOP)
	dropbox:DockMargin(4, 0, 4, 0)
    dropbox.Paint = function()
        surface.SetDrawColor(255,255,255,5)
        surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
    end

    return dropbox
end

function PANEL:AddTextEntry(payloadName)
	local entry = self:Add("DTextEntry")
	entry:Dock(TOP)
	entry:SetFont("ixPluginCharTraitFont")
	entry.Paint = self.PaintTextEntry
	entry:DockMargin(4, 4, 4, 4)
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

vgui.Register("ixPropertyCreate", PANEL, "DFrame")