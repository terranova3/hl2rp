--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN
local HIGHLIGHT = Color(255, 255, 255, 50)

PANEL = {}

function PANEL:Init()
    self:SetBackgroundBlur(true);
	self:Center()
    self:MakePopup()
	self:SetAlpha(0)
	self:DrawHeader()
	self:ShowCloseButton(false)

	self.appPermits = {}
	self.appProperties = {}

	self.container = self:Add("ixStagePanel")
	self.container:Dock(FILL)

	self.topDock = self.container:Add("DPanel")
	self.topDock:Dock(TOP)
	self.topDock:DockMargin(4,4,4,4)
	self.topDock.Paint = function() end

	self:BuildDetails()
	self:BuildPermits()
	self:BuildProperties()
end

function PANEL:BuildDetails()
	self.details = self.container:AddStagePanel("details")
	self.detailsButton = self.topDock:Add(self.container:AddStageButton("Details", "details"))
	self.detailsButton:SetSize(150, self:GetTall())

	self.nameLabel = self.details:Add(self:AddLabel("Business name"))
	self.nameLabel:SetZPos(0)

	self.name = self.details:Add(self:AddTextEntry("name"))
	self.name:SetTall(48)
	self.name.onTabPressed = function()
		self.desc:RequestFocus()
	end
	self.name:SetZPos(1)

	self.descLabel = self.details:Add(self:AddLabel("Business description"))
	self.descLabel:SetZPos(2)

	self.desc = self.details:Add(self:AddTextEntry("description"))
	self.desc:SetTall(self.name:GetTall() * 3)
	self.desc.onTabPressed = function()
		self.name:RequestFocus()
	end
	self.desc:SetMultiline(true)
	self.desc:SetZPos(3)

	self.container:SetActivePanel("details");
end

function PANEL:BuildPermits()
	self.permits = self.container:AddStagePanel("permits")
	self.permitsButton = self.topDock:Add(self.container:AddStageButton("Permits", "permits"))
	self.permitsButton:SetSize(150, self:GetTall())

	self.permitLabel = self.permits:Add(self:AddLabel("Business permits"))
	self.permitLabel:SetZPos(4)

	self.addPermit = self.permits:Add("DButton")
	self.addPermit:SetText("Add Permit")
	self.addPermit:SetZPos(5)
	self.addPermit:Dock(TOP)
	self.addPermit.DoClick = function()
        self.popoutPanel = vgui.Create("ixPopoutPanel")
        self.popoutPanel:SetHeaderText("Permits")

        PLUGIN.businessApplication:SetVisible(false)

        self.popoutPanel.OnRemove = function()       
            PLUGIN.businessApplication:SetVisible(true)
        end

		self.popoutPanel:SetInfoText("This is the list of permits avaliable")

		for _, v in pairs(ix.permits.GetAll()) do
			local hasPermit = false

			for _, value in pairs(self.appPermits) do
				if(v.name == value.permit.name) then
					hasPermit = true
					break
				end
			end

			local button = self.popoutPanel:AddBigButton(v.name, "materials/" .. v.icon)
			button:DockMargin(0,0,0,2)
			button.DoClick = function()
				button:Remove()
				PLUGIN.businessApplication:AddPermit(v)
			end

			if(hasPermit) then
				button:SetEnabled(false)
				button.Paint = function() end
			end
		end
	end

	self.perms = self.permits:Add("DPanel")
	self.perms:DockMargin(0,4,0,4)
	self.perms:SetZPos(6)
	self.perms:Dock(FILL)

	self.scroll = self.perms:Add("DScrollPanel")
	self.scroll:Dock(FILL)
end

function PANEL:BuildProperties()
	self.properties = self.container:AddStagePanel("properties")
	self.propertiesButton = self.topDock:Add(self.container:AddStageButton("Properties", "properties"))
	self.propertiesButton:SetSize(150, self:GetTall())

	self.propertyLabel = self.properties:Add(self:AddLabel("Business properties"))
	self.propertyLabel:SetZPos(4)

	self.addProperty = self.properties:Add("DButton")
	self.addProperty:SetText("Add Property")
	self.addProperty:SetZPos(5)
	self.addProperty:Dock(TOP)
	self.addProperty.DoClick = function()
        self.popoutPanel = vgui.Create("ixPopoutPanel")
        self.popoutPanel:SetHeaderText("Permits")

        PLUGIN.businessApplication:SetVisible(false)

        self.popoutPanel.OnRemove = function()       
            PLUGIN.businessApplication:SetVisible(true)
        end

		self.popoutPanel:SetInfoText("This is the list of properties avaliable")

		for _, v in pairs(ix.property.stored) do
			if(!v.name and ix.property.GetSection(v.section)) then
				local section = ix.property.GetSection(v.section)

				v.name = string.format("%s - Apartment %s", section.tag, ix.property.GetSectionCount(v.section))
			end

			if(v.name) then 
				local button = self.popoutPanel:AddBigButton(v.name)
				button:DockMargin(0,0,0,2)
				button.DoClick = function()
					button:Remove()
					PLUGIN.businessApplication:AddProperty(v)
				end
			end
		end
	end

	self.props = self.properties:Add("DPanel")
	self.props:DockMargin(0,4,0,4)
	self.props:SetZPos(6)
	self.props:Dock(FILL)

	self.propertyScroll = self.props:Add("DScrollPanel")
	self.propertyScroll:Dock(FILL)
