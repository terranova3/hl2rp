--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ix.limb = ix.limb or {}
ix.limb.hitgroup = ix.limb.hitgroup or {}
ix.limb.config = ix.limb.config or {}

-- A function to return the hitgroup table from the hitgroup array.
function ix.limb.GetHitgroup(group)
    if(ix.limb.hitgroup[group]) then
        return ix.limb.hitgroup[group]
    end

    return nil
end

-- A function to add a new hitgroup to the hitgroup array.
function ix.limb.AddHitGroup(group, data)
    ix.limb.hitgroup[group] = data
end

-- Adds all the keys to the hitgroup array
function ix.limb.HitGroupData(data)
    local array = {
        name = data[1] or "Undefined",
        maxHealth = data[2] or 100,
        fractureThreshold = data[3] or 20,
        scale = data[4] or 1
    }

    return array
end

-- A function to return a limbs name.
function ix.limb.GetName(group)
    local limbData = ix.limb.GetHitgroup(group)

    if(limbData) then
        return limbData.name
    end

    return nil
end

-- A function to return the characters health of a particular limb
function ix.limb.GetHealth(character, group, fraction)
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

-- A function to return whether a limb is fractured or not.
function ix.limb.HasFracture(character, group)
    local limbs = character:GetLimbs()

    if(limbs and limbs[group]) then
        return limbs[group].fracture
    end

    return false
end

function ix.limb.GetHealthFlip(character, group)
	local max = ix.limb.GetHitgroup(group).maxHealth
	return max - ix.limb.GetHealth(character, group)
end

-- A function to get the local player's limb percentage health.
function ix.limb.GetHealthPercentage(client, group, bFlip)
    local character = client:GetCharacter()
    local maxHP = ix.limb.GetHitgroup(group).maxHealth
    local hp = ix.limb.GetHealth(character, group)
    
    if(bFlip) then
		hp = ix.limb.GetHealthFlip(character, group)
    end

    local percent = hp * 100 / maxHP
    
    return math.ceil(percent)
end
