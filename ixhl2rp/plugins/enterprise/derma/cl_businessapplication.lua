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

	self.nameLabel = self:AddLabel("Business name")
	self.nameLabel:SetZPos(0)

	self.name = self:AddTextEntry("name")
	self.name:SetTall(48)
	self.name.onTabPressed = function()
		self.desc:RequestFocus()
	end
	self.name:SetZPos(1)

	self.descLabel = self:AddLabel("Business description")
	self.descLabel:SetZPos(2)

	self.desc = self:AddTextEntry("description")
	self.desc:SetTall(self.name:GetTall() * 3)
	self.desc.onTabPressed = function()
		self.name:RequestFocus()
	end
	self.desc:SetMultiline(true)
	self.desc:SetZPos(3)

	self.permitLabel = self:AddLabel("Business permits")
	self.permitLabel:SetZPos(4)

	self.addPermit = self:Add("DButton")
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

	self.permits = self:Add("DPanel")
	self.permits:DockMargin(0,4,0,4)
	self.permits:SetZPos(6)
	self.permits:Dock(FILL)

	self.scroll = self.permits:Add("DScrollPanel")
	self.scroll:Dock(FILL)
end

function PANEL:DrawHeader()
    self.header = self:Add("DPanel")
    self.header:SetSize((ScrW() * 0.25) - 10, 32)
    self.header:SetPos(5, 4)  
    self.header.Paint = function() 
        derma.SkinFunc("DrawImportantBackground", 0, 0, self:GetWide(), self:GetTall(), Color(100, 170, 220, 80))
    end

    self.headerLabel = self.header:Add("DLabel")
    self.headerLabel:SetText("Editing business application...")
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

function PANEL:Build(itemTable, editMode)
	self.itemTable = itemTable
	self.item = ix.item.instances[itemTable.id]

	self.name:SetValue(self.item:GetData("businessName", ""))
	self.desc:SetValue(self.item:GetData("businessDescription", ""))

	for k, v in pairs(self.item:GetData("businessPermits", {})) do
		local permit = ix.permits.Get(v)

		self:AddPermit(permit)
	end

	if(!editMode) then
		self.headerLabel:SetText("Viewing business application...")
	end

	self:SetVisible(true)
end

function PANEL:OnRemove()
	self:Save()
end

function PANEL:Save()
	local permits = {}

	for k, v in pairs(self.appPermits) do
		table.insert(permits, v.permit.name)
	end

    local data = {
		id = self.itemTable.id,
        name = string.sub(self.name:GetValue(), 0, 32),
		description = string.sub(self.desc:GetValue(), 0, 128),
		permits = permits
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