end

function PANEL:DrawHeader()
    self.header = self:Add("DPanel")
    self.header:SetSize((ScrW() * 0.25) - 10, 32)
    self.header:SetPos(5, 4)  
    self.header.Paint = function() 
        derma.SkinFunc("DrawImportantBackground", 0, 0, self:GetWide(), self:GetTall(), Color(100, 170, 220, 80))
    end

    self.headerLabel = self.header:Add("DLabel")
    self.headerLabel:SetText("Business application")
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

function PANEL:Build(id, editMode, property)
	self.id = id
	self.item = ix.item.instances[id]

	ix.property.stored = property.stored
	ix.property.sections = property.sections

	self.name:SetValue(self.item:GetData("businessName", ""))
	self.desc:SetValue(self.item:GetData("businessDescription", ""))

	for k, v in pairs(self.item:GetData("businessPermits", {})) do
		local permit = ix.permits.Get(v)

		self:AddPermit(permit)
	end

	self:SetVisible(true)
end

function PANEL:OnRemove()
	self:Save()
end

function PANEL:Save()
	local permits = {}
	local properties = {}

	for k, v in pairs(self.appPermits) do
		table.insert(permits, v.permit.name)
	end

	for k, v in pairs(self.appProperties) do
		table.insert(properties, {
			name = v.property.name,
			id = v.property.index
		})
	end

	PrintTable(self.appProperties)
	PrintTable(properties)
    local data = {
		id = self.id,
        name = string.sub(self.name:GetValue(), 0, 32),
		description = string.sub(self.desc:GetValue(), 0, 128),
		permits = permits,
		properties = properties
    }

	net.Start("ixBusinessApplicationUpdate")
		net.WriteTable(data)
	net.SendToServer()
end

function PANEL:AddLabel(text, colored, title)
    local label = self:Add("DLabel")
    local font = "ixInfoPanelFont"

    if(title) then
        font = "ixInfoPanelTitleFont"
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

function PANEL:AddPermit(permit)
	local button = self.scroll:Add("DButton")
    button:Dock(TOP)
    button:SetTall(64)
    button:InvalidateLayout(true)
    button:SetText("")
    button:SetFont("ixPluginCharTraitFont")
    button.PaintOver = function() 
        ix.util.DrawText(permit.name, 48, 24, color_white, 0, 0, "ixPluginTooltipDescFont")
    end

    local icon = button:Add("Material")
    icon:SetSize(32, 32)
    icon:SetPos(8, 16)
    icon:SetMaterial(permit.icon or "materials/terranova/ui/traits/honest.png")
	icon.AutoSize = false
	
	local delete = button:Add("DButton")
    delete:SetText("X")
    delete:SetFont("ixPluginCharTraitFont")
	delete:Dock(RIGHT)
	delete:SetSize(32, 32)
	delete.DoClick = function()
		for k, v in pairs(self.appPermits) do
			if(v.name == permit.name) then
				self.appPermits[k].panel:Remove()
				self.appPermits[k] = nil
			end
		end
	end

	table.insert(self.appPermits, {
		permit = permit,
		panel = button
	})

    return button
end

function PANEL:AddProperty(property)
	local button = self.propertyScroll:Add("DButton")
    button:Dock(TOP)
    button:SetTall(64)
    button:InvalidateLayout(true)
    button:SetText("")
    button:SetFont("ixPluginCharTraitFont")
    button.PaintOver = function() 
        ix.util.DrawText(property.name, 48, 24, color_white, 0, 0, "ixPluginTooltipDescFont")
    end

    local icon = button:Add("Material")
    icon:SetSize(32, 32)
    icon:SetPos(8, 16)
    icon:SetMaterial("materials/terranova/ui/traits/honest.png")
	icon.AutoSize = false
	
	local delete = button:Add("DButton")
    delete:SetText("X")
    delete:SetFont("ixPluginCharTraitFont")
	delete:Dock(RIGHT)
	delete:SetSize(32, 32)
	delete.DoClick = function()
		for k, v in pairs(self.appProperties) do
			if(v.name == property.name) then
				self.appProperties[k].panel:Remove()
				self.appProperties[k] = nil
			end
		end
	end

	table.insert(self.appProperties, {
		property = property,
		panel = button
	})

    return button
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

vgui.Register("ixBusinessApplication", PANEL, "DFrame")