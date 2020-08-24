--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ix.infoMenu = {}
ix.infoMenu.stored = {}

function ix.infoMenu.Add(text)
    table.insert(ix.infoMenu.stored, text)
end

function ix.infoMenu.GetData()
    local character = LocalPlayer():GetCharacter()
    local faction = ix.faction.indices[LocalPlayer():Team()]

    hook.Run("SetInfoMenuData", character, faction)
end

function ix.infoMenu.Display()
    ix.infoMenu.stored = {}     
    ix.infoMenu.GetData()

    ix.infoMenu.open = true
    ix.infoMenu.panel = vgui.Create("ixInfoMenu")
end

function ix.infoMenu.Remove()
    if(IsValid(ix.infoMenu.panel)) then
        ix.infoMenu.panel:Remove()
    end

    ix.infoMenu.panel = nil
    ix.infoMenu.open = false
end 

local PANEL = {}

DEFINE_BASECLASS("DFrame")

function PANEL:Init(logs)
    self.startTime = SysTime()
    self.noAnchor = CurTime() + 0.4
	self.anchorMode = true

    self:SetAlpha(0)
    self:SetSize(564, 64)
    self:ShowCloseButton(false)
    self:MakePopup()
	self:SetTitle("");

    self:Populate()
    self:BuildTraits()
    self:BuildMenuPanel()
    self:SetPos((ScrW() * 0.5) - self:GetWide() * 0.5, (ScrH() * 0.25))

    self:InvalidateLayout(true)
    self:SizeToChildren(false, true)

    self:AlphaTo(255, 0.5)
end

function PANEL:Populate()
    local faction = ix.faction.indices[LocalPlayer():Team()]

    self.rightContainer = self:Add("DPanel")
    self.rightContainer:Dock(RIGHT)
    self.rightContainer:SetWide(180)
    self.rightContainer.Paint = function() end

    self.limbs = self.rightContainer:Add("ixLimbPicture")
    self.limbs:SetScale(0.5)
    self.limbs:SetPos(-60, 0)

    self.header = self:Add(self:AddLabel(8, "Character and roleplay info", true, true))

    local format = "%A, %B %d, %Y. %H:%M:%S"

    self.time = self:Add(self:AddLabel(4, ix.date.GetFormatted(format)))
    self.time:SetContentAlignment(5)
    self.time:SetExpensiveShadow(1, Color(0, 0, 0, 150))
    self.time.Think = function(this)
        if ((this.nextTime or 0) < CurTime()) then
            this:SetText(ix.date.GetFormatted(format))
            this.nextTime = CurTime() + 0.5
        end
    end

    self.bars = {}
    for _, v in ipairs(ix.bar.list) do
        self:AddBar(v.index, v.color, v.priority)
	end

    self.infoBox = self:Add("DPanel")
    self.infoBox:Dock(TOP)
    self.infoBox:DockPadding(5, 5, 5, 5)
    self.infoBox.Paint = function()
        surface.SetDrawColor(25, 25, 25, 225)
        surface.DrawRect(0, 0, self.infoBox:GetWide(), self.infoBox:GetTall())
    
        surface.SetDrawColor(90, 90, 90, 255)
        surface.DrawOutlinedRect(0, 0, self.infoBox:GetWide(), self.infoBox:GetTall())
    end

    local name = LocalPlayer():GetName()

    self.name = self.infoBox:Add(self:AddLabel(4, name, true))

    local subname = faction.name
    local job = LocalPlayer():GetCharacter():GetJob()

    if(job) then
        subname = job
    end

    self.faction = self.infoBox:Add(self:AddLabel(8, subname, true))

    for k, v in pairs(ix.infoMenu.stored) do
        self.infoBox:Add(self:AddLabel(0, v))
    end
end

