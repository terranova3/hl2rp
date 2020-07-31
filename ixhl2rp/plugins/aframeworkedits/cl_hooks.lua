--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

-- Disables ammo interface in bottom right.
function PLUGIN:CanDrawAmmoHUD(weapon)
    return false;
end;

function PLUGIN:LoadedMenuButtons(buttons)
	for k, v in pairs(buttons) do
		if(v.name == "you") then
			v:Remove()
		end
	end
end

function ArcCW:ShouldDrawHUDElement(ele)
	return false
end