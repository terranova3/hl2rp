--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

-- Disables ammo interface in bottom right.
function PLUGIN:CanDrawAmmoHUD(weapon)
    return false;
end;