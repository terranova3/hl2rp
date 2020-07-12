--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN

function PLUGIN:PreDrawHalos()
    local client = LocalPlayer()
    local entList = {}

    for k, v in pairs(ents.GetAll()) do
        if(v:GetClass():find("door")) then
            table.insert(entList, v)
        end
    end

    if(client:GetData("propertyEdit")) then
        halo.Add(entList, Color( 0, 0, 255 ), 5, 5, 2)
    end 
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
        end
    end)
end

local PANEL = {}

function PANEL:Init()
    self:SetSize(512,64)
    self:SetPos((ScrW() * 0.5) - self:GetWide() * 0.5, (ScrH() * 0.75) - self:GetTall() * 0.5)

    local label = self:Add("DLabel")
    label:SetText("Press R to edit this property.")
    label:SetFont("ixMediumFont")
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
