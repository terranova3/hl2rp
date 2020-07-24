--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local playerMeta = FindMetaTable("Player");

function playerMeta:GetChatIcon()
    local icon = "icon16/user.png"

    if (self:IsSuperAdmin()) then
        icon = "icon16/shield.png"
    elseif (self:IsAdmin()) then
        icon = "icon16/star.png"
    elseif (self:IsUserGroup("moderator") or self:IsUserGroup("operator")) then
        icon = "icon16/wrench.png"
    elseif (self:IsUserGroup("vip") or self:IsUserGroup("donator") or self:IsUserGroup("donor")) then
        icon = "icon16/heart.png"
    end

    return icon
end