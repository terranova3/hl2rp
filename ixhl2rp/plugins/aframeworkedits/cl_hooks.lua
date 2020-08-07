--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

PLUGIN.rankIcons = {
	["Management"] = "icon16/key.png",
	["Developer"] = "icon16/shield.png",
	["Super Admin"] = "icon16/shield.png",
	["Admin"] = "icon16/star.png",
	["Game Master"] = "icon16/asterisk_yellow.png",
}

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

function PLUGIN:GetPlayerIcon(speaker)
	if(self.rankIcons[speaker:GetUserGroup()]) then
		return self.rankIcons[speaker:GetUserGroup()]
	end

	return "icon16/user.png"
end