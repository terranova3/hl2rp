--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

local PANEL = {};
local panelWidth = 700
local panelHeight = 800

-- Called when the panel is initialized.
function PANEL:Init()
    self:SetTitle("Editing blueprints")
	self:SetBackgroundBlur(true);
	self:SetDeleteOnClose(false);
    self:SetSize(panelWidth, panelHeight)
    
	-- Called when the button is clicked.
	function self.btnClose.DoClick(button)
		self:Close(); 
		self:Remove();
		
		gui.EnableScreenClicker(false);
    end;

    net.Receive("ixSendBlueprints", function()
        local targetName = net.ReadString(32)
        local blueprints = net.ReadTable()
        
        self:Populate(targetName, blueprints)
    end)
end;

function PANEL:SetCharacter(charID)
    net.Start("ixRequestBlueprints")
        net.WriteInt(charID, 32)
    net.SendToServer()
end

net.Receive("ixManageBlueprints", function()
    local charID = net.ReadInt(32)

    if(IsValid(ix.gui.menu)) then
        ix.gui.menu:Remove()
    end

    local management = vgui.Create("ixBlueprintManagement")
    management:MakePopup()
    management:SetCharacter(charID)
end)

function PANEL:Populate(targetName, blueprints)
    if(IsValid(self.scroll)) then
        self.scroll:Remove()
    end

    self.scroll = self:Add("DScrollPanel")
	self.scroll:Dock(FILL)
    self.scroll:DockMargin(4,4,4,4)

    local label = self.scroll:Add("DLabel")
    label:Dock(TOP)
    label:DockMargin(4, 4, 4, 4)
    label:SetTextColor(color_white)
    label:SetFont("ixMenuButtonFontSmall")
    label:SetExpensiveShadow(1, Color(0, 0, 0, 200))
    label:SetText(string.format("Editing %s's blueprints.", targetName))

    for k, v in pairs(blueprints) do
        local recipe = ix.recipe.Get(v)

        if(recipe) then
            local blueprint = self.scroll:Add("DPanel")
            blueprint:Dock(TOP)
            blueprint:SetTall(48)
            blueprint:DockMargin(4,4,4,4)
            function blueprint:Paint(w, h)
                surface.SetDrawColor(30, 30, 30, 150)
                surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
            
                local outlineColor = Color(100, 170, 220, 80)
            
                surface.SetDrawColor(outlineColor)
                surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
            end

            local item = ix.item.list[recipe:GetFirstResult()]
            local icon = blueprint:Add("SpawnIcon")
            icon:InvalidateLayout(true)
            icon:Dock(LEFT)
            icon:SetSize(32, 32)
            icon:DockMargin(2, 2, 2, 2)
            icon:SetModel(recipe:GetModel() or item:GetModel(), recipe:GetSkin() or item:GetSkin())
        
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

            local label = blueprint:Add("DLabel")
            label:Dock(FILL)
            label:DockMargin(4, 0, 0, 0)
            label:SetContentAlignment(4)
            label:SetTextColor(color_white)
            label:SetFont("ixMenuButtonFontSmall")
            label:SetExpensiveShadow(1, Color(0, 0, 0, 200))
            label:SetText("Blueprint: " .. recipe:GetName())

            local delete = blueprint:Add("ixNewButton")
            delete:Dock(RIGHT)
            delete:DockMargin(4,4,4,4)
            delete:SetText("Remove")
            delete:SetWide(60)

            function delete:DoClick()
                ix.command.Send("CharRemoveBlueprint", targetName, v)
                blueprint:Remove()
            end
        end
    end
end 

-- Called each frame.
function PANEL:Think()
	local scrW = ScrW();
	local scrH = ScrH();
	
    self:SetSize(panelWidth, panelHeight)
	self:SetPos( (scrW / 2) - (self:GetWide() / 2), (scrH / 2) - (self:GetTall() / 2) );
end;

vgui.Register("ixBlueprintManagement", PANEL, "DFrame")