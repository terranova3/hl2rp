
PLUGIN.name = "Observer"
PLUGIN.author = "Chessnut"
PLUGIN.description = "Adds on to the no-clip mode to prevent intrusion."

CAMI.RegisterPrivilege({
	Name = "Helix - Observer",
	MinAccess = "admin"
})

ix.option.Add("observerTeleportBack", ix.type.bool, true, {
	bNetworked = true,
	category = "Admin Settings",
	hidden = function()
		return !CAMI.PlayerHasAccess(LocalPlayer(), "Helix - Observer", nil)
	end
})

local playerMeta = FindMetaTable("Player")

function playerMeta:InObserver()
	if(self:GetMoveType() == MOVETYPE_NOCLIP) then
		return true
	end

	return false
end

if (CLIENT) then
	function PLUGIN:ShouldPopulateEntityInfo(entity)
		if (IsValid(entity)) then
			if ((entity:IsPlayer() or IsValid(entity:GetNetVar("player"))) and entity:GetMoveType() == MOVETYPE_NOCLIP) then
				return false
			end
		end
	end

	function PLUGIN:DrawPhysgunBeam(client, physgun, enabled, target, bone, hitPos)
		if (client != LocalPlayer() and client:GetMoveType() == MOVETYPE_NOCLIP) then
			return false
		end
	end

	function PLUGIN:PrePlayerDraw(client)
		if (client:GetMoveType() == MOVETYPE_NOCLIP and !client:InVehicle()) then
			return true
		end
	end
else
	ix.log.AddType("observerEnter", function(client, ...)
		return string.format("%s entered observer.", client:Name())
	end)

	ix.log.AddType("observerExit", function(client, ...)
		if (ix.option.Get(client, "observerTeleportBack", true)) then
			return string.format("%s exited observer.", client:Name())
		else
			return string.format("%s exited observer at their location.", client:Name())
		end
	end)

	function PLUGIN:CanPlayerEnterObserver(client)
		if (CAMI.PlayerHasAccess(client, "Helix - Observer", nil)) then
			return true
		end
	end

	function PLUGIN:CanPlayerEnterVehicle(client, vehicle, role)
		if (client:GetMoveType() == MOVETYPE_NOCLIP) then
			return false
		end
	end

	function PLUGIN:PlayerNoClip(client, state)
		if (hook.Run("CanPlayerEnterObserver", client)) then
			if (state) then
				client.ixObsData = {client:GetPos(), client:EyeAngles()}

				-- Hide them so they are not visible.
				client:SetNoDraw(true)
				client:SetNotSolid(true)
				client:DrawWorldModel(false)
				client:DrawShadow(false)
				client:GodEnable()
				client:SetNoTarget(true)

				hook.Run("OnPlayerObserve", client, state)
			else
				if (client.ixObsData) then
					-- Move they player back if they want.
					if (ix.option.Get(client, "observerTeleportBack", true)) then
						local position, angles = client.ixObsData[1], client.ixObsData[2]

						-- Do it the next frame since the player can not be moved right now.
						timer.Simple(0, function()
							client:SetPos(position)
							client:SetEyeAngles(angles)
							client:SetVelocity(Vector(0, 0, 0))
						end)
					end

					client.ixObsData = nil
				end

				-- Make the player visible again.
				client:SetNoDraw(false)
				client:SetNotSolid(false)
				client:DrawWorldModel(true)
				client:DrawShadow(true)
				client:GodDisable()
				client:SetNoTarget(false)

				hook.Run("OnPlayerObserve", client, state)
			end

			return true
		end
	end

	function PLUGIN:OnPlayerObserve(client, state)
		if (state) then
			ix.log.Add(client, "observerEnter")
		else
			ix.log.Add(client, "observerExit")
		end
	end
end
