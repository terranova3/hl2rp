--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

PLUGIN.rankIcons = {
	["founder"] = "icon16/key.png",
	["developer"] = "icon16/shield.png",
	["superadmin"] = "icon16/shield.png",
	["admin"] = "icon16/star.png",
	["gamemaster"] = "icon16/asterisk_yellow.png",
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
	if(serverguard) then
		local rank = serverguard.ranks:GetRank(serverguard.player:GetRank(speaker))
			
		if (type(rank) == "table" and rank.texture) then
			return rank.texture
		end
	end

	if(self.rankIcons[speaker:GetUserGroup()]) then
		return self.rankIcons[speaker:GetUserGroup()]
	end

	return "icon16/user.png"
end

timer.Create("DisableEyeMove", 60, 0, function()
	RunConsoleCommand("r_eyemove", 0)
end)