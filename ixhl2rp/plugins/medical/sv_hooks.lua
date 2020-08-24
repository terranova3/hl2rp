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
				ix.limb.TakeDamage(target, lastHitGroup, info, 3)
			end

			if (lastHitGroup > 0) then
				local hit = ix.limb.GetHealthPercentage(target, lastHitGroup) / 100

				if (hit > 0) then
					local scale = ix.limb.GetScaleDamage(lastHitGroup)

					info:ScaleDamage(scale + hit)
				end
			end

			ix.limb.RunDamage(target:GetCharacter(), attacker, lastHitGroup)
		end
	end
end

function PLUGIN:CalculateFallDamage(target, hitgroup, info)
	local dmgShareRight = (math.random(0, 100))
	local dmgShareLeft = (100 - dmgShareRight)

	ix.limb.TakeDamage(target, HITGROUP_RIGHTLEG, info, dmgShareRight / 100)
	ix.limb.TakeDamage(target, HITGROUP_LEFTLEG, info, dmgShareLeft / 100)
end

function PLUGIN:PlayerFootstep(client, pos, foot)
end

function PLUGIN:HealPlayer(character, item, bIsTarget)
	local hasFracture, fractures = character:GetFractures()
	local amount = item:GetData("currentAmount", 0)
	local client = character:GetPlayer()
	local targetString = ""

	if(bIsTarget) then
		targetString = "target's "
	end

	-- Priority for healing is removing fractures.
	if(hasFracture and amount >= 30) then
		local limb = fractures[math.random(1, #fractures)]
		
		ix.limb.SetFracture(character, limb.hitgroup, false)
		item:SetData("currentAmount", amount - 30)

		if(!character:GetFractures()) then
			ix.limb.ResetMovement(client)
		end

		client:EmitSound("items/medshot4.wav", 80)

		return false, string.format("You have fixed your %s%s.", targetString, limb.name)
	end

	-- If we need hp, heal the player.
	if(client:Health() < client:GetMaxHealth()) then
		local healingRequired = client:GetMaxHealth() - client:Health()
		local healing = healingRequired
		local empty = false

		if(amount >= healingRequired) then
			item:SetData("currentAmount", item:GetData("currentAmount", 0) - healing)
		else
			healing = item:GetData("currentAmount", 0)
			empty = true
		end

		client:SetHealth(client:Health() + (healing or 0))
		client:EmitSound("items/medshot4.wav", 80)

		return empty, string.format("You have healed your %shealth for %s.", targetString, healing)
	end

	local injuredLimbs = character:GetInjuredLimbs()

	-- If we have no fractures, heal the player.
	if(#injuredLimbs >= 1) then
		local limb = injuredLimbs[math.random(1, #injuredLimbs)]
		local healingRequired = limb.health
		local healing = healingRequired
		local empty = false

		if(amount >= healingRequired) then
			item:SetData("currentAmount", item:GetData("currentAmount") - healing)
		elseif(amount < healingRequired) then
			healing = item:GetData("currentAmount")
			empty = true
		end

		ix.limb.SetHealth(character, limb.hitgroup, -healing)
		client:EmitSound("items/medshot4.wav", 80)

		return empty, string.format("You have healed your %s%s for %s.", targetString, limb.name, healing)
	end

	return false, "You don't have any injuries."
end

timer.Create("ixFractureTick", 1, 0, function()
	ix.limb.FractureTick()
end)