--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PANEL = {}

function PANEL:Init(logs)
    self:SetSize(self.minimumWidth, 64)

    self.limbInfo = {};

    self:SetSize(120, 240)
    self.texInfo = {
        shouldDisplay = true,
        textures = {
            [HITGROUP_RIGHTARM] = ix.limb:GetTexture(HITGROUP_RIGHTARM),
            [HITGROUP_RIGHTLEG] = ix.limb:GetTexture(HITGROUP_RIGHTLEG),
            [HITGROUP_LEFTARM] = ix.limb:GetTexture(HITGROUP_LEFTARM),
            [HITGROUP_LEFTLEG] = ix.limb:GetTexture(HITGROUP_LEFTLEG),
            [HITGROUP_STOMACH] = ix.limb:GetTexture(HITGROUP_STOMACH),
            [HITGROUP_CHEST] = ix.limb:GetTexture(HITGROUP_CHEST),
            [HITGROUP_HEAD] = ix.limb:GetTexture(HITGROUP_HEAD),
            ["body"] = ix.limb:GetTexture("body")
        },
        names = {
            [HITGROUP_RIGHTARM] = ix.limb:GetName(HITGROUP_RIGHTARM),
            [HITGROUP_RIGHTLEG] = ix.limb:GetName(HITGROUP_RIGHTLEG),
            [HITGROUP_LEFTARM] = ix.limb:GetName(HITGROUP_LEFTARM),
            [HITGROUP_LEFTLEG] = ix.limb:GetName(HITGROUP_LEFTLEG),
            [HITGROUP_STOMACH] = ix.limb:GetName(HITGROUP_STOMACH),
            [HITGROUP_CHEST] = ix.limb:GetName(HITGROUP_CHEST),
            [HITGROUP_HEAD] = ix.limb:GetName(HITGROUP_HEAD),
        }
    };

    --Clockwork.plugin:Call("GetPlayerLimbInfo", texInfo);
end

function PANEL:Paint(w, h)
    if (self.texInfo.shouldDisplay) then
        surface.SetDrawColor(255, 255, 255, 150);
        surface.SetMaterial(self.texInfo.textures["body"]);
        surface.DrawTexturedRect(0, 0, self:GetWide(), self:GetTall());
        
        for k, v in pairs(ix.limb.hitGroups) do
            local limbHealth = ix.limb:GetHealth(k);
            local limbColor = ix.limb:GetColor(limbHealth);
            local newIndex = #self.limbInfo + 1;
            
            surface.SetDrawColor(limbColor.r, limbColor.g, limbColor.b, 150);
            surface.SetMaterial(self.texInfo.textures[k]);
            surface.DrawTexturedRect(0, 0, self:GetWide(), self:GetTall());
            
            self.limbInfo[newIndex] = {
                color = limbColor,
                text = self.texInfo.names[k]..": "..limbHealth.."%"
            };
        end;
    end
end


vgui.Register("ixLimbPanel", PANEL, "DPanel")