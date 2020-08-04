--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local playerMeta = FindMetaTable("Player");

function playerMeta:GetChatIcon()
    local icon = "icon16/user.png"

    if(CAMI.PlayerHasAccess(speaker, "Helix - Management", nil)) then
        icon = "icon16/key.png"
    elseif(CAMI.PlayerHasAccess(speaker, "Helix - Developer", nil)) then
        icon = "icon16/wrench.png"
    elseif(CAMI.PlayerHasAccess(speaker, "Helix - Gamemaster", nil)) then
        icon = "icon16/asterisk_yellow.png"
    elseif(CAMI.PlayerHasAccess(speaker, "Helix - Donator", nil)) then
        icon = "icon16/heart.png"
    elseif (speaker:IsSuperAdmin()) then
        icon = "icon16/shield.png"
    elseif(speaker:IsAdmin()) then
        icon = "icon16/star.png"
    end
    
    return icon
end