function PANEL:BuildTraits()
    local character = LocalPlayer():GetCharacter()
    local traits = character:GetData("traits", {})

    if(traits[1]) then
        self.container = self.infoBox:Add("DPanel")
        self.container:Dock(TOP)
        self.container:DockMargin(0, 4, 0, 0)
        self.container:SetTall(36)
        self.container.Paint = function() end

        self.center = self.container:Add("DPanel")
        self.center:SetTall(36)
        self.center:SetPos(90, 2)
        self.center:SetWide(190)
        self.center:SetContentAlignment(5)
        self.center:SetDrawBackground(false)
        
        for k, v in pairs(traits) do
            local trait = ix.traits.Get(v)

            if(trait) then
                self.icon = self.center:Add("Material")
                self.icon:SetSize(32, 32)
                self.icon:DockMargin(2,2,2,2)
                self.icon:Dock(LEFT)
                self.icon:SetMaterial(trait.icon)
                self.icon.AutoSize = false

                self.icon:SetHelixTooltip(function(tooltip)
                    local name = tooltip:AddRow("description")
                    name:SetText(trait.name)
                    name:SetFont("ixPluginTooltipDescFont")
                    name:SizeToContents()

                    local description = tooltip:AddRow("description")
                    description:SetText(trait.description)
                    description:SetFont("ixPluginTooltipDescFont")
                    description:SizeToContents()

                    if(trait.opposite) then
                        local exclusive = tooltip:AddRow("exclusive")
                        exclusive:SetText("Mutually exclusive with " .. trait.opposite)
                        exclusive:SizeToContents()
                        exclusive:SetFont("ixPluginTooltipSmallFont")
                    end
                end)
            end
        end

        self.container:InvalidateLayout(true)
        self.container:SizeToChildren(false, true)
    end
    
    self.infoBox:InvalidateLayout(true)
    self.infoBox:SizeToChildren(false, true)
end

function PANEL:BuildMenuPanel()
    self.menu = self:Add("ixInteractMenu")
    self.menu:Dock(TOP)
    self.menu:DockMargin(0, 4, 0, 0)

    for k, v in pairs(ix.quickmenu.stored) do
        if((v.shouldShow and v.shouldShow() == true) or !v.shouldShow) then
            self.menu:AddOption(k, v)
        end
    end

    self.menu:Build()

    self.initialized = true
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0,0,0,125)
   -- surface.DrawRect(0, 0, w, h)

    Derma_DrawBackgroundBlur(self, self.startTime)
end

function PANEL:AddLabel(margin, text, colored, title)
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
    label:DockMargin(0, 0, 0, margin)
	return label
end

function PANEL:AddBar(index, color, priority)
	local panel = self:Add("ixInfoBar")
	panel:SetSize(self:GetWide(), BAR_HEIGHT)
    panel:Dock(TOP)
    panel:DockMargin(0,0,0,4)
	panel:SetID(index)
	panel:SetColor(color)
	panel:SetPriority(priority)

	self.bars[#self.bars + 1] = panel
	self:Sort()

	return panel
end

function PANEL:OnKeyCodePressed(key)
	self.noAnchor = CurTime() + 0.5

	if (key == KEY_F1) then
		ix.infoMenu.Remove()
	end
end

function PANEL:Think()
    -- If the selector no longer exists, exit.
    if(!IsValid(self.menu)) then
        ix.infoMenu.Remove()
    end

	for _, v in ipairs(self.bars) do
        local info = ix.bar.list[v:GetID()]
		local realValue, barText = info.GetValue()

		if (bShouldHide or realValue == false or realValue < 0.01) then
			v:SetVisible(false)
			continue
		end
        
		v:SetVisible(true)
		v:SetValue(realValue)
		v:SetText(isstring(barText) and barText or "")
    end
 
	local bTabDown = input.IsKeyDown(KEY_F1)

	if (bTabDown and (self.noAnchor or CurTime() + 0.4) < CurTime() and self.anchorMode) then
		self.anchorMode = false
		--surface.PlaySound("buttons/lightswitch2.wav")
	end

	if ((!self.anchorMode and !bTabDown) or gui.IsGameUIVisible()) then
		ix.infoMenu.Remove()
    end

    if(self.initialized and !self.menu.IsVisible) then
		ix.infoMenu.Remove()
    end
end

-- sort bars by priority
function PANEL:Sort()
	table.sort(self.bars, function(a, b)
		return a:GetPriority() < b:GetPriority()
	end)
end

vgui.Register("ixInfoMenu", PANEL, "DFrame")