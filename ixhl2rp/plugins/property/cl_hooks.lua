--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN

net.Receive("ixPropertyAddSync", function()
    local doors = net.ReadTable()

    LocalPlayer().selectedDoors = doors
end)

function PLUGIN:PreDrawHalos()
    if(!LocalPlayer():GetData("propertyEdit") or LocalPlayer().selectedDoors == nil) then return end

    halo.Add(LocalPlayer().selectedDoors, Color( 0, 0, 255 ), 5, 5, 2)
end

do
    local aimLength = 0.35
	local aimTime = 0
	local aimEntity
	local lastEntity
    local lastTrace = {}
    
    timer.Create("ixDoorInfo", 0.1, 0, function()
        local client = LocalPlayer()
        local time = SysTime()

        if (!IsValid(client)) then
            return
        end

        local character = client:GetCharacter()

        if (!character) then
            return
        end
        
        if(client:GetData("propertyEdit")) then
            lastTrace.start = client:GetShootPos()
            lastTrace.endpos = lastTrace.start + client:GetAimVector(client) * 160
            lastTrace.filter = client
            lastTrace.mask = MASK_SHOT_HULL

            lastEntity = util.TraceHull(lastTrace).Entity

            if (lastEntity != aimEntity) then
                aimTime = time + aimLength
                aimEntity = lastEntity
            end

            local panel = ix.gui.doorTooltip
            local bShouldShow = time >= aimTime and (!IsValid(ix.gui.menu) or ix.gui.menu.bClosing) and (!IsValid(ix.gui.characterMenu) or ix.gui.characterMenu.bClosing)
            
            if(bShouldShow and IsValid(lastEntity) and lastEntity:IsDoor()) then
                if (!IsValid(panel) or (IsValid(panel) and panel:GetEntity() != lastEntity)) then
                    if (IsValid(ix.gui.doorTooltip)) then
                        ix.gui.doorTooltip:Remove()
                    end

                    local tooltip = vgui.Create("ixDoorTooltip")
                    tooltip:SetEntity(lastEntity)

                    ix.gui.doorTooltip = tooltip
                end
            elseif (IsValid(panel) and panel:GetEntity():IsDoor()) then
                panel:Remove()
            end
        else
            if (IsValid(ix.gui.doorTooltip)) then
                ix.gui.doorTooltip:Remove()
            end
        end
    end)
end

local PANEL = {}

function PANEL:Init() 
    self:SetSize(512,64)
    self:SetPos((ScrW() * 0.5) - self:GetWide() * 0.5, 4)

    local label = self:Add("DLabel")
    label:SetText("Property Management")
    label:SetFont("ixMediumFont")
    label:SetContentAlignment(5)
    label:Dock(TOP)
    label:SetTall(16)

    local label = self:Add("DLabel")
    label:SetText("Press R to add this door to the property.")
    label:SetFont("ixMediumFont")
    label:SetContentAlignment(5)
    label:Dock(FILL)
end

function PANEL:Paint() end

function PANEL:SetEntity(ent)
    self.entity = ent
end

function PANEL:GetEntity()
    return self.entity or nil
end

vgui.Register("ixDoorTooltip", PANEL, "DPanel")
