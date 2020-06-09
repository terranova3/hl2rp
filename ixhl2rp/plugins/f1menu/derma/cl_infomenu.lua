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

local PANEL = {}

DEFINE_BASECLASS("DFrame")

function PANEL:Init(logs)
    self.startTime = SysTime()

    self:SetAlpha(0)
    self:SetSize(math.min(ScrW() * 0.5, 512), 480)
    self:Center()
    self:ShowCloseButton(false)
    self:MakePopup()
	self:SetTitle("");
    self:AlphaTo(255, 0.25)
    self:Populate()
end

function PANEL:Populate()
    local faction = ix.faction.indices[LocalPlayer():Team()]

    self.header = self:Add(self:AddLabel(8, "Character and roleplay info", true, true))

    -- time here

    self.infoBox = self:Add("DPanel")
    self.infoBox:Dock(TOP)
    self.infoBox:DockPadding(5, 5, 5, 5)

    self.name = self.infoBox:Add(self:AddLabel(4, LocalPlayer():GetName(), true))
    self.faction = self.infoBox:Add(self:AddLabel(8, faction.name, true))

    for k, v in pairs(ix.infoMenu.stored) do
        self.infoBox:Add(self:AddLabel(0, v))
    end

    
    self.infoBox:InvalidateLayout( true )
    self.infoBox:SizeToChildren(false, true)
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

vgui.Register("ixInfoMenu", PANEL, "DFrame")

netstream.Hook("InfoToggle", function(data)
	if (IsValid(LocalPlayer()) and LocalPlayer():GetCharacter()) then
        if(!ix.infoMenu.open) then
            -- Reset any previous data and load any custom strings we want to add to the info menu.
            ix.infoMenu.stored = {}     
            ix.infoMenu.GetData()

            ix.infoMenu.open = true
            ix.infoMenu.panel = vgui.Create("ixInfoMenu")
        else
            ix.infoMenu.panel:Remove()
            ix.infoMenu.panel = nil
            ix.infoMenu.open = false
        end
	end;
end);