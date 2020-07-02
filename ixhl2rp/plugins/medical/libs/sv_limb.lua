--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

-- Called when we are being hit and need to be scaling limb damage based on various modifiers
function ix.limb.TakeDamage(client, group, info)
    local character = client:GetCharacter()
    local damage = info:GetDamage()
    local damageType = info:GetDamageType()

    if(group > 0 and damage > 0) then

        -- Armor will halve the damage.
        if(client:Armor() - damage > 0) then
            damage = damage / 2
        end

        self:SetHealth(character, group, damage)

        local health = self:GetHealth(character, group)

        -- Different damage types can cause different types of wounds
        if(damageType) then
            local limbHitgroup = self.GetHitgroup(group)
            local canBleed = ix.limb.config.createBleed[damageType] or false
            local canFracture = ix.limb.config.createFracture[damageType] or false

            if(canBleed and damage => limbHitgroup.bleedThreshold) then
                self.SetBleeding(character, group, true)
            end

            if(canFracture and damage => limbHitgroup.fractureThreshold) then
                self.SetFracture(character, group, true)
            end
        end

        -- Called for any plugins that might need to use it
        hook.run("LimbTakeDamage", client, group, damage, health, info)
    end
end

-- A function to return the characters health of a particular limb
function ix.limb:GetHealth(character, group, fraction)
    local limbs = character:GetLimbs()

    if(limbs[group]) then
        if(fraction) then
            return limbs[group].health / 100
        else
            return limbs[group].health
        end
    end

    return 0
end

-- A function to subtract or add to a limb's health
function ix.limb:SetHealth(character, group, damage)
    local limbs = character:GetLimbs()
    local limb = limbs[group]

	if (limb) then
        limb.health = math.Clamp((limb.health or 0) + math.ceil(damage), 0, self.GetHitgroup(group)[1])
		character:SetLimbs(limbs)
	end
end

-- A function to set the bleed status of a character's limb.
function ix.limb.SetBleeding(character, group, bleeding)
    local limbs = character:GetLimbs()

    if(limbs[group]) then
        limbs[group].bleeding = bleeding

        character:SetLimbs(limbs)

        if(bleeding == false) then
            self.SetBleedDamage(character, group, 0)
        end
    end
end

-- A function to have different bleed damages.
function ix.limb.SetBleedDamage(character, group, damage)
    local limbs = character:GetLimbs()

    if(limbs) then
        data[group].bleedDamage = damage

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

-- A function to return whether a limb is bleeding or not.
function ix.limb.HasBleed(character, group)
    local limbs = character:GetLimbs()

    if(limbs and limbs[group]) then
        return limbs[group].bleeding
    end

    return false
end

-- A function to return whether a limb is fractured or not.
function ix.limb.HasFracture(character, group)
    local limbs = character:GetLimbs()

    if(limbs and limbs[group]) then
        return limbs[group].fracture
    end

    return false
end