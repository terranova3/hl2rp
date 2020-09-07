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

net.Receive("ixStartSound", function()
	local sound = net.ReadString(32)

	if(!sound) then
		return
	end

	surface.PlaySound(sound)
end)

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

netstream.Hook("ixPlaySound", function(sound)
	surface.PlaySound(sound);
end);

local hookRun = hook.Run

do
	local aimLength = 0.35
	local aimTime = 0
	local aimEntity
	local lastEntity
	local lastTrace = {}

	if(timer.Exists("ixCheckTargetEntity")) then
	  timer.Remove("ixCheckTargetEntity")
	end
  
	timer.Create("ixCheckTargetEntity", 0.1, 0, function()
		local client = LocalPlayer()
		local time = SysTime()

		if (!IsValid(client)) then
			return
		end

		local character = client:GetCharacter()

		if (!character) then
			return
		end

		lastTrace.start = client:GetShootPos()
		lastTrace.endpos = lastTrace.start + client:GetAimVector(client) * ix.config.Get("LookRange", 160)
		lastTrace.filter = client
		lastTrace.mask = MASK_SHOT_HULL

		lastEntity = util.TraceHull(lastTrace).Entity

		if (lastEntity != aimEntity) then
			aimTime = time + aimLength
			aimEntity = lastEntity
		end

		local panel = ix.gui.entityInfo
		local bShouldShow = time >= aimTime and (!IsValid(ix.gui.menu) or ix.gui.menu.bClosing) and
			(!IsValid(ix.gui.characterMenu) or ix.gui.characterMenu.bClosing)
		local bShouldPopulate = lastEntity.OnShouldPopulateEntityInfo and lastEntity:OnShouldPopulateEntityInfo() or true

		if (bShouldShow and IsValid(lastEntity) and hookRun("ShouldPopulateEntityInfo", lastEntity) != false and
			(lastEntity.PopulateEntityInfo or bShouldPopulate)) then

			if (!IsValid(panel) or (IsValid(panel) and panel:GetEntity() != lastEntity)) then
				if (IsValid(ix.gui.entityInfo)) then
					ix.gui.entityInfo:Remove()
				end

				local infoPanel = vgui.Create(ix.option.Get("minimalTooltips", false) and "ixTooltipMinimal" or "ixTooltip")
				local entityPlayer = lastEntity:GetNetVar("player")

				if (entityPlayer) then
					infoPanel:SetEntity(entityPlayer)
					infoPanel.entity = lastEntity
				else
					infoPanel:SetEntity(lastEntity)
				end

				infoPanel:SetDrawArrow(true)
				ix.gui.entityInfo = infoPanel
			end
		elseif (IsValid(panel)) then
			panel:Remove()
		end
	end)
  end