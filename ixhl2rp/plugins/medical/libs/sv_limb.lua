--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ix.limb.fractureSounds = {
    ["male"] = {
        "vo/npc/male01/myleg01.wav",
        "vo/npc/male01/myleg02.wav"
    },
    ["female"] = {
        "vo/npc/female01/myleg01.wav",
        "vo/npc/female01/myleg02.wav"
    }
}
-- Called when we are being hit and need to be scaling limb damage based on various modifiers
function ix.limb.TakeDamage(client, group, info, diff)
    local character = client:GetCharacter()
    local damage = info:GetDamage()
    local damageType = info:GetDamageType()

    if(group > 0 and damage > 0) then
        -- Armor will halve the damage.
        if(client:Armor() - damage > 0) then
            damage = damage * 0.75
        end

        ix.limb.SetHealth(character, group, damage * (diff or 1))

        local health = ix.limb.GetHealth(character, group)

        -- Different damage types can cause different types of wounds
        if(damageType) then
            local limbHitgroup = ix.limb.GetHitgroup(group)
            local canFracture = ix.limb.config.createFracture[damageType] or false

            if(canFracture and (damage * (diff or 1)) >= limbHitgroup.fractureThreshold) then
                ix.limb.SetFracture(character, group, true)

                if(client:Alive() and character:GetFaction() == FACTION_CITIZEN and (client.fractureSound or 0) < CurTime()) then
                    if(client:IsFemale()) then
                        client:EmitSound(ix.limb.fractureSounds["female"][math.random(1,2)], 80)
                    else
                        client:EmitSound(ix.limb.fractureSounds["male"][math.random(1,2)], 80)
                    end

                    client.fractureSound = CurTime() + 2
                end
            end
        end

        -- Called for any plugins that might need to use it
        hook.Run("LimbTakeDamage", client, group, damage, health, info)
    end
end

-- A function to instantly kill the player if their limbs are gone.
function ix.limb.RunDamage(character, attacker, hitgroup)
end

-- A function to subtract or add to a limb's health
function ix.limb.SetHealth(character, group, damage)
    local limbs = character:GetLimbs()
    local limb = limbs[group]
    
    if (limb) then
        limb.health = math.Clamp((limb.health or 0) + math.ceil(damage), 0, ix.limb.GetHitgroup(group).maxHealth)
		character:SetLimbs(limbs)
	end
end

-- A function to change the fracture status of a character's limb.
function ix.limb.SetFracture(character, group, fracture)
    local limbs = character:GetLimbs()

    if(limbs[group]) then
        limbs[group].fracture = fracture

        character:SetLimbs(limbs)
    end
end

-- A function to get scale damage.
function ix.limb.GetScaleDamage(group)
    local limb = ix.limb.GetHitgroup(group)

	if (limb) then
		return limb.scale
	end
	
	return 0
end

function ix.limb.FractureTick()
    for k, v in pairs(player.GetAll()) do
        if(!v:GetCharacter() or v:GetCharacter():GetFractures() == false) then
            return
        end

        local client = v

		local leftLeg = ix.limb.GetHealthPercentage(client, HITGROUP_LEFTLEG, true) / 100
		local rightLeg = ix.limb.GetHealthPercentage(client, HITGROUP_RIGHTLEG, true) / 100
        local legDamage = leftLeg + rightLeg / 2

        if(legDamage < 0.65) then
            legDamage = 0.65
        end

        local walkSpeed = ix.config.Get("walkSpeed") * legDamage
        local runSpeed = ix.config.Get("runSpeed") * legDamage
        local jumpPower = 160 * legDamage

        if(legDamage > 0) then
            client:SetWalkSpeed(math.Clamp(walkSpeed, 0, ix.config.Get("walkSpeed")))
            client:SetRunSpeed(math.Clamp(runSpeed, 0, ix.config.Get("runSpeed")))
            client:SetJumpPower(math.Clamp(jumpPower, 0, 160))
        end
    end 
end

function ix.limb.ResetMovement(client)
    client:SetWalkSpeed(ix.config.Get("walkSpeed"))
    client:SetRunSpeed(ix.config.Get("runSpeed"))
    client:SetJumpPower(160)
end

-- A function to reset a player's limb data.
function ix.limb.ResetLimbData(character)
    local limbs = {}	
    
	for i = 1, #ix.limb.hitgroup do
		limbs[i] = {
			health = 0, 
			fracture = false,
		}
	end
	
	character:SetLimbs(limbs)
end