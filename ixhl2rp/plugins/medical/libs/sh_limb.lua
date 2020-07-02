--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ix.limb = ix.limb or {}
ix.limb.hitgroup = ix.limb.hitgroup or {}
ix.limb.config = ix.limb.config or {}

-- A function to return the hitgroup table from the hitgroup array.
function ix.limb.GetHitgroup(group)
    if(self.hitgroup[group]) then
        return self.hitgroup[group]
    end

    return nil
end

-- A function to add a new hitgroup to the hitgroup array.
function ix.limb.AddHitGroup(group, data)
    self.hitgroup[group] = data
end

-- Adds all the keys to the hitgroup array
function ix.limb.HitGroupData(data)
    local array = {
        name = data[1] or "Undefined",
        maxHealth = data[2] or 100,
        fractureThreshold = data[3] or 20,
        bleedThreshold = data[4] or 5,
        scale = data[5] or 1
    }

    return array
end