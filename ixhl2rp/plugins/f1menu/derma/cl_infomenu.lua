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
    ix.infoMenu.panel:Remove()
    CloseDermaMenus()
    ix.infoMenu.panel = nil
    ix.infoMenu.open = false
end 

local PANEL = {}

DEFINE_BASECLASS("DFrame")

function PANEL:Init(logs)
    self.startTime = SysTime()
    self.noAnchor = CurTime() + 0.4
	self.anchorMode = true
    self.minimumWidth = 512

    self:SetAlpha(0)
    self:SetSize(self.minimumWidth, 64)
    self:ShowCloseButton(false)
    self:MakePopup()
	self:SetTitle("");

    self:Populate()
    self:BuildMenuPanel()

    self:InvalidateLayout(true)
    self:SizeToChildren(false, true)

    self:SetPos(self.menuX, (self.menuY - self:GetTall()))

    self:AlphaTo(255, 0.5)
end

function PANEL:Populate()
    local faction = ix.faction.indices[LocalPlayer():Team()]

    self.rightContainer = self:Add("DPanel")
    self.rightContainer:Dock(RIGHT)
    self.rightContainer:SetWide(128)
    self.rightContainer.Paint = function() end

    self.limbPanel = self.rightContainer:Add("ixLimbPanel")

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

    self.name = self.infoBox:Add(self:AddLabel(4, LocalPlayer():GetName(), true))
    self.faction = self.infoBox:Add(self:AddLabel(8, faction.name, true))

    for k, v in pairs(ix.infoMenu.stored) do
        self.infoBox:Add(self:AddLabel(0, v))
    end

    self.infoBox:InvalidateLayout(true)
    self.infoBox:SizeToChildren(false, true)
end

function PANEL:BuildMenuPanel()
    local options = {};
		
    for k, v in pairs(ix.quickmenu.categories) do
        options[k] = {};
        
        for k2, v2 in pairs(v) do
            local info = v2.GetInfo();
            
            if (type(info) == "table") then
                options[k][k2] = info;
                options[k][k2].isArgTable = true;
            end;
        end;
    end;
    
    for k, v in pairs(ix.quickmenu.stored) do
        local info = v.GetInfo();
        
        if (type(info) == "table") then
            options[k] = info;
            options[k].isArgTable = true;
        end;
    end;

    self.menu = ix.util.AddMenuFromData(nil, options, function(menuPanel, option, arguments)
        if (arguments.name) then
            option = arguments.name;
        end;
        
        if (arguments.options) then
            local subMenu = menuPanel:AddSubMenu(option);
            
            for k, v in pairs(arguments.options) do
                local name = v;
                
                if (type(v) == "table") then
                    name = v[1];
                end;
                
                subMenu:AddOption(name, function()
                    if (arguments.Callback) then
                        if (type(v) == "table") then
                            arguments.Callback(v[2]);
                        else
                            arguments.Callback(v);
                        end;
                    end;
                end);
            end;
            
            if (IsValid(subMenu)) then
                if (arguments.toolTip) then
                    subMenu:SetToolTip(arguments.toolTip);
                end;
            end;
        else
            menuPanel:AddOption(option, function()
                if (arguments.Callback) then
                    arguments.Callback();
                end;
            end);
            
            menuPanel.Items = menuPanel:GetChildren();
            local panel = menuPanel.Items[#menuPanel.Items];
            
            if (IsValid(panel) and arguments.toolTip) then
                --panel:SetToolTip(arguments.toolTip);
            end;
        end;
    end, self.minimumWidth);

    self.menu:Center()
    self.menuX, self.menuY = self.menu:GetPos()

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
	local curTime = CurTime()

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
		surface.PlaySound("buttons/lightswitch2.wav")
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