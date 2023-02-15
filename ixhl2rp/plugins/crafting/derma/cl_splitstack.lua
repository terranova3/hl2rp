--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PANEL = {};
local panelWidth = 350
local panelHeight = 190

-- Called when the panel is initialized.
function PANEL:Init()
    self:SetTitle("")
    self.stack = 1
	self.startTime = SysTime()
    self:SetBackgroundBlur(true);
	self:SetDeleteOnClose(false);
    self:SetSize(panelWidth, panelHeight)
end;

function PANEL:Populate(id)
    local this = self

    local topDock = self:Add("DPanel")
    topDock:Dock(TOP)
    topDock:SetTall(48)
    topDock:DockMargin(4,4,4,4)

    function topDock:Paint(w, h) end

    local item = ix.item.instances[id]
    self.maxSplit = item:GetStacks()-1

    local icon = topDock:Add("ixItemIcon")
    icon:InvalidateLayout(true)
    icon:Dock(LEFT)
    icon:SetSize(48, 48)
    icon:DockMargin(2, 2, 2, 2)
    icon:SetModel(item:GetModel(), item:GetSkin())
    icon:SetItemTable(item)
    icon:SetHelixTooltip(function(tooltip)
        ix.hud.PopulateItemTooltip(tooltip, item)
    end)

    if ((item.iconCam and !ICON_RENDER_QUEUE[item.uniqueID]) or item.forceRender) then
        local iconCam = item.iconCam
        iconCam = {
            cam_pos = iconCam.pos,
            cam_fov = iconCam.fov,
            cam_ang = iconCam.ang,
        }
        ICON_RENDER_QUEUE[item.uniqueID] = true

        icon:RebuildSpawnIconEx(
            iconCam
        )
    end

    local label = topDock:Add("DLabel")
    label:Dock(FILL)
    label:DockMargin(4, 0, 0, 0)
    label:SetContentAlignment(5)
    label:SetTextColor(Color(218,171,3,255))
    label:SetFont("ixMenuButtonFontSmall")
    label:SetExpensiveShadow(1, Color(0, 0, 0, 200))
    label:SetText(string.format("Splitting %s.", item:GetName()))

    local stack = self:Add("DPanel")
    stack:Dock(FILL)
    stack:SetTall(48)
    stack:DockMargin(4,4,4,4)

    function stack:Paint(w, h)
        surface.SetDrawColor(30, 30, 30, 150)
        surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
    
        local outlineColor = Color(100, 170, 220, 80)
    
        surface.SetDrawColor(outlineColor)
        surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
    end

    local stackPanel = stack:Add("DPanel")
    stackPanel:Dock(TOP)
    stackPanel:SetTall(48)

    function stackPanel:Paint() end

    local subtract = stackPanel:Add("ixNewButton")
    subtract:Dock(LEFT)
    subtract:SetText("-")
    subtract:SetSize(48, 48)
    subtract:DockMargin(4,4,0,4)
    
    function subtract:DoClick()
        this.stack = math.Clamp(this.stack-1, 1, this.maxSplit)
    end

    local indicator = stackPanel:Add("DPanel")
    indicator:Dock(FILL)
    indicator:SetTall(48)
    indicator:DockMargin(0,4,0,4)

    function indicator:Paint(w, h)
        surface.SetDrawColor(90, 90, 90, 120)
        surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
        
        surface.SetDrawColor(Color(25, 25, 25, 180))
    
        surface.DrawRect(0, 0, self:GetWide(), self:GetTall())

        surface.SetDrawColor(Color(100, 170, 220, 80))
        surface.DrawRect(4, 4, (self:GetWide()-8) * (math.Clamp(this.stack / this.maxSplit, 0, 1)), self:GetTall()-8)
    end
        
    local add = stackPanel:Add("ixNewButton")
    add:Dock(RIGHT)
    add:SetText("+")
    add:SetSize(48, 48)
    add:DockMargin(0,4,4,4)

    function add:DoClick()
        this.stack = math.Clamp(this.stack+1, 1, this.maxSplit)
    end

    local split = stack:Add("ixNewButton")
    split:Dock(BOTTOM)
    split:DockMargin(4,4,4,4)
    split:SetTall(44)

    function split:Think()
        split:SetText(string.format("Split (%s)", this.stack))  
    end

    stack:SizeToContents()

    function split:DoClick()
        net.Start("ixProcessSplit")
            net.WriteUInt(item.id, 32)
            net.WriteUInt(this.stack, 8)
        net.SendToServer()

        vgui.Create("ixMenu")
        this:Close()
    end
end 

function PANEL:Paint()
    Derma_DrawBackgroundBlur(self, self.startTime)

	surface.SetDrawColor(30, 30, 30, 150)
	surface.DrawRect(0, 0, self:GetWide(), self:GetTall())

	surface.SetDrawColor(Color(100, 170, 220, 80))
	surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
end

-- Called each frame.
function PANEL:Think()
	local scrW = ScrW();
	local scrH = ScrH();
	
    self:SetSize(panelWidth, panelHeight)
	self:SetPos( (scrW / 2) - (self:GetWide() / 2), (scrH / 2) - (self:GetTall() / 2) );
end;

vgui.Register("ixSplitStack", PANEL, "DFrame");

net.Receive("ixSplitStack", function()
    if(IsValid(ix.gui.menu)) then
        ix.gui.menu:Remove()
    end

    local split = vgui.Create("ixSplitStack")
    split:MakePopup()
    split:Populate(net.ReadInt(32))
end);
